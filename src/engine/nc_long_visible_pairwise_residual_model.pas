unit nc_long_visible_pairwise_residual_model;

interface

uses
    nc_long_final_ranker_model;

type
    TncLongVisiblePairwiseResidualFeatures = record
        candidate_candidate_score: Int64;
        candidate_dict_weight: Int64;
        candidate_has_dict_weight: Int64;
        candidate_source_user: Int64;
        candidate_source_chain: Int64;
        candidate_source_pattern: Int64;
        candidate_source_redup: Int64;
        candidate_source_local_rerank: Int64;
        candidate_source_rule_fallback: Int64;
        candidate_legacy_rank: Int64;
        candidate_legacy_top: Int64;
        candidate_chain_rank: Int64;
        candidate_chain_present: Int64;
        candidate_chain_first_stage_score: Int64;
        candidate_chain_second_stage_score: Int64;
        candidate_chain_score_gap: Int64;
        candidate_complete_match: Int64;
        candidate_partial_match: Int64;
        candidate_text_units: Int64;
        candidate_comment_length: Int64;
        candidate_unit_delta: Int64;
        candidate_path_available: Int64;
        candidate_path_confidence_score: Int64;
        candidate_path_confidence_tier: Int64;
        candidate_path_segments: Int64;
        candidate_path_single_segments: Int64;
        candidate_path_max_segment_units: Int64;
        candidate_char_lm_score: Int64;
        candidate_char_lm_suffix_score: Int64;
        candidate_char_lm_context_score: Int64;
        candidate_char_lm_context_gain: Int64;
        candidate_has_left_context: Int64;
        candidate_query_choice_bonus: Int64;
        candidate_latest_query_choice: Int64;
        candidate_query_path_bonus: Int64;
        candidate_query_path_penalty: Int64;
        candidate_input_syllable_count: Int64;
        candidate_score_per_unit: Int64;
        candidate_dict_weight_per_unit: Int64;
        candidate_complete_user: Int64;
        candidate_complete_dictionary: Int64;
        candidate_complete_chain: Int64;
        delta_candidate_score: Int64;
        delta_dict_weight: Int64;
        delta_has_dict_weight: Int64;
        delta_source_user: Int64;
        delta_source_chain: Int64;
        delta_source_pattern: Int64;
        delta_source_redup: Int64;
        delta_source_local_rerank: Int64;
        delta_source_rule_fallback: Int64;
        delta_legacy_rank: Int64;
        delta_legacy_top: Int64;
        delta_chain_rank: Int64;
        delta_chain_present: Int64;
        delta_chain_first_stage_score: Int64;
        delta_chain_second_stage_score: Int64;
        delta_chain_score_gap: Int64;
        delta_complete_match: Int64;
        delta_partial_match: Int64;
        delta_text_units: Int64;
        delta_comment_length: Int64;
        delta_unit_delta: Int64;
        delta_path_available: Int64;
        delta_path_confidence_score: Int64;
        delta_path_confidence_tier: Int64;
        delta_path_segments: Int64;
        delta_path_single_segments: Int64;
        delta_path_max_segment_units: Int64;
        delta_char_lm_score: Int64;
        delta_char_lm_suffix_score: Int64;
        delta_char_lm_context_score: Int64;
        delta_char_lm_context_gain: Int64;
        delta_has_left_context: Int64;
        delta_query_choice_bonus: Int64;
        delta_latest_query_choice: Int64;
        delta_query_path_bonus: Int64;
        delta_query_path_penalty: Int64;
        delta_input_syllable_count: Int64;
        delta_score_per_unit: Int64;
        delta_dict_weight_per_unit: Int64;
        delta_complete_user: Int64;
        delta_complete_dictionary: Int64;
        delta_complete_chain: Int64;
        candidate_current_rank: Int64;
        candidate_ranker_score: Int64;
        candidate_ranker_score_gap: Int64;
        baseline_ranker_applied: Int64;
        baseline_abstain_score: Int64;
    end;

const
    c_long_visible_pairwise_residual_feature_count: Integer = 89;
    c_long_visible_pairwise_residual_tree_count: Integer = 192;
    c_long_visible_pairwise_residual_max_challenger_rank: Integer = 0;
    c_long_visible_pairwise_residual_score_scale: Double = 100000000.0;
    c_long_visible_pairwise_residual_promotion_threshold: Int64 = -4069003;
    c_long_visible_pairwise_residual_reference_score: Int64 = -233859357;
    c_long_visible_pairwise_residual_reference_score_low: Int64 = -591034982;
    c_long_visible_pairwise_residual_reference_score_high: Int64 = -192975470;
    c_long_visible_pairwise_residual_reference_score_mixed: Int64 = -296841771;

procedure build_long_visible_pairwise_residual_features(
    const candidate_features: TncLongFinalRankerFeatures;
    const top_features: TncLongFinalRankerFeatures;
    const candidate_rank: Integer;
    const candidate_ranker_score: Int64;
    const top_ranker_score: Int64;
    const baseline_ranker_applied: Boolean;
    const baseline_abstain_score: Int64;
    out features: TncLongVisiblePairwiseResidualFeatures);
function long_visible_pairwise_residual_score(
    const features: TncLongVisiblePairwiseResidualFeatures): Int64;
function long_visible_pairwise_residual_self_test: Boolean;

implementation

{ Final-visible pairwise residual. It may promote at most one candidate.
  Training report SHA-256: 2C03EDE0AC555608F9DC3CD5E4AD2A0B6C9304B8FE0CCF716A4634F054A00434
  LightGBM model SHA-256: 8223FC508F84B4FC7D55E0C9178F0DCD2679AAEBB61D9DE592F5DC762544ABCC }

procedure build_long_visible_pairwise_residual_features(
    const candidate_features: TncLongFinalRankerFeatures;
    const top_features: TncLongFinalRankerFeatures;
    const candidate_rank: Integer;
    const candidate_ranker_score: Int64;
    const top_ranker_score: Int64;
    const baseline_ranker_applied: Boolean;
    const baseline_abstain_score: Int64;
    out features: TncLongVisiblePairwiseResidualFeatures);
begin
    features.candidate_candidate_score := candidate_features.candidate_score;
    features.candidate_dict_weight := candidate_features.dict_weight;
    features.candidate_has_dict_weight := Ord(candidate_features.has_dict_weight);
    features.candidate_source_user := Ord(candidate_features.source_user);
    features.candidate_source_chain := Ord(candidate_features.source_chain);
    features.candidate_source_pattern := Ord(candidate_features.source_pattern);
    features.candidate_source_redup := Ord(candidate_features.source_redup);
    features.candidate_source_local_rerank := Ord(candidate_features.source_local_rerank);
    features.candidate_source_rule_fallback := Ord(candidate_features.source_rule_fallback);
    features.candidate_legacy_rank := candidate_features.legacy_rank;
    features.candidate_legacy_top := Ord(candidate_features.legacy_top);
    features.candidate_chain_rank := candidate_features.chain_rank;
    features.candidate_chain_present := Ord(candidate_features.chain_present);
    features.candidate_chain_first_stage_score := candidate_features.chain_first_stage_score;
    features.candidate_chain_second_stage_score := candidate_features.chain_second_stage_score;
    features.candidate_chain_score_gap := candidate_features.chain_score_gap;
    features.candidate_complete_match := Ord(candidate_features.complete_match);
    features.candidate_partial_match := Ord(candidate_features.partial_match);
    features.candidate_text_units := candidate_features.text_units;
    features.candidate_comment_length := candidate_features.comment_length;
    features.candidate_unit_delta := candidate_features.unit_delta;
    features.candidate_path_available := Ord(candidate_features.path_available);
    features.candidate_path_confidence_score := candidate_features.path_confidence_score;
    features.candidate_path_confidence_tier := candidate_features.path_confidence_tier;
    features.candidate_path_segments := candidate_features.path_segments;
    features.candidate_path_single_segments := candidate_features.path_single_segments;
    features.candidate_path_max_segment_units := candidate_features.path_max_segment_units;
    features.candidate_char_lm_score := candidate_features.char_lm_score;
    features.candidate_char_lm_suffix_score := candidate_features.char_lm_suffix_score;
    features.candidate_char_lm_context_score := candidate_features.char_lm_context_score;
    features.candidate_char_lm_context_gain := candidate_features.char_lm_context_gain;
    features.candidate_has_left_context := Ord(candidate_features.has_left_context);
    features.candidate_query_choice_bonus := candidate_features.query_choice_bonus;
    features.candidate_latest_query_choice := Ord(candidate_features.latest_query_choice);
    features.candidate_query_path_bonus := candidate_features.query_path_bonus;
    features.candidate_query_path_penalty := candidate_features.query_path_penalty;
    features.candidate_input_syllable_count := candidate_features.input_syllable_count;
    features.candidate_score_per_unit := candidate_features.score_per_unit;
    features.candidate_dict_weight_per_unit := candidate_features.dict_weight_per_unit;
    features.candidate_complete_user := Ord(candidate_features.complete_user);
    features.candidate_complete_dictionary := Ord(candidate_features.complete_dictionary);
    features.candidate_complete_chain := Ord(candidate_features.complete_chain);
    features.delta_candidate_score := candidate_features.candidate_score - top_features.candidate_score;
    features.delta_dict_weight := candidate_features.dict_weight - top_features.dict_weight;
    features.delta_has_dict_weight := Ord(candidate_features.has_dict_weight) - Ord(top_features.has_dict_weight);
    features.delta_source_user := Ord(candidate_features.source_user) - Ord(top_features.source_user);
    features.delta_source_chain := Ord(candidate_features.source_chain) - Ord(top_features.source_chain);
    features.delta_source_pattern := Ord(candidate_features.source_pattern) - Ord(top_features.source_pattern);
    features.delta_source_redup := Ord(candidate_features.source_redup) - Ord(top_features.source_redup);
    features.delta_source_local_rerank := Ord(candidate_features.source_local_rerank) - Ord(top_features.source_local_rerank);
    features.delta_source_rule_fallback := Ord(candidate_features.source_rule_fallback) - Ord(top_features.source_rule_fallback);
    features.delta_legacy_rank := candidate_features.legacy_rank - top_features.legacy_rank;
    features.delta_legacy_top := Ord(candidate_features.legacy_top) - Ord(top_features.legacy_top);
    features.delta_chain_rank := candidate_features.chain_rank - top_features.chain_rank;
    features.delta_chain_present := Ord(candidate_features.chain_present) - Ord(top_features.chain_present);
    features.delta_chain_first_stage_score := candidate_features.chain_first_stage_score - top_features.chain_first_stage_score;
    features.delta_chain_second_stage_score := candidate_features.chain_second_stage_score - top_features.chain_second_stage_score;
    features.delta_chain_score_gap := candidate_features.chain_score_gap - top_features.chain_score_gap;
    features.delta_complete_match := Ord(candidate_features.complete_match) - Ord(top_features.complete_match);
    features.delta_partial_match := Ord(candidate_features.partial_match) - Ord(top_features.partial_match);
    features.delta_text_units := candidate_features.text_units - top_features.text_units;
    features.delta_comment_length := candidate_features.comment_length - top_features.comment_length;
    features.delta_unit_delta := candidate_features.unit_delta - top_features.unit_delta;
    features.delta_path_available := Ord(candidate_features.path_available) - Ord(top_features.path_available);
    features.delta_path_confidence_score := candidate_features.path_confidence_score - top_features.path_confidence_score;
    features.delta_path_confidence_tier := candidate_features.path_confidence_tier - top_features.path_confidence_tier;
    features.delta_path_segments := candidate_features.path_segments - top_features.path_segments;
    features.delta_path_single_segments := candidate_features.path_single_segments - top_features.path_single_segments;
    features.delta_path_max_segment_units := candidate_features.path_max_segment_units - top_features.path_max_segment_units;
    features.delta_char_lm_score := candidate_features.char_lm_score - top_features.char_lm_score;
    features.delta_char_lm_suffix_score := candidate_features.char_lm_suffix_score - top_features.char_lm_suffix_score;
    features.delta_char_lm_context_score := candidate_features.char_lm_context_score - top_features.char_lm_context_score;
    features.delta_char_lm_context_gain := candidate_features.char_lm_context_gain - top_features.char_lm_context_gain;
    features.delta_has_left_context := Ord(candidate_features.has_left_context) - Ord(top_features.has_left_context);
    features.delta_query_choice_bonus := candidate_features.query_choice_bonus - top_features.query_choice_bonus;
    features.delta_latest_query_choice := Ord(candidate_features.latest_query_choice) - Ord(top_features.latest_query_choice);
    features.delta_query_path_bonus := candidate_features.query_path_bonus - top_features.query_path_bonus;
    features.delta_query_path_penalty := candidate_features.query_path_penalty - top_features.query_path_penalty;
    features.delta_input_syllable_count := candidate_features.input_syllable_count - top_features.input_syllable_count;
    features.delta_score_per_unit := candidate_features.score_per_unit - top_features.score_per_unit;
    features.delta_dict_weight_per_unit := candidate_features.dict_weight_per_unit - top_features.dict_weight_per_unit;
    features.delta_complete_user := Ord(candidate_features.complete_user) - Ord(top_features.complete_user);
    features.delta_complete_dictionary := Ord(candidate_features.complete_dictionary) - Ord(top_features.complete_dictionary);
    features.delta_complete_chain := Ord(candidate_features.complete_chain) - Ord(top_features.complete_chain);
    features.candidate_current_rank := candidate_rank;
    features.candidate_ranker_score := candidate_ranker_score;
    features.candidate_ranker_score_gap := candidate_ranker_score - top_ranker_score;
    features.baseline_ranker_applied := Ord(baseline_ranker_applied);
    features.baseline_abstain_score := baseline_abstain_score;
end;

