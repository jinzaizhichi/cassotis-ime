unit nc_char_lm;

{ Shared character-level causal language model.
  The engine sees only IncCharLm; the host implements it over nc_lm_* in the
  native bridge DLL. A nil or not-ready model leaves every ranking unchanged. }

interface

uses System.SysUtils, System.Math;

type
    IncCharLm = interface
        ['{6B0F3C2E-7A51-4D0B-9C1E-2F5D8A4B7E13}']
        function char_lm_ready: Boolean;
        { Sums log P(text | context) for texts in order while their packed
          prefix trie stays within max_nodes; the first min_count texts are
          always scored. Returns how many leading texts were scored, or -1. }
        function score_texts(const context: string; const texts: TArray<string>;
            const min_count, max_nodes: Integer; out logp: TArray<Single>): Integer;
    end;

    { A continuation proposed for Tab: the kept base prefix (top1 or top2 minus
      replace_units characters) and the suffix, with the local-completion
      ranker's score and ABSTAIN score. rank is the pool rank (1-based), 0 for
      the fallback generator. }
    TncCharLmContinuation = record
        base_text: string;
        suffix_text: string;
        rank: Integer;
        base_rank: Integer;
        score: Single;
        abstain_score: Single;
        generator: Boolean;
    end;

const
    { Long-sentence rerank, chosen on the 8,000-sentence fiction dev set
      (50M-parameter model, int8 with float layer-5 MLP output). }
    c_char_lm_long_min_units = 6;
    c_char_lm_long_pool_limit = 20;
    c_char_lm_long_min_count = 2;
    c_char_lm_long_max_nodes = 110;
    c_char_lm_long_rank_weight = 0.25;
    c_char_lm_long_visible_bonus = 2.0;
    { Short-word context rerank over the visible exact entries for the input
      (prefix completions excluded), chosen on the 30,000-case fiction
      short-word dev set with left context required. }
    c_char_lm_short_limit = 5;
    c_char_lm_short_rank_weight = 1.0;
    { Tab continuation: show the most probable candidate when P(correct) is at
      least this. Chosen on the 7,996-sentence fiction Tab dev set as the most
      hits without more wrong prompts than the ranker alone (5-fold CV). }
    c_char_lm_tab_min_probability = 0.02;

{ Chooses the long-sentence top1 from the final complete pool and the visible
  top1. pool_texts/pool_ranks are the final ranking's candidates in their
  original order with their final ranks. Candidates must cover expected_units
  characters; duplicates keep their first occurrence. The visible top1 goes
  first (and is appended to the pool when missing), then the pool's first
  c_char_lm_long_pool_limit entries by final rank, cut by the node budget.
  Each is scored LM - w * ln(pool position) + bonus * [is visible]; ties keep
  the earlier text. Returns True with chosen <> visible when the model prefers
  another candidate. }
function nc_char_lm_choose_long_top(const model: IncCharLm; const context: string;
    const pool_texts: TArray<string>; const pool_ranks: TArray<Integer>;
    const visible: string; const expected_units: Integer; out chosen: string): Boolean;

{ Chooses among the first c_char_lm_short_limit distinct texts (the visible
  complete candidates in order) by log P(text | context) - w * ln(position).
  Ties keep the earlier text. Returns False when nothing was scored. }
function nc_char_lm_choose_short_top(const model: IncCharLm; const context: string;
    const texts: TArray<string>; out best_index: Integer): Boolean;

{ Estimates P(the displayed continuation is correct) for each candidate from
  the ranker scores and log P(base + suffix | context) - log P(base | context),
  with a logistic model fit on the Tab dev set. Returns False when nothing was
  scored; otherwise best_index is the most probable candidate (ties keep the
  earlier one) and probability its estimate. }
function nc_char_lm_choose_continuation(const model: IncCharLm; const context: string;
    const candidates: TArray<TncCharLmContinuation>; out best_index: Integer;
    out probability: Double): Boolean;

function nc_char_lm_code_point_count(const text: string): Integer;

implementation

