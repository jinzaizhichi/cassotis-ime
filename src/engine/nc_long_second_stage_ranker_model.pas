unit nc_long_second_stage_ranker_model;

interface

const
    c_long_second_stage_ranker_rank1_min_char_lm_gain: Integer = 1;
    c_long_second_stage_ranker_rank1_threshold: Int64 = 2301443;
    c_long_second_stage_ranker_rank3_threshold: Int64 = High(Int64);
    c_long_second_stage_ranker_rank5_threshold: Int64 = 2259002;

function long_second_stage_ranker_score(const first_stage_score: Integer;
    const char_lm_score: Integer; const word_lm_bonus: Integer;
    const base_score: Integer; const segments: Integer;
    const single_segments: Integer; const max_segment_units: Integer;
    const anchor_units: Integer; const has_anchor: Boolean): Int64;

implementation

function long_second_stage_ranker_score(const first_stage_score: Integer;
    const char_lm_score: Integer; const word_lm_bonus: Integer;
    const base_score: Integer; const segments: Integer;
    const single_segments: Integer; const max_segment_units: Integer;
    const anchor_units: Integer; const has_anchor: Boolean): Int64;
begin
    { Pairwise quality model trained on independent novel, chat, and formal
      long-sentence candidates. Calibrated rank gates only promote an expanded
      search state when it clears every observed regression margin.
      Model report SHA-256:
      A95AEDE5644D32388E8F68D824EB6BBCFD0EE74CB24BF77828035821A7DCDC58 }
    Result := Int64(first_stage_score) * 4
        + Int64(char_lm_score) * 2447
        + Int64(word_lm_bonus) * 2166
        + Int64(base_score) * 3
        - Int64(segments) * 740852
        - Int64(single_segments) * 314489
        + Int64(max_segment_units) * 634918
        - Int64(anchor_units) * 33042
        + Int64(Ord(has_anchor)) * 0;
end;

end.