function visible_pairwise_tree_0(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -12618272.999999998 then
    begin
        if features.candidate_ranker_score <= -22751277.499999996 then
        begin
            Result := -4.6230295064723954;
        end
        else
        begin
            Result := -4.5153574517943049;
        end;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -600.49999999999989 then
        begin
            Result := -4.4669383162778731;
        end
        else
        begin
            if features.candidate_chain_score_gap <= -82769276.999999985 then
            begin
                Result := -4.3619118357426983;
            end
            else
            begin
                if features.delta_candidate_score <= 17919.500000000004 then
                begin
                    if features.baseline_abstain_score <= 1.1454525564034803 then
                    begin
                        Result := -3.988885019810811;
                    end
                    else
                    begin
                        Result := -4.5824845658570172;
                    end;
                end
                else
                begin
                    Result := -4.4184003891494728;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_1(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -16909885.999999996 then
    begin
        if features.candidate_ranker_score <= -29050782.499999996 then
        begin
            Result := -0.024733050192866028;
        end
        else
        begin
            Result := 0.033097963516107269;
        end;
    end
    else
    begin
        if features.delta_char_lm_score <= -721.49999999999989 then
        begin
            if features.delta_char_lm_score <= -1806.4999999999998 then
            begin
                Result := -0.0044550852730308966;
            end
            else
            begin
                Result := 0.12417342374017848;
            end;
        end
        else
        begin
            if features.delta_chain_second_stage_score <= -96701944.999999985 then
            begin
                Result := 0.15935639273070648;
            end
            else
            begin
                if features.baseline_abstain_score <= 0.97303776155812505 then
                begin
                    Result := 0.34613693796948186;
                end
                else
                begin
                    Result := 0.078776867215544874;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_2(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -16909885.999999996 then
    begin
        if features.candidate_ranker_score <= -29050782.499999996 then
        begin
            Result := -0.024808840197032986;
        end
        else
        begin
            Result := 0.032669046810403966;
        end;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -514.49999999999989 then
        begin
            if features.delta_char_lm_suffix_score <= -1425.4999999999998 then
            begin
                Result := 0.0085860022992436131;
            end
            else
            begin
                if features.candidate_path_segments <= 6.5000000000000009 then
                begin
                    Result := 0.14483127562343776;
                end
                else
                begin
                    Result := 0.017839450858023749;
                end;
            end;
        end
        else
        begin
            if features.candidate_chain_score_gap <= -19277788.999999996 then
            begin
                Result := 0.17756794053042735;
            end
            else
            begin
                Result := 0.27670956109885914;
            end;
        end;
    end;
end;

function visible_pairwise_tree_3(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -16909885.999999996 then
    begin
        if features.candidate_ranker_score <= -24450401.999999996 then
        begin
            Result := -0.024414545596081905;
        end
        else
        begin
            Result := 0.030889010239648015;
        end;
    end
    else
    begin
        if features.delta_char_lm_score <= -761.49999999999989 then
        begin
            if features.delta_char_lm_score <= -1806.4999999999998 then
            begin
                Result := -0.0079738913886512174;
            end
            else
            begin
                if features.candidate_text_units <= 7.5000000000000009 then
                begin
                    Result := 0.147681796091475;
                end
                else
                begin
                    Result := 0.042348461493783206;
                end;
            end;
        end
        else
        begin
            if features.candidate_path_segments <= 9.5000000000000018 then
            begin
                Result := 0.18482260196699682;
            end
            else
            begin
                Result := 0.081702526555589391;
            end;
        end;
    end;
end;

function visible_pairwise_tree_4(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -17830651.999999996 then
    begin
        if features.candidate_ranker_score <= -27532802.999999996 then
        begin
            Result := -0.024516357514164158;
        end
        else
        begin
            Result := 0.028658837902773078;
        end;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -395.49999999999994 then
        begin
            if features.delta_char_lm_suffix_score <= -1425.4999999999998 then
            begin
                Result := 0.0042646990538822782;
            end
            else
            begin
                Result := 0.095897775944808958;
            end;
        end
        else
        begin
            if features.candidate_chain_score_gap <= -19277788.999999996 then
            begin
                Result := 0.1265194503778263;
            end
            else
            begin
                if features.candidate_chain_score_gap <= 28372192.000000004 then
                begin
                    Result := 0.2200135565646365;
                end
                else
                begin
                    Result := 0.045271901758749455;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_5(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score_gap <= -51945939.499999993 then
    begin
        if features.candidate_complete_match <= 1.0000000180025095E-35 then
        begin
            Result := -0.025165273831752179;
        end
        else
        begin
            Result := 0.0037170089632178778;
        end;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -37446511.499999993 then
        begin
            if features.delta_char_lm_score <= -1806.4999999999998 then
            begin
                Result := -0.013852917968590978;
            end
            else
            begin
                if features.delta_candidate_score <= -8999.4999999999982 then
                begin
                    Result := 0.042375877941248391;
                end
                else
                begin
                    Result := 0.10446019495177601;
                end;
            end;
        end
        else
        begin
            if features.delta_chain_rank <= 1.0000000180025095E-35 then
            begin
                Result := 0.19749229743407845;
            end
            else
            begin
                Result := 0.12109207169515471;
            end;
        end;
    end;
end;

function visible_pairwise_tree_6(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -22751277.499999996 then
    begin
        Result := -0.023971623610103032;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -1043.4999999999998 then
        begin
            Result := 0.019946392639396085;
        end
        else
        begin
            if features.candidate_ranker_score_gap <= -38475682.499999993 then
            begin
                if features.candidate_path_segments <= 5.5000000000000009 then
                begin
                    Result := 0.10708062706954871;
                end
                else
                begin
                    if features.delta_char_lm_suffix_score <= -83.499999999999986 then
                    begin
                        Result := 0.022209178719419104;
                    end
                    else
                    begin
                        Result := 0.096953825712304681;
                    end;
                end;
            end
            else
            begin
                if features.candidate_chain_first_stage_score <= 51896.500000000007 then
                begin
                    Result := 0.15106754341794904;
                end
                else
                begin
                    Result := 0.10187809338179162;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_7(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score_gap <= -52599408.499999993 then
    begin
        if features.candidate_path_max_segment_units <= 1.5000000000000002 then
        begin
            Result := -0.025152029752316507;
        end
        else
        begin
            Result := 0.0033641859976363425;
        end;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -37446511.499999993 then
        begin
            if features.delta_char_lm_score <= -1676.4999999999998 then
            begin
                Result := -0.010237634864885355;
            end
            else
            begin
                if features.delta_dict_weight <= -8997.4999999999982 then
                begin
                    Result := 0.034093606847395361;
                end
                else
                begin
                    if features.delta_chain_first_stage_score <= 434.00000000000006 then
                    begin
                        Result := 0.10134325213131201;
                    end
                    else
                    begin
                        Result := 0.010108678781950023;
                    end;
                end;
            end;
        end
        else
        begin
            Result := 0.10674683918469477;
        end;
    end;
end;

function visible_pairwise_tree_8(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -22751277.499999996 then
    begin
        Result := -0.023905212142204119;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -1013.4999999999999 then
        begin
            Result := 0.021038562074482171;
        end
        else
        begin
            if features.delta_chain_second_stage_score <= -105907756.99999999 then
            begin
                Result := 0.050749733923886889;
            end
            else
            begin
                if features.delta_chain_first_stage_score <= 434.00000000000006 then
                begin
                    Result := 0.10315000249931623;
                end
                else
                begin
                    if features.candidate_ranker_score <= 3328865.0000000005 then
                    begin
                        Result := 0.04266309058410292;
                    end
                    else
                    begin
                        if features.delta_char_lm_suffix_score <= -318.49999999999994 then
                        begin
                            Result := 0.042830977546717358;
                        end
                        else
                        begin
                            Result := 0.13425977751909743;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_9(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -21730144.999999996 then
    begin
        Result := -0.023796051816799127;
    end
    else
    begin
        if features.delta_char_lm_score <= -476.49999999999994 then
        begin
            if features.candidate_text_units <= 7.5000000000000009 then
            begin
                if features.delta_char_lm_score <= -1806.4999999999998 then
                begin
                    Result := -0.0074182898829701959;
                end
                else
                begin
                    if features.candidate_dict_weight_per_unit <= 4337.5000000000009 then
                    begin
                        Result := 0.027959002434009686;
                    end
                    else
                    begin
                        Result := 0.11329979221230457;
                    end;
                end;
            end
            else
            begin
                Result := 0.02161204107943417;
            end;
        end
        else
        begin
            if features.candidate_path_segments <= 5.5000000000000009 then
            begin
                Result := 0.10845819351067809;
            end
            else
            begin
                Result := 0.071517521862580438;
            end;
        end;
    end;
end;

function visible_pairwise_tree_10(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -24450401.999999996 then
    begin
        Result := -0.024307326707431194;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -1013.4999999999999 then
        begin
            Result := 0.010703128097241868;
        end
        else
        begin
            if features.candidate_path_segments <= 7.5000000000000009 then
            begin
                if features.delta_score_per_unit <= -184.49999999999997 then
                begin
                    Result := 0.053742208541926198;
                end
                else
                begin
                    if features.candidate_char_lm_suffix_score <= -4603.4999999999991 then
                    begin
                        Result := 0.092727039884214685;
                    end
                    else
                    begin
                        Result := 0.011040003348335624;
                    end;
                end;
            end
            else
            begin
                if features.delta_char_lm_suffix_score <= -103.49999999999999 then
                begin
                    Result := 0.020170411329237255;
                end
                else
                begin
                    Result := 0.080215729549814929;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_11(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -24450401.999999996 then
    begin
        Result := -0.0241664009864235;
    end
    else
    begin
        if features.delta_char_lm_context_score <= -395.49999999999994 then
        begin
            if features.delta_char_lm_score <= -1806.4999999999998 then
            begin
                Result := -0.011806484366548839;
            end
            else
            begin
                if features.candidate_path_segments <= 6.5000000000000009 then
                begin
                    Result := 0.053567577871408235;
                end
                else
                begin
                    Result := 0.009438098014026083;
                end;
            end;
        end
        else
        begin
            if features.candidate_chain_rank <= 1.5000000000000002 then
            begin
                if features.delta_char_lm_context_score <= 1.0000000180025095E-35 then
                begin
                    Result := 0.07704152313577578;
                end
                else
                begin
                    Result := 0.15838565636549637;
                end;
            end
            else
            begin
                Result := 0.059033206895307881;
            end;
        end;
    end;
end;

function visible_pairwise_tree_12(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score_gap <= -52780194.999999993 then
    begin
        if features.candidate_path_max_segment_units <= 1.5000000000000002 then
        begin
            Result := -0.025120150476983412;
        end
        else
        begin
            if features.delta_char_lm_suffix_score <= -83.499999999999986 then
            begin
                Result := -0.0049960055170930979;
            end
            else
            begin
                Result := 0.10124624301153939;
            end;
        end;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -38475682.499999993 then
        begin
            if features.delta_char_lm_score <= -1806.4999999999998 then
            begin
                Result := -0.017756942729308365;
            end
            else
            begin
                if features.candidate_input_syllable_count <= 12.500000000000002 then
                begin
                    Result := 0.052131820608216597;
                end
                else
                begin
                    Result := 0.0094850923253204933;
                end;
            end;
        end
        else
        begin
            Result := 0.066215062905965683;
        end;
    end;
end;

function visible_pairwise_tree_13(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score_gap <= -52780194.999999993 then
    begin
        if features.candidate_path_max_segment_units <= 1.5000000000000002 then
        begin
            Result := -0.025113783566440014;
        end
        else
        begin
            if features.delta_char_lm_suffix_score <= -42.499999999999993 then
            begin
                Result := -0.0036346698244285264;
            end
            else
            begin
                Result := 0.098913554540204951;
            end;
        end;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -37446511.499999993 then
        begin
            if features.delta_char_lm_score <= -1806.4999999999998 then
            begin
                Result := -0.015505955592907808;
            end
            else
            begin
                Result := 0.042536892387396288;
            end;
        end
        else
        begin
            if features.candidate_chain_first_stage_score <= 1.0000000180025095E-35 then
            begin
                Result := 0.087222422976083652;
            end
            else
            begin
                Result := 0.054082416734372502;
            end;
        end;
    end;
end;

function visible_pairwise_tree_14(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -29050782.499999996 then
    begin
        Result := -0.024650479794613399;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -1425.4999999999998 then
        begin
            Result := -0.0071699290736455387;
        end
        else
        begin
            if features.delta_char_lm_suffix_score <= -123.49999999999999 then
            begin
                if features.delta_dict_weight <= -8997.4999999999982 then
                begin
                    Result := 0.014749941663370049;
                end
                else
                begin
                    if features.candidate_input_syllable_count <= 10.500000000000002 then
                    begin
                        Result := 0.065107311720182262;
                    end
                    else
                    begin
                        Result := 0.031203832361514645;
                    end;
                end;
            end
            else
            begin
                if features.candidate_chain_rank <= 1.5000000000000002 then
                begin
                    Result := 0.10329663157587826;
                end
                else
                begin
                    Result := 0.052848792116957803;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_15(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -27532802.999999996 then
    begin
        Result := -0.02425571776782277;
    end
    else
    begin
        if features.delta_char_lm_score <= -721.49999999999989 then
        begin
            if features.delta_candidate_score <= -1.0000000180025095E-35 then
            begin
                Result := -0.0054199847388953157;
            end
            else
            begin
                Result := 0.033575852211480371;
            end;
        end
        else
        begin
            if features.candidate_text_units <= 9.5000000000000018 then
            begin
                if features.delta_score_per_unit <= -999.49999999999989 then
                begin
                    Result := 0.031380451974308339;
                end
                else
                begin
                    Result := 0.077208704440689863;
                end;
            end
            else
            begin
                if features.candidate_ranker_score_gap <= -14880512.999999998 then
                begin
                    Result := 0.037527559748086886;
                end
                else
                begin
                    Result := 0.077936825627429582;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_16(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -24450401.999999996 then
    begin
        Result := -0.024101300135013486;
    end
    else
    begin
        if features.delta_char_lm_score <= -761.49999999999989 then
        begin
            if features.delta_candidate_score <= -1.0000000180025095E-35 then
            begin
                Result := -0.0042261538729456089;
            end
            else
            begin
                if features.candidate_char_lm_suffix_score <= -5707.4999999999991 then
                begin
                    Result := 0.042160444658693397;
                end
                else
                begin
                    Result := -0.0036414106613505506;
                end;
            end;
        end
        else
        begin
            if features.candidate_text_units <= 10.500000000000002 then
            begin
                Result := 0.059718793160271726;
            end
            else
            begin
                if features.delta_char_lm_suffix_score <= -123.49999999999999 then
                begin
                    Result := 0.0253505187412165;
                end
                else
                begin
                    Result := 0.05453941997672708;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_17(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -27532802.999999996 then
    begin
        Result := -0.024201520387804216;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -299.49999999999994 then
        begin
            if features.delta_char_lm_suffix_score <= -1425.4999999999998 then
            begin
                Result := -0.00523268406084998;
            end
            else
            begin
                if features.candidate_text_units <= 10.500000000000002 then
                begin
                    if features.delta_dict_weight <= -8997.4999999999982 then
                    begin
                        Result := 0.0088187245692167172;
                    end
                    else
                    begin
                        Result := 0.048497252979513704;
                    end;
                end
                else
                begin
                    Result := 0.012184291358973158;
                end;
            end;
        end
        else
        begin
            if features.candidate_chain_rank <= 1.5000000000000002 then
            begin
                Result := 0.071624026444663647;
            end
            else
            begin
                Result := 0.040773307906534779;
            end;
        end;
    end;
end;

function visible_pairwise_tree_18(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -27532802.999999996 then
    begin
        Result := -0.024220597053613405;
    end
    else
    begin
        if features.delta_char_lm_score <= -1676.4999999999998 then
        begin
            Result := -0.0089931510623154805;
        end
        else
        begin
            if features.delta_dict_weight_per_unit <= 11409.500000000002 then
            begin
                if features.delta_path_single_segments <= 1.0000000180025095E-35 then
                begin
                    Result := 0.042849077597199074;
                end
                else
                begin
                    if features.delta_char_lm_suffix_score <= -1.0000000180025095E-35 then
                    begin
                        Result := 0.0090506739723412773;
                    end
                    else
                    begin
                        Result := 0.047028043900234018;
                    end;
                end;
            end
            else
            begin
                if features.delta_candidate_score <= -221.49999999999997 then
                begin
                    Result := 0.014048762407226601;
                end
                else
                begin
                    Result := 0.072916997682183654;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_19(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -29906484.999999996 then
    begin
        Result := -0.024889379141076091;
    end
    else
    begin
        if features.delta_char_lm_score <= -761.49999999999989 then
        begin
            if features.candidate_text_units <= 7.5000000000000009 then
            begin
                if features.candidate_source_rule_fallback <= 1.0000000180025095E-35 then
                begin
                    if features.delta_char_lm_score <= -1806.4999999999998 then
                    begin
                        Result := -0.0075867684117521001;
                    end
                    else
                    begin
                        Result := 0.056341270420118716;
                    end;
                end
                else
                begin
                    Result := -0.0058960577350598729;
                end;
            end
            else
            begin
                Result := -0.0031158964549354955;
            end;
        end
        else
        begin
            if features.candidate_path_single_segments <= 1.5000000000000002 then
            begin
                Result := 0.052448939400974816;
            end
            else
            begin
                Result := 0.032710915579771717;
            end;
        end;
    end;
end;

function visible_pairwise_tree_20(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score_gap <= -52780194.999999993 then
    begin
        if features.candidate_path_segments <= 1.0000000180025095E-35 then
        begin
            Result := -0.025072524065968632;
        end
        else
        begin
            if features.delta_char_lm_suffix_score <= -83.499999999999986 then
            begin
                Result := -0.0047317863381854943;
            end
            else
            begin
                Result := 0.064654390336234033;
            end;
        end;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -37446511.499999993 then
        begin
            if features.delta_path_single_segments <= 1.0000000180025095E-35 then
            begin
                Result := 0.031373799635364748;
            end
            else
            begin
                Result := 0.0087731526555450672;
            end;
        end
        else
        begin
            if features.baseline_abstain_score <= 1.2479930108789816 then
            begin
                Result := 0.0421190973941791;
            end
            else
            begin
                Result := -0.018226984976284815;
            end;
        end;
    end;
end;

function visible_pairwise_tree_21(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -29050782.499999996 then
    begin
        Result := -0.024378358953303002;
    end
    else
    begin
        if features.delta_char_lm_score <= -1806.4999999999998 then
        begin
            Result := -0.014917044535137484;
        end
        else
        begin
            if features.candidate_ranker_score_gap <= -3202697.9999999995 then
            begin
                if features.delta_dict_weight <= -2063.4999999999995 then
                begin
                    if features.delta_candidate_score <= 42836.000000000007 then
                    begin
                        if features.delta_char_lm_score <= -82.499999999999986 then
                        begin
                            Result := 0.0041096460394336974;
                        end
                        else
                        begin
                            Result := 0.03183882913723636;
                        end;
                    end
                    else
                    begin
                        Result := 0.13210467842282478;
                    end;
                end
                else
                begin
                    Result := 0.037062484015594664;
                end;
            end
            else
            begin
                Result := 0.088903147844338837;
            end;
        end;
    end;
end;

function visible_pairwise_tree_22(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024908810585845341;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -356.49999999999994 then
        begin
            if features.delta_char_lm_score <= -1806.4999999999998 then
            begin
                Result := -0.01397826099488101;
            end
            else
            begin
                if features.candidate_text_units <= 6.5000000000000009 then
                begin
                    Result := 0.042257887107454685;
                end
                else
                begin
                    if features.delta_dict_weight_per_unit <= 11409.500000000002 then
                    begin
                        Result := 0.0083072407972902725;
                    end
                    else
                    begin
                        Result := 0.034545998093427566;
                    end;
                end;
            end;
        end
        else
        begin
            if features.candidate_chain_rank <= 1.5000000000000002 then
            begin
                Result := 0.056104141304998689;
            end
            else
            begin
                Result := 0.030921259479697361;
            end;
        end;
    end;
end;

function visible_pairwise_tree_23(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -29050782.499999996 then
    begin
        Result := -0.024489549754404618;
    end
    else
    begin
        if features.delta_char_lm_score <= -721.49999999999989 then
        begin
            if features.candidate_source_rule_fallback <= 1.0000000180025095E-35 then
            begin
                if features.candidate_text_units <= 7.5000000000000009 then
                begin
                    if features.delta_char_lm_score <= -2118.4999999999995 then
                    begin
                        Result := -0.014599922955659423;
                    end
                    else
                    begin
                        Result := 0.043126388392849116;
                    end;
                end
                else
                begin
                    Result := 0.0054351805995699332;
                end;
            end
            else
            begin
                if features.delta_candidate_score <= 42836.000000000007 then
                begin
                    Result := -0.019842574448306595;
                end
                else
                begin
                    Result := 0.09705049502536231;
                end;
            end;
        end
        else
        begin
            Result := 0.033080832740741709;
        end;
    end;
end;

function visible_pairwise_tree_24(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.025050546476609988;
    end
    else
    begin
        if features.delta_char_lm_score <= -681.49999999999989 then
        begin
            if features.candidate_ranker_score_gap <= -52780194.999999993 then
            begin
                Result := -0.012421070496308133;
            end
            else
            begin
                Result := 0.017653746752928395;
            end;
        end
        else
        begin
            if features.candidate_score_per_unit <= 15140.500000000002 then
            begin
                if features.delta_char_lm_score <= -359.49999999999994 then
                begin
                    Result := 0.013624979079783096;
                end
                else
                begin
                    Result := 0.032421213204900955;
                end;
            end
            else
            begin
                if features.delta_candidate_score <= -1.0000000180025095E-35 then
                begin
                    Result := 0.021276552031300248;
                end
                else
                begin
                    Result := 0.071645321952727312;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_25(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024880333886120511;
    end
    else
    begin
        if features.delta_char_lm_score <= -1676.4999999999998 then
        begin
            Result := -0.010638466785461997;
        end
        else
        begin
            if features.delta_dict_weight_per_unit <= -435.99999999999994 then
            begin
                if features.delta_candidate_score <= 42836.000000000007 then
                begin
                    if features.candidate_ranker_score <= 1304858.0000000002 then
                    begin
                        Result := 0.0066038537962720308;
                    end
                    else
                    begin
                        Result := 0.036411354123384941;
                    end;
                end
                else
                begin
                    Result := 0.11247318913212159;
                end;
            end
            else
            begin
                if features.delta_chain_first_stage_score <= 434.00000000000006 then
                begin
                    Result := 0.035815193012159338;
                end
                else
                begin
                    Result := 0.017959951470238069;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_26(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024871260908013334;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -318.49999999999994 then
        begin
            if features.candidate_ranker_score_gap <= -39744917.999999993 then
            begin
                Result := 0.0039015431239138236;
            end
            else
            begin
                if features.delta_path_single_segments <= 1.0000000180025095E-35 then
                begin
                    Result := 0.039607745238956341;
                end
                else
                begin
                    Result := 0.011542026860019145;
                end;
            end;
        end
        else
        begin
            if features.delta_path_max_segment_units <= 1.0000000180025095E-35 then
            begin
                if features.candidate_ranker_score <= 11175094.500000002 then
                begin
                    Result := 0.024510825786025797;
                end
                else
                begin
                    Result := 0.0744227022537612;
                end;
            end
            else
            begin
                Result := 0.056509457080386231;
            end;
        end;
    end;
end;

function visible_pairwise_tree_27(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024860459855684691;
    end
    else
    begin
        if features.delta_char_lm_score <= -681.49999999999989 then
        begin
            if features.delta_score_per_unit <= 5424.5000000000009 then
            begin
                if features.delta_dict_weight_per_unit <= 602.50000000000011 then
                begin
                    Result := -0.0099204240638292203;
                end
                else
                begin
                    Result := 0.016463104617582464;
                end;
            end
            else
            begin
                if features.delta_chain_score_gap <= -35129879.999999993 then
                begin
                    Result := 0.0029083071965634675;
                end
                else
                begin
                    Result := 0.11455298087157229;
                end;
            end;
        end
        else
        begin
            if features.candidate_path_single_segments <= 1.5000000000000002 then
            begin
                Result := 0.036919063985334379;
            end
            else
            begin
                Result := 0.022234538585072596;
            end;
        end;
    end;
end;

function visible_pairwise_tree_28(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024851148927418965;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -318.49999999999994 then
        begin
            if features.delta_char_lm_score <= -1806.4999999999998 then
            begin
                Result := -0.015159238467230836;
            end
            else
            begin
                if features.candidate_path_segments <= 7.5000000000000009 then
                begin
                    if features.delta_dict_weight_per_unit <= -435.99999999999994 then
                    begin
                        Result := 0.0022115739533546518;
                    end
                    else
                    begin
                        Result := 0.025352672840354758;
                    end;
                end
                else
                begin
                    Result := -0.0064405680342833997;
                end;
            end;
        end
        else
        begin
            if features.delta_path_max_segment_units <= 1.0000000180025095E-35 then
            begin
                Result := 0.024515399554458178;
            end
            else
            begin
                Result := 0.050823872094077564;
            end;
        end;
    end;
end;

function visible_pairwise_tree_29(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -29906484.999999996 then
    begin
        Result := -0.02484191219975249;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -1425.4999999999998 then
        begin
            Result := -0.0094271781358970866;
        end
        else
        begin
            if features.candidate_ranker_score_gap <= -3202697.9999999995 then
            begin
                if features.candidate_text_units <= 8.5000000000000018 then
                begin
                    if features.delta_candidate_score <= -1.0000000180025095E-35 then
                    begin
                        Result := 0.017800873784180694;
                    end
                    else
                    begin
                        Result := 0.038813812531407532;
                    end;
                end
                else
                begin
                    if features.delta_char_lm_score <= -476.49999999999994 then
                    begin
                        Result := 0.0038739349589719616;
                    end
                    else
                    begin
                        Result := 0.021867231393229741;
                    end;
                end;
            end
            else
            begin
                Result := 0.067014714010244433;
            end;
        end;
    end;
end;

function visible_pairwise_tree_30(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024831237996253908;
    end
    else
    begin
        if features.delta_char_lm_score <= -1676.4999999999998 then
        begin
            Result := -0.011673800612833553;
        end
        else
        begin
            if features.delta_path_single_segments <= 1.0000000180025095E-35 then
            begin
                if features.candidate_text_units <= 6.5000000000000009 then
                begin
                    Result := 0.053188558861666471;
                end
                else
                begin
                    Result := 0.023539610033965687;
                end;
            end
            else
            begin
                if features.delta_dict_weight_per_unit <= 11409.500000000002 then
                begin
                    if features.candidate_ranker_score_gap <= -14880512.999999998 then
                    begin
                        Result := 0.0036545050652700578;
                    end
                    else
                    begin
                        Result := 0.042883723044577167;
                    end;
                end
                else
                begin
                    Result := 0.033351970239345989;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_31(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024820615304574759;
    end
    else
    begin
        if features.delta_char_lm_score <= -761.49999999999989 then
        begin
            if features.delta_score_per_unit <= 5424.5000000000009 then
            begin
                if features.candidate_source_rule_fallback <= 1.0000000180025095E-35 then
                begin
                    Result := 0.010677395095317755;
                end
                else
                begin
                    Result := -0.019898144501009681;
                end;
            end
            else
            begin
                if features.candidate_dict_weight <= 64610.000000000007 then
                begin
                    Result := 0.11374049236988532;
                end
                else
                begin
                    Result := 0.0045568543696068182;
                end;
            end;
        end
        else
        begin
            if features.candidate_chain_rank <= 1.5000000000000002 then
            begin
                Result := 0.031523861036252779;
            end
            else
            begin
                Result := 0.01808490731791795;
            end;
        end;
    end;
end;

function visible_pairwise_tree_32(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024876844178901958;
    end
    else
    begin
        if features.delta_char_lm_score <= -681.49999999999989 then
        begin
            if features.delta_candidate_score <= -1.0000000180025095E-35 then
            begin
                Result := -0.0083065008358013843;
            end
            else
            begin
                if features.candidate_char_lm_suffix_score <= -6428.4999999999991 then
                begin
                    if features.candidate_path_single_segments <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.05226294778062375;
                    end
                    else
                    begin
                        Result := 0.010978173441963715;
                    end;
                end
                else
                begin
                    Result := 0.00028367590459250425;
                end;
            end;
        end
        else
        begin
            if features.delta_path_max_segment_units <= 1.0000000180025095E-35 then
            begin
                Result := 0.01867651264598175;
            end
            else
            begin
                Result := 0.032918284680240807;
            end;
        end;
    end;
end;

function visible_pairwise_tree_33(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024800282244707084;
    end
    else
    begin
        if features.delta_char_lm_score <= -1676.4999999999998 then
        begin
            Result := -0.011504045191997631;
        end
        else
        begin
            if features.delta_path_single_segments <= 1.0000000180025095E-35 then
            begin
                if features.candidate_text_units <= 6.5000000000000009 then
                begin
                    Result := 0.04929470861109729;
                end
                else
                begin
                    Result := 0.020858880769820464;
                end;
            end
            else
            begin
                if features.candidate_ranker_score_gap <= -37715374.999999993 then
                begin
                    Result := -0.0033636738646808766;
                end
                else
                begin
                    if features.candidate_text_units <= 11.500000000000002 then
                    begin
                        Result := 0.026543322732617565;
                    end
                    else
                    begin
                        Result := 0.0022242292443254235;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_34(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024789550933897869;
    end
    else
    begin
        if features.delta_char_lm_score <= -1806.4999999999998 then
        begin
            Result := -0.013331422241554081;
        end
        else
        begin
            if features.candidate_text_units <= 6.5000000000000009 then
            begin
                Result := 0.031958814492445753;
            end
            else
            begin
                if features.delta_char_lm_suffix_score <= -279.49999999999994 then
                begin
                    Result := 0.0093974363319319076;
                end
                else
                begin
                    if features.candidate_ranker_score <= 15331123.500000002 then
                    begin
                        if features.delta_chain_first_stage_score <= 434.00000000000006 then
                        begin
                            Result := 0.023056982277364659;
                        end
                        else
                        begin
                            Result := 0.00039660146295020872;
                        end;
                    end
                    else
                    begin
                        Result := 0.05549839336622725;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_35(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -29906484.999999996 then
    begin
        Result := -0.024779902275796465;
    end
    else
    begin
        if features.delta_char_lm_score <= -1806.4999999999998 then
        begin
            Result := -0.014403956949740938;
        end
        else
        begin
            if features.delta_dict_weight <= -2063.4999999999995 then
            begin
                if features.delta_candidate_score <= 42836.000000000007 then
                begin
                    if features.candidate_ranker_score_gap <= -11410693.999999998 then
                    begin
                        Result := 0.0047221494799530774;
                    end
                    else
                    begin
                        Result := 0.053150447644432011;
                    end;
                end
                else
                begin
                    Result := 0.099559672746179689;
                end;
            end
            else
            begin
                if features.candidate_path_segments <= 7.5000000000000009 then
                begin
                    Result := 0.023702565513004148;
                end
                else
                begin
                    Result := 0.0096084658265452646;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_36(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -28771663.999999996 then
    begin
        Result := -0.024220199784943067;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -123.49999999999999 then
        begin
            if features.delta_dict_weight <= -8997.4999999999982 then
            begin
                if features.delta_candidate_score <= 42836.000000000007 then
                begin
                    if features.delta_score_per_unit <= -2191.9999999999995 then
                    begin
                        Result := 0.022190817657405583;
                    end
                    else
                    begin
                        Result := -0.014408707581910006;
                    end;
                end
                else
                begin
                    Result := 0.09816159733025398;
                end;
            end
            else
            begin
                Result := 0.016227110904688074;
            end;
        end
        else
        begin
            if features.candidate_chain_rank <= 1.5000000000000002 then
            begin
                Result := 0.042487954420009737;
            end
            else
            begin
                Result := 0.017278670614762102;
            end;
        end;
    end;
end;

function visible_pairwise_tree_37(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024757772679445476;
    end
    else
    begin
        if features.delta_char_lm_score <= -1806.4999999999998 then
        begin
            Result := -0.015738056542725493;
        end
        else
        begin
            if features.delta_dict_weight <= -2063.4999999999995 then
            begin
                if features.delta_candidate_score <= 42836.000000000007 then
                begin
                    if features.delta_char_lm_suffix_score <= -103.49999999999999 then
                    begin
                        Result := -0.0031821146345163381;
                    end
                    else
                    begin
                        Result := 0.01798040594090141;
                    end;
                end
                else
                begin
                    Result := 0.086243801827329325;
                end;
            end
            else
            begin
                if features.delta_chain_first_stage_score <= 1.0000000180025095E-35 then
                begin
                    Result := 0.026176484354788393;
                end
                else
                begin
                    Result := 0.011587442226715176;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_38(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024746118147919317;
    end
    else
    begin
        if features.delta_char_lm_score <= -476.49999999999994 then
        begin
            if features.candidate_text_units <= 7.5000000000000009 then
            begin
                Result := 0.020193428943849939;
            end
            else
            begin
                Result := 0.0010419531241189154;
            end;
        end
        else
        begin
            if features.baseline_abstain_score <= 0.97303776155812505 then
            begin
                if features.candidate_ranker_score <= 6394579.5000000009 then
                begin
                    if features.delta_score_per_unit <= -184.49999999999997 then
                    begin
                        Result := 0.0099111288406686978;
                    end
                    else
                    begin
                        Result := 0.024108172638692447;
                    end;
                end
                else
                begin
                    Result := 0.037477653620849927;
                end;
            end
            else
            begin
                Result := -0.0044308552312120148;
            end;
        end;
    end;
end;

function visible_pairwise_tree_39(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024735230354992616;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -1425.4999999999998 then
        begin
            Result := -0.0077613909538595885;
        end
        else
        begin
            if features.candidate_ranker_score_gap <= -3202697.9999999995 then
            begin
                if features.delta_dict_weight_per_unit <= -133.49999999999997 then
                begin
                    if features.delta_score_per_unit <= 4850.5000000000009 then
                    begin
                        Result := 0.005285403183413459;
                    end
                    else
                    begin
                        Result := 0.07194857229476985;
                    end;
                end
                else
                begin
                    if features.delta_chain_first_stage_score <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.022785259108707455;
                    end
                    else
                    begin
                        Result := 0.0094348762022425977;
                    end;
                end;
            end
            else
            begin
                Result := 0.050220022235704612;
            end;
        end;
    end;
end;

function visible_pairwise_tree_40(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024724787327525557;
    end
    else
    begin
        if features.delta_char_lm_score <= -681.49999999999989 then
        begin
            if features.delta_score_per_unit <= 5424.5000000000009 then
            begin
                Result := 0.0017772458035308484;
            end
            else
            begin
                if features.delta_dict_weight <= 66107.000000000015 then
                begin
                    if features.candidate_char_lm_score <= -5404.4999999999991 then
                    begin
                        Result := 0.12250103802541822;
                    end
                    else
                    begin
                        Result := 0.0;
                    end;
                end
                else
                begin
                    Result := 0.0091682783728224016;
                end;
            end;
        end
        else
        begin
            if features.baseline_abstain_score <= 0.97303776155812505 then
            begin
                Result := 0.01801596566930054;
            end
            else
            begin
                Result := -0.0086170234027935881;
            end;
        end;
    end;
end;

function visible_pairwise_tree_41(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024713086294606331;
    end
    else
    begin
        if features.delta_char_lm_score <= -761.49999999999989 then
        begin
            if features.delta_score_per_unit <= 5424.5000000000009 then
            begin
                if features.candidate_source_rule_fallback <= 1.0000000180025095E-35 then
                begin
                    if features.candidate_text_units <= 7.5000000000000009 then
                    begin
                        Result := 0.020820428386656396;
                    end
                    else
                    begin
                        Result := -0.0049173032715998091;
                    end;
                end
                else
                begin
                    Result := -0.022030206971234437;
                end;
            end
            else
            begin
                if features.candidate_chain_score_gap <= -58534888.499999993 then
                begin
                    Result := -0.0048544074339228549;
                end
                else
                begin
                    Result := 0.072312698897318284;
                end;
            end;
        end
        else
        begin
            Result := 0.016506949294647768;
        end;
    end;
end;

function visible_pairwise_tree_42(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -29906484.999999996 then
    begin
        Result := -0.024702073432771393;
    end
    else
    begin
        if features.delta_char_lm_score <= -1806.4999999999998 then
        begin
            Result := -0.015698661377364895;
        end
        else
        begin
            if features.candidate_ranker_score_gap <= -14880512.999999998 then
            begin
                if features.delta_dict_weight <= -2063.4999999999995 then
                begin
                    if features.delta_score_per_unit <= 4850.5000000000009 then
                    begin
                        Result := 0.0026894143613087531;
                    end
                    else
                    begin
                        Result := 0.066418907716823683;
                    end;
                end
                else
                begin
                    if features.candidate_path_segments <= 7.5000000000000009 then
                    begin
                        Result := 0.018986024661156505;
                    end
                    else
                    begin
                        Result := 0.0051136262041502241;
                    end;
                end;
            end
            else
            begin
                Result := 0.031074226387593863;
            end;
        end;
    end;
end;

function visible_pairwise_tree_43(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024688461455313254;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -37177529.499999993 then
        begin
            if features.delta_char_lm_suffix_score <= -20.499999999999996 then
            begin
                Result := 0.0044033500875446585;
            end
            else
            begin
                if features.candidate_dict_weight_per_unit <= 5360.5000000000009 then
                begin
                    Result := 0.041999722509685172;
                end
                else
                begin
                    Result := 0.0071789894516324287;
                end;
            end;
        end
        else
        begin
            if features.candidate_chain_first_stage_score <= 1.0000000180025095E-35 then
            begin
                Result := 0.029723555544656194;
            end
            else
            begin
                if features.delta_char_lm_suffix_score <= 210.50000000000003 then
                begin
                    Result := 0.014307402522658108;
                end
                else
                begin
                    Result := -0.010810638170863904;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_44(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024677533599379225;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -259.49999999999994 then
        begin
            if features.candidate_path_segments <= 7.5000000000000009 then
            begin
                if features.candidate_ranker_score_gap <= -43538027.999999993 then
                begin
                    Result := 0.0012581119282966049;
                end
                else
                begin
                    Result := 0.015005866504578844;
                end;
            end
            else
            begin
                Result := -0.0086753630806573525;
            end;
        end
        else
        begin
            if features.delta_path_max_segment_units <= 1.0000000180025095E-35 then
            begin
                if features.candidate_ranker_score <= 15726501.000000002 then
                begin
                    Result := 0.01272094164855684;
                end
                else
                begin
                    Result := 0.04645486800784842;
                end;
            end
            else
            begin
                Result := 0.035384011294599657;
            end;
        end;
    end;
end;

function visible_pairwise_tree_45(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -29050782.499999996 then
    begin
        Result := -0.024071534527489141;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -37177529.499999993 then
        begin
            if features.delta_path_single_segments <= 1.0000000180025095E-35 then
            begin
                if features.delta_path_segments <= -1.4999999999999998 then
                begin
                    Result := -0.0023463387564536596;
                end
                else
                begin
                    if features.candidate_text_units <= 12.500000000000002 then
                    begin
                        Result := 0.020043179259433594;
                    end
                    else
                    begin
                        Result := 0.00016037641011964468;
                    end;
                end;
            end
            else
            begin
                Result := -0.0024000316639808845;
            end;
        end
        else
        begin
            if features.delta_char_lm_suffix_score <= 210.50000000000003 then
            begin
                Result := 0.018931502550905532;
            end
            else
            begin
                Result := -0.0026309632655206663;
            end;
        end;
    end;
end;

function visible_pairwise_tree_46(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024651428201913721;
    end
    else
    begin
        if features.delta_char_lm_context_score <= -279.49999999999994 then
        begin
            if features.candidate_ranker_score_gap <= -39744917.999999993 then
            begin
                if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
                begin
                    Result := 0.048926363582576606;
                end
                else
                begin
                    Result := -0.0032251628274640553;
                end;
            end
            else
            begin
                if features.delta_path_single_segments <= 1.0000000180025095E-35 then
                begin
                    Result := 0.020706902933351902;
                end
                else
                begin
                    Result := 0.0032993806047123806;
                end;
            end;
        end
        else
        begin
            if features.delta_path_max_segment_units <= 1.0000000180025095E-35 then
            begin
                Result := 0.012324270151582649;
            end
            else
            begin
                Result := 0.031616868108406235;
            end;
        end;
    end;
end;

function visible_pairwise_tree_47(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024922386616088695;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -453.49999999999994 then
        begin
            if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
            begin
                Result := 0.053495629720983866;
            end
            else
            begin
                Result := 0.0026137841144422752;
            end;
        end
        else
        begin
            if features.candidate_chain_rank <= 1.5000000000000002 then
            begin
                if features.delta_char_lm_suffix_score <= -1.0000000180025095E-35 then
                begin
                    Result := 0.014572203649175809;
                end
                else
                begin
                    Result := 0.038463593930218878;
                end;
            end
            else
            begin
                if features.delta_chain_first_stage_score <= 434.00000000000006 then
                begin
                    Result := 0.013780967762213506;
                end
                else
                begin
                    Result := -0.0026922504019577941;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_48(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024627907112539038;
    end
    else
    begin
        if features.delta_char_lm_score <= -681.49999999999989 then
        begin
            if features.delta_score_per_unit <= 5424.5000000000009 then
            begin
                if features.delta_dict_weight_per_unit <= 602.50000000000011 then
                begin
                    Result := -0.011907144176351784;
                end
                else
                begin
                    Result := 0.0069995004165482981;
                end;
            end
            else
            begin
                if features.delta_dict_weight <= 66107.000000000015 then
                begin
                    Result := 0.073797152208945241;
                end
                else
                begin
                    Result := 0.0072245295428578485;
                end;
            end;
        end
        else
        begin
            if features.delta_candidate_score <= -2046.4999999999998 then
            begin
                Result := 0.0064196308947587601;
            end
            else
            begin
                Result := 0.016572907763915946;
            end;
        end;
    end;
end;

function visible_pairwise_tree_49(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024714939999788809;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= -253219802.49999997 then
        begin
            Result := -0.012613432408679584;
        end
        else
        begin
            if features.candidate_char_lm_suffix_score <= -6935.4999999999991 then
            begin
                Result := 0.019105687015443625;
            end
            else
            begin
                if features.delta_char_lm_score <= -1078.4999999999998 then
                begin
                    Result := -0.006900717274647159;
                end
                else
                begin
                    if features.candidate_text_units <= 10.500000000000002 then
                    begin
                        Result := 0.016075455775135101;
                    end
                    else
                    begin
                        if features.delta_char_lm_score <= -507.49999999999994 then
                        begin
                            Result := -0.011038478927672466;
                        end
                        else
                        begin
                            Result := 0.0079446493724616273;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_50(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.02460148305115395;
    end
    else
    begin
        if features.delta_char_lm_score <= -1806.4999999999998 then
        begin
            Result := -0.013249919128069668;
        end
        else
        begin
            if features.candidate_path_single_segments <= 1.5000000000000002 then
            begin
                if features.candidate_char_lm_suffix_score <= -6980.4999999999991 then
                begin
                    if features.delta_candidate_score <= -1.0000000180025095E-35 then
                    begin
                        Result := 0.012122892286824956;
                    end
                    else
                    begin
                        if features.candidate_path_max_segment_units <= 2.5000000000000004 then
                        begin
                            Result := 0.018281470634136581;
                        end
                        else
                        begin
                            Result := 0.070499897298298142;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.012278760228820636;
                end;
            end
            else
            begin
                Result := 0.0074037786383207033;
            end;
        end;
    end;
end;

function visible_pairwise_tree_51(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -29906484.999999996 then
    begin
        Result := -0.024591114636499652;
    end
    else
    begin
        if features.delta_char_lm_score <= -1806.4999999999998 then
        begin
            Result := -0.01431303382447994;
        end
        else
        begin
            if features.candidate_ranker_score_gap <= -3202697.9999999995 then
            begin
                if features.candidate_path_single_segments <= 1.5000000000000002 then
                begin
                    if features.candidate_char_lm_context_score <= -8707.4999999999982 then
                    begin
                        Result := 0.074100876346950936;
                    end
                    else
                    begin
                        if features.candidate_ranker_score_gap <= -40343441.499999993 then
                        begin
                            Result := 0.0075460943710053885;
                        end
                        else
                        begin
                            Result := 0.018898289985596825;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.0071408676075138677;
                end;
            end
            else
            begin
                Result := 0.043424735106512569;
            end;
        end;
    end;
end;

function visible_pairwise_tree_52(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.02457468029344808;
    end
    else
    begin
        if features.delta_path_single_segments <= 1.5000000000000002 then
        begin
            if features.candidate_candidate_score <= 28794.000000000004 then
            begin
                Result := 0.03241486544126343;
            end
            else
            begin
                if features.candidate_char_lm_suffix_score <= -6980.4999999999991 then
                begin
                    Result := 0.021219061651800392;
                end
                else
                begin
                    if features.delta_dict_weight_per_unit <= -133.49999999999997 then
                    begin
                        Result := -0.0019356143331951956;
                    end
                    else
                    begin
                        Result := 0.01141770155551293;
                    end;
                end;
            end;
        end
        else
        begin
            if features.delta_char_lm_suffix_score <= -1.0000000180025095E-35 then
            begin
                Result := -0.0026357999951323596;
            end
            else
            begin
                Result := 0.017537883665418169;
            end;
        end;
    end;
end;

function visible_pairwise_tree_53(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024561310650173713;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -103.49999999999999 then
        begin
            if features.delta_dict_weight <= -8997.4999999999982 then
            begin
                if features.delta_score_per_unit <= 4850.5000000000009 then
                begin
                    if features.delta_score_per_unit <= -2191.9999999999995 then
                    begin
                        Result := 0.010758847973967678;
                    end
                    else
                    begin
                        Result := -0.016347452595894259;
                    end;
                end
                else
                begin
                    Result := 0.070929007090177645;
                end;
            end
            else
            begin
                Result := 0.0095555074898102943;
            end;
        end
        else
        begin
            if features.delta_path_max_segment_units <= 1.0000000180025095E-35 then
            begin
                Result := 0.010722115998039801;
            end
            else
            begin
                Result := 0.039924784223345479;
            end;
        end;
    end;
end;

function visible_pairwise_tree_54(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024546640098955835;
    end
    else
    begin
        if features.delta_char_lm_score <= -1806.4999999999998 then
        begin
            Result := -0.01308249456512508;
        end
        else
        begin
            if features.candidate_chain_first_stage_score <= 209184.00000000003 then
            begin
                if features.candidate_char_lm_suffix_score <= -5659.4999999999991 then
                begin
                    if features.delta_path_single_segments <= 1.5000000000000002 then
                    begin
                        Result := 0.016425241819829937;
                    end
                    else
                    begin
                        if features.candidate_ranker_score_gap <= -37177529.499999993 then
                        begin
                            Result := -0.0086194580599847706;
                        end
                        else
                        begin
                            Result := 0.013051494373325857;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.0045464636147920044;
                end;
            end
            else
            begin
                Result := -0.0036927085595337555;
            end;
        end;
    end;
end;

function visible_pairwise_tree_55(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024648420470911401;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -3202697.9999999995 then
        begin
            if features.delta_path_single_segments <= 1.5000000000000002 then
            begin
                if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
                begin
                    Result := 0.05294284983669461;
                end
                else
                begin
                    if features.delta_char_lm_score <= -1806.4999999999998 then
                    begin
                        Result := -0.018309584472568859;
                    end
                    else
                    begin
                        if features.delta_path_segments <= 1.5000000000000002 then
                        begin
                            Result := 0.0088001742977295207;
                        end
                        else
                        begin
                            Result := 0.022031681410498202;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := 0.0017805662104560143;
            end;
        end
        else
        begin
            Result := 0.038655853767928086;
        end;
    end;
end;

function visible_pairwise_tree_56(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024517095596520683;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= -333363365.99999994 then
        begin
            Result := -0.022042353203221874;
        end
        else
        begin
            if features.delta_char_lm_score <= -1676.4999999999998 then
            begin
                Result := -0.010531334157801123;
            end
            else
            begin
                if features.delta_dict_weight_per_unit <= 11409.500000000002 then
                begin
                    if features.delta_path_single_segments <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.01004515312982643;
                    end
                    else
                    begin
                        Result := 0.0011623463895488568;
                    end;
                end
                else
                begin
                    if features.delta_candidate_score <= -221.49999999999997 then
                    begin
                        Result := -0.0034211903175249895;
                    end
                    else
                    begin
                        Result := 0.024298413046584512;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_57(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024624398118767935;
    end
    else
    begin
        if features.delta_char_lm_score <= -681.49999999999989 then
        begin
            if features.candidate_text_units <= 7.5000000000000009 then
            begin
                if features.candidate_chain_score_gap <= -202005074.49999997 then
                begin
                    Result := 0.063771871084458545;
                end
                else
                begin
                    Result := 0.0064678659476707272;
                end;
            end
            else
            begin
                Result := -0.00636311622124519;
            end;
        end
        else
        begin
            if features.candidate_score_per_unit <= 14350.500000000002 then
            begin
                Result := 0.0082013806205507422;
            end
            else
            begin
                if features.delta_candidate_score <= -1.0000000180025095E-35 then
                begin
                    Result := 0.0042501715415864689;
                end
                else
                begin
                    Result := 0.030634310435906517;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_58(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.02448802354321809;
    end
    else
    begin
        if features.delta_char_lm_score <= -1806.4999999999998 then
        begin
            Result := -0.016990596367176921;
        end
        else
        begin
            if features.delta_char_lm_context_score <= -240.49999999999997 then
            begin
                if features.candidate_char_lm_suffix_score <= -6935.4999999999991 then
                begin
                    Result := 0.016900194276967751;
                end
                else
                begin
                    if features.candidate_ranker_score <= -3102174.9999999995 then
                    begin
                        Result := -0.0057747276159118184;
                    end
                    else
                    begin
                        Result := 0.006935149243711608;
                    end;
                end;
            end
            else
            begin
                if features.delta_path_max_segment_units <= 1.0000000180025095E-35 then
                begin
                    Result := 0.0089984376133923332;
                end
                else
                begin
                    Result := 0.027809457219093444;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_59(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024849641193671265;
    end
    else
    begin
        if features.delta_char_lm_context_score <= -299.49999999999994 then
        begin
            if features.candidate_text_units <= 6.5000000000000009 then
            begin
                Result := 0.014438186498285875;
            end
            else
            begin
                Result := 0.00079934504847283666;
            end;
        end
        else
        begin
            if features.candidate_chain_rank <= 1.5000000000000002 then
            begin
                Result := 0.021139740307356547;
            end
            else
            begin
                if features.delta_chain_first_stage_score <= 434.00000000000006 then
                begin
                    if features.delta_char_lm_context_score <= 308.50000000000006 then
                    begin
                        Result := 0.013379829127014593;
                    end
                    else
                    begin
                        Result := -0.016201874424049561;
                    end;
                end
                else
                begin
                    Result := -0.0048375260826828137;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_60(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -29906484.999999996 then
    begin
        Result := -0.024459617180165257;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -3202697.9999999995 then
        begin
            if features.delta_chain_second_stage_score <= -253219802.49999997 then
            begin
                Result := -0.012726208778900423;
            end
            else
            begin
                if features.delta_char_lm_score <= 308.50000000000006 then
                begin
                    if features.delta_char_lm_suffix_score <= -182.49999999999997 then
                    begin
                        Result := 0.0050263328628887168;
                    end
                    else
                    begin
                        if features.delta_path_max_segment_units <= 1.0000000180025095E-35 then
                        begin
                            Result := 0.0088074135184140548;
                        end
                        else
                        begin
                            Result := 0.031287702223566791;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.014998919564785619;
                end;
            end;
        end
        else
        begin
            Result := 0.038345374243433157;
        end;
    end;
end;

function visible_pairwise_tree_61(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024440215001864132;
    end
    else
    begin
        if features.candidate_ranker_score <= -3102174.9999999995 then
        begin
            if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
            begin
                Result := 0.045900471315613006;
            end
            else
            begin
                if features.candidate_text_units <= 12.500000000000002 then
                begin
                    if features.delta_char_lm_suffix_score <= -299.49999999999994 then
                    begin
                        if features.candidate_char_lm_suffix_score <= -6980.4999999999991 then
                        begin
                            Result := 0.010275964730298333;
                        end
                        else
                        begin
                            Result := -0.0058384299730936421;
                        end;
                    end
                    else
                    begin
                        Result := 0.01496841204289371;
                    end;
                end
                else
                begin
                    Result := -0.008501159157412598;
                end;
            end;
        end
        else
        begin
            Result := 0.01015501359182041;
        end;
    end;
end;

function visible_pairwise_tree_62(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024829106150253862;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -1425.4999999999998 then
        begin
            Result := -0.010397720991149521;
        end
        else
        begin
            if features.delta_chain_second_stage_score <= -221019079.49999997 then
            begin
                Result := -0.010348030348756296;
            end
            else
            begin
                if features.candidate_chain_second_stage_score <= 390848988.00000006 then
                begin
                    if features.candidate_path_segments <= 7.5000000000000009 then
                    begin
                        Result := 0.010794779117336596;
                    end
                    else
                    begin
                        if features.delta_char_lm_suffix_score <= -356.49999999999994 then
                        begin
                            Result := -0.013859462652049579;
                        end
                        else
                        begin
                            Result := 0.0062983954211639675;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.01085532253474979;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_63(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.candidate_ranker_score_gap <= -3202697.9999999995 then
        begin
            if features.delta_dict_weight <= -8997.4999999999982 then
            begin
                if features.delta_score_per_unit <= 4850.5000000000009 then
                begin
                    if features.delta_score_per_unit <= -3882.4999999999995 then
                    begin
                        if features.delta_chain_first_stage_score <= -90556.499999999985 then
                        begin
                            Result := -0.0043913144362808269;
                        end
                        else
                        begin
                            Result := 0.022457263868291496;
                        end;
                    end
                    else
                    begin
                        Result := -0.008179723229374743;
                    end;
                end
                else
                begin
                    Result := 0.05011196316385183;
                end;
            end
            else
            begin
                Result := 0.0082755126837522289;
            end;
        end
        else
        begin
            Result := 0.034912219028460437;
        end;
    end
    else
    begin
        Result := -0.024822632702091917;
    end;
end;

function visible_pairwise_tree_64(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024815521286350905;
    end
    else
    begin
        if features.delta_char_lm_score <= -761.49999999999989 then
        begin
            if features.candidate_text_units <= 7.5000000000000009 then
            begin
                if features.candidate_chain_rank <= 1.5000000000000002 then
                begin
                    if features.delta_score_per_unit <= 7117.5000000000009 then
                    begin
                        if features.candidate_dict_weight_per_unit <= 4337.5000000000009 then
                        begin
                            Result := -0.018300756934792741;
                        end
                        else
                        begin
                            Result := 0.012946134695902292;
                        end;
                    end
                    else
                    begin
                        Result := 0.057381657099522435;
                    end;
                end
                else
                begin
                    Result := 0.047948145670540704;
                end;
            end
            else
            begin
                Result := -0.0093696410584170869;
            end;
        end
        else
        begin
            Result := 0.0084990939649728717;
        end;
    end;
end;

function visible_pairwise_tree_65(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.02480794353009742;
    end
    else
    begin
        if features.delta_char_lm_score <= -681.49999999999989 then
        begin
            if features.delta_candidate_score <= -1.0000000180025095E-35 then
            begin
                Result := -0.010456165003676457;
            end
            else
            begin
                if features.candidate_char_lm_suffix_score <= -7286.4999999999991 then
                begin
                    Result := 0.028389184496720534;
                end
                else
                begin
                    Result := 0.00060956590669611517;
                end;
            end;
        end
        else
        begin
            if features.delta_char_lm_context_score <= 342.50000000000006 then
            begin
                if features.candidate_dict_weight <= 48841.000000000007 then
                begin
                    Result := 0.017166415244887216;
                end
                else
                begin
                    Result := 0.0064506741006778029;
                end;
            end
            else
            begin
                Result := -0.018335669609495512;
            end;
        end;
    end;
end;

function visible_pairwise_tree_66(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024801299901259476;
    end
    else
    begin
        if features.delta_char_lm_score <= -2118.4999999999995 then
        begin
            Result := -0.018405842084612042;
        end
        else
        begin
            if features.baseline_abstain_score <= 1.0410326842613473 then
            begin
                if features.candidate_char_lm_context_score <= -6935.4999999999991 then
                begin
                    Result := 0.015049485994371052;
                end
                else
                begin
                    if features.delta_char_lm_suffix_score <= -201.49999999999997 then
                    begin
                        Result := 0.0020407944831094022;
                    end
                    else
                    begin
                        if features.delta_path_available <= 1.0000000180025095E-35 then
                        begin
                            Result := 0.0081487421535971754;
                        end
                        else
                        begin
                            Result := 0.031463576743905507;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := -0.013906516412789158;
            end;
        end;
    end;
end;

function visible_pairwise_tree_67(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024793464434245231;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= -253219802.49999997 then
        begin
            Result := -0.015145922746763235;
        end
        else
        begin
            if features.delta_char_lm_score <= -2118.4999999999995 then
            begin
                Result := -0.017758455896457331;
            end
            else
            begin
                if features.candidate_char_lm_context_score <= -8707.4999999999982 then
                begin
                    if features.candidate_ranker_score <= -4779062.9999999991 then
                    begin
                        Result := 0.066763638251542717;
                    end
                    else
                    begin
                        Result := -0.0055359495360447694;
                    end;
                end
                else
                begin
                    if features.candidate_chain_first_stage_score <= 178217.00000000003 then
                    begin
                        Result := 0.0075348124617874226;
                    end
                    else
                    begin
                        Result := -0.0022608359022499957;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_68(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024785652365863473;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -3202697.9999999995 then
        begin
            if features.delta_dict_weight_per_unit <= -435.99999999999994 then
            begin
                if features.delta_score_per_unit <= 4850.5000000000009 then
                begin
                    if features.delta_candidate_score <= -50557.999999999993 then
                    begin
                        if features.delta_chain_first_stage_score <= -90556.499999999985 then
                        begin
                            Result := -0.0050478842426080091;
                        end
                        else
                        begin
                            Result := 0.026544132099057146;
                        end;
                    end
                    else
                    begin
                        Result := -0.0064679228509329631;
                    end;
                end
                else
                begin
                    Result := 0.046332542018532284;
                end;
            end
            else
            begin
                Result := 0.0083887695328995759;
            end;
        end
        else
        begin
            Result := 0.032070430313093777;
        end;
    end;
end;

function visible_pairwise_tree_69(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.delta_char_lm_score <= -507.49999999999994 then
        begin
            if features.candidate_text_units <= 7.5000000000000009 then
            begin
                Result := 0.0096429526466892228;
            end
            else
            begin
                if features.delta_score_per_unit <= 4279.5000000000009 then
                begin
                    Result := -0.0081524708376931477;
                end
                else
                begin
                    if features.delta_chain_score_gap <= -35129879.999999993 then
                    begin
                        Result := -0.0064102073980510255;
                    end
                    else
                    begin
                        Result := 0.040112477579937411;
                    end;
                end;
            end;
        end
        else
        begin
            if features.delta_char_lm_suffix_score <= 342.50000000000006 then
            begin
                Result := 0.0090047678189648164;
            end
            else
            begin
                Result := -0.01561766802659059;
            end;
        end;
    end
    else
    begin
        Result := -0.024778039835382869;
    end;
end;

function visible_pairwise_tree_70(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024770801494717408;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -14880512.999999998 then
        begin
            if features.delta_candidate_score <= -8999.4999999999982 then
            begin
                if features.candidate_score_per_unit <= 1750.0000000000002 then
                begin
                    if features.delta_chain_first_stage_score <= -106295.49999999999 then
                    begin
                        Result := -0.0070577308170522088;
                    end
                    else
                    begin
                        Result := 0.032075064201329592;
                    end;
                end
                else
                begin
                    Result := -0.0065100801648110412;
                end;
            end
            else
            begin
                if features.delta_chain_first_stage_score <= 1.0000000180025095E-35 then
                begin
                    Result := 0.0089963247045684834;
                end
                else
                begin
                    Result := -0.00050567675715788071;
                end;
            end;
        end
        else
        begin
            Result := 0.018443213469577877;
        end;
    end;
end;

function visible_pairwise_tree_71(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -29906484.999999996 then
    begin
        Result := -0.024435832545481911;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -3202697.9999999995 then
        begin
            if features.candidate_text_units <= 9.5000000000000018 then
            begin
                if features.delta_score_per_unit <= 5424.5000000000009 then
                begin
                    Result := 0.0068416801442145172;
                end
                else
                begin
                    if features.delta_path_max_segment_units <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.00024928615248617428;
                    end
                    else
                    begin
                        Result := 0.065534397745015127;
                    end;
                end;
            end
            else
            begin
                if features.delta_char_lm_suffix_score <= -474.49999999999994 then
                begin
                    Result := -0.0092437126959146933;
                end
                else
                begin
                    Result := 0.0041016780347670426;
                end;
            end;
        end
        else
        begin
            Result := 0.031623096990521286;
        end;
    end;
end;

function visible_pairwise_tree_72(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024755424524644541;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -279.49999999999994 then
        begin
            Result := 0.0014260162492312576;
        end
        else
        begin
            if features.candidate_ranker_score <= 15726501.000000002 then
            begin
                if features.candidate_score_per_unit <= 30118.500000000004 then
                begin
                    if features.candidate_dict_weight_per_unit <= 5360.5000000000009 then
                    begin
                        if features.delta_chain_first_stage_score <= -90556.499999999985 then
                        begin
                            Result := 0.0;
                        end
                        else
                        begin
                            Result := 0.021917154732706452;
                        end;
                    end
                    else
                    begin
                        Result := 0.0028758249612087479;
                    end;
                end
                else
                begin
                    Result := 0.039206961129559043;
                end;
            end
            else
            begin
                Result := 0.031576206394602249;
            end;
        end;
    end;
end;

function visible_pairwise_tree_73(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024400416238983064;
    end
    else
    begin
        if features.delta_path_single_segments <= 1.0000000180025095E-35 then
        begin
            if features.candidate_candidate_score <= 48661.500000000007 then
            begin
                Result := 0.020699323894224225;
            end
            else
            begin
                if features.candidate_chain_second_stage_score <= 390848988.00000006 then
                begin
                    Result := 0.0073960066873702511;
                end
                else
                begin
                    Result := -0.014851130467681562;
                end;
            end;
        end
        else
        begin
            if features.candidate_ranker_score_gap <= -37715374.999999993 then
            begin
                if features.delta_char_lm_suffix_score <= 126.50000000000001 then
                begin
                    Result := -0.012786464487405363;
                end
                else
                begin
                    Result := 0.026363970474719545;
                end;
            end
            else
            begin
                Result := 0.0066228921858183885;
            end;
        end;
    end;
end;

function visible_pairwise_tree_74(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -29906484.999999996 then
    begin
        Result := -0.024387760565541303;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -123.49999999999999 then
        begin
            if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
            begin
                Result := 0.037731421316285055;
            end
            else
            begin
                if features.delta_dict_weight <= -2063.4999999999995 then
                begin
                    Result := -0.0057006233229705879;
                end
                else
                begin
                    Result := 0.0039233825039087988;
                end;
            end;
        end
        else
        begin
            if features.delta_path_max_segment_units <= 1.0000000180025095E-35 then
            begin
                if features.candidate_ranker_score <= 13613463.500000002 then
                begin
                    Result := 0.0042104652655328943;
                end
                else
                begin
                    Result := 0.032154149116730327;
                end;
            end
            else
            begin
                Result := 0.025946489095756031;
            end;
        end;
    end;
end;

function visible_pairwise_tree_75(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_unit_delta <= -1.0000000180025095E-35 then
    begin
        Result := -0.024730721399944564;
    end
    else
    begin
        if features.delta_char_lm_score <= -476.49999999999994 then
        begin
            if features.candidate_text_units <= 7.5000000000000009 then
            begin
                Result := 0.0071826448024230926;
            end
            else
            begin
                Result := -0.0048769214745755188;
            end;
        end
        else
        begin
            if features.baseline_abstain_score <= 1.0685854882015289 then
            begin
                if features.candidate_chain_rank <= 2.5000000000000004 then
                begin
                    if features.delta_candidate_score <= 361.50000000000006 then
                    begin
                        Result := 0.0093804124478411698;
                    end
                    else
                    begin
                        Result := -0.0024436485015646267;
                    end;
                end
                else
                begin
                    Result := 0.03768693845128708;
                end;
            end
            else
            begin
                Result := -0.017853358992776472;
            end;
        end;
    end;
end;

function visible_pairwise_tree_76(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024721572056721909;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -1425.4999999999998 then
        begin
            Result := -0.011140578524916928;
        end
        else
        begin
            if features.candidate_path_segments <= 12.500000000000002 then
            begin
                if features.delta_path_single_segments <= 1.0000000180025095E-35 then
                begin
                    Result := 0.0079585665482287508;
                end
                else
                begin
                    if features.delta_char_lm_suffix_score <= 1.0000000180025095E-35 then
                    begin
                        if features.delta_path_segments <= 3.5000000000000004 then
                        begin
                            Result := -0.012527156668364342;
                        end
                        else
                        begin
                            Result := 0.0042378960931950703;
                        end;
                    end
                    else
                    begin
                        Result := 0.012459781386848768;
                    end;
                end;
            end
            else
            begin
                Result := -0.019333385177104867;
            end;
        end;
    end;
end;

function visible_pairwise_tree_77(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024713583154007849;
    end
    else
    begin
        if features.delta_char_lm_score <= -2118.4999999999995 then
        begin
            Result := -0.018403827977749379;
        end
        else
        begin
            if features.candidate_ranker_score_gap <= -14880512.999999998 then
            begin
                if features.delta_legacy_rank <= 1.0000000180025095E-35 then
                begin
                    Result := -0.011576677082535113;
                end
                else
                begin
                    if features.candidate_path_segments <= 7.5000000000000009 then
                    begin
                        Result := 0.0065953849020222617;
                    end
                    else
                    begin
                        if features.delta_char_lm_score <= -111.49999999999999 then
                        begin
                            Result := -0.0085404676924369927;
                        end
                        else
                        begin
                            Result := 0.0089869916446026626;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := 0.017232911551794801;
            end;
        end;
    end;
end;

function visible_pairwise_tree_78(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024704299203512518;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= -253219802.49999997 then
        begin
            Result := -0.013933203565942937;
        end
        else
        begin
            if features.candidate_ranker_score_gap <= -3202697.9999999995 then
            begin
                if features.candidate_path_single_segments <= 3.5000000000000004 then
                begin
                    if features.delta_char_lm_score <= 262.50000000000006 then
                    begin
                        if features.candidate_chain_second_stage_score <= 390848988.00000006 then
                        begin
                            Result := 0.0061288177423621942;
                        end
                        else
                        begin
                            Result := -0.01205302417565237;
                        end;
                    end
                    else
                    begin
                        Result := -0.01476978830045673;
                    end;
                end
                else
                begin
                    Result := -0.0039805428409559682;
                end;
            end
            else
            begin
                Result := 0.027425212494469678;
            end;
        end;
    end;
end;

function visible_pairwise_tree_79(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -29906484.999999996 then
    begin
        Result := -0.024301573314108215;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -1425.4999999999998 then
        begin
            Result := -0.010132922113806536;
        end
        else
        begin
            if features.delta_dict_weight_per_unit <= 11409.500000000002 then
            begin
                if features.delta_path_single_segments <= 1.0000000180025095E-35 then
                begin
                    if features.candidate_candidate_score <= 48661.500000000007 then
                    begin
                        Result := 0.022137293299420258;
                    end
                    else
                    begin
                        Result := 0.0041995308426140618;
                    end;
                end
                else
                begin
                    Result := -0.0031368959113219522;
                end;
            end
            else
            begin
                if features.delta_candidate_score <= -221.49999999999997 then
                begin
                    Result := -0.010531913101230387;
                end
                else
                begin
                    Result := 0.017781702652883077;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_80(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.02468618017297328;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -279.49999999999994 then
        begin
            Result := 0.00076215019003743247;
        end
        else
        begin
            if features.candidate_ranker_score <= 15331123.500000002 then
            begin
                if features.delta_chain_first_stage_score <= 434.00000000000006 then
                begin
                    if features.delta_score_per_unit <= -25.499999999999996 then
                    begin
                        Result := 0.00092807939858027203;
                    end
                    else
                    begin
                        Result := 0.013855784263193761;
                    end;
                end
                else
                begin
                    if features.candidate_dict_weight_per_unit <= 606.50000000000011 then
                    begin
                        Result := 0.037190011709492293;
                    end
                    else
                    begin
                        Result := -0.0096081272715910129;
                    end;
                end;
            end
            else
            begin
                Result := 0.027095787601915847;
            end;
        end;
    end;
end;

function visible_pairwise_tree_81(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024677138305146576;
    end
    else
    begin
        if features.delta_char_lm_score <= -507.49999999999994 then
        begin
            if features.candidate_text_units <= 10.500000000000002 then
            begin
                if features.delta_candidate_score <= 42836.000000000007 then
                begin
                    if features.delta_char_lm_suffix_score <= -1425.4999999999998 then
                    begin
                        Result := -0.015523847730322679;
                    end
                    else
                    begin
                        Result := 0.0039077760882753844;
                    end;
                end
                else
                begin
                    if features.candidate_chain_score_gap <= -1.0000000180025095E-35 then
                    begin
                        Result := -0.0055363216488399127;
                    end
                    else
                    begin
                        Result := 0.062878100066762019;
                    end;
                end;
            end
            else
            begin
                Result := -0.012481347116836662;
            end;
        end
        else
        begin
            Result := 0.0063269417015933823;
        end;
    end;
end;

function visible_pairwise_tree_82(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024239555159221254;
    end
    else
    begin
        if features.delta_path_single_segments <= -1.4999999999999998 then
        begin
            if features.candidate_char_lm_context_score <= -6272.4999999999991 then
            begin
                Result := 0.025508429134547424;
            end
            else
            begin
                Result := 0.0028179267537223637;
            end;
        end
        else
        begin
            if features.delta_char_lm_score <= -445.49999999999994 then
            begin
                if features.delta_score_per_unit <= 5868.5000000000009 then
                begin
                    Result := -0.0030820811944050988;
                end
                else
                begin
                    if features.delta_dict_weight <= 66107.000000000015 then
                    begin
                        Result := 0.067852601634196916;
                    end
                    else
                    begin
                        Result := -0.0028854513424295593;
                    end;
                end;
            end
            else
            begin
                Result := 0.0050849115447652886;
            end;
        end;
    end;
end;

function visible_pairwise_tree_83(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.candidate_ranker_score_gap <= -3202697.9999999995 then
        begin
            if features.delta_dict_weight_per_unit <= -435.99999999999994 then
            begin
                if features.delta_candidate_score <= 42836.000000000007 then
                begin
                    if features.delta_char_lm_context_score <= -669.49999999999989 then
                    begin
                        Result := -0.016634587344801874;
                    end
                    else
                    begin
                        if features.delta_dict_weight <= -50979.499999999993 then
                        begin
                            Result := 0.0058615862996938654;
                        end
                        else
                        begin
                            Result := -0.006952486479006037;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.043992704368617075;
                end;
            end
            else
            begin
                Result := 0.0057699530230015733;
            end;
        end
        else
        begin
            Result := 0.031839329693051838;
        end;
    end
    else
    begin
        Result := -0.024656754461932578;
    end;
end;

function visible_pairwise_tree_84(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_path_max_segment_units <= 1.0000000180025095E-35 then
    begin
        Result := -0.021675363448917875;
    end
    else
    begin
        if features.candidate_char_lm_suffix_score <= -5528.4999999999991 then
        begin
            if features.candidate_chain_first_stage_score <= 209184.00000000003 then
            begin
                if features.candidate_chain_second_stage_score <= 77569630.500000015 then
                begin
                    if features.candidate_candidate_score <= 181311.00000000003 then
                    begin
                        Result := 0.0042700048593124059;
                    end
                    else
                    begin
                        if features.delta_score_per_unit <= 5868.5000000000009 then
                        begin
                            Result := 0.012444123133377083;
                        end
                        else
                        begin
                            Result := 0.067364841595571365;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.018347557987299614;
                end;
            end
            else
            begin
                Result := -0.0081551027302134201;
            end;
        end
        else
        begin
            Result := -0.0007952871124948885;
        end;
    end;
end;

function visible_pairwise_tree_85(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024181925683663841;
    end
    else
    begin
        if features.candidate_char_lm_suffix_score <= -6935.4999999999991 then
        begin
            Result := 0.0097822507509846349;
        end
        else
        begin
            if features.delta_char_lm_suffix_score <= -240.49999999999997 then
            begin
                if features.candidate_path_max_segment_units <= 3.5000000000000004 then
                begin
                    if features.candidate_chain_second_stage_score <= -138154689.99999997 then
                    begin
                        Result := -0.021853161963434651;
                    end
                    else
                    begin
                        Result := 0.0025006880295264829;
                    end;
                end
                else
                begin
                    Result := -0.011733119090716079;
                end;
            end
            else
            begin
                if features.delta_path_available <= 1.0000000180025095E-35 then
                begin
                    Result := 0.0045571065863734828;
                end
                else
                begin
                    Result := 0.026345486293965905;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_86(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024162038223151373;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= -333363365.99999994 then
        begin
            Result := -0.021896987633599357;
        end
        else
        begin
            if features.delta_path_single_segments <= -1.4999999999999998 then
            begin
                if features.candidate_char_lm_suffix_score <= -5659.4999999999991 then
                begin
                    Result := 0.01976425366919116;
                end
                else
                begin
                    Result := -0.005677518065519702;
                end;
            end
            else
            begin
                if features.candidate_ranker_score_gap <= -37177529.499999993 then
                begin
                    Result := -0.000386589341812049;
                end
                else
                begin
                    if features.candidate_chain_first_stage_score <= 51896.500000000007 then
                    begin
                        Result := 0.013075794867691058;
                    end
                    else
                    begin
                        Result := 0.0018968842874696726;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_87(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.02461760815000396;
    end
    else
    begin
        if features.candidate_chain_second_stage_score <= 390848988.00000006 then
        begin
            if features.delta_char_lm_score <= -2118.4999999999995 then
            begin
                Result := -0.016150487281277503;
            end
            else
            begin
                if features.baseline_abstain_score <= 1.2479930108789816 then
                begin
                    if features.candidate_char_lm_suffix_score <= -6935.4999999999991 then
                    begin
                        Result := 0.010794788019728982;
                    end
                    else
                    begin
                        if features.delta_char_lm_score <= -573.49999999999989 then
                        begin
                            Result := -0.0027622345255445347;
                        end
                        else
                        begin
                            Result := 0.005413369648921037;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.021870937861792155;
                end;
            end;
        end
        else
        begin
            Result := -0.012977137337080488;
        end;
    end;
end;

function visible_pairwise_tree_88(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -29906484.999999996 then
    begin
        Result := -0.024125527776172172;
    end
    else
    begin
        if features.delta_char_lm_score <= -761.49999999999989 then
        begin
            if features.candidate_char_lm_suffix_score <= -5707.4999999999991 then
            begin
                Result := 0.0015750349856797612;
            end
            else
            begin
                Result := -0.015489793977703795;
            end;
        end
        else
        begin
            if features.candidate_score_per_unit <= 14350.500000000002 then
            begin
                Result := 0.0031457788491916685;
            end
            else
            begin
                if features.delta_score_per_unit <= -999.49999999999989 then
                begin
                    if features.candidate_char_lm_suffix_score <= -5048.4999999999991 then
                    begin
                        Result := -0.016656674880598323;
                    end
                    else
                    begin
                        Result := 0.029154860560449025;
                    end;
                end
                else
                begin
                    Result := 0.017633481467415495;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_89(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.02459692789470995;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= -243626826.99999997 then
        begin
            Result := -0.01316935238639081;
        end
        else
        begin
            if features.candidate_chain_rank <= 2.5000000000000004 then
            begin
                if features.delta_source_local_rerank <= -1.0000000180025095E-35 then
                begin
                    if features.delta_char_lm_suffix_score <= -220.49999999999997 then
                    begin
                        if features.delta_score_per_unit <= 4850.5000000000009 then
                        begin
                            Result := 0.0030594300737154848;
                        end
                        else
                        begin
                            Result := 0.053081874619481752;
                        end;
                    end
                    else
                    begin
                        Result := 0.024604067690705948;
                    end;
                end
                else
                begin
                    Result := 0.0014330748706694243;
                end;
            end
            else
            begin
                Result := 0.026005343739728095;
            end;
        end;
    end;
end;

function visible_pairwise_tree_90(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024585758631478397;
    end
    else
    begin
        if features.delta_char_lm_score <= -2118.4999999999995 then
        begin
            Result := -0.018085251966710986;
        end
        else
        begin
            if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
            begin
                if features.candidate_ranker_score <= -4779062.9999999991 then
                begin
                    Result := 0.057351933292068828;
                end
                else
                begin
                    Result := -0.0070415335053636841;
                end;
            end
            else
            begin
                if features.delta_dict_weight_per_unit <= 11409.500000000002 then
                begin
                    Result := 0.0018056972001774135;
                end
                else
                begin
                    if features.delta_candidate_score <= -221.49999999999997 then
                    begin
                        Result := -0.0069252607653027699;
                    end
                    else
                    begin
                        Result := 0.015053186452169432;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_91(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024574008478957;
    end
    else
    begin
        if features.delta_char_lm_score <= -1806.4999999999998 then
        begin
            Result := -0.015780630194850539;
        end
        else
        begin
            if features.candidate_chain_first_stage_score <= 182800.00000000003 then
            begin
                if features.candidate_ranker_score <= 2216914.5000000005 then
                begin
                    if features.delta_legacy_rank <= 1.0000000180025095E-35 then
                    begin
                        Result := -0.018769288642023912;
                    end
                    else
                    begin
                        Result := 0.003688533357398912;
                    end;
                end
                else
                begin
                    if features.delta_char_lm_score <= -539.49999999999989 then
                    begin
                        Result := -0.00728132457332959;
                    end
                    else
                    begin
                        Result := 0.014398291714331067;
                    end;
                end;
            end
            else
            begin
                Result := -0.0054385710415383237;
            end;
        end;
    end;
end;

function visible_pairwise_tree_92(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.02456076517962142;
    end
    else
    begin
        if features.delta_path_single_segments <= 1.0000000180025095E-35 then
        begin
            if features.candidate_candidate_score <= 28794.000000000004 then
            begin
                Result := 0.020699364876961241;
            end
            else
            begin
                if features.delta_path_segments <= 1.0000000180025095E-35 then
                begin
                    Result := 0.0023605898897356859;
                end
                else
                begin
                    if features.delta_candidate_score <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.0082704986903270675;
                    end
                    else
                    begin
                        Result := 0.033525759489521328;
                    end;
                end;
            end;
        end
        else
        begin
            if features.candidate_ranker_score_gap <= -37715374.999999993 then
            begin
                Result := -0.0088130948012636254;
            end
            else
            begin
                Result := 0.0033225407457919964;
            end;
        end;
    end;
end;

function visible_pairwise_tree_93(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -31398395.999999996 then
    begin
        Result := -0.024003453440743252;
    end
    else
    begin
        if features.candidate_char_lm_suffix_score <= -6935.4999999999991 then
        begin
            Result := 0.0095305107991761791;
        end
        else
        begin
            if features.delta_char_lm_score <= -1078.4999999999998 then
            begin
                Result := -0.0083225785593951385;
            end
            else
            begin
                if features.candidate_input_syllable_count <= 10.500000000000002 then
                begin
                    Result := 0.0075296573291479818;
                end
                else
                begin
                    if features.delta_char_lm_score <= -507.49999999999994 then
                    begin
                        Result := -0.013192482702491954;
                    end
                    else
                    begin
                        if features.candidate_ranker_score <= 19545263.500000004 then
                        begin
                            Result := 0.00023126705559134496;
                        end
                        else
                        begin
                            Result := 0.031218667545663714;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_94(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024537939268855589;
    end
    else
    begin
        if features.candidate_chain_first_stage_score <= 209184.00000000003 then
        begin
            if features.candidate_chain_second_stage_score <= 436482271.00000006 then
            begin
                if features.delta_char_lm_score <= -2118.4999999999995 then
                begin
                    Result := -0.015854438158598046;
                end
                else
                begin
                    if features.baseline_abstain_score <= 1.2479930108789816 then
                    begin
                        if features.delta_chain_second_stage_score <= -312518516.49999994 then
                        begin
                            Result := -0.014746099860053576;
                        end
                        else
                        begin
                            Result := 0.0052219362882793396;
                        end;
                    end
                    else
                    begin
                        Result := -0.021502589722730364;
                    end;
                end;
            end
            else
            begin
                Result := -0.016023127300014588;
            end;
        end
        else
        begin
            Result := -0.0072516740113706462;
        end;
    end;
end;

function visible_pairwise_tree_95(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024524864417138609;
    end
    else
    begin
        if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
        begin
            if features.delta_path_max_segment_units <= -1.0000000180025095E-35 then
            begin
                Result := -0.01251063912897105;
            end
            else
            begin
                if features.candidate_ranker_score <= -4779062.9999999991 then
                begin
                    if features.delta_char_lm_score <= -2806.4999999999995 then
                    begin
                        Result := -0.0062695964954279128;
                    end
                    else
                    begin
                        Result := 0.077015247120231223;
                    end;
                end
                else
                begin
                    Result := -0.0034086056487694395;
                end;
            end;
        end
        else
        begin
            if features.delta_char_lm_score <= -1676.4999999999998 then
            begin
                Result := -0.01425098169052824;
            end
            else
            begin
                Result := 0.0033163586374862042;
            end;
        end;
    end;
end;

function visible_pairwise_tree_96(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024512188162366746;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= -312518516.49999994 then
        begin
            Result := -0.016893004314120261;
        end
        else
        begin
            if features.baseline_abstain_score <= 1.0685854882015289 then
            begin
                if features.candidate_char_lm_context_score <= -6935.4999999999991 then
                begin
                    if features.delta_score_per_unit <= 5424.5000000000009 then
                    begin
                        Result := 0.0077463235657164696;
                    end
                    else
                    begin
                        if features.delta_chain_first_stage_score <= 6447.5000000000009 then
                        begin
                            Result := 0.084754576262785847;
                        end
                        else
                        begin
                            Result := -0.0015938179536439511;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.0029816182149856405;
                end;
            end
            else
            begin
                Result := -0.015973158572497727;
            end;
        end;
    end;
end;

function visible_pairwise_tree_97(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score <= -29906484.999999996 then
    begin
        Result := -0.024220090678346979;
    end
    else
    begin
        if features.delta_char_lm_context_score <= -279.49999999999994 then
        begin
            Result := 0.0;
        end
        else
        begin
            if features.candidate_ranker_score <= 15331123.500000002 then
            begin
                if features.delta_chain_first_stage_score <= 434.00000000000006 then
                begin
                    if features.delta_score_per_unit <= -25.499999999999996 then
                    begin
                        if features.candidate_char_lm_score <= -3353.4999999999995 then
                        begin
                            Result := -0.0024492801068663255;
                        end
                        else
                        begin
                            Result := 0.032238148347150164;
                        end;
                    end
                    else
                    begin
                        Result := 0.010643080647174211;
                    end;
                end
                else
                begin
                    Result := -0.0062026723758441147;
                end;
            end
            else
            begin
                Result := 0.025388877025502906;
            end;
        end;
    end;
end;

function visible_pairwise_tree_98(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024487496365911979;
    end
    else
    begin
        if features.delta_path_single_segments <= 1.0000000180025095E-35 then
        begin
            if features.candidate_candidate_score <= 28794.000000000004 then
            begin
                Result := 0.01899488668577444;
            end
            else
            begin
                if features.delta_path_segments <= 1.0000000180025095E-35 then
                begin
                    Result := 0.0014813878174494326;
                end
                else
                begin
                    if features.delta_candidate_score <= 42836.000000000007 then
                    begin
                        Result := 0.010051869734755364;
                    end
                    else
                    begin
                        Result := 0.054694001521607444;
                    end;
                end;
            end;
        end
        else
        begin
            if features.candidate_ranker_score_gap <= -37177529.499999993 then
            begin
                Result := -0.009230466744969355;
            end
            else
            begin
                Result := 0.0029549418655247274;
            end;
        end;
    end;
end;

function visible_pairwise_tree_99(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024473857400491475;
    end
    else
    begin
        if features.delta_char_lm_score <= -2118.4999999999995 then
        begin
            Result := -0.017696251146974172;
        end
        else
        begin
            if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
            begin
                Result := 0.030471562604304767;
            end
            else
            begin
                if features.delta_dict_weight_per_unit <= -133.49999999999997 then
                begin
                    Result := -0.001330674073555858;
                end
                else
                begin
                    if features.delta_chain_first_stage_score <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.0074924909135000986;
                    end
                    else
                    begin
                        if features.candidate_ranker_score <= 3654976.0000000005 then
                        begin
                            Result := -0.0073460655417135869;
                        end
                        else
                        begin
                            Result := 0.009398290156151675;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_100(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024460559204419863;
    end
    else
    begin
        if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
        begin
            if features.candidate_ranker_score <= -4779062.9999999991 then
            begin
                Result := 0.04395839349504696;
            end
            else
            begin
                Result := -0.0085372165837791902;
            end;
        end
        else
        begin
            if features.delta_char_lm_score <= -1560.4999999999998 then
            begin
                if features.delta_score_per_unit <= 5868.5000000000009 then
                begin
                    Result := -0.015862558433863569;
                end
                else
                begin
                    Result := 0.029478112390486477;
                end;
            end
            else
            begin
                if features.candidate_chain_second_stage_score <= 390848988.00000006 then
                begin
                    Result := 0.0030105386543589881;
                end
                else
                begin
                    Result := -0.012673136175985434;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_101(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024445216976287758;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -3202697.9999999995 then
        begin
            if features.delta_dict_weight <= -8997.4999999999982 then
            begin
                if features.delta_score_per_unit <= 5424.5000000000009 then
                begin
                    if features.delta_score_per_unit <= -3882.4999999999995 then
                    begin
                        Result := 0.0050318381946390274;
                    end
                    else
                    begin
                        Result := -0.0092586476556116345;
                    end;
                end
                else
                begin
                    Result := 0.032165920879894942;
                end;
            end
            else
            begin
                if features.delta_chain_first_stage_score <= 1.0000000180025095E-35 then
                begin
                    Result := 0.0067585654996411967;
                end
                else
                begin
                    Result := -0.0023890935228204424;
                end;
            end;
        end
        else
        begin
            Result := 0.026603614121501425;
        end;
    end;
end;

function visible_pairwise_tree_102(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024431375854309604;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -37177529.499999993 then
        begin
            if features.delta_char_lm_suffix_score <= -1.0000000180025095E-35 then
            begin
                if features.delta_candidate_score <= 8920.5000000000018 then
                begin
                    if features.delta_dict_weight <= -8997.4999999999982 then
                    begin
                        Result := -0.013071526128004796;
                    end
                    else
                    begin
                        Result := -0.00089952061034105049;
                    end;
                end
                else
                begin
                    if features.candidate_char_lm_suffix_score <= -7104.4999999999991 then
                    begin
                        Result := 0.038176095238944413;
                    end
                    else
                    begin
                        Result := -0.00059934849311451817;
                    end;
                end;
            end
            else
            begin
                Result := 0.012428914668901149;
            end;
        end
        else
        begin
            Result := 0.0045311913242724105;
        end;
    end;
end;

function visible_pairwise_tree_103(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.baseline_abstain_score <= 1.186274445030014 then
        begin
            if features.candidate_path_segments <= 11.500000000000002 then
            begin
                if features.delta_char_lm_score <= -507.49999999999994 then
                begin
                    if features.candidate_text_units <= 12.500000000000002 then
                    begin
                        Result := 0.00090369098858911331;
                    end
                    else
                    begin
                        Result := -0.017514468382681194;
                    end;
                end
                else
                begin
                    if features.candidate_ranker_score <= 2216914.5000000005 then
                    begin
                        Result := 0.002950936453678533;
                    end
                    else
                    begin
                        Result := 0.012505595763349107;
                    end;
                end;
            end
            else
            begin
                Result := -0.01287160827719103;
            end;
        end
        else
        begin
            Result := -0.022484479769070434;
        end;
    end
    else
    begin
        Result := -0.02441610971531416;
    end;
end;

function visible_pairwise_tree_104(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024399496125950652;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -3202697.9999999995 then
        begin
            if features.delta_dict_weight <= -8997.4999999999982 then
            begin
                if features.delta_candidate_score <= 42836.000000000007 then
                begin
                    if features.delta_score_per_unit <= -6723.4999999999991 then
                    begin
                        if features.delta_chain_first_stage_score <= -106295.49999999999 then
                        begin
                            Result := -0.007590353217092935;
                        end
                        else
                        begin
                            Result := 0.024200560610055027;
                        end;
                    end
                    else
                    begin
                        Result := -0.0088850606784679244;
                    end;
                end
                else
                begin
                    Result := 0.037802539414783454;
                end;
            end
            else
            begin
                Result := 0.0038055413078017216;
            end;
        end
        else
        begin
            Result := 0.023978380709380714;
        end;
    end;
end;

function visible_pairwise_tree_105(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024385571753651487;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -3202697.9999999995 then
        begin
            if features.delta_char_lm_suffix_score <= 342.50000000000006 then
            begin
                if features.delta_char_lm_suffix_score <= -1.0000000180025095E-35 then
                begin
                    Result := 0.00080237956062778864;
                end
                else
                begin
                    if features.candidate_chain_first_stage_score <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.021573765851504351;
                    end
                    else
                    begin
                        if features.baseline_abstain_score <= 0.51827137127864875 then
                        begin
                            Result := 0.014896819623259906;
                        end
                        else
                        begin
                            Result := -0.0077808465734659788;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := -0.016852849949891831;
            end;
        end
        else
        begin
            Result := 0.026191295944307271;
        end;
    end;
end;

function visible_pairwise_tree_106(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024369771820957935;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= -312518516.49999994 then
        begin
            Result := -0.016787349477934803;
        end
        else
        begin
            if features.candidate_chain_second_stage_score <= 390848988.00000006 then
            begin
                if features.delta_path_single_segments <= 1.0000000180025095E-35 then
                begin
                    Result := 0.0045693431067468952;
                end
                else
                begin
                    if features.candidate_ranker_score <= -2043929.9999999998 then
                    begin
                        Result := -0.010109809348648156;
                    end
                    else
                    begin
                        if features.delta_char_lm_score <= -476.49999999999994 then
                        begin
                            Result := -0.0044811823420838129;
                        end
                        else
                        begin
                            Result := 0.010319248754665666;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := -0.010225841203547578;
            end;
        end;
    end;
end;

function visible_pairwise_tree_107(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.0243550865668694;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -3202697.9999999995 then
        begin
            if features.delta_dict_weight_per_unit <= -133.49999999999997 then
            begin
                if features.delta_candidate_score <= 42836.000000000007 then
                begin
                    if features.delta_candidate_score <= -50557.999999999993 then
                    begin
                        Result := 0.0044720129939653346;
                    end
                    else
                    begin
                        if features.delta_char_lm_suffix_score <= -201.49999999999997 then
                        begin
                            Result := -0.012501211425565007;
                        end
                        else
                        begin
                            Result := -0.00097431261896961598;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.030286977622734121;
                end;
            end
            else
            begin
                Result := 0.0034576563576810418;
            end;
        end
        else
        begin
            Result := 0.024230577196749401;
        end;
    end;
end;

function visible_pairwise_tree_108(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024338284725026263;
    end
    else
    begin
        if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
        begin
            if features.candidate_ranker_score <= -4779062.9999999991 then
            begin
                if features.delta_path_max_segment_units <= -1.0000000180025095E-35 then
                begin
                    Result := -0.0094938514632292199;
                end
                else
                begin
                    Result := 0.054392971346235275;
                end;
            end
            else
            begin
                Result := -0.0081793371712923779;
            end;
        end
        else
        begin
            if features.delta_chain_second_stage_score <= -312518516.49999994 then
            begin
                Result := -0.018975164127021507;
            end
            else
            begin
                if features.candidate_chain_rank <= 2.5000000000000004 then
                begin
                    Result := 0.0009382314088873273;
                end
                else
                begin
                    Result := 0.019900796500855519;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_109(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024321332964746114;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= 299073856.50000006 then
        begin
            if features.candidate_chain_second_stage_score <= 390848988.00000006 then
            begin
                if features.delta_char_lm_score <= -2118.4999999999995 then
                begin
                    Result := -0.017611581547724298;
                end
                else
                begin
                    if features.delta_char_lm_suffix_score <= 342.50000000000006 then
                    begin
                        if features.candidate_char_lm_suffix_score <= -6935.4999999999991 then
                        begin
                            Result := 0.0085072098002955364;
                        end
                        else
                        begin
                            Result := 0.0018633041661659626;
                        end;
                    end
                    else
                    begin
                        Result := -0.015312971850786587;
                    end;
                end;
            end
            else
            begin
                Result := -0.013538271024160843;
            end;
        end
        else
        begin
            Result := 0.026953895660587687;
        end;
    end;
end;

function visible_pairwise_tree_110(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024304347882341631;
    end
    else
    begin
        if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
        begin
            if features.candidate_path_single_segments <= 1.5000000000000002 then
            begin
                Result := 0.039457096966715594;
            end
            else
            begin
                Result := -0.0081468503683281741;
            end;
        end
        else
        begin
            if features.delta_char_lm_score <= -1806.4999999999998 then
            begin
                Result := -0.017499041564173583;
            end
            else
            begin
                if features.delta_path_single_segments <= 1.0000000180025095E-35 then
                begin
                    Result := 0.0034282002139190471;
                end
                else
                begin
                    if features.delta_path_segments <= 3.5000000000000004 then
                    begin
                        Result := -0.0075664593434195977;
                    end
                    else
                    begin
                        Result := 0.0037365916401917777;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_111(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024287533819129299;
    end
    else
    begin
        if features.delta_path_single_segments <= 1.0000000180025095E-35 then
        begin
            if features.candidate_candidate_score <= 28794.000000000004 then
            begin
                Result := 0.018437926291163139;
            end
            else
            begin
                if features.delta_path_segments <= 1.0000000180025095E-35 then
                begin
                    Result := 0.001301796028289148;
                end
                else
                begin
                    if features.delta_candidate_score <= 42836.000000000007 then
                    begin
                        Result := 0.0086270472141506682;
                    end
                    else
                    begin
                        Result := 0.052879135885769396;
                    end;
                end;
            end;
        end
        else
        begin
            if features.candidate_ranker_score_gap <= -37715374.999999993 then
            begin
                Result := -0.0090990222834981226;
            end
            else
            begin
                Result := 0.0024636088311072398;
            end;
        end;
    end;
end;

function visible_pairwise_tree_112(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.baseline_abstain_score <= 0.92306488145931842 then
        begin
            if features.delta_char_lm_suffix_score <= -123.49999999999999 then
            begin
                if features.candidate_path_segments <= 7.5000000000000009 then
                begin
                    if features.delta_path_segments <= -1.4999999999999998 then
                    begin
                        Result := -0.013227657467583359;
                    end
                    else
                    begin
                        Result := 0.0041981909103348354;
                    end;
                end
                else
                begin
                    Result := -0.0096608512906711935;
                end;
            end
            else
            begin
                if features.delta_path_max_segment_units <= 1.0000000180025095E-35 then
                begin
                    Result := 0.0035940572724729677;
                end
                else
                begin
                    Result := 0.019472194097097703;
                end;
            end;
        end
        else
        begin
            Result := -0.0090719758475502534;
        end;
    end
    else
    begin
        Result := -0.024269800275026773;
    end;
end;

function visible_pairwise_tree_113(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024249652454261451;
    end
    else
    begin
        if features.delta_char_lm_score <= -507.49999999999994 then
        begin
            if features.candidate_text_units <= 13.500000000000002 then
            begin
                if features.delta_score_per_unit <= 5868.5000000000009 then
                begin
                    Result := -0.0015908796460525122;
                end
                else
                begin
                    if features.candidate_dict_weight <= 64610.000000000007 then
                    begin
                        Result := 0.049187200416373297;
                    end
                    else
                    begin
                        Result := -0.00079654560868133413;
                    end;
                end;
            end
            else
            begin
                Result := -0.019266449626367459;
            end;
        end
        else
        begin
            if features.candidate_ranker_score <= 15331123.500000002 then
            begin
                Result := 0.0030021557902727269;
            end
            else
            begin
                Result := 0.018388653150259192;
            end;
        end;
    end;
end;

function visible_pairwise_tree_114(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024231412423399865;
    end
    else
    begin
        if features.delta_char_lm_score <= -2118.4999999999995 then
        begin
            Result := -0.017346558373053954;
        end
        else
        begin
            if features.candidate_input_syllable_count <= 6.5000000000000009 then
            begin
                if features.delta_chain_second_stage_score <= -86873804.499999985 then
                begin
                    Result := 0.05129338625448511;
                end
                else
                begin
                    Result := 0.0068099981319282733;
                end;
            end
            else
            begin
                if features.delta_chain_second_stage_score <= -243626826.99999997 then
                begin
                    Result := -0.014513340786828194;
                end
                else
                begin
                    if features.delta_path_max_segment_units <= 7.5000000000000009 then
                    begin
                        Result := 0.0012577453588874675;
                    end
                    else
                    begin
                        Result := 0.015159577244452408;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_115(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024210157594412487;
    end
    else
    begin
        if features.baseline_abstain_score <= 0.98145548074306743 then
        begin
            if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
            begin
                Result := 0.032162712215835401;
            end
            else
            begin
                if features.delta_dict_weight_per_unit <= -133.49999999999997 then
                begin
                    if features.candidate_ranker_score_gap <= -16132875.999999998 then
                    begin
                        Result := -0.0040809670877029035;
                    end
                    else
                    begin
                        Result := 0.021307476104345812;
                    end;
                end
                else
                begin
                    if features.delta_chain_first_stage_score <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.0063196758241003351;
                    end
                    else
                    begin
                        Result := -0.0014532892709805919;
                    end;
                end;
            end;
        end
        else
        begin
            Result := -0.013259646108821433;
        end;
    end;
end;

function visible_pairwise_tree_116(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024194789089759396;
    end
    else
    begin
        if features.delta_path_single_segments <= 1.0000000180025095E-35 then
        begin
            if features.candidate_chain_score_gap <= -189846404.49999997 then
            begin
                if features.candidate_text_units <= 8.5000000000000018 then
                begin
                    Result := 0.069410426604797792;
                end
                else
                begin
                    Result := 0.0075429877871807565;
                end;
            end
            else
            begin
                Result := 0.0025376236066027846;
            end;
        end
        else
        begin
            if features.delta_char_lm_suffix_score <= -1.0000000180025095E-35 then
            begin
                if features.delta_path_segments <= 3.5000000000000004 then
                begin
                    Result := -0.014279338182446092;
                end
                else
                begin
                    Result := 0.00030788168668595558;
                end;
            end
            else
            begin
                Result := 0.0091931846719606261;
            end;
        end;
    end;
end;

function visible_pairwise_tree_117(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
        begin
            if features.candidate_path_single_segments <= 1.0000000180025095E-35 then
            begin
                Result := 0.042688907406945059;
            end
            else
            begin
                Result := -0.0042096787875984072;
            end;
        end
        else
        begin
            if features.delta_char_lm_score <= -2118.4999999999995 then
            begin
                Result := -0.021176358476831872;
            end
            else
            begin
                if features.delta_path_single_segments <= 1.5000000000000002 then
                begin
                    if features.candidate_candidate_score <= 48661.500000000007 then
                    begin
                        Result := 0.014229546998334322;
                    end
                    else
                    begin
                        Result := 0.0014583050851741477;
                    end;
                end
                else
                begin
                    Result := -0.0027742581606216461;
                end;
            end;
        end;
    end
    else
    begin
        Result := -0.024172754874684576;
    end;
end;

function visible_pairwise_tree_118(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024153370488783295;
    end
    else
    begin
        if features.delta_char_lm_score <= -721.49999999999989 then
        begin
            if features.delta_dict_weight_per_unit <= 23349.000000000004 then
            begin
                if features.delta_score_per_unit <= 5424.5000000000009 then
                begin
                    if features.candidate_source_rule_fallback <= 1.0000000180025095E-35 then
                    begin
                        if features.delta_path_single_segments <= 1.0000000180025095E-35 then
                        begin
                            Result := 0.0040817507792059674;
                        end
                        else
                        begin
                            Result := -0.0113071841006025;
                        end;
                    end
                    else
                    begin
                        Result := -0.020016952797243307;
                    end;
                end
                else
                begin
                    Result := 0.013205052355150702;
                end;
            end
            else
            begin
                Result := 0.011416787711631684;
            end;
        end
        else
        begin
            Result := 0.0027569281754212336;
        end;
    end;
end;

function visible_pairwise_tree_119(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024131807815730474;
    end
    else
    begin
        if features.candidate_text_units <= 6.5000000000000009 then
        begin
            if features.candidate_chain_score_gap <= -80291272.999999985 then
            begin
                Result := 0.049065621161513258;
            end
            else
            begin
                Result := 0.0058637456101218221;
            end;
        end
        else
        begin
            if features.delta_char_lm_score <= -761.49999999999989 then
            begin
                if features.candidate_ranker_score <= -5859297.9999999991 then
                begin
                    Result := -0.016134838549795572;
                end
                else
                begin
                    Result := 0.00049562088522196409;
                end;
            end
            else
            begin
                if features.delta_char_lm_suffix_score <= 308.50000000000006 then
                begin
                    Result := 0.0023752271625892287;
                end
                else
                begin
                    Result := -0.016463540276135034;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_120(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024111026667025623;
    end
    else
    begin
        if features.delta_path_single_segments <= 1.5000000000000002 then
        begin
            if features.candidate_chain_score_gap <= -187204557.99999997 then
            begin
                if features.candidate_text_units <= 8.5000000000000018 then
                begin
                    Result := 0.060236974779747321;
                end
                else
                begin
                    Result := 0.0063692814370957312;
                end;
            end
            else
            begin
                if features.delta_chain_second_stage_score <= -232427249.49999997 then
                begin
                    Result := -0.019681529924446516;
                end
                else
                begin
                    Result := 0.0031948528096142452;
                end;
            end;
        end
        else
        begin
            if features.delta_dict_weight_per_unit <= 12146.000000000002 then
            begin
                Result := -0.0062164178734013323;
            end
            else
            begin
                Result := 0.0066731605360528983;
            end;
        end;
    end;
end;

function visible_pairwise_tree_121(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024090285130519595;
    end
    else
    begin
        if features.delta_char_lm_score <= -1290.4999999999998 then
        begin
            if features.delta_score_per_unit <= 5424.5000000000009 then
            begin
                Result := -0.011132956916789215;
            end
            else
            begin
                if features.delta_dict_weight <= 66107.000000000015 then
                begin
                    Result := 0.049576933656724054;
                end
                else
                begin
                    Result := -0.011492943551102457;
                end;
            end;
        end
        else
        begin
            if features.candidate_text_units <= 8.5000000000000018 then
            begin
                if features.delta_chain_score_gap <= -191650113.49999997 then
                begin
                    Result := 0.043668415504097703;
                end
                else
                begin
                    Result := 0.005628277784382049;
                end;
            end
            else
            begin
                Result := 0.00070749077076525107;
            end;
        end;
    end;
end;

function visible_pairwise_tree_122(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024068781784955855;
    end
    else
    begin
        if features.delta_char_lm_score <= -2118.4999999999995 then
        begin
            Result := -0.019200178596295914;
        end
        else
        begin
            if features.delta_chain_second_stage_score <= -306231305.99999994 then
            begin
                Result := -0.016525483473765878;
            end
            else
            begin
                if features.candidate_legacy_rank <= 2.5000000000000004 then
                begin
                    Result := 0.0011466277765258199;
                end
                else
                begin
                    if features.candidate_text_units <= 8.5000000000000018 then
                    begin
                        Result := 0.030446329301402154;
                    end
                    else
                    begin
                        if features.delta_char_lm_score <= -223.49999999999997 then
                        begin
                            Result := -0.0046745743863678153;
                        end
                        else
                        begin
                            Result := 0.020873011702012414;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_123(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.024047528704384424;
    end
    else
    begin
        if features.candidate_text_units <= 6.5000000000000009 then
        begin
            if features.delta_chain_rank <= 1.0000000180025095E-35 then
            begin
                if features.delta_candidate_score <= 8920.5000000000018 then
                begin
                    if features.delta_source_local_rerank <= -1.0000000180025095E-35 then
                    begin
                        Result := 0.012144527575823932;
                    end
                    else
                    begin
                        if features.candidate_char_lm_score <= -3428.4999999999995 then
                        begin
                            Result := -0.0085914215552119477;
                        end
                        else
                        begin
                            Result := 0.025615283391774792;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.031384947139754864;
                end;
            end
            else
            begin
                Result := 0.035056634038375507;
            end;
        end
        else
        begin
            Result := 0.00020242603955570554;
        end;
    end;
end;

function visible_pairwise_tree_124(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.candidate_text_units <= 6.5000000000000009 then
        begin
            Result := 0.0086494462225331133;
        end
        else
        begin
            if features.delta_chain_second_stage_score <= -216067608.49999997 then
            begin
                if features.candidate_dict_weight_per_unit <= 10809.000000000002 then
                begin
                    Result := -0.020047808078832823;
                end
                else
                begin
                    Result := 0.0099178970766588982;
                end;
            end
            else
            begin
                if features.candidate_chain_rank <= 2.5000000000000004 then
                begin
                    if features.candidate_ranker_score <= -3102174.9999999995 then
                    begin
                        Result := -0.0032616342383957916;
                    end
                    else
                    begin
                        Result := 0.0021145464845592648;
                    end;
                end
                else
                begin
                    Result := 0.022370142828707223;
                end;
            end;
        end;
    end
    else
    begin
        Result := -0.024024427880548087;
    end;
end;

function visible_pairwise_tree_125(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023998377983844479;
    end
    else
    begin
        if features.candidate_char_lm_suffix_score <= -6935.4999999999991 then
        begin
            Result := 0.0059706129862252353;
        end
        else
        begin
            if features.delta_char_lm_score <= -1016.4999999999999 then
            begin
                Result := -0.0093016842169870977;
            end
            else
            begin
                if features.candidate_candidate_score <= 45616.000000000007 then
                begin
                    if features.delta_chain_first_stage_score <= 55877.500000000007 then
                    begin
                        Result := 0.0054607761939462996;
                    end
                    else
                    begin
                        Result := 0.039235299048882046;
                    end;
                end
                else
                begin
                    if features.delta_chain_score_gap <= 73689927.000000015 then
                    begin
                        Result := -1.7982357807140967E-05;
                    end
                    else
                    begin
                        Result := -0.022716124348612737;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_126(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023974998826085475;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= -253219802.49999997 then
        begin
            if features.candidate_dict_weight_per_unit <= 12718.500000000002 then
            begin
                Result := -0.019616653954671166;
            end
            else
            begin
                Result := 0.024165509460476367;
            end;
        end
        else
        begin
            if features.candidate_chain_rank <= 2.5000000000000004 then
            begin
                if features.candidate_path_segments <= 11.500000000000002 then
                begin
                    if features.baseline_abstain_score <= 1.2479930108789816 then
                    begin
                        Result := 0.0015962702735791449;
                    end
                    else
                    begin
                        Result := -0.021354810425086756;
                    end;
                end
                else
                begin
                    Result := -0.012631281679027906;
                end;
            end
            else
            begin
                Result := 0.020238127958229435;
            end;
        end;
    end;
end;

function visible_pairwise_tree_127(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023951041841353965;
    end
    else
    begin
        if features.candidate_text_units <= 6.5000000000000009 then
        begin
            if features.delta_chain_rank <= 1.0000000180025095E-35 then
            begin
                if features.delta_source_local_rerank <= -1.0000000180025095E-35 then
                begin
                    Result := 0.013947764710835288;
                end
                else
                begin
                    if features.delta_candidate_score <= 8920.5000000000018 then
                    begin
                        if features.candidate_char_lm_score <= -3428.4999999999995 then
                        begin
                            Result := -0.0087327601689964479;
                        end
                        else
                        begin
                            Result := 0.02490767677641265;
                        end;
                    end
                    else
                    begin
                        Result := 0.023370178355699257;
                    end;
                end;
            end
            else
            begin
                Result := 0.038874119791907413;
            end;
        end
        else
        begin
            Result := 0.00015784571357351697;
        end;
    end;
end;

function visible_pairwise_tree_128(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.02392874694921894;
    end
    else
    begin
        if features.candidate_path_segments <= 9.5000000000000018 then
        begin
            if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
            begin
                Result := 0.022913979247015839;
            end
            else
            begin
                if features.delta_char_lm_score <= -445.49999999999994 then
                begin
                    if features.delta_score_per_unit <= 951.50000000000011 then
                    begin
                        if features.delta_char_lm_suffix_score <= -1.0000000180025095E-35 then
                        begin
                            Result := -0.0046460451240827299;
                        end
                        else
                        begin
                            Result := 0.017619219306768664;
                        end;
                    end
                    else
                    begin
                        Result := 0.0091132628221053426;
                    end;
                end
                else
                begin
                    Result := 0.0042154151087880247;
                end;
            end;
        end
        else
        begin
            Result := -0.0063845502631701637;
        end;
    end;
end;

function visible_pairwise_tree_129(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023900694365724392;
    end
    else
    begin
        if features.baseline_abstain_score <= 1.0685854882015289 then
        begin
            if features.delta_char_lm_suffix_score <= -1.0000000180025095E-35 then
            begin
                Result := 0.00024249564579261132;
            end
            else
            begin
                if features.baseline_abstain_score <= 0.54709137296723831 then
                begin
                    Result := 0.014547589220172429;
                end
                else
                begin
                    if features.delta_char_lm_score <= 30.500000000000004 then
                    begin
                        if features.candidate_chain_first_stage_score <= 87433.500000000015 then
                        begin
                            Result := 0.025098611380439152;
                        end
                        else
                        begin
                            Result := -0.0039360373241264478;
                        end;
                    end
                    else
                    begin
                        Result := -0.0073234001019979889;
                    end;
                end;
            end;
        end
        else
        begin
            Result := -0.017931609142259813;
        end;
    end;
end;

function visible_pairwise_tree_130(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.candidate_ranker_score_gap <= -3202697.9999999995 then
        begin
            if features.delta_path_single_segments <= 1.5000000000000002 then
            begin
                if features.candidate_chain_score_gap <= -187204557.99999997 then
                begin
                    if features.candidate_text_units <= 8.5000000000000018 then
                    begin
                        Result := 0.05334330460410202;
                    end
                    else
                    begin
                        Result := 0.0070322127867372798;
                    end;
                end
                else
                begin
                    Result := 0.0016375726321924086;
                end;
            end
            else
            begin
                if features.delta_dict_weight_per_unit <= 12146.000000000002 then
                begin
                    Result := -0.006599772971804291;
                end
                else
                begin
                    Result := 0.0068888785726918811;
                end;
            end;
        end
        else
        begin
            Result := 0.020453279155234715;
        end;
    end
    else
    begin
        Result := -0.023873569661813088;
    end;
end;

function visible_pairwise_tree_131(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023848908093543141;
    end
    else
    begin
        if features.candidate_chain_first_stage_score <= 182800.00000000003 then
        begin
            if features.delta_chain_second_stage_score <= -312518516.49999994 then
            begin
                Result := -0.016170903479028675;
            end
            else
            begin
                if features.baseline_abstain_score <= 1.2479930108789816 then
                begin
                    if features.delta_chain_score_gap <= -194221963.49999997 then
                    begin
                        if features.candidate_ranker_score_gap <= -62804080.999999993 then
                        begin
                            Result := -0.001318773125726095;
                        end
                        else
                        begin
                            Result := 0.040570640010171646;
                        end;
                    end
                    else
                    begin
                        Result := 0.0024097815830755273;
                    end;
                end
                else
                begin
                    Result := -0.020907012298765751;
                end;
            end;
        end
        else
        begin
            Result := -0.0058922238552173304;
        end;
    end;
end;

function visible_pairwise_tree_132(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023823083039384407;
    end
    else
    begin
        if features.delta_char_lm_score <= -2118.4999999999995 then
        begin
            Result := -0.017144583079148252;
        end
        else
        begin
            if features.candidate_char_lm_suffix_score <= -6935.4999999999991 then
            begin
                Result := 0.0067772559371851787;
            end
            else
            begin
                if features.delta_char_lm_context_score <= -240.49999999999997 then
                begin
                    if features.candidate_ranker_score <= -3102174.9999999995 then
                    begin
                        Result := -0.0082219556200933668;
                    end
                    else
                    begin
                        Result := 0.0011960006772187856;
                    end;
                end
                else
                begin
                    if features.delta_path_available <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.0020753741008046672;
                    end
                    else
                    begin
                        Result := 0.019924921331257131;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_133(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023796070846197632;
    end
    else
    begin
        if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
        begin
            if features.delta_path_max_segment_units <= -1.0000000180025095E-35 then
            begin
                Result := -0.013246690014620494;
            end
            else
            begin
                if features.candidate_path_single_segments <= 1.0000000180025095E-35 then
                begin
                    Result := 0.048166495785261991;
                end
                else
                begin
                    Result := -0.0025186442361464444;
                end;
            end;
        end
        else
        begin
            if features.delta_char_lm_score <= -1676.4999999999998 then
            begin
                if features.delta_score_per_unit <= 5868.5000000000009 then
                begin
                    Result := -0.019263794313809028;
                end
                else
                begin
                    Result := 0.029275475148177039;
                end;
            end
            else
            begin
                Result := 0.0012778989197006049;
            end;
        end;
    end;
end;

function visible_pairwise_tree_134(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023765690824621526;
    end
    else
    begin
        if features.delta_chain_first_stage_score <= 1.0000000180025095E-35 then
        begin
            if features.delta_score_per_unit <= 5424.5000000000009 then
            begin
                if features.delta_dict_weight <= -2063.4999999999995 then
                begin
                    Result := -0.0033846873447892392;
                end
                else
                begin
                    Result := 0.0048409059866020973;
                end;
            end
            else
            begin
                Result := 0.031527511531664137;
            end;
        end
        else
        begin
            if features.candidate_dict_weight <= -1.0000000180025095E-35 then
            begin
                Result := 0.041163577516040439;
            end
            else
            begin
                if features.candidate_ranker_score <= 3328865.0000000005 then
                begin
                    Result := -0.0089741330784399928;
                end
                else
                begin
                    Result := 0.004736721020986494;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_135(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023736870282252288;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -14880512.999999998 then
        begin
            if features.delta_path_segments <= 6.5000000000000009 then
            begin
                if features.delta_legacy_rank <= 1.0000000180025095E-35 then
                begin
                    Result := -0.01145090772736234;
                end
                else
                begin
                    Result := 0.0011864614761456945;
                end;
            end
            else
            begin
                Result := -0.013049546101863957;
            end;
        end
        else
        begin
            if features.candidate_text_units <= 10.500000000000002 then
            begin
                Result := -0.0054428228818899256;
            end
            else
            begin
                if features.delta_chain_score_gap <= 7434994.0000000009 then
                begin
                    Result := 0.024467323760686093;
                end
                else
                begin
                    Result := -0.0085869657805786159;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_136(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023708747079681236;
    end
    else
    begin
        if features.baseline_abstain_score <= 1.2479930108789816 then
        begin
            if features.candidate_ranker_score <= 1304858.0000000002 then
            begin
                if features.delta_legacy_rank <= 1.0000000180025095E-35 then
                begin
                    Result := -0.018725851757613817;
                end
                else
                begin
                    Result := 0.00034191442988521517;
                end;
            end
            else
            begin
                if features.candidate_dict_weight <= 210723.00000000003 then
                begin
                    if features.delta_char_lm_score <= -330.49999999999994 then
                    begin
                        Result := -0.0011386985798850044;
                    end
                    else
                    begin
                        Result := 0.010385789418860397;
                    end;
                end
                else
                begin
                    Result := -0.012868859772667966;
                end;
            end;
        end
        else
        begin
            Result := -0.021417944882999536;
        end;
    end;
end;

function visible_pairwise_tree_137(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023676851334077015;
    end
    else
    begin
        if features.delta_candidate_score <= -50557.999999999993 then
        begin
            if features.delta_chain_first_stage_score <= -91688.499999999985 then
            begin
                Result := -0.0033340803105069042;
            end
            else
            begin
                if features.candidate_score_per_unit <= 5083.5000000000009 then
                begin
                    Result := 0.027633936400065506;
                end
                else
                begin
                    Result := 0.0022037622477595396;
                end;
            end;
        end
        else
        begin
            if features.delta_score_per_unit <= -474.99999999999994 then
            begin
                if features.candidate_char_lm_score <= -3131.4999999999995 then
                begin
                    Result := -0.0086223549609790642;
                end
                else
                begin
                    Result := 0.023926794501555715;
                end;
            end
            else
            begin
                Result := 0.0012083837121273145;
            end;
        end;
    end;
end;

function visible_pairwise_tree_138(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023648255918452613;
    end
    else
    begin
        if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
        begin
            Result := 0.021635522482047632;
        end
        else
        begin
            if features.delta_char_lm_score <= -476.49999999999994 then
            begin
                if features.candidate_chain_score_gap <= 6621247.5000000009 then
                begin
                    if features.candidate_char_lm_suffix_score <= -5570.4999999999991 then
                    begin
                        Result := -0.00055202446096875094;
                    end
                    else
                    begin
                        Result := -0.012305582824876989;
                    end;
                end
                else
                begin
                    Result := 0.027743362264962636;
                end;
            end
            else
            begin
                if features.delta_source_local_rerank <= -1.0000000180025095E-35 then
                begin
                    Result := 0.013671886257487928;
                end
                else
                begin
                    Result := 0.0015702099088354083;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_139(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score_gap <= -67541427.999999985 then
    begin
        Result := -0.023694136830784012;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= 342.50000000000006 then
        begin
            if features.candidate_char_lm_suffix_score <= -6935.4999999999991 then
            begin
                if features.candidate_path_max_segment_units <= 2.5000000000000004 then
                begin
                    Result := 0.00067369213721865293;
                end
                else
                begin
                    if features.delta_candidate_score <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.0033689726013426766;
                    end
                    else
                    begin
                        if features.candidate_text_units <= 8.5000000000000018 then
                        begin
                            Result := 0.052841342068178559;
                        end
                        else
                        begin
                            Result := 0.0074289304524040997;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := -7.1389063597272133E-05;
            end;
        end
        else
        begin
            Result := -0.0171773533533254;
        end;
    end;
end;

function visible_pairwise_tree_140(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.delta_path_single_segments <= 1.0000000180025095E-35 then
        begin
            if features.candidate_candidate_score <= 48661.500000000007 then
            begin
                if features.delta_path_max_segment_units <= 4.5000000000000009 then
                begin
                    if features.candidate_path_segments <= 5.5000000000000009 then
                    begin
                        Result := 0.032977033509819974;
                    end
                    else
                    begin
                        Result := 0.002896462915157869;
                    end;
                end
                else
                begin
                    Result := -0.018674264374914408;
                end;
            end
            else
            begin
                Result := 0.001374174861350194;
            end;
        end
        else
        begin
            if features.delta_char_lm_suffix_score <= -1.0000000180025095E-35 then
            begin
                Result := -0.0060923170312656089;
            end
            else
            begin
                Result := 0.0073283104077875184;
            end;
        end;
    end
    else
    begin
        Result := -0.023585031735281703;
    end;
end;

function visible_pairwise_tree_141(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023556015414713402;
    end
    else
    begin
        if features.candidate_chain_score_gap <= 54774488.000000007 then
        begin
            if features.delta_char_lm_suffix_score <= 379.50000000000006 then
            begin
                if features.delta_char_lm_suffix_score <= -123.49999999999999 then
                begin
                    if features.candidate_chain_score_gap <= 6621247.5000000009 then
                    begin
                        Result := -0.0011307705914971643;
                    end
                    else
                    begin
                        Result := 0.016975611036599017;
                    end;
                end
                else
                begin
                    if features.candidate_dict_weight_per_unit <= 5360.5000000000009 then
                    begin
                        Result := 0.013776422734120459;
                    end
                    else
                    begin
                        Result := 0.0017565017516147756;
                    end;
                end;
            end
            else
            begin
                Result := -0.018636969853158838;
            end;
        end
        else
        begin
            Result := -0.018269138205476328;
        end;
    end;
end;

function visible_pairwise_tree_142(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023519935782804223;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -83.499999999999986 then
        begin
            if features.delta_path_single_segments <= 1.0000000180025095E-35 then
            begin
                if features.candidate_char_lm_suffix_score <= -8206.4999999999982 then
                begin
                    Result := 0.023843638137787667;
                end
                else
                begin
                    if features.candidate_ranker_score <= -4992347.4999999991 then
                    begin
                        Result := -0.0046293569306792666;
                    end
                    else
                    begin
                        Result := 0.0046531936240115758;
                    end;
                end;
            end
            else
            begin
                Result := -0.0059993243172993208;
            end;
        end
        else
        begin
            if features.delta_path_max_segment_units <= 1.0000000180025095E-35 then
            begin
                Result := 0.0018168532652919061;
            end
            else
            begin
                Result := 0.01697027213394757;
            end;
        end;
    end;
end;

function visible_pairwise_tree_143(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023488543408410115;
    end
    else
    begin
        if features.candidate_chain_first_stage_score <= 209184.00000000003 then
        begin
            if features.delta_chain_second_stage_score <= -312518516.49999994 then
            begin
                Result := -0.018007364739139605;
            end
            else
            begin
                if features.candidate_chain_rank <= 2.5000000000000004 then
                begin
                    if features.candidate_candidate_score <= 181311.00000000003 then
                    begin
                        Result := 0.00053023241590700084;
                    end
                    else
                    begin
                        if features.delta_score_per_unit <= 5868.5000000000009 then
                        begin
                            Result := 0.0064566043584776177;
                        end
                        else
                        begin
                            Result := 0.045069954252811573;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.021083096617104908;
                end;
            end;
        end
        else
        begin
            Result := -0.0084838167924648541;
        end;
    end;
end;

function visible_pairwise_tree_144(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023456971821608844;
    end
    else
    begin
        if features.baseline_abstain_score <= 0.97303776155812505 then
        begin
            if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
            begin
                Result := 0.024458369055321998;
            end
            else
            begin
                if features.candidate_ranker_score <= -3102174.9999999995 then
                begin
                    if features.delta_char_lm_suffix_score <= -1.0000000180025095E-35 then
                    begin
                        Result := -0.0033311002011275105;
                    end
                    else
                    begin
                        Result := 0.011668155616233133;
                    end;
                end
                else
                begin
                    if features.delta_candidate_score <= -50557.999999999993 then
                    begin
                        Result := 0.016437643128865465;
                    end
                    else
                    begin
                        Result := 0.0019918642367657757;
                    end;
                end;
            end;
        end
        else
        begin
            Result := -0.010893844943409559;
        end;
    end;
end;

function visible_pairwise_tree_145(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023419721164795664;
    end
    else
    begin
        if features.delta_path_single_segments <= 1.5000000000000002 then
        begin
            if features.candidate_candidate_score <= 48661.500000000007 then
            begin
                if features.candidate_chain_score_gap <= -15829433.999999998 then
                begin
                    Result := 0.0015041622488556328;
                end
                else
                begin
                    if features.delta_char_lm_suffix_score <= -1147.4999999999998 then
                    begin
                        Result := -0.01090276262536833;
                    end
                    else
                    begin
                        Result := 0.026109497176698471;
                    end;
                end;
            end
            else
            begin
                if features.candidate_chain_second_stage_score <= 289648223.00000006 then
                begin
                    Result := 0.0022737058488731766;
                end
                else
                begin
                    Result := -0.009154295073450466;
                end;
            end;
        end
        else
        begin
            Result := -0.0027619835679370489;
        end;
    end;
end;

function visible_pairwise_tree_146(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023384717158489814;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= -259.49999999999994 then
        begin
            if features.candidate_char_lm_suffix_score <= -7286.4999999999991 then
            begin
                if features.candidate_text_units <= 8.5000000000000018 then
                begin
                    Result := 0.016356626691952616;
                end
                else
                begin
                    Result := -0.0050558744323757638;
                end;
            end
            else
            begin
                if features.candidate_ranker_score <= -3102174.9999999995 then
                begin
                    Result := -0.0087572359525158044;
                end
                else
                begin
                    if features.delta_candidate_score <= -50036.499999999993 then
                    begin
                        Result := 0.034179651039325784;
                    end
                    else
                    begin
                        Result := -0.0011039093042155472;
                    end;
                end;
            end;
        end
        else
        begin
            Result := 0.0029199844969480769;
        end;
    end;
end;

function visible_pairwise_tree_147(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.baseline_abstain_score <= 1.0685854882015289 then
        begin
            if features.delta_char_lm_score <= -476.49999999999994 then
            begin
                if features.candidate_char_lm_suffix_score <= -6428.4999999999991 then
                begin
                    if features.delta_path_single_segments <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.0076652439896152218;
                    end
                    else
                    begin
                        Result := -0.0062423478133157529;
                    end;
                end
                else
                begin
                    Result := -0.0070119318749278375;
                end;
            end
            else
            begin
                if features.candidate_ranker_score <= 17075713.000000004 then
                begin
                    Result := 0.0016493625957818801;
                end
                else
                begin
                    Result := 0.017736998093049034;
                end;
            end;
        end
        else
        begin
            Result := -0.017327355416043057;
        end;
    end
    else
    begin
        Result := -0.023349654500004299;
    end;
end;

function visible_pairwise_tree_148(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023308010523483885;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= 299073856.50000006 then
        begin
            if features.candidate_chain_second_stage_score <= 289648223.00000006 then
            begin
                if features.delta_char_lm_score <= -2118.4999999999995 then
                begin
                    Result := -0.016990165647910293;
                end
                else
                begin
                    Result := 0.0013682526129475091;
                end;
            end
            else
            begin
                if features.delta_chain_score_gap <= -136994204.49999997 then
                begin
                    Result := 0.016038537458207255;
                end
                else
                begin
                    Result := -0.012891771548591759;
                end;
            end;
        end
        else
        begin
            if features.candidate_text_units <= 11.500000000000002 then
            begin
                Result := 0.038962360544046767;
            end
            else
            begin
                Result := -0.006631747761418511;
            end;
        end;
    end;
end;

function visible_pairwise_tree_149(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.023271817785773936;
    end
    else
    begin
        if features.candidate_path_segments <= 12.500000000000002 then
        begin
            if features.delta_char_lm_score <= -2118.4999999999995 then
            begin
                Result := -0.016881779076812566;
            end
            else
            begin
                if features.candidate_chain_second_stage_score <= 390848988.00000006 then
                begin
                    if features.baseline_abstain_score <= 1.2479930108789816 then
                    begin
                        if features.delta_char_lm_score <= -387.49999999999994 then
                        begin
                            Result := -0.00033745796945026978;
                        end
                        else
                        begin
                            Result := 0.0044403965614546875;
                        end;
                    end
                    else
                    begin
                        Result := -0.020864470903308951;
                    end;
                end
                else
                begin
                    Result := -0.011355558630666347;
                end;
            end;
        end
        else
        begin
            Result := -0.019374193548535056;
        end;
    end;
end;

function visible_pairwise_tree_150(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.delta_complete_match <= -1.0000000180025095E-35 then
    begin
        Result := -0.023236525237388703;
    end
    else
    begin
        if features.candidate_path_segments <= 11.500000000000002 then
        begin
            if features.delta_chain_second_stage_score <= 299073856.50000006 then
            begin
                if features.candidate_char_lm_suffix_score <= -5528.4999999999991 then
                begin
                    if features.candidate_chain_second_stage_score <= 77569630.500000015 then
                    begin
                        Result := 0.00092645889514676163;
                    end
                    else
                    begin
                        if features.candidate_chain_score_gap <= -142956063.99999997 then
                        begin
                            Result := -0.012853063667841317;
                        end
                        else
                        begin
                            Result := 0.017015980959227628;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.0030053363885906362;
                end;
            end
            else
            begin
                Result := 0.02151905596601409;
            end;
        end
        else
        begin
            Result := -0.012187871801424298;
        end;
    end;
end;

function visible_pairwise_tree_151(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_unit_delta <= -1.0000000180025095E-35 then
    begin
        Result := -0.023194148273263489;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= 299073856.50000006 then
        begin
            if features.candidate_chain_second_stage_score <= 390848988.00000006 then
            begin
                if features.delta_path_single_segments <= 1.5000000000000002 then
                begin
                    if features.candidate_candidate_score <= 48661.500000000007 then
                    begin
                        Result := 0.01093822214871208;
                    end
                    else
                    begin
                        Result := 0.0013707316382831557;
                    end;
                end
                else
                begin
                    if features.candidate_candidate_score <= 181311.00000000003 then
                    begin
                        Result := -0.0052467194196445591;
                    end
                    else
                    begin
                        Result := 0.012524248196512613;
                    end;
                end;
            end
            else
            begin
                Result := -0.01335584703402393;
            end;
        end
        else
        begin
            Result := 0.024298712198850558;
        end;
    end;
end;

function visible_pairwise_tree_152(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.delta_char_lm_suffix_score <= 379.50000000000006 then
        begin
            if features.delta_char_lm_suffix_score <= -182.49999999999997 then
            begin
                if features.candidate_path_segments <= 7.5000000000000009 then
                begin
                    Result := 0.00075281719276537032;
                end
                else
                begin
                    Result := -0.0091079045431114638;
                end;
            end
            else
            begin
                if features.delta_path_max_segment_units <= 7.5000000000000009 then
                begin
                    Result := 0.0031722218684836004;
                end
                else
                begin
                    if features.candidate_char_lm_suffix_score <= -5839.4999999999991 then
                    begin
                        Result := 0.056228629981596091;
                    end
                    else
                    begin
                        Result := -0.0053550102103570177;
                    end;
                end;
            end;
        end
        else
        begin
            Result := -0.017929768036289716;
        end;
    end
    else
    begin
        Result := -0.023155944731107905;
    end;
end;

function visible_pairwise_tree_153(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.02311612490860053;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= -312518516.49999994 then
        begin
            Result := -0.018122044614796756;
        end
        else
        begin
            if features.delta_chain_score_gap <= -194221963.49999997 then
            begin
                if features.candidate_text_units <= 8.5000000000000018 then
                begin
                    Result := 0.050238483316452281;
                end
                else
                begin
                    Result := 0.0030705373329653258;
                end;
            end
            else
            begin
                if features.delta_chain_second_stage_score <= -39103572.499999993 then
                begin
                    Result := -0.0020217016682992027;
                end
                else
                begin
                    if features.delta_char_lm_score <= -853.49999999999989 then
                    begin
                        Result := -0.0028627841423696622;
                    end
                    else
                    begin
                        Result := 0.0045586440076984857;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_154(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.delta_char_lm_suffix_score <= -2013.4999999999998 then
        begin
            Result := -0.02097361809131559;
        end
        else
        begin
            if features.delta_chain_second_stage_score <= -312518516.49999994 then
            begin
                Result := -0.017443370548758799;
            end
            else
            begin
                if features.baseline_abstain_score <= 1.2479930108789816 then
                begin
                    if features.delta_chain_first_stage_score <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.002526449692610358;
                    end
                    else
                    begin
                        if features.delta_dict_weight <= -57216.999999999993 then
                        begin
                            Result := 0.036450033977630976;
                        end
                        else
                        begin
                            Result := -0.0037786188105161027;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.020631658693018695;
                end;
            end;
        end;
    end
    else
    begin
        Result := -0.023069954684388314;
    end;
end;

function visible_pairwise_tree_155(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.delta_path_single_segments <= -1.4999999999999998 then
        begin
            Result := 0.0073157748221483569;
        end
        else
        begin
            if features.delta_dict_weight_per_unit <= -133.49999999999997 then
            begin
                if features.delta_candidate_score <= -50557.999999999993 then
                begin
                    Result := 0.0037347098696355555;
                end
                else
                begin
                    if features.delta_score_per_unit <= 4850.5000000000009 then
                    begin
                        if features.delta_char_lm_suffix_score <= -103.49999999999999 then
                        begin
                            Result := -0.016899518587492734;
                        end
                        else
                        begin
                            Result := -0.0023514712503521443;
                        end;
                    end
                    else
                    begin
                        Result := 0.027085866242059511;
                    end;
                end;
            end
            else
            begin
                Result := 0.001341221154878154;
            end;
        end;
    end
    else
    begin
        Result := -0.023036836304482763;
    end;
end;

function visible_pairwise_tree_156(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.022991267389221279;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= 299073856.50000006 then
        begin
            if features.candidate_chain_second_stage_score <= 221614304.00000003 then
            begin
                if features.candidate_chain_second_stage_score <= 77569630.500000015 then
                begin
                    Result := -5.7610417311249358E-05;
                end
                else
                begin
                    if features.candidate_path_single_segments <= 1.5000000000000002 then
                    begin
                        Result := 0.017144722323235835;
                    end
                    else
                    begin
                        Result := 0.0012361736745292343;
                    end;
                end;
            end
            else
            begin
                Result := -0.005792121660381325;
            end;
        end
        else
        begin
            if features.candidate_input_syllable_count <= 11.500000000000002 then
            begin
                Result := 0.032080907027713018;
            end
            else
            begin
                Result := -0.0071416427359457454;
            end;
        end;
    end;
end;

function visible_pairwise_tree_157(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.delta_path_single_segments <= -1.4999999999999998 then
        begin
            if features.candidate_candidate_score <= 28794.000000000004 then
            begin
                if features.candidate_chain_second_stage_score <= -1.0000000180025095E-35 then
                begin
                    Result := -0.0065797270842703681;
                end
                else
                begin
                    Result := 0.048435947229223425;
                end;
            end
            else
            begin
                if features.candidate_char_lm_score <= -4334.4999999999991 then
                begin
                    Result := 0.0082741636469865418;
                end
                else
                begin
                    Result := -0.011890358066483565;
                end;
            end;
        end
        else
        begin
            if features.delta_path_max_segment_units <= 11.500000000000002 then
            begin
                Result := 0.00039319713172234079;
            end
            else
            begin
                Result := 0.036329661795369811;
            end;
        end;
    end
    else
    begin
        Result := -0.022947475366454782;
    end;
end;

function visible_pairwise_tree_158(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.022896629437122187;
    end
    else
    begin
        if features.delta_dict_weight <= -2063.4999999999995 then
        begin
            if features.delta_candidate_score <= -50557.999999999993 then
            begin
                if features.delta_chain_first_stage_score <= -91688.499999999985 then
                begin
                    Result := -0.0047802451762832031;
                end
                else
                begin
                    Result := 0.014861952826671548;
                end;
            end
            else
            begin
                Result := -0.0060749792720825122;
            end;
        end
        else
        begin
            if features.delta_chain_first_stage_score <= 1.0000000180025095E-35 then
            begin
                Result := 0.0044195223565746157;
            end
            else
            begin
                if features.candidate_ranker_score <= 3328865.0000000005 then
                begin
                    Result := -0.0070026738877551585;
                end
                else
                begin
                    Result := 0.005175359370321219;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_159(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score_gap <= -67541427.999999985 then
    begin
        Result := -0.021838898921439823;
    end
    else
    begin
        if features.candidate_char_lm_suffix_score <= -8707.4999999999982 then
        begin
            if features.delta_path_max_segment_units <= -1.0000000180025095E-35 then
            begin
                Result := -0.01382567657175918;
            end
            else
            begin
                if features.candidate_ranker_score <= -4779062.9999999991 then
                begin
                    if features.delta_char_lm_score <= -2806.4999999999995 then
                    begin
                        Result := -0.0072409082226827714;
                    end
                    else
                    begin
                        Result := 0.050752799605470078;
                    end;
                end
                else
                begin
                    Result := -0.005958770179347885;
                end;
            end;
        end
        else
        begin
            if features.candidate_path_segments <= 12.500000000000002 then
            begin
                Result := 0.00056562231631986299;
            end
            else
            begin
                Result := -0.015373714153327042;
            end;
        end;
    end;
end;

function visible_pairwise_tree_160(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.022813358843294353;
    end
    else
    begin
        if features.candidate_text_units <= 6.5000000000000009 then
        begin
            if features.candidate_chain_score_gap <= -80291272.999999985 then
            begin
                Result := 0.041620368256902948;
            end
            else
            begin
                Result := 0.0044143586243255246;
            end;
        end
        else
        begin
            if features.delta_char_lm_score <= -761.49999999999989 then
            begin
                if features.candidate_dict_weight <= 32636.500000000004 then
                begin
                    Result := -0.015832602236795636;
                end
                else
                begin
                    Result := -0.0017525686382887824;
                end;
            end
            else
            begin
                if features.baseline_abstain_score <= 0.92306488145931842 then
                begin
                    Result := 0.0017058461521676548;
                end
                else
                begin
                    Result := -0.011218757204719446;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_161(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.022770384238362744;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -3202697.9999999995 then
        begin
            if features.delta_dict_weight <= -2063.4999999999995 then
            begin
                Result := -0.0030839471808360914;
            end
            else
            begin
                if features.delta_chain_first_stage_score <= 1.0000000180025095E-35 then
                begin
                    Result := 0.0040936433382758319;
                end
                else
                begin
                    if features.candidate_ranker_score <= 3328865.0000000005 then
                    begin
                        Result := -0.0073142006800819255;
                    end
                    else
                    begin
                        if features.delta_char_lm_score <= -387.49999999999994 then
                        begin
                            Result := -0.0028776146987697115;
                        end
                        else
                        begin
                            Result := 0.014192536874840539;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            Result := 0.019583535237054809;
        end;
    end;
end;

function visible_pairwise_tree_162(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.022720191087336028;
    end
    else
    begin
        if features.candidate_path_segments <= 11.500000000000002 then
        begin
            if features.candidate_char_lm_suffix_score <= -4572.4999999999991 then
            begin
                if features.candidate_ranker_score <= 1336385.5000000002 then
                begin
                    Result := 0.00029749627711902056;
                end
                else
                begin
                    if features.delta_char_lm_score <= -387.49999999999994 then
                    begin
                        Result := -0.0029008608456752628;
                    end
                    else
                    begin
                        Result := 0.0087431641035457322;
                    end;
                end;
            end
            else
            begin
                if features.delta_char_lm_score <= 1.0000000180025095E-35 then
                begin
                    Result := -0.015763228576722459;
                end
                else
                begin
                    Result := 0.012861198464797967;
                end;
            end;
        end
        else
        begin
            Result := -0.014437255676931566;
        end;
    end;
end;

function visible_pairwise_tree_163(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.delta_chain_second_stage_score <= 299073856.50000006 then
        begin
            if features.candidate_chain_second_stage_score <= 390848988.00000006 then
            begin
                if features.delta_path_segments <= -1.4999999999999998 then
                begin
                    if features.candidate_chain_second_stage_score <= -8738094.4999999981 then
                    begin
                        Result := 0.022736837572326196;
                    end
                    else
                    begin
                        Result := -0.011556980531236055;
                    end;
                end
                else
                begin
                    if features.candidate_path_segments <= 5.5000000000000009 then
                    begin
                        Result := 0.0036695904976136885;
                    end
                    else
                    begin
                        Result := -0.0015951116528288005;
                    end;
                end;
            end
            else
            begin
                Result := -0.014894081631968717;
            end;
        end
        else
        begin
            Result := 0.022407596628923162;
        end;
    end
    else
    begin
        Result := -0.022671806321027079;
    end;
end;

function visible_pairwise_tree_164(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.candidate_path_segments <= 12.500000000000002 then
        begin
            if features.delta_char_lm_score <= -2118.4999999999995 then
            begin
                Result := -0.016593412916725388;
            end
            else
            begin
                if features.baseline_abstain_score <= 0.98825663634865313 then
                begin
                    if features.candidate_char_lm_score <= -7428.4999999999991 then
                    begin
                        if features.delta_chain_first_stage_score <= 434.00000000000006 then
                        begin
                            Result := 0.032959816878907519;
                        end
                        else
                        begin
                            Result := -0.012412903830884491;
                        end;
                    end
                    else
                    begin
                        Result := 0.0014973148016174868;
                    end;
                end
                else
                begin
                    Result := -0.011104040062539984;
                end;
            end;
        end
        else
        begin
            Result := -0.017080981054481994;
        end;
    end
    else
    begin
        Result := -0.022624488166239857;
    end;
end;

function visible_pairwise_tree_165(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.delta_path_segments <= -1.4999999999999998 then
    begin
        Result := -0.011190730206412466;
    end
    else
    begin
        if features.delta_path_max_segment_units <= 7.5000000000000009 then
        begin
            if features.candidate_chain_score_gap <= 54774488.000000007 then
            begin
                if features.delta_path_single_segments <= 1.5000000000000002 then
                begin
                    if features.candidate_chain_score_gap <= -187204557.99999997 then
                    begin
                        Result := 0.01869380471690325;
                    end
                    else
                    begin
                        Result := 0.001337106945877129;
                    end;
                end
                else
                begin
                    if features.candidate_ranker_score_gap <= -14880512.999999998 then
                    begin
                        Result := -0.0048153955619390371;
                    end
                    else
                    begin
                        Result := 0.016243643281427432;
                    end;
                end;
            end
            else
            begin
                Result := -0.016010247554655879;
            end;
        end
        else
        begin
            Result := 0.018589452090700176;
        end;
    end;
end;

function visible_pairwise_tree_166(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score_gap <= -67541427.999999985 then
    begin
        Result := -0.0214214719707474;
    end
    else
    begin
        if features.candidate_path_single_segments <= 1.5000000000000002 then
        begin
            if features.delta_score_per_unit <= 5424.5000000000009 then
            begin
                if features.delta_path_segments <= 1.5000000000000002 then
                begin
                    if features.delta_char_lm_score <= -853.49999999999989 then
                    begin
                        Result := -0.010095292506759987;
                    end
                    else
                    begin
                        Result := 0.0022172877648654241;
                    end;
                end
                else
                begin
                    Result := 0.0098306134067203451;
                end;
            end
            else
            begin
                if features.delta_dict_weight_per_unit <= 6668.5000000000009 then
                begin
                    Result := 0.038714824899950102;
                end
                else
                begin
                    Result := 0.0001878325958060837;
                end;
            end;
        end
        else
        begin
            Result := -0.001485069953816097;
        end;
    end;
end;

function visible_pairwise_tree_167(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.022510669814663181;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -3202697.9999999995 then
        begin
            if features.delta_char_lm_suffix_score <= 379.50000000000006 then
            begin
                if features.candidate_chain_second_stage_score <= 436482271.00000006 then
                begin
                    if features.candidate_char_lm_score <= -3182.4999999999995 then
                    begin
                        Result := 0.00035523844410126224;
                    end
                    else
                    begin
                        if features.delta_score_per_unit <= -25.499999999999996 then
                        begin
                            Result := 0.04137342598688129;
                        end
                        else
                        begin
                            Result := -0.0098468939821159812;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.01520305733746081;
                end;
            end
            else
            begin
                Result := -0.021378707253876167;
            end;
        end
        else
        begin
            Result := 0.017823360387113952;
        end;
    end;
end;

function visible_pairwise_tree_168(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.022458028092904647;
    end
    else
    begin
        if features.candidate_chain_second_stage_score <= 390848988.00000006 then
        begin
            if features.baseline_abstain_score <= 1.2479930108789816 then
            begin
                if features.candidate_ranker_score_gap <= -38475682.499999993 then
                begin
                    Result := -0.0015324897411401438;
                end
                else
                begin
                    if features.candidate_chain_first_stage_score <= 51896.500000000007 then
                    begin
                        Result := 0.007670463401797444;
                    end
                    else
                    begin
                        if features.delta_chain_first_stage_score <= 1.0000000180025095E-35 then
                        begin
                            Result := 0.0048974544002082709;
                        end
                        else
                        begin
                            Result := -0.00425560391062209;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := -0.020093786651815285;
            end;
        end
        else
        begin
            Result := -0.011428242488999478;
        end;
    end;
end;

function visible_pairwise_tree_169(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.candidate_path_single_segments <= 1.5000000000000002 then
        begin
            if features.delta_score_per_unit <= 5424.5000000000009 then
            begin
                if features.candidate_chain_score_gap <= -181605509.99999997 then
                begin
                    if features.delta_dict_weight_per_unit <= -5649.4999999999991 then
                    begin
                        Result := -0.0093283881587475134;
                    end
                    else
                    begin
                        Result := 0.041213823870371785;
                    end;
                end
                else
                begin
                    if features.candidate_ranker_score_gap <= -42376629.499999993 then
                    begin
                        Result := -0.004305122022518741;
                    end
                    else
                    begin
                        Result := 0.0047641104761833317;
                    end;
                end;
            end
            else
            begin
                Result := 0.022366547166031075;
            end;
        end
        else
        begin
            Result := -0.00085789520482607679;
        end;
    end
    else
    begin
        Result := -0.022403966204366865;
    end;
end;

function visible_pairwise_tree_170(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.022353203706075617;
    end
    else
    begin
        if features.baseline_abstain_score <= 1.2479930108789816 then
        begin
            if features.delta_char_lm_score <= -476.49999999999994 then
            begin
                if features.candidate_chain_score_gap <= 6621247.5000000009 then
                begin
                    if features.candidate_input_syllable_count <= 9.5000000000000018 then
                    begin
                        if features.candidate_chain_score_gap <= -198471260.49999997 then
                        begin
                            Result := 0.033057615159865487;
                        end
                        else
                        begin
                            Result := -0.00065227942481217087;
                        end;
                    end
                    else
                    begin
                        Result := -0.010570757251210643;
                    end;
                end
                else
                begin
                    Result := 0.024222111045111964;
                end;
            end
            else
            begin
                Result := 0.0022813140405269386;
            end;
        end
        else
        begin
            Result := -0.020361150152414163;
        end;
    end;
end;

function visible_pairwise_tree_171(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.022301099200218527;
    end
    else
    begin
        if features.candidate_char_lm_suffix_score <= -6935.4999999999991 then
        begin
            Result := 0.0049338762342679915;
        end
        else
        begin
            if features.candidate_chain_second_stage_score <= -138154689.99999997 then
            begin
                Result := -0.0098447344573115696;
            end
            else
            begin
                if features.delta_char_lm_score <= -1078.4999999999998 then
                begin
                    Result := -0.0094827768728173046;
                end
                else
                begin
                    if features.candidate_text_units <= 10.500000000000002 then
                    begin
                        if features.delta_path_segments <= 3.5000000000000004 then
                        begin
                            Result := 0.0015759205224928335;
                        end
                        else
                        begin
                            Result := 0.012427130752020529;
                        end;
                    end
                    else
                    begin
                        Result := -0.0017815424995663688;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_172(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_unit_delta <= -1.0000000180025095E-35 then
    begin
        Result := -0.022245100968061367;
    end
    else
    begin
        if features.delta_char_lm_suffix_score <= 342.50000000000006 then
        begin
            if features.candidate_char_lm_suffix_score <= -6980.4999999999991 then
            begin
                Result := 0.0047542488722427164;
            end
            else
            begin
                if features.delta_char_lm_suffix_score <= -240.49999999999997 then
                begin
                    if features.candidate_ranker_score <= -3102174.9999999995 then
                    begin
                        Result := -0.0084825332678739301;
                    end
                    else
                    begin
                        Result := 0.0004416330442692111;
                    end;
                end
                else
                begin
                    if features.delta_path_max_segment_units <= 1.0000000180025095E-35 then
                    begin
                        Result := -0.00025372987691238354;
                    end
                    else
                    begin
                        Result := 0.012936393376109077;
                    end;
                end;
            end;
        end
        else
        begin
            Result := -0.017882814737031225;
        end;
    end;
end;

function visible_pairwise_tree_173(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.022186978695792753;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= -333363365.99999994 then
        begin
            Result := -0.01803546461466143;
        end
        else
        begin
            if features.candidate_chain_score_gap <= -293204934.99999994 then
            begin
                Result := 0.032729782515648995;
            end
            else
            begin
                if features.candidate_legacy_rank <= 2.5000000000000004 then
                begin
                    Result := 0.00032108115151247354;
                end
                else
                begin
                    if features.delta_chain_first_stage_score <= -43521.999999999993 then
                    begin
                        Result := -0.01002453048383792;
                    end
                    else
                    begin
                        if features.delta_dict_weight <= 66107.000000000015 then
                        begin
                            Result := 0.021989813959729682;
                        end
                        else
                        begin
                            Result := -0.0019759496503858449;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_174(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.022129732436152783;
    end
    else
    begin
        if features.candidate_path_segments <= 11.500000000000002 then
        begin
            if features.baseline_abstain_score <= 1.2479930108789816 then
            begin
                if features.delta_candidate_score <= -50557.999999999993 then
                begin
                    if features.delta_chain_first_stage_score <= -91688.499999999985 then
                    begin
                        Result := -0.0040945597849024592;
                    end
                    else
                    begin
                        Result := 0.016203170693488957;
                    end;
                end
                else
                begin
                    if features.delta_dict_weight <= -8997.4999999999982 then
                    begin
                        Result := -0.0055444615133777601;
                    end
                    else
                    begin
                        Result := 0.0019103902616872679;
                    end;
                end;
            end
            else
            begin
                Result := -0.020029442020101731;
            end;
        end
        else
        begin
            Result := -0.011667707318153196;
        end;
    end;
end;

function visible_pairwise_tree_175(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.delta_path_segments <= -1.4999999999999998 then
    begin
        if features.candidate_chain_second_stage_score <= -8738094.4999999981 then
        begin
            if features.delta_dict_weight <= -92726.999999999985 then
            begin
                Result := 0.033432093012995517;
            end
            else
            begin
                Result := -0.012588304384216513;
            end;
        end
        else
        begin
            Result := -0.012912045405045354;
        end;
    end
    else
    begin
        if features.candidate_chain_first_stage_score <= 209184.00000000003 then
        begin
            if features.candidate_candidate_score <= 181311.00000000003 then
            begin
                Result := 0.00036329223669367375;
            end
            else
            begin
                if features.delta_candidate_score <= -12108.499999999998 then
                begin
                    Result := -0.013353544284321658;
                end
                else
                begin
                    Result := 0.011107110843676075;
                end;
            end;
        end
        else
        begin
            Result := -0.0078403810787576605;
        end;
    end;
end;

function visible_pairwise_tree_176(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.022046617480462476;
    end
    else
    begin
        if features.delta_chain_second_stage_score <= -312518516.49999994 then
        begin
            Result := -0.017739533446291558;
        end
        else
        begin
            if features.delta_legacy_top <= -1.0000000180025095E-35 then
            begin
                if features.candidate_chain_rank <= 2.5000000000000004 then
                begin
                    Result := 0.00060090006224947665;
                end
                else
                begin
                    if features.delta_char_lm_suffix_score <= -474.49999999999994 then
                    begin
                        Result := -0.0064785895675150834;
                    end
                    else
                    begin
                        if features.candidate_chain_first_stage_score <= 62660.500000000007 then
                        begin
                            Result := 0.058644601762818431;
                        end
                        else
                        begin
                            Result := 0.011071987844920228;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := -0.0079405810716128809;
            end;
        end;
    end;
end;

function visible_pairwise_tree_177(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.021985757055068292;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -37446511.499999993 then
        begin
            Result := -0.0019700097918476634;
        end
        else
        begin
            if features.candidate_legacy_rank <= 2.5000000000000004 then
            begin
                if features.delta_chain_rank <= 1.0000000180025095E-35 then
                begin
                    Result := 0.008444521500120707;
                end
                else
                begin
                    if features.candidate_candidate_score <= 126119.50000000001 then
                    begin
                        Result := -0.0038455290715632817;
                    end
                    else
                    begin
                        Result := 0.004381607559580324;
                    end;
                end;
            end
            else
            begin
                if features.delta_dict_weight_per_unit <= 9259.0000000000018 then
                begin
                    Result := 0.032553269064902107;
                end
                else
                begin
                    Result := -0.0039381244580414046;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_178(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_ranker_score_gap <= -67541427.999999985 then
    begin
        Result := -0.020603676614306676;
    end
    else
    begin
        if features.candidate_ranker_score_gap <= -3202697.9999999995 then
        begin
            if features.candidate_input_syllable_count <= 13.500000000000002 then
            begin
                Result := 0.001393421401391049;
            end
            else
            begin
                if features.delta_char_lm_score <= -507.49999999999994 then
                begin
                    if features.candidate_score_per_unit <= 4572.5000000000009 then
                    begin
                        Result := 0.018254789259464756;
                    end
                    else
                    begin
                        Result := -0.024119588624948042;
                    end;
                end
                else
                begin
                    if features.delta_dict_weight <= -38899.999999999993 then
                    begin
                        Result := -0.011704008389745578;
                    end
                    else
                    begin
                        Result := 0.00045676921661055858;
                    end;
                end;
            end;
        end
        else
        begin
            Result := 0.016771201059008308;
        end;
    end;
end;

function visible_pairwise_tree_179(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.02187348390312267;
    end
    else
    begin
        if features.delta_char_lm_context_score <= -123.49999999999999 then
        begin
            if features.candidate_path_segments <= 7.5000000000000009 then
            begin
                if features.candidate_path_segments <= 1.5000000000000002 then
                begin
                    Result := -0.0075139014762843339;
                end
                else
                begin
                    Result := 0.0023848736052974155;
                end;
            end
            else
            begin
                Result := -0.0085983803890047391;
            end;
        end
        else
        begin
            if features.delta_path_max_segment_units <= 4.5000000000000009 then
            begin
                Result := 0.0019038830046742559;
            end
            else
            begin
                if features.candidate_char_lm_score <= -4603.4999999999991 then
                begin
                    Result := 0.040012432801180102;
                end
                else
                begin
                    Result := -0.0031781957363537293;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_180(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.021804661271211674;
    end
    else
    begin
        if features.delta_path_single_segments <= -1.4999999999999998 then
        begin
            if features.candidate_ranker_score_gap <= -42376629.499999993 then
            begin
                Result := -0.0031886934402651948;
            end
            else
            begin
                if features.delta_candidate_score <= 28535.000000000004 then
                begin
                    if features.baseline_abstain_score <= 0.8955361871899653 then
                    begin
                        if features.delta_chain_first_stage_score <= -132236.99999999997 then
                        begin
                            Result := -6.4685375236306187E-05;
                        end
                        else
                        begin
                            Result := 0.03123216758662764;
                        end;
                    end
                    else
                    begin
                        Result := -0.0080568230977814456;
                    end;
                end
                else
                begin
                    Result := 0.00057834389022450776;
                end;
            end;
        end
        else
        begin
            Result := -0.0010153139061825716;
        end;
    end;
end;

function visible_pairwise_tree_181(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.021747827503157798;
    end
    else
    begin
        if features.candidate_char_lm_suffix_score <= -6935.4999999999991 then
        begin
            if features.delta_chain_first_stage_score <= 434.00000000000006 then
            begin
                if features.delta_candidate_score <= 42836.000000000007 then
                begin
                    if features.candidate_ranker_score_gap <= -35455514.499999993 then
                    begin
                        if features.delta_candidate_score <= -1.0000000180025095E-35 then
                        begin
                            Result := -0.0064204549787441586;
                        end
                        else
                        begin
                            Result := 0.0074791567333985197;
                        end;
                    end
                    else
                    begin
                        Result := 0.016825332955918128;
                    end;
                end
                else
                begin
                    Result := 0.053216564270481617;
                end;
            end
            else
            begin
                Result := -0.0092598204496723291;
            end;
        end
        else
        begin
            Result := -0.0010994219794071094;
        end;
    end;
end;

function visible_pairwise_tree_182(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.02169213547509085;
    end
    else
    begin
        if features.candidate_chain_first_stage_score <= 287884.50000000006 then
        begin
            if features.candidate_path_single_segments <= 5.5000000000000009 then
            begin
                if features.delta_char_lm_score <= -387.49999999999994 then
                begin
                    Result := -0.001543948675775908;
                end
                else
                begin
                    if features.candidate_ranker_score <= 11175094.500000002 then
                    begin
                        if features.candidate_chain_first_stage_score <= 1.0000000180025095E-35 then
                        begin
                            Result := 0.009201940030334024;
                        end
                        else
                        begin
                            Result := -0.0011675983462329628;
                        end;
                    end
                    else
                    begin
                        Result := 0.018139899951325145;
                    end;
                end;
            end
            else
            begin
                Result := -0.014869472583498508;
            end;
        end
        else
        begin
            Result := -0.016491801354194324;
        end;
    end;
end;

function visible_pairwise_tree_183(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.021627740760358945;
    end
    else
    begin
        if features.delta_char_lm_score <= -2118.4999999999995 then
        begin
            Result := -0.016438108798775847;
        end
        else
        begin
            if features.candidate_path_single_segments <= 4.5000000000000009 then
            begin
                if features.candidate_chain_first_stage_score <= -1.0000000180025095E-35 then
                begin
                    if features.candidate_score_per_unit <= 1031.0000000000002 then
                    begin
                        Result := 0.0;
                    end
                    else
                    begin
                        Result := 0.031975452353120569;
                    end;
                end
                else
                begin
                    Result := 0.00069757770771727043;
                end;
            end
            else
            begin
                if features.delta_chain_second_stage_score <= -68372456.499999985 then
                begin
                    Result := -0.019940491283285559;
                end
                else
                begin
                    Result := 0.00010538256227463316;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_184(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.021556755965723037;
    end
    else
    begin
        if features.delta_path_single_segments <= -1.4999999999999998 then
        begin
            if features.candidate_candidate_score <= 28794.000000000004 then
            begin
                if features.candidate_chain_second_stage_score <= -1.0000000180025095E-35 then
                begin
                    Result := -0.0073534540151468514;
                end
                else
                begin
                    Result := 0.04576599553219237;
                end;
            end
            else
            begin
                if features.candidate_char_lm_score <= -4334.4999999999991 then
                begin
                    Result := 0.0079066816762646767;
                end
                else
                begin
                    Result := -0.012492344088902112;
                end;
            end;
        end
        else
        begin
            if features.delta_path_max_segment_units <= 11.500000000000002 then
            begin
                Result := -0.00068432032941575507;
            end
            else
            begin
                Result := 0.035873603797011891;
            end;
        end;
    end;
end;

function visible_pairwise_tree_185(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.021497908317094465;
    end
    else
    begin
        if features.candidate_char_lm_context_score <= -4572.4999999999991 then
        begin
            if features.delta_score_per_unit <= -25.499999999999996 then
            begin
                if features.delta_candidate_score <= -50557.999999999993 then
                begin
                    if features.delta_chain_second_stage_score <= 16695861.000000002 then
                    begin
                        Result := 0.0024120736703604072;
                    end
                    else
                    begin
                        Result := 0.032102125116545963;
                    end;
                end
                else
                begin
                    Result := -0.0059415711450756343;
                end;
            end
            else
            begin
                Result := 0.0025673806153668609;
            end;
        end
        else
        begin
            if features.delta_char_lm_score <= 1.0000000180025095E-35 then
            begin
                Result := -0.014907991524582779;
            end
            else
            begin
                Result := 0.012617354298289675;
            end;
        end;
    end;
end;

function visible_pairwise_tree_186(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.021433472007376896;
    end
    else
    begin
        if features.delta_char_lm_score <= -2118.4999999999995 then
        begin
            Result := -0.016225324620955262;
        end
        else
        begin
            if features.candidate_char_lm_suffix_score <= -6980.4999999999991 then
            begin
                if features.delta_score_per_unit <= -999.49999999999989 then
                begin
                    if features.delta_chain_first_stage_score <= -55504.499999999993 then
                    begin
                        if features.delta_char_lm_score <= -279.49999999999994 then
                        begin
                            Result := -0.014114440093752548;
                        end
                        else
                        begin
                            Result := 0.043170584258129113;
                        end;
                    end
                    else
                    begin
                        Result := -0.014331679861808081;
                    end;
                end
                else
                begin
                    Result := 0.008713740170641077;
                end;
            end
            else
            begin
                Result := 0.0;
            end;
        end;
    end;
end;

function visible_pairwise_tree_187(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.021362180484819002;
    end
    else
    begin
        if features.delta_char_lm_score <= -2118.4999999999995 then
        begin
            Result := -0.016198757772599132;
        end
        else
        begin
            if features.candidate_legacy_rank <= 2.5000000000000004 then
            begin
                Result := 1.1777521279814435E-05;
            end
            else
            begin
                if features.candidate_ranker_score_gap <= -30306795.499999996 then
                begin
                    Result := 0.0024292772471644838;
                end
                else
                begin
                    if features.candidate_char_lm_suffix_score <= -5707.4999999999991 then
                    begin
                        if features.candidate_dict_weight <= 109307.50000000001 then
                        begin
                            Result := 0.057932269676979287;
                        end
                        else
                        begin
                            Result := -0.005956666424138073;
                        end;
                    end
                    else
                    begin
                        Result := -0.009267588566151997;
                    end;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_188(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.candidate_path_segments <= 9.5000000000000018 then
        begin
            if features.candidate_dict_weight <= 181916.50000000003 then
            begin
                Result := 9.5300237289927778E-05;
            end
            else
            begin
                if features.delta_score_per_unit <= -25.499999999999996 then
                begin
                    Result := -0.0092763020047932371;
                end
                else
                begin
                    if features.delta_char_lm_suffix_score <= -814.49999999999989 then
                    begin
                        Result := -0.0085740431188451403;
                    end
                    else
                    begin
                        Result := 0.01966393737690194;
                    end;
                end;
            end;
        end
        else
        begin
            if features.candidate_ranker_score <= 17075713.000000004 then
            begin
                Result := -0.010498428030130858;
            end
            else
            begin
                Result := 0.015277296466228635;
            end;
        end;
    end
    else
    begin
        Result := -0.021296974147997277;
    end;
end;

function visible_pairwise_tree_189(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_partial_match <= 1.0000000180025095E-35 then
    begin
        if features.candidate_ranker_score_gap <= -3202697.9999999995 then
        begin
            if features.delta_candidate_score <= -2046.4999999999998 then
            begin
                if features.candidate_dict_weight_per_unit <= 5360.5000000000009 then
                begin
                    Result := 0.0029650785394329457;
                end
                else
                begin
                    Result := -0.0079348805688781287;
                end;
            end
            else
            begin
                if features.candidate_char_lm_suffix_score <= -4603.4999999999991 then
                begin
                    if features.delta_candidate_score <= -159.49999999999997 then
                    begin
                        Result := 0.0081271755028473492;
                    end
                    else
                    begin
                        Result := 0.00093795990826693078;
                    end;
                end
                else
                begin
                    Result := -0.012109732878295101;
                end;
            end;
        end
        else
        begin
            Result := 0.016298398717569423;
        end;
    end
    else
    begin
        Result := -0.021223406902169076;
    end;
end;

function visible_pairwise_tree_190(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_complete_match <= 1.0000000180025095E-35 then
    begin
        Result := -0.021159507101039671;
    end
    else
    begin
        if features.candidate_ranker_score <= 1304858.0000000002 then
        begin
            if features.candidate_legacy_rank <= 1.5000000000000002 then
            begin
                Result := -0.017304643835695799;
            end
            else
            begin
                Result := -0.00010056720616484761;
            end;
        end
        else
        begin
            if features.delta_char_lm_score <= -507.49999999999994 then
            begin
                if features.delta_score_per_unit <= 4579.5000000000009 then
                begin
                    Result := -0.013646442609337409;
                end
                else
                begin
                    Result := 0.0191121436966597;
                end;
            end
            else
            begin
                if features.candidate_dict_weight <= 210723.00000000003 then
                begin
                    Result := 0.0076631709009735193;
                end
                else
                begin
                    Result := -0.0092362215883387729;
                end;
            end;
        end;
    end;
end;

function visible_pairwise_tree_191(
    const features: TncLongVisiblePairwiseResidualFeatures): Double;
begin
    if features.candidate_path_max_segment_units <= 1.5000000000000002 then
    begin
        if features.baseline_abstain_score <= 1.0000000180025095E-35 then
        begin
            Result := 0.003626255178226288;
        end
        else
        begin
            Result := -0.020186212294655725;
        end;
    end
    else
    begin
        if features.delta_dict_weight_per_unit <= 11409.500000000002 then
        begin
            if features.delta_path_single_segments <= 1.0000000180025095E-35 then
            begin
                Result := 0.0012425496378591231;
            end
            else
            begin
                if features.candidate_score_per_unit <= 7078.0000000000009 then
                begin
                    Result := 0.00032569085756467699;
                end
                else
                begin
                    Result := -0.0103442370055171;
                end;
            end;
        end
        else
        begin
            if features.delta_candidate_score <= -221.49999999999997 then
            begin
                Result := -0.010192673682238633;
            end
            else
            begin
                Result := 0.0086899327277367329;
            end;
        end;
    end;
end;
function long_visible_pairwise_residual_score(
    const features: TncLongVisiblePairwiseResidualFeatures): Int64;
var
    score: Double;
begin
    score := 0.0;
    score := score + visible_pairwise_tree_0(features);
    score := score + visible_pairwise_tree_1(features);
    score := score + visible_pairwise_tree_2(features);
    score := score + visible_pairwise_tree_3(features);
    score := score + visible_pairwise_tree_4(features);
    score := score + visible_pairwise_tree_5(features);
    score := score + visible_pairwise_tree_6(features);
    score := score + visible_pairwise_tree_7(features);
    score := score + visible_pairwise_tree_8(features);
    score := score + visible_pairwise_tree_9(features);
    score := score + visible_pairwise_tree_10(features);
    score := score + visible_pairwise_tree_11(features);
    score := score + visible_pairwise_tree_12(features);
    score := score + visible_pairwise_tree_13(features);
    score := score + visible_pairwise_tree_14(features);
    score := score + visible_pairwise_tree_15(features);
    score := score + visible_pairwise_tree_16(features);
    score := score + visible_pairwise_tree_17(features);
    score := score + visible_pairwise_tree_18(features);
    score := score + visible_pairwise_tree_19(features);
    score := score + visible_pairwise_tree_20(features);
    score := score + visible_pairwise_tree_21(features);
    score := score + visible_pairwise_tree_22(features);
    score := score + visible_pairwise_tree_23(features);
    score := score + visible_pairwise_tree_24(features);
    score := score + visible_pairwise_tree_25(features);
    score := score + visible_pairwise_tree_26(features);
    score := score + visible_pairwise_tree_27(features);
    score := score + visible_pairwise_tree_28(features);
    score := score + visible_pairwise_tree_29(features);
    score := score + visible_pairwise_tree_30(features);
    score := score + visible_pairwise_tree_31(features);
    score := score + visible_pairwise_tree_32(features);
    score := score + visible_pairwise_tree_33(features);
    score := score + visible_pairwise_tree_34(features);
    score := score + visible_pairwise_tree_35(features);
    score := score + visible_pairwise_tree_36(features);
    score := score + visible_pairwise_tree_37(features);
    score := score + visible_pairwise_tree_38(features);
    score := score + visible_pairwise_tree_39(features);
    score := score + visible_pairwise_tree_40(features);
    score := score + visible_pairwise_tree_41(features);
    score := score + visible_pairwise_tree_42(features);
    score := score + visible_pairwise_tree_43(features);
    score := score + visible_pairwise_tree_44(features);
    score := score + visible_pairwise_tree_45(features);
    score := score + visible_pairwise_tree_46(features);
    score := score + visible_pairwise_tree_47(features);
    score := score + visible_pairwise_tree_48(features);
    score := score + visible_pairwise_tree_49(features);
    score := score + visible_pairwise_tree_50(features);
    score := score + visible_pairwise_tree_51(features);
    score := score + visible_pairwise_tree_52(features);
    score := score + visible_pairwise_tree_53(features);
    score := score + visible_pairwise_tree_54(features);
    score := score + visible_pairwise_tree_55(features);
    score := score + visible_pairwise_tree_56(features);
    score := score + visible_pairwise_tree_57(features);
    score := score + visible_pairwise_tree_58(features);
    score := score + visible_pairwise_tree_59(features);
    score := score + visible_pairwise_tree_60(features);
    score := score + visible_pairwise_tree_61(features);
    score := score + visible_pairwise_tree_62(features);
    score := score + visible_pairwise_tree_63(features);
    score := score + visible_pairwise_tree_64(features);
    score := score + visible_pairwise_tree_65(features);
    score := score + visible_pairwise_tree_66(features);
    score := score + visible_pairwise_tree_67(features);
    score := score + visible_pairwise_tree_68(features);
    score := score + visible_pairwise_tree_69(features);
    score := score + visible_pairwise_tree_70(features);
    score := score + visible_pairwise_tree_71(features);
    score := score + visible_pairwise_tree_72(features);
    score := score + visible_pairwise_tree_73(features);
    score := score + visible_pairwise_tree_74(features);
    score := score + visible_pairwise_tree_75(features);
    score := score + visible_pairwise_tree_76(features);
    score := score + visible_pairwise_tree_77(features);
    score := score + visible_pairwise_tree_78(features);
    score := score + visible_pairwise_tree_79(features);
    score := score + visible_pairwise_tree_80(features);
    score := score + visible_pairwise_tree_81(features);
    score := score + visible_pairwise_tree_82(features);
    score := score + visible_pairwise_tree_83(features);
    score := score + visible_pairwise_tree_84(features);
    score := score + visible_pairwise_tree_85(features);
    score := score + visible_pairwise_tree_86(features);
    score := score + visible_pairwise_tree_87(features);
    score := score + visible_pairwise_tree_88(features);
    score := score + visible_pairwise_tree_89(features);
    score := score + visible_pairwise_tree_90(features);
    score := score + visible_pairwise_tree_91(features);
    score := score + visible_pairwise_tree_92(features);
    score := score + visible_pairwise_tree_93(features);
    score := score + visible_pairwise_tree_94(features);
    score := score + visible_pairwise_tree_95(features);
    score := score + visible_pairwise_tree_96(features);
    score := score + visible_pairwise_tree_97(features);
    score := score + visible_pairwise_tree_98(features);
    score := score + visible_pairwise_tree_99(features);
    score := score + visible_pairwise_tree_100(features);
    score := score + visible_pairwise_tree_101(features);
    score := score + visible_pairwise_tree_102(features);
    score := score + visible_pairwise_tree_103(features);
    score := score + visible_pairwise_tree_104(features);
    score := score + visible_pairwise_tree_105(features);
    score := score + visible_pairwise_tree_106(features);
    score := score + visible_pairwise_tree_107(features);
    score := score + visible_pairwise_tree_108(features);
    score := score + visible_pairwise_tree_109(features);
    score := score + visible_pairwise_tree_110(features);
    score := score + visible_pairwise_tree_111(features);
    score := score + visible_pairwise_tree_112(features);
    score := score + visible_pairwise_tree_113(features);
    score := score + visible_pairwise_tree_114(features);
    score := score + visible_pairwise_tree_115(features);
    score := score + visible_pairwise_tree_116(features);
    score := score + visible_pairwise_tree_117(features);
    score := score + visible_pairwise_tree_118(features);
    score := score + visible_pairwise_tree_119(features);
    score := score + visible_pairwise_tree_120(features);
    score := score + visible_pairwise_tree_121(features);
    score := score + visible_pairwise_tree_122(features);
    score := score + visible_pairwise_tree_123(features);
    score := score + visible_pairwise_tree_124(features);
    score := score + visible_pairwise_tree_125(features);
    score := score + visible_pairwise_tree_126(features);
    score := score + visible_pairwise_tree_127(features);
    score := score + visible_pairwise_tree_128(features);
    score := score + visible_pairwise_tree_129(features);
    score := score + visible_pairwise_tree_130(features);
    score := score + visible_pairwise_tree_131(features);
    score := score + visible_pairwise_tree_132(features);
    score := score + visible_pairwise_tree_133(features);
    score := score + visible_pairwise_tree_134(features);
    score := score + visible_pairwise_tree_135(features);
    score := score + visible_pairwise_tree_136(features);
    score := score + visible_pairwise_tree_137(features);
    score := score + visible_pairwise_tree_138(features);
    score := score + visible_pairwise_tree_139(features);
    score := score + visible_pairwise_tree_140(features);
    score := score + visible_pairwise_tree_141(features);
    score := score + visible_pairwise_tree_142(features);
    score := score + visible_pairwise_tree_143(features);
    score := score + visible_pairwise_tree_144(features);
    score := score + visible_pairwise_tree_145(features);
    score := score + visible_pairwise_tree_146(features);
    score := score + visible_pairwise_tree_147(features);
    score := score + visible_pairwise_tree_148(features);
    score := score + visible_pairwise_tree_149(features);
    score := score + visible_pairwise_tree_150(features);
    score := score + visible_pairwise_tree_151(features);
    score := score + visible_pairwise_tree_152(features);
    score := score + visible_pairwise_tree_153(features);
    score := score + visible_pairwise_tree_154(features);
    score := score + visible_pairwise_tree_155(features);
    score := score + visible_pairwise_tree_156(features);
    score := score + visible_pairwise_tree_157(features);
    score := score + visible_pairwise_tree_158(features);
    score := score + visible_pairwise_tree_159(features);
    score := score + visible_pairwise_tree_160(features);
    score := score + visible_pairwise_tree_161(features);
    score := score + visible_pairwise_tree_162(features);
    score := score + visible_pairwise_tree_163(features);
    score := score + visible_pairwise_tree_164(features);
    score := score + visible_pairwise_tree_165(features);
    score := score + visible_pairwise_tree_166(features);
    score := score + visible_pairwise_tree_167(features);
    score := score + visible_pairwise_tree_168(features);
    score := score + visible_pairwise_tree_169(features);
    score := score + visible_pairwise_tree_170(features);
    score := score + visible_pairwise_tree_171(features);
    score := score + visible_pairwise_tree_172(features);
    score := score + visible_pairwise_tree_173(features);
    score := score + visible_pairwise_tree_174(features);
    score := score + visible_pairwise_tree_175(features);
    score := score + visible_pairwise_tree_176(features);
    score := score + visible_pairwise_tree_177(features);
    score := score + visible_pairwise_tree_178(features);
    score := score + visible_pairwise_tree_179(features);
    score := score + visible_pairwise_tree_180(features);
    score := score + visible_pairwise_tree_181(features);
    score := score + visible_pairwise_tree_182(features);
    score := score + visible_pairwise_tree_183(features);
    score := score + visible_pairwise_tree_184(features);
    score := score + visible_pairwise_tree_185(features);
    score := score + visible_pairwise_tree_186(features);
    score := score + visible_pairwise_tree_187(features);
    score := score + visible_pairwise_tree_188(features);
    score := score + visible_pairwise_tree_189(features);
    score := score + visible_pairwise_tree_190(features);
    score := score + visible_pairwise_tree_191(features);
    Result := Trunc(score * c_long_visible_pairwise_residual_score_scale);
end;

function long_visible_pairwise_residual_self_test: Boolean;
var
    features: TncLongVisiblePairwiseResidualFeatures;
begin
    FillChar(features, SizeOf(features), 0);
    if long_visible_pairwise_residual_score(features) <>
        c_long_visible_pairwise_residual_reference_score then Exit(False);
    features.candidate_candidate_score := -1000000;
    features.candidate_dict_weight := -1000000;
    features.candidate_has_dict_weight := -1000000;
    features.candidate_source_user := -1000000;
    features.candidate_source_chain := -1000000;
    features.candidate_source_pattern := -1000000;
    features.candidate_source_redup := -1000000;
    features.candidate_source_local_rerank := -1000000;
    features.candidate_source_rule_fallback := -1000000;
    features.candidate_legacy_rank := -1000000;
    features.candidate_legacy_top := -1000000;
    features.candidate_chain_rank := -1000000;
    features.candidate_chain_present := -1000000;
    features.candidate_chain_first_stage_score := -1000000;
    features.candidate_chain_second_stage_score := -1000000;
    features.candidate_chain_score_gap := -1000000;
    features.candidate_complete_match := -1000000;
    features.candidate_partial_match := -1000000;
    features.candidate_text_units := -1000000;
    features.candidate_comment_length := -1000000;
    features.candidate_unit_delta := -1000000;
    features.candidate_path_available := -1000000;
    features.candidate_path_confidence_score := -1000000;
    features.candidate_path_confidence_tier := -1000000;
    features.candidate_path_segments := -1000000;
    features.candidate_path_single_segments := -1000000;
    features.candidate_path_max_segment_units := -1000000;
    features.candidate_char_lm_score := -1000000;
    features.candidate_char_lm_suffix_score := -1000000;
    features.candidate_char_lm_context_score := -1000000;
    features.candidate_char_lm_context_gain := -1000000;
    features.candidate_has_left_context := -1000000;
    features.candidate_query_choice_bonus := -1000000;
    features.candidate_latest_query_choice := -1000000;
    features.candidate_query_path_bonus := -1000000;
    features.candidate_query_path_penalty := -1000000;
    features.candidate_input_syllable_count := -1000000;
    features.candidate_score_per_unit := -1000000;
    features.candidate_dict_weight_per_unit := -1000000;
    features.candidate_complete_user := -1000000;
    features.candidate_complete_dictionary := -1000000;
    features.candidate_complete_chain := -1000000;
    features.delta_candidate_score := -1000000;
    features.delta_dict_weight := -1000000;
    features.delta_has_dict_weight := -1000000;
    features.delta_source_user := -1000000;
    features.delta_source_chain := -1000000;
    features.delta_source_pattern := -1000000;
    features.delta_source_redup := -1000000;
    features.delta_source_local_rerank := -1000000;
    features.delta_source_rule_fallback := -1000000;
    features.delta_legacy_rank := -1000000;
    features.delta_legacy_top := -1000000;
    features.delta_chain_rank := -1000000;
    features.delta_chain_present := -1000000;
    features.delta_chain_first_stage_score := -1000000;
    features.delta_chain_second_stage_score := -1000000;
    features.delta_chain_score_gap := -1000000;
    features.delta_complete_match := -1000000;
    features.delta_partial_match := -1000000;
    features.delta_text_units := -1000000;
    features.delta_comment_length := -1000000;
    features.delta_unit_delta := -1000000;
    features.delta_path_available := -1000000;
    features.delta_path_confidence_score := -1000000;
    features.delta_path_confidence_tier := -1000000;
    features.delta_path_segments := -1000000;
    features.delta_path_single_segments := -1000000;
    features.delta_path_max_segment_units := -1000000;
    features.delta_char_lm_score := -1000000;
    features.delta_char_lm_suffix_score := -1000000;
    features.delta_char_lm_context_score := -1000000;
    features.delta_char_lm_context_gain := -1000000;
    features.delta_has_left_context := -1000000;
    features.delta_query_choice_bonus := -1000000;
    features.delta_latest_query_choice := -1000000;
    features.delta_query_path_bonus := -1000000;
    features.delta_query_path_penalty := -1000000;
    features.delta_input_syllable_count := -1000000;
    features.delta_score_per_unit := -1000000;
    features.delta_dict_weight_per_unit := -1000000;
    features.delta_complete_user := -1000000;
    features.delta_complete_dictionary := -1000000;
    features.delta_complete_chain := -1000000;
    features.candidate_current_rank := -1000000;
    features.candidate_ranker_score := -1000000;
    features.candidate_ranker_score_gap := -1000000;
    features.baseline_ranker_applied := -1000000;
    features.baseline_abstain_score := -1000000;
    if long_visible_pairwise_residual_score(features) <>
        c_long_visible_pairwise_residual_reference_score_low then Exit(False);
    features.candidate_candidate_score := 1000000;
    features.candidate_dict_weight := 1000000;
    features.candidate_has_dict_weight := 1000000;
    features.candidate_source_user := 1000000;
    features.candidate_source_chain := 1000000;
    features.candidate_source_pattern := 1000000;
    features.candidate_source_redup := 1000000;
    features.candidate_source_local_rerank := 1000000;
    features.candidate_source_rule_fallback := 1000000;
    features.candidate_legacy_rank := 1000000;
    features.candidate_legacy_top := 1000000;
    features.candidate_chain_rank := 1000000;
    features.candidate_chain_present := 1000000;
    features.candidate_chain_first_stage_score := 1000000;
    features.candidate_chain_second_stage_score := 1000000;
    features.candidate_chain_score_gap := 1000000;
    features.candidate_complete_match := 1000000;
    features.candidate_partial_match := 1000000;
    features.candidate_text_units := 1000000;
    features.candidate_comment_length := 1000000;
    features.candidate_unit_delta := 1000000;
    features.candidate_path_available := 1000000;
    features.candidate_path_confidence_score := 1000000;
    features.candidate_path_confidence_tier := 1000000;
    features.candidate_path_segments := 1000000;
    features.candidate_path_single_segments := 1000000;
    features.candidate_path_max_segment_units := 1000000;
    features.candidate_char_lm_score := 1000000;
    features.candidate_char_lm_suffix_score := 1000000;
    features.candidate_char_lm_context_score := 1000000;
    features.candidate_char_lm_context_gain := 1000000;
    features.candidate_has_left_context := 1000000;
    features.candidate_query_choice_bonus := 1000000;
    features.candidate_latest_query_choice := 1000000;
    features.candidate_query_path_bonus := 1000000;
    features.candidate_query_path_penalty := 1000000;
    features.candidate_input_syllable_count := 1000000;
    features.candidate_score_per_unit := 1000000;
    features.candidate_dict_weight_per_unit := 1000000;
    features.candidate_complete_user := 1000000;
    features.candidate_complete_dictionary := 1000000;
    features.candidate_complete_chain := 1000000;
    features.delta_candidate_score := 1000000;
    features.delta_dict_weight := 1000000;
    features.delta_has_dict_weight := 1000000;
    features.delta_source_user := 1000000;
    features.delta_source_chain := 1000000;
    features.delta_source_pattern := 1000000;
    features.delta_source_redup := 1000000;
    features.delta_source_local_rerank := 1000000;
    features.delta_source_rule_fallback := 1000000;
    features.delta_legacy_rank := 1000000;
    features.delta_legacy_top := 1000000;
    features.delta_chain_rank := 1000000;
    features.delta_chain_present := 1000000;
    features.delta_chain_first_stage_score := 1000000;
    features.delta_chain_second_stage_score := 1000000;
    features.delta_chain_score_gap := 1000000;
    features.delta_complete_match := 1000000;
    features.delta_partial_match := 1000000;
    features.delta_text_units := 1000000;
    features.delta_comment_length := 1000000;
    features.delta_unit_delta := 1000000;
    features.delta_path_available := 1000000;
    features.delta_path_confidence_score := 1000000;
    features.delta_path_confidence_tier := 1000000;
    features.delta_path_segments := 1000000;
    features.delta_path_single_segments := 1000000;
    features.delta_path_max_segment_units := 1000000;
    features.delta_char_lm_score := 1000000;
    features.delta_char_lm_suffix_score := 1000000;
    features.delta_char_lm_context_score := 1000000;
    features.delta_char_lm_context_gain := 1000000;
    features.delta_has_left_context := 1000000;
    features.delta_query_choice_bonus := 1000000;
    features.delta_latest_query_choice := 1000000;
    features.delta_query_path_bonus := 1000000;
    features.delta_query_path_penalty := 1000000;
    features.delta_input_syllable_count := 1000000;
    features.delta_score_per_unit := 1000000;
    features.delta_dict_weight_per_unit := 1000000;
    features.delta_complete_user := 1000000;
    features.delta_complete_dictionary := 1000000;
    features.delta_complete_chain := 1000000;
    features.candidate_current_rank := 1000000;
    features.candidate_ranker_score := 1000000;
    features.candidate_ranker_score_gap := 1000000;
    features.baseline_ranker_applied := 1000000;
    features.baseline_abstain_score := 1000000;
    if long_visible_pairwise_residual_score(features) <>
        c_long_visible_pairwise_residual_reference_score_high then Exit(False);
    features.candidate_candidate_score := 137;
    features.candidate_dict_weight := -274;
    features.candidate_has_dict_weight := 411;
    features.candidate_source_user := -548;
    features.candidate_source_chain := 685;
    features.candidate_source_pattern := -822;
    features.candidate_source_redup := 959;
    features.candidate_source_local_rerank := -1096;
    features.candidate_source_rule_fallback := 1233;
    features.candidate_legacy_rank := -1370;
    features.candidate_legacy_top := 1507;
    features.candidate_chain_rank := -1644;
    features.candidate_chain_present := 1781;
    features.candidate_chain_first_stage_score := -1918;
    features.candidate_chain_second_stage_score := 2055;
    features.candidate_chain_score_gap := -2192;
    features.candidate_complete_match := 2329;
    features.candidate_partial_match := -2466;
    features.candidate_text_units := 2603;
    features.candidate_comment_length := -2740;
    features.candidate_unit_delta := 2877;
    features.candidate_path_available := -3014;
    features.candidate_path_confidence_score := 3151;
    features.candidate_path_confidence_tier := -3288;
    features.candidate_path_segments := 3425;
    features.candidate_path_single_segments := -3562;
    features.candidate_path_max_segment_units := 3699;
    features.candidate_char_lm_score := -3836;
    features.candidate_char_lm_suffix_score := 3973;
    features.candidate_char_lm_context_score := -4110;
    features.candidate_char_lm_context_gain := 4247;
    features.candidate_has_left_context := -4384;
    features.candidate_query_choice_bonus := 4521;
    features.candidate_latest_query_choice := -4658;
    features.candidate_query_path_bonus := 4795;
    features.candidate_query_path_penalty := -4932;
    features.candidate_input_syllable_count := 5069;
    features.candidate_score_per_unit := -5206;
    features.candidate_dict_weight_per_unit := 5343;
    features.candidate_complete_user := -5480;
    features.candidate_complete_dictionary := 5617;
    features.candidate_complete_chain := -5754;
    features.delta_candidate_score := 5891;
    features.delta_dict_weight := -6028;
    features.delta_has_dict_weight := 6165;
    features.delta_source_user := -6302;
    features.delta_source_chain := 6439;
    features.delta_source_pattern := -6576;
    features.delta_source_redup := 6713;
    features.delta_source_local_rerank := -6850;
    features.delta_source_rule_fallback := 6987;
    features.delta_legacy_rank := -7124;
    features.delta_legacy_top := 7261;
    features.delta_chain_rank := -7398;
    features.delta_chain_present := 7535;
    features.delta_chain_first_stage_score := -7672;
    features.delta_chain_second_stage_score := 7809;
    features.delta_chain_score_gap := -7946;
    features.delta_complete_match := 8083;
    features.delta_partial_match := -8220;
    features.delta_text_units := 8357;
    features.delta_comment_length := -8494;
    features.delta_unit_delta := 8631;
    features.delta_path_available := -8768;
    features.delta_path_confidence_score := 8905;
    features.delta_path_confidence_tier := -9042;
    features.delta_path_segments := 9179;
    features.delta_path_single_segments := -9316;
    features.delta_path_max_segment_units := 9453;
    features.delta_char_lm_score := -9590;
    features.delta_char_lm_suffix_score := 9727;
    features.delta_char_lm_context_score := -9864;
    features.delta_char_lm_context_gain := 10001;
    features.delta_has_left_context := -10138;
    features.delta_query_choice_bonus := 10275;
    features.delta_latest_query_choice := -10412;
    features.delta_query_path_bonus := 10549;
    features.delta_query_path_penalty := -10686;
    features.delta_input_syllable_count := 10823;
    features.delta_score_per_unit := -10960;
    features.delta_dict_weight_per_unit := 11097;
    features.delta_complete_user := -11234;
    features.delta_complete_dictionary := 11371;
    features.delta_complete_chain := -11508;
    features.candidate_current_rank := 11645;
    features.candidate_ranker_score := -11782;
    features.candidate_ranker_score_gap := 11919;
    features.baseline_ranker_applied := -12056;
    features.baseline_abstain_score := 12193;
    Result := long_visible_pairwise_residual_score(features) =
        c_long_visible_pairwise_residual_reference_score_mixed;
end;

end.