const
    c_tab_feature_count = 11;
    // Logistic model fit on the Tab dev set's continuation pools. Features:
    // ranker score, score - abstain, score - best ranked score, ln(pool rank),
    // suffix log-probability, per character, suffix characters, base
    // log-probability - best base, suffix log-probability - best, base is
    // top2, generator.
    c_tab_feature_mean: array[0..c_tab_feature_count - 1] of Double = (
        -11.772880502762936, -11.847919214710313, -9.296960417387904, 2.4783279058173204,
        -6.650943793343474, -5.740284079722411, 1.2589816176023911, -0.051519699093898856,
        -4.447989229046104, 0.002843014567412249, 0.007253332037372277);
    c_tab_feature_scale: array[0..c_tab_feature_count - 1] of Double = (
        6.640685938008207, 6.04000534052108, 5.870374414418903, 0.8916710016398441,
        2.705799777948034, 2.4459158415689104, 0.5503939536327123, 0.6650820920025834,
        2.8729501310864856, 0.05324407893903667, 0.08485706441683039);
    c_tab_feature_weight: array[0..c_tab_feature_count - 1] of Double = (
        0.23302303672944116, 1.1694070958686273, -0.9010290368756128, -0.0538935198833472,
        1.8769881970317532, 0.4486094861688398, 0.2299522908430179, 3.4049781564914894,
        -0.08244410597377476, -0.38295603176087856, -0.05486665921684637);
    c_tab_bias = -7.426349470244992;

function nc_char_lm_code_point_count(const text: string): Integer;
var
    idx: Integer;
begin
    Result := 0;
    idx := 1;
    while idx <= Length(text) do
    begin
        if (Ord(text[idx]) >= $D800) and (Ord(text[idx]) <= $DBFF) and
            (idx < Length(text)) and (Ord(text[idx + 1]) >= $DC00) and
            (Ord(text[idx + 1]) <= $DFFF) then
            Inc(idx);
        Inc(idx);
        Inc(Result);
    end;
end;

function nc_char_lm_choose_long_top(const model: IncCharLm; const context: string;
    const pool_texts: TArray<string>; const pool_ranks: TArray<Integer>;
    const visible: string; const expected_units: Integer; out chosen: string): Boolean;
var
    complete: TArray<string>;
    ranks, order: TArray<Integer>;
    texts: TArray<string>;
    logp: TArray<Single>;
    text, visible_text: string;
    idx, other, count, visible_index, scored, best: Integer;
    score, best_score: Double;
begin
    Result := False;
    chosen := '';
    if (model = nil) or (expected_units < c_char_lm_long_min_units) or
        (Length(pool_texts) <> Length(pool_ranks)) or (not model.char_lm_ready) then
        Exit;

    // Complete, distinct texts in original order, then stably by final rank.
    count := 0;
    SetLength(complete, Length(pool_texts) + 1);
    SetLength(ranks, Length(pool_texts) + 1);
    for idx := 0 to High(pool_texts) do
    begin
        text := Trim(pool_texts[idx]);
        if (text = '') or (nc_char_lm_code_point_count(text) <> expected_units) then
            Continue;
        other := 0;
        while (other < count) and (complete[other] <> text) do
            Inc(other);
        if other < count then
            Continue;
        complete[count] := text;
        ranks[count] := pool_ranks[idx];
        Inc(count);
    end;
    for idx := 1 to count - 1 do
    begin
        text := complete[idx];
        other := ranks[idx];
        best := idx - 1;
        while (best >= 0) and (ranks[best] > other) do
        begin
            complete[best + 1] := complete[best];
            ranks[best + 1] := ranks[best];
            Dec(best);
        end;
        complete[best + 1] := text;
        ranks[best + 1] := other;
    end;

    visible_text := Trim(visible);
    visible_index := -1;
    if (visible_text <> '') and
        (nc_char_lm_code_point_count(visible_text) = expected_units) then
    begin
        visible_index := 0;
        while (visible_index < count) and (complete[visible_index] <> visible_text) do
            Inc(visible_index);
        if visible_index = count then
        begin
            complete[count] := visible_text;
            Inc(count);
        end;
    end;

    SetLength(order, 0);
    if visible_index >= 0 then
        order := [visible_index];
    for idx := 0 to Min(c_char_lm_long_pool_limit, count) - 1 do
        if idx <> visible_index then
            order := order + [idx];
    if Length(order) < c_char_lm_long_min_count then
        Exit;

    SetLength(texts, Length(order));
    for idx := 0 to High(order) do
        texts[idx] := complete[order[idx]];
    scored := model.score_texts(context, texts, c_char_lm_long_min_count,
        c_char_lm_long_max_nodes, logp);
    if (scored < c_char_lm_long_min_count) or (scored > Length(order)) or
        (Length(logp) < scored) then
        Exit;

    best := -1;
    best_score := 0.0;
    for idx := 0 to scored - 1 do
    begin
        score := logp[idx] - c_char_lm_long_rank_weight * Ln(order[idx] + 1);
        if order[idx] = visible_index then
            score := score + c_char_lm_long_visible_bonus;
        if (best < 0) or (score > best_score) then
        begin
            best := order[idx];
            best_score := score;
        end;
    end;
    chosen := complete[best];
    Result := chosen <> visible_text;
end;

function nc_char_lm_choose_continuation(const model: IncCharLm; const context: string;
    const candidates: TArray<TncCharLmContinuation>; out best_index: Integer;
    out probability: Double): Boolean;
var
    texts: TArray<string>;

    function text_index(const value: string): Integer;
    begin
        Result := 0;
        while (Result < Length(texts)) and (texts[Result] <> value) do
            Inc(Result);
        if Result = Length(texts) then
            texts := texts + [value];
    end;

var
    logp: TArray<Single>;
    base_idx, full_idx: TArray<Integer>;
    features: array[0..c_tab_feature_count - 1] of Double;
    idx, feature, units: Integer;
    best_base, top_score, lm_best, base_lp, suffix_lp, logit, p: Double;
    has_ranked: Boolean;
begin
    Result := False;
    best_index := -1;
    probability := 0.0;
    if (model = nil) or (Length(candidates) = 0) or (not model.char_lm_ready) then
        Exit;
    // Same text order as the dev-set scoring: each base, then its full text.
    SetLength(base_idx, Length(candidates));
    SetLength(full_idx, Length(candidates));
    for idx := 0 to High(candidates) do
    begin
        if (candidates[idx].base_text = '') or (candidates[idx].suffix_text = '') then
            Exit;
        base_idx[idx] := text_index(candidates[idx].base_text);
        full_idx[idx] := text_index(candidates[idx].base_text + candidates[idx].suffix_text);
    end;
    if model.score_texts(context, texts, Length(texts), 0, logp) <> Length(texts) then
        Exit;

    best_base := -MaxDouble;
    lm_best := -MaxDouble;
    top_score := 0.0;
    has_ranked := False;
    for idx := 0 to High(candidates) do
    begin
        best_base := Max(best_base, logp[base_idx[idx]]);
        lm_best := Max(lm_best, logp[full_idx[idx]] - logp[base_idx[idx]]);
        if not candidates[idx].generator then
        begin
            if (not has_ranked) or (candidates[idx].score > top_score) then
                top_score := candidates[idx].score;
            has_ranked := True;
        end;
    end;

    for idx := 0 to High(candidates) do
    begin
        base_lp := logp[base_idx[idx]];
        suffix_lp := logp[full_idx[idx]] - base_lp;
        units := Max(1, nc_char_lm_code_point_count(candidates[idx].suffix_text));
        if candidates[idx].generator then
        begin
            features[0] := 0.0;
            features[1] := 0.0;
            features[2] := 0.0;
        end
        else
        begin
            features[0] := candidates[idx].score;
            features[1] := candidates[idx].score - candidates[idx].abstain_score;
            features[2] := candidates[idx].score - top_score;
        end;
        if candidates[idx].rank > 0 then
            features[3] := Ln(candidates[idx].rank)
        else
            features[3] := 0.0;
        features[4] := suffix_lp;
        features[5] := suffix_lp / units;
        features[6] := units;
        features[7] := base_lp - best_base;
        features[8] := suffix_lp - lm_best;
        features[9] := Ord(candidates[idx].base_rank = 2);
        features[10] := Ord(candidates[idx].generator);
        logit := c_tab_bias;
        for feature := 0 to c_tab_feature_count - 1 do
            logit := logit + c_tab_feature_weight[feature] *
                (features[feature] - c_tab_feature_mean[feature]) / c_tab_feature_scale[feature];
        p := 1.0 / (1.0 + Exp(-logit));
        if (best_index < 0) or (p > probability) then
        begin
            best_index := idx;
            probability := p;
        end;
    end;
    Result := True;
end;

function nc_char_lm_choose_short_top(const model: IncCharLm; const context: string;
    const texts: TArray<string>; out best_index: Integer): Boolean;
var
    logp: TArray<Single>;
    count, idx: Integer;
    score, best_score: Double;
begin
    Result := False;
    best_index := 0;
    count := Min(Length(texts), c_char_lm_short_limit);
    if (model = nil) or (count < 2) or (not model.char_lm_ready) then
        Exit;
    if model.score_texts(context, Copy(texts, 0, count), count, 0, logp) <> count then
        Exit;
    best_score := 0.0;
    for idx := 0 to count - 1 do
    begin
        score := logp[idx] - c_char_lm_short_rank_weight * Ln(idx + 1);
        if (idx = 0) or (score > best_score) then
        begin
            best_index := idx;
            best_score := score;
        end;
    end;
    Result := True;
end;

end.
