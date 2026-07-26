unit nc_long_final_ranker_model;

interface

type
    TncLongFinalRankerFeatures = record
        candidate_score: Integer;
        dict_weight: Integer;
        has_dict_weight: Boolean;
        source_user: Boolean;
        source_chain: Boolean;
        source_pattern: Boolean;
        source_redup: Boolean;
        source_local_rerank: Boolean;
        source_rule_fallback: Boolean;
        legacy_rank: Integer;
        legacy_top: Boolean;
        chain_rank: Integer;
        chain_present: Boolean;
        chain_first_stage_score: Integer;
        chain_second_stage_score: Int64;
        chain_score_gap: Int64;
        complete_match: Boolean;
        partial_match: Boolean;
        text_units: Integer;
        comment_length: Integer;
        unit_delta: Integer;
        path_available: Boolean;
        path_confidence_score: Integer;
        path_confidence_tier: Integer;
        path_segments: Integer;
        path_single_segments: Integer;
        path_max_segment_units: Integer;
        char_lm_score: Integer;
        char_lm_suffix_score: Integer;
        char_lm_context_score: Integer;
        char_lm_context_gain: Integer;
        has_left_context: Boolean;
        query_choice_bonus: Integer;
        latest_query_choice: Boolean;
        query_path_bonus: Integer;
        query_path_penalty: Integer;
        input_syllable_count: Integer;
        score_per_unit: Integer;
        dict_weight_per_unit: Integer;
        complete_user: Boolean;
        complete_dictionary: Boolean;
        complete_chain: Boolean;
    end;

const
    c_long_final_ranker_default_profile: Integer = 2;
    c_long_final_ranker_feature_count: Integer = 42;
    c_long_final_ranker_tree_count: Integer = 96;
    c_long_final_ranker_score_scale: Double = 100000000.0;
    c_long_final_ranker_reference_score: Int64 = -52489312;
    c_long_final_ranker_reference_score_low: Int64 = -74891041;
    c_long_final_ranker_reference_score_high: Int64 = 72546004;
    c_long_final_ranker_reference_score_mixed: Int64 = -94350371;

function long_final_ranker_score(
    const features: TncLongFinalRankerFeatures): Int64;
function long_final_ranker_self_test: Boolean;

implementation

{ Final visible-candidate LightGBM LambdaRank model. The generated unit has no LightGBM runtime dependency.
  Training report SHA-256: 7C4E05C8840E391C5F0FFD3BBD9A3A97FB7857FB500D93B5E505169923DF0639
  LightGBM model SHA-256: DE0072945ACE1E5DE66BF0543C19DDC70E7727DF0E12422489A7C763428383F9 }

function long_final_ranker_tree_0(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        Result := 0.068367310882239157;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.069980695144267524;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                    begin
                        if features.candidate_score <= 169507.50000000003 then
                        begin
                            if features.path_max_segment_units <= 13.500000000000002 then
                            begin
                                Result := -0.052403842341312186;
                            end
                            else
                            begin
                                Result := -0.012522799164438181;
                            end;
                        end
                        else
                        begin
                            Result := -0.024756006087350724;
                        end;
                    end
                    else
                    begin
                        Result := 0.014423755919493769;
                    end;
                end
                else
                begin
                    Result := -0.064073576389973394;
                end;
            end;
        end
        else
        begin
            if features.legacy_rank <= 2.5000000000000004 then
            begin
                if features.chain_score_gap <= -59742350.999999993 then
                begin
                    if features.chain_second_stage_score <= -64024275.499999993 then
                    begin
                        if features.score_per_unit <= 10722.500000000002 then
                        begin
                            Result := -0.034392010115421492;
                        end
                        else
                        begin
                            Result := 0.027569303034345273;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -83244892.999999985 then
                        begin
                            Result := -0.055369249099191595;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 9825698.5000000019 then
                            begin
                                if features.char_lm_suffix_score <= -5794.4999999999991 then
                                begin
                                    Result := -0.032301291792385292;
                                end
                                else
                                begin
                                    Result := 0.01635356186702382;
                                end;
                            end
                            else
                            begin
                                if features.text_units <= 7.5000000000000009 then
                                begin
                                    Result := 0.010202393624717532;
                                end
                                else
                                begin
                                    Result := -0.058281906936155696;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                    begin
                        if features.path_single_segments <= 1.5000000000000002 then
                        begin
                            if features.char_lm_context_score <= -6208.4999999999991 then
                            begin
                                Result := 0.010243431680334598;
                            end
                            else
                            begin
                                Result := -0.03184017037175086;
                            end;
                        end
                        else
                        begin
                            if features.score_per_unit <= 7397.0000000000009 then
                            begin
                                Result := 0.0014007025035320921;
                            end
                            else
                            begin
                                Result := -0.043616021005350093;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -20341703.499999996 then
                        begin
                            if features.chain_second_stage_score <= 97834285.500000015 then
                            begin
                                if features.chain_score_gap <= -35118691.999999993 then
                                begin
                                    if features.chain_second_stage_score <= 57463472.000000007 then
                                    begin
                                        if features.char_lm_suffix_score <= -6231.4999999999991 then
                                        begin
                                            if features.score_per_unit <= 10000.500000000002 then
                                            begin
                                                Result := -0.032663138705801058;
                                            end
                                            else
                                            begin
                                                if features.chain_second_stage_score <= -45677944.999999993 then
                                                begin
                                                    Result := 0.034060151938145225;
                                                end
                                                else
                                                begin
                                                    Result := -0.010338921813000461;
                                                end;
                                            end;
                                        end
                                        else
                                        begin
                                            if features.char_lm_context_gain <= -656.49999999999989 then
                                            begin
                                                if features.char_lm_context_gain <= -863.49999999999989 then
                                                begin
                                                    Result := 0.023909369047906026;
                                                end
                                                else
                                                begin
                                                    Result := -0.035695634690594051;
                                                end;
                                            end
                                            else
                                            begin
                                                Result := 0.030127324629632198;
                                            end;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.022903064111608286;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.02307016229441005;
                                end;
                            end
                            else
                            begin
                                Result := -0.02272849353293644;
                            end;
                        end
                        else
                        begin
                            if features.path_single_segments <= 3.5000000000000004 then
                            begin
                                Result := 0.037677301132578049;
                            end
                            else
                            begin
                                Result := 0.013917485228744217;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.chain_first_stage_score <= 180036.00000000003 then
                begin
                    Result := -0.049925705643514479;
                end
                else
                begin
                    Result := -0.016272248031723498;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_1(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_rank <= 1.5000000000000002 then
        begin
            Result := 0.063119942191238454;
        end
        else
        begin
            Result := 0.050311747208555906;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.065598989597549701;
            end
            else
            begin
                if features.char_lm_score <= -4513.4999999999991 then
                begin
                    if features.chain_first_stage_score <= 27672.000000000004 then
                    begin
                        if features.char_lm_context_score <= -10322.499999999998 then
                        begin
                            if features.candidate_score <= 163815.50000000003 then
                            begin
                                Result := -0.056457914269120328;
                            end
                            else
                            begin
                                Result := 0.046536298363281291;
                            end;
                        end
                        else
                        begin
                            Result := -0.053726544122942317;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -53550508.499999993 then
                        begin
                            Result := -0.021301479484804701;
                        end
                        else
                        begin
                            Result := 0.042279102707405536;
                        end;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 156322.00000000003 then
                    begin
                        Result := -0.034566897219631992;
                    end
                    else
                    begin
                        Result := 0.0057791251746545811;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -48874815.499999993 then
            begin
                if features.chain_second_stage_score <= -6376268.4999999991 then
                begin
                    if features.char_lm_score <= -5118.4999999999991 then
                    begin
                        if features.chain_second_stage_score <= -64024275.499999993 then
                        begin
                            if features.chain_score_gap <= -89371168.999999985 then
                            begin
                                Result := -0.031055468235058153;
                            end
                            else
                            begin
                                if features.char_lm_context_score <= -8509.4999999999982 then
                                begin
                                    Result := -0.028387923047499243;
                                end
                                else
                                begin
                                    Result := 0.03049943444413122;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := -0.038192343716708252;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -90788920.499999985 then
                        begin
                            if features.score_per_unit <= 10722.500000000002 then
                            begin
                                Result := -0.058211280734880695;
                            end
                            else
                            begin
                                Result := 0.02093968852819408;
                            end;
                        end
                        else
                        begin
                            Result := 0.030667149625590865;
                        end;
                    end;
                end
                else
                begin
                    if features.path_single_segments <= 1.5000000000000002 then
                    begin
                        Result := -0.014642927928726459;
                    end
                    else
                    begin
                        Result := -0.050845078495071548;
                    end;
                end;
            end
            else
            begin
                if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                begin
                    if features.path_segments <= 2.5000000000000004 then
                    begin
                        Result := 0.035196617057523284;
                    end
                    else
                    begin
                        if features.legacy_rank <= 2.5000000000000004 then
                        begin
                            Result := -0.017163133212133391;
                        end
                        else
                        begin
                            Result := -0.053242815896601986;
                        end;
                    end;
                end
                else
                begin
                    if features.score_per_unit <= 11286.500000000002 then
                    begin
                        if features.chain_score_gap <= -29121231.999999996 then
                        begin
                            if features.path_segments <= 5.5000000000000009 then
                            begin
                                Result := 0.015595303907105038;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -55362432.999999993 then
                                begin
                                    Result := 0.016482773714155453;
                                end
                                else
                                begin
                                    Result := -0.02705992299736969;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -3655.4999999999995 then
                            begin
                                if features.char_lm_score <= -4096.4999999999991 then
                                begin
                                    if features.char_lm_context_gain <= -314.49999999999994 then
                                    begin
                                        if features.dict_weight <= 120968.00000000001 then
                                        begin
                                            Result := 0.011142494060002811;
                                        end
                                        else
                                        begin
                                            Result := -0.0044731829425373277;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.058974746898787379;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.028787592323538901;
                                end;
                            end
                            else
                            begin
                                Result := -0.024008066772547829;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.017198240514868041;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_2(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_rank <= 1.5000000000000002 then
        begin
            Result := 0.05994146771937077;
        end
        else
        begin
            Result := 0.048678297020317778;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.062038683657367241;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if features.char_lm_context_score <= -6626.4999999999991 then
                    begin
                        Result := -0.033084293447094931;
                    end
                    else
                    begin
                        if features.candidate_score <= 102582.50000000001 then
                        begin
                            Result := -0.05608218919855168;
                        end
                        else
                        begin
                            Result := 0.0061734693992780455;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -11066.499999999998 then
                    begin
                        Result := 0.040151466762684371;
                    end
                    else
                    begin
                        if features.score_per_unit <= 35838.000000000007 then
                        begin
                            if features.chain_first_stage_score <= 131999.00000000003 then
                            begin
                                Result := -0.057588623698280307;
                            end
                            else
                            begin
                                Result := -0.0042075233202780761;
                            end;
                        end
                        else
                        begin
                            Result := 0.013557201674136286;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.legacy_rank <= 2.5000000000000004 then
            begin
                if features.chain_first_stage_score <= 87237.000000000015 then
                begin
                    if features.path_single_segments <= 3.5000000000000004 then
                    begin
                        if features.chain_second_stage_score <= 9825698.5000000019 then
                        begin
                            if features.dict_weight_per_unit <= 5237.0000000000009 then
                            begin
                                if features.path_single_segments <= 2.5000000000000004 then
                                begin
                                    if features.char_lm_context_gain <= -1649.4999999999998 then
                                    begin
                                        Result := -0.033648391199326742;
                                    end
                                    else
                                    begin
                                        Result := 0.01957467801384781;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.015702738528575989;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_context_score <= -6049.4999999999991 then
                                begin
                                    if features.path_single_segments <= 1.0000000180025095E-35 then
                                    begin
                                        Result := -0.0029875744733508089;
                                    end
                                    else
                                    begin
                                        if features.char_lm_suffix_score <= -7057.4999999999991 then
                                        begin
                                            if features.score_per_unit <= 9317.5000000000018 then
                                            begin
                                                Result := -0.0067737082857321088;
                                            end
                                            else
                                            begin
                                                Result := -0.050057851259698936;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := -0.013582381781806277;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.058318491419128093;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.011682410488510767;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -7165.4999999999991 then
                        begin
                            Result := -0.00067428300223517919;
                        end
                        else
                        begin
                            Result := -0.049175974778930043;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_rank <= 1.5000000000000002 then
                    begin
                        if features.chain_first_stage_score <= 133056.50000000003 then
                        begin
                            Result := 0.027480298958493448;
                        end
                        else
                        begin
                            if features.chain_first_stage_score <= 141429.00000000003 then
                            begin
                                Result := -0.034263104598818865;
                            end
                            else
                            begin
                                Result := 0.0090483881198883502;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.candidate_score <= 154940.50000000003 then
                        begin
                            if features.path_single_segments <= 3.5000000000000004 then
                            begin
                                Result := -0.0039478807439336239;
                            end
                            else
                            begin
                                if features.text_units <= 18.500000000000004 then
                                begin
                                    Result := -0.039728136361631715;
                                end
                                else
                                begin
                                    Result := 0.015132887394447439;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.text_units <= 13.500000000000002 then
                            begin
                                Result := 0.035511487779713559;
                            end
                            else
                            begin
                                if features.score_per_unit <= 12356.500000000002 then
                                begin
                                    Result := 0.0083633229633222391;
                                end
                                else
                                begin
                                    Result := -0.020258276251154995;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := -0.031912591893302367;
            end;
        end;
    end;
end;

function long_final_ranker_tree_3(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_rank <= 1.5000000000000002 then
        begin
            Result := 0.057057807955001531;
        end
        else
        begin
            Result := 0.046353497975366295;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.05905550987111724;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                    begin
                        Result := -0.032605848962808485;
                    end
                    else
                    begin
                        Result := 0.0043771701963310405;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -9852.4999999999982 then
                    begin
                        if features.candidate_score <= 172944.00000000003 then
                        begin
                            Result := -0.025834170967069733;
                        end
                        else
                        begin
                            Result := 0.044076378280256491;
                        end;
                    end
                    else
                    begin
                        Result := -0.052368849007529326;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -52040049.499999993 then
            begin
                if features.chain_second_stage_score <= -32334096.999999996 then
                begin
                    if features.char_lm_score <= -5118.4999999999991 then
                    begin
                        if features.chain_second_stage_score <= -64024275.499999993 then
                        begin
                            if features.dict_weight_per_unit <= 10636.500000000002 then
                            begin
                                Result := -0.024432278196536615;
                            end
                            else
                            begin
                                Result := 0.016883181385102784;
                            end;
                        end
                        else
                        begin
                            Result := -0.03606440122150531;
                        end;
                    end
                    else
                    begin
                        Result := 0.0099164418745359192;
                    end;
                end
                else
                begin
                    Result := -0.038095133797533792;
                end;
            end
            else
            begin
                if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                begin
                    if features.legacy_rank <= 2.5000000000000004 then
                    begin
                        if features.candidate_score <= 48495.500000000007 then
                        begin
                            Result := 0.0048619006498969077;
                        end
                        else
                        begin
                            Result := -0.016281397955129919;
                        end;
                    end
                    else
                    begin
                        if features.path_single_segments <= 4.5000000000000009 then
                        begin
                            Result := -0.051829512740136807;
                        end
                        else
                        begin
                            Result := 0.021316071117162091;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -35118691.999999993 then
                    begin
                        if features.score_per_unit <= 10476.500000000002 then
                        begin
                            if features.chain_score_gap <= -39298151.499999993 then
                            begin
                                Result := -0.011371301537879673;
                            end
                            else
                            begin
                                Result := -0.049805481346391095;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 14389599.500000002 then
                            begin
                                Result := 0.016328136139141584;
                            end
                            else
                            begin
                                if features.char_lm_score <= -4610.4999999999991 then
                                begin
                                    Result := -0.053906753234205178;
                                end
                                else
                                begin
                                    Result := -0.00099078405616217363;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.legacy_rank <= 2.5000000000000004 then
                        begin
                            if features.chain_second_stage_score <= -55362432.999999993 then
                            begin
                                Result := 0.035344205825106549;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -10732023.999999998 then
                                begin
                                    if features.chain_second_stage_score <= 100857689.50000001 then
                                    begin
                                        if features.char_lm_score <= -4263.4999999999991 then
                                        begin
                                            Result := 0.0003781864575310478;
                                        end
                                        else
                                        begin
                                            Result := 0.024495768287814506;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.026456419032160138;
                                    end;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= -12721871.999999998 then
                                    begin
                                        Result := -0.0031272567377414674;
                                    end
                                    else
                                    begin
                                        Result := 0.020117999706641229;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.score_per_unit <= 11771.500000000002 then
                            begin
                                if features.chain_score_gap <= -18208077.499999996 then
                                begin
                                    Result := 0.0083485866287715347;
                                end
                                else
                                begin
                                    Result := -0.048118624960182238;
                                end;
                            end
                            else
                            begin
                                Result := 0.024505891974410752;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_4(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.legacy_top) <= 1.0000000180025095E-35 then
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if features.path_max_segment_units <= 5.5000000000000009 then
            begin
                Result := -0.056528683037308416;
            end
            else
            begin
                if features.char_lm_score <= -4513.4999999999991 then
                begin
                    if features.chain_first_stage_score <= 77616.500000000015 then
                    begin
                        if features.char_lm_context_score <= -9852.4999999999982 then
                        begin
                            if features.candidate_score <= 163815.50000000003 then
                            begin
                                Result := -0.036472687922457961;
                            end
                            else
                            begin
                                Result := 0.023975421531925757;
                            end;
                        end
                        else
                        begin
                            Result := -0.046319721672266473;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -53550508.499999993 then
                        begin
                            Result := -0.023353263198774787;
                        end
                        else
                        begin
                            Result := 0.042522141601393781;
                        end;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 206260.00000000003 then
                    begin
                        Result := -0.021888261606917734;
                    end
                    else
                    begin
                        Result := 0.014659770701441246;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -59742350.999999993 then
            begin
                if features.chain_second_stage_score <= -6376268.4999999991 then
                begin
                    if features.char_lm_score <= -5016.4999999999991 then
                    begin
                        if features.score_per_unit <= 10609.500000000002 then
                        begin
                            Result := -0.040550394637710964;
                        end
                        else
                        begin
                            Result := -0.011166600256453819;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -89371168.999999985 then
                        begin
                            Result := -0.02458891499042902;
                        end
                        else
                        begin
                            Result := 0.026943594099561732;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.044060137929195234;
                end;
            end
            else
            begin
                if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                begin
                    if features.path_single_segments <= 1.5000000000000002 then
                    begin
                        if features.candidate_score <= 48495.500000000007 then
                        begin
                            Result := 0.015874384775649088;
                        end
                        else
                        begin
                            Result := -0.012015465459006058;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -9082.4999999999982 then
                        begin
                            Result := -0.055673803363113797;
                        end
                        else
                        begin
                            if features.candidate_score <= 104352.50000000001 then
                            begin
                                Result := -0.0078728103873067432;
                            end
                            else
                            begin
                                Result := -0.032575014247286059;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -35118691.999999993 then
                    begin
                        if features.chain_second_stage_score <= 59813173.500000007 then
                        begin
                            if features.char_lm_context_gain <= -1160.4999999999998 then
                            begin
                                Result := -0.035761635153835548;
                            end
                            else
                            begin
                                if features.char_lm_score <= -6634.4999999999991 then
                                begin
                                    Result := 0.028901796248371397;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -5438.4999999999991 then
                                    begin
                                        if features.dict_weight_per_unit <= 10636.500000000002 then
                                        begin
                                            Result := -0.038267141816377609;
                                        end
                                        else
                                        begin
                                            Result := -0.0037103844905635518;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.010040780501011128;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := -0.029447017447084122;
                        end;
                    end
                    else
                    begin
                        if features.path_single_segments <= 3.5000000000000004 then
                        begin
                            if features.char_lm_score <= -3655.4999999999995 then
                            begin
                                if features.path_single_segments <= 1.5000000000000002 then
                                begin
                                    Result := 0.021371429193587491;
                                end
                                else
                                begin
                                    Result := 0.0090894821721929382;
                                end;
                            end
                            else
                            begin
                                Result := -0.0087578419495605731;
                            end;
                        end
                        else
                        begin
                            if features.candidate_score <= 110551.50000000001 then
                            begin
                                Result := -0.02842690198241183;
                            end
                            else
                            begin
                                Result := 0.0037769640669998036;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end
    else
    begin
        if features.chain_rank <= 1.5000000000000002 then
        begin
            Result := 0.054631277852045121;
        end
        else
        begin
            Result := 0.044795918213532224;
        end;
    end;
end;

function long_final_ranker_tree_5(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_score_gap <= -999794.49999999988 then
        begin
            Result := 0.043570448048505149;
        end
        else
        begin
            Result := 0.052427690308577565;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.054358510479580319;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                    begin
                        if features.char_lm_score <= -4513.4999999999991 then
                        begin
                            Result := -0.032858511928499638;
                        end
                        else
                        begin
                            Result := -0.0095525268208420666;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -122461489.49999999 then
                        begin
                            Result := -0.020560880330661911;
                        end
                        else
                        begin
                            Result := 0.028663053461544595;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_first_stage_score <= 27672.000000000004 then
                    begin
                        Result := -0.049133956832655298;
                    end
                    else
                    begin
                        Result := -0.015401888666215561;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -59742350.999999993 then
            begin
                if features.chain_score_gap <= -90788920.499999985 then
                begin
                    if features.dict_weight_per_unit <= 10636.500000000002 then
                    begin
                        Result := -0.054752216275414954;
                    end
                    else
                    begin
                        Result := -0.019101500640213109;
                    end;
                end
                else
                begin
                    if features.path_single_segments <= 2.5000000000000004 then
                    begin
                        if features.chain_first_stage_score <= 64858.500000000007 then
                        begin
                            Result := 0.018110053192000583;
                        end
                        else
                        begin
                            if features.char_lm_suffix_score <= -7165.4999999999991 then
                            begin
                                Result := 0.010613631202936361;
                            end
                            else
                            begin
                                Result := -0.030410154098652657;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := -0.034279605529388794;
                    end;
                end;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                    begin
                        if features.path_single_segments <= 1.5000000000000002 then
                        begin
                            if features.dict_weight <= 28679.000000000004 then
                            begin
                                Result := 0.048052458793840735;
                            end
                            else
                            begin
                                if features.char_lm_suffix_score <= -7562.4999999999991 then
                                begin
                                    Result := 0.016558556842908002;
                                end
                                else
                                begin
                                    if features.char_lm_suffix_score <= -6693.4999999999991 then
                                    begin
                                        Result := -0.036372607681064976;
                                    end
                                    else
                                    begin
                                        if features.char_lm_score <= -4465.4999999999991 then
                                        begin
                                            Result := 0.0099698751305842565;
                                        end
                                        else
                                        begin
                                            Result := -0.020060447200974919;
                                        end;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := -0.019738498182223049;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -10732023.999999998 then
                        begin
                            Result := 0.0010031928167626156;
                        end
                        else
                        begin
                            if features.path_segments <= 6.5000000000000009 then
                            begin
                                Result := 0.022722092739686089;
                            end
                            else
                            begin
                                Result := 0.010826137677494945;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_first_stage_score <= 55406.000000000007 then
                    begin
                        if features.path_single_segments <= 4.5000000000000009 then
                        begin
                            if features.path_segments <= 2.5000000000000004 then
                            begin
                                Result := 0.0174242889022913;
                            end
                            else
                            begin
                                Result := -0.049149206594588712;
                            end;
                        end
                        else
                        begin
                            Result := 0.015145240014360522;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_context_gain <= -1012.4999999999999 then
                        begin
                            Result := 0.013261993420651959;
                        end
                        else
                        begin
                            if features.chain_first_stage_score <= 253629.50000000003 then
                            begin
                                if features.dict_weight_per_unit <= 11734.500000000002 then
                                begin
                                    Result := -0.048588874247634528;
                                end
                                else
                                begin
                                    Result := -0.001893005409614057;
                                end;
                            end
                            else
                            begin
                                Result := 0.014837511470938387;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_6(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_rank <= 1.5000000000000002 then
        begin
            Result := 0.050662103906744541;
        end
        else
        begin
            Result := 0.041018120610733316;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.052489170550806284;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if features.char_lm_context_score <= -6626.4999999999991 then
                    begin
                        Result := -0.030548091604224063;
                    end
                    else
                    begin
                        if features.candidate_score <= 102582.50000000001 then
                        begin
                            Result := -0.045929227549766187;
                        end
                        else
                        begin
                            Result := 0.0073441047530286496;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -11066.499999999998 then
                    begin
                        Result := 0.03248811605964446;
                    end
                    else
                    begin
                        Result := -0.045240727670026577;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -59011123.499999993 then
            begin
                if features.chain_second_stage_score <= -27494981.499999996 then
                begin
                    if features.char_lm_suffix_score <= -5816.4999999999991 then
                    begin
                        if features.path_single_segments <= 2.5000000000000004 then
                        begin
                            if features.score_per_unit <= 1532.5000000000002 then
                            begin
                                Result := 0.034191622626492855;
                            end
                            else
                            begin
                                Result := -0.016427526202718989;
                            end;
                        end
                        else
                        begin
                            if features.path_segments <= 11.500000000000002 then
                            begin
                                Result := -0.052300785457867691;
                            end
                            else
                            begin
                                Result := 0.020366578193721716;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.012476839514527752;
                    end;
                end
                else
                begin
                    Result := -0.037338623450283923;
                end;
            end
            else
            begin
                if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                begin
                    if features.legacy_rank <= 2.5000000000000004 then
                    begin
                        if features.path_single_segments <= 1.5000000000000002 then
                        begin
                            if features.dict_weight <= 28679.000000000004 then
                            begin
                                Result := 0.042648988232144802;
                            end
                            else
                            begin
                                Result := -0.0047691723913338294;
                            end;
                        end
                        else
                        begin
                            if features.candidate_score <= 104352.50000000001 then
                            begin
                                if features.candidate_score <= 31004.500000000004 then
                                begin
                                    Result := -0.027655670357641916;
                                end
                                else
                                begin
                                    Result := 0.0018549916172633601;
                                end;
                            end
                            else
                            begin
                                Result := -0.033484763595003068;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.path_single_segments <= 4.5000000000000009 then
                        begin
                            if features.char_lm_context_gain <= -1887.4999999999998 then
                            begin
                                Result := -0.0052083718343127854;
                            end
                            else
                            begin
                                Result := -0.052847367622349692;
                            end;
                        end
                        else
                        begin
                            Result := 0.01450306243009169;
                        end;
                    end;
                end
                else
                begin
                    if features.legacy_rank <= 2.5000000000000004 then
                    begin
                        if features.chain_score_gap <= -9835736.4999999981 then
                        begin
                            if features.chain_second_stage_score <= -60934688.499999993 then
                            begin
                                Result := 0.023732765829023277;
                            end
                            else
                            begin
                                Result := -0.0018928840224603459;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 25555719.500000004 then
                            begin
                                if features.chain_second_stage_score <= -67962788.499999985 then
                                begin
                                    Result := 0.041985218139681646;
                                end
                                else
                                begin
                                    Result := 0.0068428527428600052;
                                end;
                            end
                            else
                            begin
                                Result := 0.021640966714792802;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.score_per_unit <= 11771.500000000002 then
                        begin
                            if features.char_lm_context_gain <= -946.49999999999989 then
                            begin
                                if features.chain_score_gap <= -20981126.499999996 then
                                begin
                                    Result := 0.025204326266178627;
                                end
                                else
                                begin
                                    Result := -0.039835378112169056;
                                end;
                            end
                            else
                            begin
                                Result := -0.044640072754450796;
                            end;
                        end
                        else
                        begin
                            Result := 0.010155197972001751;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_7(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_rank <= 1.5000000000000002 then
        begin
            Result := 0.048984788199495123;
        end
        else
        begin
            Result := 0.039702161409724442;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.050863757141927403;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if features.char_lm_score <= -4709.4999999999991 then
                    begin
                        if features.char_lm_context_gain <= -1247.4999999999998 then
                        begin
                            Result := -0.040992992025918371;
                        end
                        else
                        begin
                            if features.char_lm_score <= -5382.4999999999991 then
                            begin
                                Result := -0.00792202557805116;
                            end
                            else
                            begin
                                Result := -0.034707772025064768;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := -0.0045553495033377397;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -11066.499999999998 then
                    begin
                        Result := 0.034083545961683365;
                    end
                    else
                    begin
                        if features.score_per_unit <= 35838.000000000007 then
                        begin
                            Result := -0.045737067003210286;
                        end
                        else
                        begin
                            Result := 0.013043685280751404;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -59742350.999999993 then
            begin
                if features.chain_second_stage_score <= -23768986.499999996 then
                begin
                    if features.dict_weight_per_unit <= 10636.500000000002 then
                    begin
                        if features.chain_score_gap <= -90788920.499999985 then
                        begin
                            Result := -0.049531337900762924;
                        end
                        else
                        begin
                            if features.char_lm_suffix_score <= -6388.4999999999991 then
                            begin
                                Result := -0.035130741011261166;
                            end
                            else
                            begin
                                Result := 0.0084889700059069886;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := -0.0024648452360691692;
                    end;
                end
                else
                begin
                    Result := -0.039618949004074686;
                end;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                    begin
                        if features.path_single_segments <= 1.5000000000000002 then
                        begin
                            if features.char_lm_context_score <= -6208.4999999999991 then
                            begin
                                Result := 0.0013128822764360421;
                            end
                            else
                            begin
                                Result := -0.036039490644958178;
                            end;
                        end
                        else
                        begin
                            Result := -0.019110256201946892;
                        end;
                    end
                    else
                    begin
                        if features.path_single_segments <= 3.5000000000000004 then
                        begin
                            if features.chain_score_gap <= -9835736.4999999981 then
                            begin
                                if features.chain_second_stage_score <= -64024275.499999993 then
                                begin
                                    Result := 0.030534581277273015;
                                end
                                else
                                begin
                                    Result := 0.00039750775943279607;
                                end;
                            end
                            else
                            begin
                                Result := 0.015558077871513858;
                            end;
                        end
                        else
                        begin
                            if features.chain_first_stage_score <= 294139.50000000006 then
                            begin
                                if features.score_per_unit <= 3548.5000000000005 then
                                begin
                                    Result := -0.045363339890457842;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -4263.4999999999991 then
                                    begin
                                        if features.char_lm_score <= -4560.4999999999991 then
                                        begin
                                            Result := -0.0045620044337097675;
                                        end
                                        else
                                        begin
                                            Result := -0.047205826383024264;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.018035172011918774;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.048010998903943107;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -18208077.499999996 then
                    begin
                        if features.chain_score_gap <= -27649849.499999996 then
                        begin
                            Result := -0.02879431571836584;
                        end
                        else
                        begin
                            Result := 0.020706983999371001;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_context_gain <= -1887.4999999999998 then
                        begin
                            Result := 0.00016262765317457735;
                        end
                        else
                        begin
                            if features.chain_first_stage_score <= 148576.00000000003 then
                            begin
                                Result := -0.048138465057390681;
                            end
                            else
                            begin
                                Result := -0.0055062984800219672;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_8(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_score_gap <= -1.0000000180025095E-35 then
        begin
            Result := 0.038526892801716298;
        end
        else
        begin
            Result := 0.047566302776090613;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.049440807248829953;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                    begin
                        if features.score_per_unit <= 24927.500000000004 then
                        begin
                            Result := -0.028341632557857998;
                        end
                        else
                        begin
                            Result := -0.0091042583385171887;
                        end;
                    end
                    else
                    begin
                        Result := 0.01058156371658796;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -11066.499999999998 then
                    begin
                        Result := 0.026728964692965738;
                    end
                    else
                    begin
                        Result := -0.042017687352411091;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -52040049.499999993 then
            begin
                if features.chain_score_gap <= -90788920.499999985 then
                begin
                    if features.score_per_unit <= 10722.500000000002 then
                    begin
                        Result := -0.049450655276946621;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -27494981.499999996 then
                        begin
                            if features.char_lm_score <= -5278.4999999999991 then
                            begin
                                Result := -0.024735218412216015;
                            end
                            else
                            begin
                                Result := 0.022581468982700779;
                            end;
                        end
                        else
                        begin
                            Result := -0.043873969186676347;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -6152.4999999999991 then
                    begin
                        if features.char_lm_score <= -5118.4999999999991 then
                        begin
                            if features.chain_second_stage_score <= -67962788.499999985 then
                            begin
                                if features.char_lm_context_score <= -8679.4999999999982 then
                                begin
                                    Result := -0.03891279942377044;
                                end
                                else
                                begin
                                    Result := 0.017058119142559194;
                                end;
                            end
                            else
                            begin
                                if features.score_per_unit <= 781.50000000000011 then
                                begin
                                    Result := 0.026102039008774384;
                                end
                                else
                                begin
                                    Result := -0.029724057153960825;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 34468452.500000007 then
                            begin
                                Result := 0.013405981967203372;
                            end
                            else
                            begin
                                Result := -0.031363749353182632;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := -0.031291815956787421;
                    end;
                end;
            end
            else
            begin
                if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                begin
                    if features.legacy_rank <= 2.5000000000000004 then
                    begin
                        if features.score_per_unit <= 9317.5000000000018 then
                        begin
                            Result := 0.0012276114850474835;
                        end
                        else
                        begin
                            if features.path_segments <= 3.5000000000000004 then
                            begin
                                Result := 0.0011785111978089855;
                            end
                            else
                            begin
                                Result := -0.025892108244589752;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.path_single_segments <= 4.5000000000000009 then
                        begin
                            if features.path_segments <= 2.5000000000000004 then
                            begin
                                Result := 0.018931164301368309;
                            end
                            else
                            begin
                                Result := -0.045642578470085154;
                            end;
                        end
                        else
                        begin
                            Result := 0.016998663888411248;
                        end;
                    end;
                end
                else
                begin
                    if features.path_single_segments <= 3.5000000000000004 then
                    begin
                        if features.chain_second_stage_score <= -60934688.499999993 then
                        begin
                            if features.path_max_segment_units <= 2.5000000000000004 then
                            begin
                                Result := -0.0010967413687056002;
                            end
                            else
                            begin
                                Result := 0.047929936166007221;
                            end;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -9835736.4999999981 then
                            begin
                                Result := 0.0012817099719599941;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -12721871.999999998 then
                                begin
                                    Result := -0.0079089212668245878;
                                end
                                else
                                begin
                                    Result := 0.016064761215816993;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := -0.0071415122474569534;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_9(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_rank <= 1.5000000000000002 then
        begin
            Result := 0.046274388737067781;
        end
        else
        begin
            Result := 0.036922073016562251;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.048177087006144148;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                    begin
                        Result := -0.023576085650642769;
                    end
                    else
                    begin
                        Result := 0.0074045741689227904;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -9852.4999999999982 then
                    begin
                        Result := -0.0039616295318754893;
                    end
                    else
                    begin
                        Result := -0.041887414543080793;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -52040049.499999993 then
            begin
                if features.chain_score_gap <= -89371168.999999985 then
                begin
                    if features.score_per_unit <= 10722.500000000002 then
                    begin
                        Result := -0.045408739233827614;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -27494981.499999996 then
                        begin
                            Result := 0.0;
                        end
                        else
                        begin
                            Result := -0.0418072124987207;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= -67962788.499999985 then
                    begin
                        if features.candidate_score <= 123730.00000000001 then
                        begin
                            Result := -0.01131549638924479;
                        end
                        else
                        begin
                            Result := 0.032972499479335511;
                        end;
                    end
                    else
                    begin
                        Result := -0.018748297558896725;
                    end;
                end;
            end
            else
            begin
                if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                begin
                    if features.legacy_rank <= 2.5000000000000004 then
                    begin
                        if features.path_single_segments <= 1.5000000000000002 then
                        begin
                            if features.char_lm_context_score <= -6208.4999999999991 then
                            begin
                                Result := 0.0040427556609389532;
                            end
                            else
                            begin
                                Result := -0.033490989563019519;
                            end;
                        end
                        else
                        begin
                            Result := -0.01687811104503777;
                        end;
                    end
                    else
                    begin
                        Result := -0.034661502645054958;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= -60934688.499999993 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            if features.candidate_score <= 131226.50000000003 then
                            begin
                                if features.candidate_score <= 63233.000000000007 then
                                begin
                                    Result := 0.015966701971979753;
                                end
                                else
                                begin
                                    Result := -0.047900526231049151;
                                end;
                            end
                            else
                            begin
                                Result := 0.02851292462527099;
                            end;
                        end
                        else
                        begin
                            Result := 0.043602774360210941;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -33002116.999999996 then
                        begin
                            if features.char_lm_context_gain <= -502.49999999999994 then
                            begin
                                Result := -0.014049413755423753;
                            end
                            else
                            begin
                                Result := 0.0093381821544547289;
                            end;
                        end
                        else
                        begin
                            if features.path_single_segments <= 1.5000000000000002 then
                            begin
                                if features.chain_second_stage_score <= -40431876.499999993 then
                                begin
                                    Result := -0.018446392136784784;
                                end
                                else
                                begin
                                    if features.char_lm_context_score <= -6208.4999999999991 then
                                    begin
                                        Result := 0.020093917539196589;
                                    end
                                    else
                                    begin
                                        Result := 0.0011885995520324554;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_context_score <= -5933.4999999999991 then
                                begin
                                    if features.char_lm_context_gain <= -404.49999999999994 then
                                    begin
                                        Result := 0.0013892061417090516;
                                    end
                                    else
                                    begin
                                        Result := -0.027498166354685907;
                                    end;
                                end
                                else
                                begin
                                    if features.path_max_segment_units <= 2.5000000000000004 then
                                    begin
                                        Result := 0.024902526758447577;
                                    end
                                    else
                                    begin
                                        if features.score_per_unit <= 12479.500000000002 then
                                        begin
                                            Result := -0.0045052428843129948;
                                        end
                                        else
                                        begin
                                            Result := 0.031065229794544017;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_10(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_score_gap <= -999794.49999999988 then
        begin
            if features.candidate_score <= 66757.000000000015 then
            begin
                Result := 0.020927577742501084;
            end
            else
            begin
                Result := 0.038138093496279904;
            end;
        end
        else
        begin
            Result := 0.045141950245031218;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.047074217833764302;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if features.chain_first_stage_score <= 55406.000000000007 then
                    begin
                        if features.char_lm_score <= -4513.4999999999991 then
                        begin
                            Result := -0.026387902879572593;
                        end
                        else
                        begin
                            Result := -0.0065334005507496559;
                        end;
                    end
                    else
                    begin
                        Result := 0.014752332498723575;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -11066.499999999998 then
                    begin
                        Result := 0.027916032656650783;
                    end
                    else
                    begin
                        Result := -0.04086092116684182;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -45818588.499999993 then
            begin
                if features.chain_score_gap <= -89371168.999999985 then
                begin
                    if features.candidate_score <= 194860.00000000003 then
                    begin
                        Result := -0.035402022200104279;
                    end
                    else
                    begin
                        Result := 0.015977560010962739;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= 70834775.500000015 then
                    begin
                        if features.chain_rank <= 2.5000000000000004 then
                        begin
                            if features.char_lm_suffix_score <= -6059.4999999999991 then
                            begin
                                if features.score_per_unit <= 1305.5000000000002 then
                                begin
                                    Result := 0.021629058925812853;
                                end
                                else
                                begin
                                    Result := -0.025200279019718615;
                                end;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= 17062271.000000004 then
                                begin
                                    Result := 0.0071405267921139668;
                                end
                                else
                                begin
                                    Result := -0.021645895375880141;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.021270207619384907;
                        end;
                    end
                    else
                    begin
                        Result := -0.040051782950440436;
                    end;
                end;
            end
            else
            begin
                if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                begin
                    if features.legacy_rank <= 2.5000000000000004 then
                    begin
                        if features.dict_weight_per_unit <= 5237.0000000000009 then
                        begin
                            Result := 0.0025673657466948985;
                        end
                        else
                        begin
                            Result := -0.013975387446472793;
                        end;
                    end
                    else
                    begin
                        if features.path_single_segments <= 4.5000000000000009 then
                        begin
                            if features.path_segments <= 2.5000000000000004 then
                            begin
                                Result := 0.018115347131313748;
                            end
                            else
                            begin
                                Result := -0.046709800375940989;
                            end;
                        end
                        else
                        begin
                            Result := 0.015798109217393348;
                        end;
                    end;
                end
                else
                begin
                    if features.score_per_unit <= 11286.500000000002 then
                    begin
                        if features.legacy_rank <= 2.5000000000000004 then
                        begin
                            if features.chain_score_gap <= -20341703.499999996 then
                            begin
                                if features.char_lm_context_gain <= -502.49999999999994 then
                                begin
                                    if features.path_segments <= 5.5000000000000009 then
                                    begin
                                        Result := 0.013303197904708393;
                                    end
                                    else
                                    begin
                                        Result := -0.016324766806896991;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.01242293280867837;
                                end;
                            end
                            else
                            begin
                                Result := 0.0078364494674486897;
                            end;
                        end
                        else
                        begin
                            if features.path_segments <= 5.5000000000000009 then
                            begin
                                Result := 0.016000677562228879;
                            end
                            else
                            begin
                                if features.chain_first_stage_score <= 253629.50000000003 then
                                begin
                                    Result := -0.033947449313227858;
                                end
                                else
                                begin
                                    Result := 0.017407549268706659;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -55362432.999999993 then
                        begin
                            Result := 0.043536862823113961;
                        end
                        else
                        begin
                            Result := 0.011404148475404932;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_11(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_rank <= 1.5000000000000002 then
        begin
            Result := 0.044073808956819151;
        end
        else
        begin
            Result := 0.035727539362762531;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.046092004718597528;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if features.char_lm_context_score <= -6974.4999999999991 then
                    begin
                        Result := -0.027474263187438987;
                    end
                    else
                    begin
                        if features.candidate_score <= 102582.50000000001 then
                        begin
                            Result := -0.041574550951051309;
                        end
                        else
                        begin
                            Result := 0.0014561181171985898;
                        end;
                    end;
                end
                else
                begin
                    if features.score_per_unit <= 24168.500000000004 then
                    begin
                        if features.chain_first_stage_score <= 43010.000000000007 then
                        begin
                            Result := -0.041261161834114678;
                        end
                        else
                        begin
                            Result := -0.008065670667573974;
                        end;
                    end
                    else
                    begin
                        Result := 0.0055901421215753394;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -59742350.999999993 then
            begin
                if features.chain_second_stage_score <= -6376268.4999999991 then
                begin
                    if features.chain_score_gap <= -90788920.499999985 then
                    begin
                        if features.score_per_unit <= 10722.500000000002 then
                        begin
                            Result := -0.044133912369537072;
                        end
                        else
                        begin
                            Result := -0.0092371957845877543;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -5794.4999999999991 then
                        begin
                            if features.chain_second_stage_score <= -64024275.499999993 then
                            begin
                                Result := 0.0065276141401187284;
                            end
                            else
                            begin
                                Result := -0.022325181311419525;
                            end;
                        end
                        else
                        begin
                            Result := 0.0215446320809537;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.033820570234100671;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.0000000180025095E-35 then
                begin
                    if features.legacy_rank <= 2.5000000000000004 then
                    begin
                        if features.score_per_unit <= 9317.5000000000018 then
                        begin
                            Result := -0.00017167303585093266;
                        end
                        else
                        begin
                            if features.path_single_segments <= 1.5000000000000002 then
                            begin
                                Result := -0.0081228561404419752;
                            end
                            else
                            begin
                                Result := -0.02714868816465715;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := -0.035796071843822511;
                    end;
                end
                else
                begin
                    if features.dict_weight_per_unit <= 10636.500000000002 then
                    begin
                        if features.legacy_rank <= 2.5000000000000004 then
                        begin
                            if features.chain_score_gap <= -28322690.999999996 then
                            begin
                                if features.chain_score_gap <= -57033799.999999993 then
                                begin
                                    Result := 0.014944269548714875;
                                end
                                else
                                begin
                                    Result := -0.013818383204276523;
                                end;
                            end
                            else
                            begin
                                Result := 0.0060103730318762753;
                            end;
                        end
                        else
                        begin
                            Result := -0.027917058773771753;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -64024275.499999993 then
                        begin
                            Result := 0.0427813930020184;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -9835736.4999999981 then
                            begin
                                if features.chain_second_stage_score <= 8106950.0000000009 then
                                begin
                                    if features.chain_score_gap <= -40225207.999999993 then
                                    begin
                                        Result := -0.0070512019556380765;
                                    end
                                    else
                                    begin
                                        Result := 0.018210302255946532;
                                    end;
                                end
                                else
                                begin
                                    if features.score_per_unit <= 13037.500000000002 then
                                    begin
                                        Result := -0.012210933012978294;
                                    end
                                    else
                                    begin
                                        Result := 0.014586224174724107;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -17266288.499999996 then
                                begin
                                    Result := -0.011412343176236064;
                                end
                                else
                                begin
                                    if features.chain_first_stage_score <= 231700.00000000003 then
                                    begin
                                        Result := 0.021056095992686041;
                                    end
                                    else
                                    begin
                                        Result := -0.0038006546323032082;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_12(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.legacy_top) <= 1.0000000180025095E-35 then
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.045209421608701304;
            end
            else
            begin
                if features.score_per_unit <= 24168.500000000004 then
                begin
                    if features.chain_rank <= 1.0000000180025095E-35 then
                    begin
                        Result := -0.034293692802688201;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -122461489.49999999 then
                        begin
                            Result := -0.029433894080368096;
                        end
                        else
                        begin
                            Result := 0.012666537221330824;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.004490450093881479;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -59742350.999999993 then
            begin
                Result := -0.022112777784552087;
            end
            else
            begin
                if features.chain_first_stage_score <= 10622.000000000002 then
                begin
                    if features.path_single_segments <= 1.5000000000000002 then
                    begin
                        if features.dict_weight <= 28679.000000000004 then
                        begin
                            Result := 0.034534612942547248;
                        end
                        else
                        begin
                            Result := -0.0070355384905433317;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_context_gain <= -1506.4999999999998 then
                        begin
                            Result := -0.035263352269505152;
                        end
                        else
                        begin
                            Result := -0.012293025728294611;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= -60934688.499999993 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            Result := -0.00082305441410162065;
                        end
                        else
                        begin
                            Result := 0.036953799913262454;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -33002116.999999996 then
                        begin
                            if features.char_lm_score <= -5800.4999999999991 then
                            begin
                                if features.path_segments <= 6.5000000000000009 then
                                begin
                                    if features.candidate_score <= 138130.50000000003 then
                                    begin
                                        Result := -0.024740506860322888;
                                    end
                                    else
                                    begin
                                        Result := 0.022853027631843242;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.043127285478921806;
                                end;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -25586281.999999996 then
                                begin
                                    Result := 0.022780613179785556;
                                end
                                else
                                begin
                                    if features.text_units <= 8.5000000000000018 then
                                    begin
                                        Result := 0.026254183021358669;
                                    end
                                    else
                                    begin
                                        Result := -0.010857073272258886;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -3724.4999999999995 then
                            begin
                                if features.char_lm_score <= -4263.4999999999991 then
                                begin
                                    if features.path_single_segments <= 1.5000000000000002 then
                                    begin
                                        if features.char_lm_context_gain <= -563.49999999999989 then
                                        begin
                                            if features.char_lm_context_score <= -7671.4999999999991 then
                                            begin
                                                Result := -0.00044443371212734715;
                                            end
                                            else
                                            begin
                                                if features.char_lm_score <= -4709.4999999999991 then
                                                begin
                                                    Result := 0.033166148043418636;
                                                end
                                                else
                                                begin
                                                    Result := -0.0046928806383087227;
                                                end;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := -0.016569517704043243;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.00021289427044815116;
                                    end;
                                end
                                else
                                begin
                                    if features.path_max_segment_units <= 2.5000000000000004 then
                                    begin
                                        Result := 0.034399341532059827;
                                    end
                                    else
                                    begin
                                        Result := 0.010580090942949042;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_score <= -2518.4999999999995 then
                                begin
                                    if features.chain_score_gap <= -6389736.9999999991 then
                                    begin
                                        Result := -0.037929354560212063;
                                    end
                                    else
                                    begin
                                        if features.chain_rank <= 1.5000000000000002 then
                                        begin
                                            Result := -0.028875987823930971;
                                        end
                                        else
                                        begin
                                            Result := 0.024630082357052246;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.03282833619865571;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end
    else
    begin
        if features.chain_score_gap <= -999794.49999999988 then
        begin
            Result := 0.033555987328016734;
        end
        else
        begin
            Result := 0.043086875522843793;
        end;
    end;
end;

function long_final_ranker_tree_13(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_rank <= 1.5000000000000002 then
        begin
            Result := 0.042257688772791506;
        end
        else
        begin
            Result := 0.0325158106469551;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.044416242379820288;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if features.chain_rank <= 3.5000000000000004 then
                    begin
                        if features.char_lm_score <= -3940.4999999999995 then
                        begin
                            Result := -0.02237835428957307;
                        end
                        else
                        begin
                            Result := 0.0071579214968255124;
                        end;
                    end
                    else
                    begin
                        Result := 0.010852191094279939;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -11066.499999999998 then
                    begin
                        Result := 0.026520085343160339;
                    end
                    else
                    begin
                        if features.score_per_unit <= 35838.000000000007 then
                        begin
                            Result := -0.038077847539968547;
                        end
                        else
                        begin
                            Result := 0.013762333628142652;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -59742350.999999993 then
            begin
                if features.chain_second_stage_score <= -9341146.9999999981 then
                begin
                    if features.char_lm_score <= -5016.4999999999991 then
                    begin
                        if features.dict_weight <= 186037.00000000003 then
                        begin
                            Result := -0.025021475247720196;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -57796089.499999993 then
                            begin
                                Result := 0.033976774271333492;
                            end
                            else
                            begin
                                Result := -0.019992665737539786;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -90788920.499999985 then
                        begin
                            Result := -0.01664781007681973;
                        end
                        else
                        begin
                            Result := 0.025757511226568365;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.032381004431802814;
                end;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                    begin
                        if features.path_single_segments <= 1.5000000000000002 then
                        begin
                            if features.dict_weight <= 28679.000000000004 then
                            begin
                                Result := 0.036416603202577245;
                            end
                            else
                            begin
                                Result := -0.0016206879793890629;
                            end;
                        end
                        else
                        begin
                            if features.dict_weight <= 109398.50000000001 then
                            begin
                                Result := -0.0055799353593242746;
                            end
                            else
                            begin
                                Result := -0.027935157250537388;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -10732023.999999998 then
                        begin
                            if features.chain_second_stage_score <= -55362432.999999993 then
                            begin
                                if features.dict_weight <= 120968.00000000001 then
                                begin
                                    Result := -0.0034494659156409971;
                                end
                                else
                                begin
                                    Result := 0.032646872046859045;
                                end;
                            end
                            else
                            begin
                                Result := -0.0024303541286781706;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 25555719.500000004 then
                            begin
                                if features.char_lm_score <= -7467.9999999999991 then
                                begin
                                    Result := 0.035196361296346436;
                                end
                                else
                                begin
                                    Result := 0.0026382656071993215;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_score <= -3655.4999999999995 then
                                begin
                                    Result := 0.019336781914568314;
                                end
                                else
                                begin
                                    Result := -0.0032701735350842646;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_first_stage_score <= 148576.00000000003 then
                    begin
                        if features.path_single_segments <= 1.5000000000000002 then
                        begin
                            if features.chain_score_gap <= -20341703.499999996 then
                            begin
                                Result := 0.022356299857745027;
                            end
                            else
                            begin
                                if features.char_lm_context_gain <= -1887.4999999999998 then
                                begin
                                    Result := 0.018787089972933581;
                                end
                                else
                                begin
                                    Result := -0.039110351186090506;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := -0.039537032550844876;
                        end;
                    end
                    else
                    begin
                        Result := -0.0021441861417617592;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_14(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_second_stage_score <= -20468598.999999996 then
        begin
            Result := 0.031443845581212743;
        end
        else
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                Result := 0.041735095726979692;
            end
            else
            begin
                Result := 0.032589780103515896;
            end;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.043716946414561093;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                    begin
                        Result := -0.017746649506656369;
                    end
                    else
                    begin
                        Result := 0.0068831797215517477;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -9852.4999999999982 then
                    begin
                        Result := 0.00045313805302795427;
                    end
                    else
                    begin
                        if features.chain_first_stage_score <= 131999.00000000003 then
                        begin
                            Result := -0.038688911950749062;
                        end
                        else
                        begin
                            Result := 0.0038559969103208521;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -52040049.499999993 then
            begin
                if features.char_lm_context_score <= -6152.4999999999991 then
                begin
                    if features.char_lm_context_score <= -6525.4999999999991 then
                    begin
                        if features.chain_score_gap <= -89371168.999999985 then
                        begin
                            Result := -0.031371674785618392;
                        end
                        else
                        begin
                            if features.chain_first_stage_score <= 70511.000000000015 then
                            begin
                                Result := 0.0059449592664551493;
                            end
                            else
                            begin
                                Result := -0.021222109052604139;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= 17062271.000000004 then
                        begin
                            Result := 0.018164350634460411;
                        end
                        else
                        begin
                            Result := -0.025262462315710884;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.031384249216202802;
                end;
            end
            else
            begin
                if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                begin
                    if features.legacy_rank <= 2.5000000000000004 then
                    begin
                        if features.path_segments <= 3.5000000000000004 then
                        begin
                            Result := 0.0051250733174687101;
                        end
                        else
                        begin
                            if features.dict_weight_per_unit <= 8173.5000000000009 then
                            begin
                                Result := -0.00089949585999245262;
                            end
                            else
                            begin
                                Result := -0.017504151665383626;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.path_single_segments <= 4.5000000000000009 then
                        begin
                            Result := -0.037333784679037273;
                        end
                        else
                        begin
                            Result := 0.014060503430702821;
                        end;
                    end;
                end
                else
                begin
                    if features.path_single_segments <= 1.5000000000000002 then
                    begin
                        if features.chain_second_stage_score <= -60934688.499999993 then
                        begin
                            Result := 0.040878214232952431;
                        end
                        else
                        begin
                            if features.dict_weight_per_unit <= 11734.500000000002 then
                            begin
                                Result := 0.0066648870167838655;
                            end
                            else
                            begin
                                Result := 0.021932798814888306;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.legacy_rank <= 2.5000000000000004 then
                        begin
                            if features.chain_score_gap <= -20341703.499999996 then
                            begin
                                if features.chain_second_stage_score <= 65201574.000000007 then
                                begin
                                    if features.char_lm_context_score <= -6049.4999999999991 then
                                    begin
                                        Result := -0.0034495228351167535;
                                    end
                                    else
                                    begin
                                        Result := 0.018977911814574269;
                                    end;
                                end
                                else
                                begin
                                    if features.path_single_segments <= 2.5000000000000004 then
                                    begin
                                        Result := -0.0025970261054738229;
                                    end
                                    else
                                    begin
                                        Result := -0.037460472994497437;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := 0.0072563804481982266;
                            end;
                        end
                        else
                        begin
                            if features.path_max_segment_units <= 3.5000000000000004 then
                            begin
                                if features.char_lm_suffix_score <= -7165.4999999999991 then
                                begin
                                    Result := 0.0038461979974942417;
                                end
                                else
                                begin
                                    Result := -0.035352332798814869;
                                end;
                            end
                            else
                            begin
                                Result := 0.010513595567389018;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_15(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_rank <= 1.5000000000000002 then
        begin
            if features.chain_second_stage_score <= -20468598.999999996 then
            begin
                Result := 0.029083952123287037;
            end
            else
            begin
                Result := 0.040966106109297074;
            end;
        end
        else
        begin
            if features.candidate_score <= 66757.000000000015 then
            begin
                Result := 0.015520173371772829;
            end
            else
            begin
                Result := 0.032926403320468194;
            end;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.043075198504435759;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if features.char_lm_context_gain <= -1035.4999999999998 then
                    begin
                        Result := -0.02236281718280847;
                    end
                    else
                    begin
                        if features.candidate_score <= 83710.000000000015 then
                        begin
                            Result := -0.030311230300971076;
                        end
                        else
                        begin
                            Result := -0.0020619517858155518;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_context_gain <= -1506.4999999999998 then
                    begin
                        Result := -0.0088826165966778125;
                    end
                    else
                    begin
                        Result := -0.036876708383534712;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -52040049.499999993 then
            begin
                if features.chain_score_gap <= -89371168.999999985 then
                begin
                    Result := -0.029882540974692916;
                end
                else
                begin
                    if features.chain_second_stage_score <= -67962788.499999985 then
                    begin
                        if features.char_lm_context_score <= -8679.4999999999982 then
                        begin
                            Result := -0.031625349875545154;
                        end
                        else
                        begin
                            Result := 0.020509881981286615;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_score <= -5668.4999999999991 then
                        begin
                            Result := -0.033755326370335834;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -19121511.999999996 then
                            begin
                                Result := 0.0065296041274749729;
                            end
                            else
                            begin
                                if features.text_units <= 8.5000000000000018 then
                                begin
                                    Result := 0.013243764700954166;
                                end
                                else
                                begin
                                    Result := -0.023406970903413576;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                begin
                    if features.legacy_rank <= 2.5000000000000004 then
                    begin
                        if features.score_per_unit <= 9317.5000000000018 then
                        begin
                            Result := 0.0012034189337222056;
                        end
                        else
                        begin
                            if features.path_segments <= 3.5000000000000004 then
                            begin
                                Result := -0.00040282439510502241;
                            end
                            else
                            begin
                                Result := -0.021039230604324062;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.path_single_segments <= 4.5000000000000009 then
                        begin
                            Result := -0.035847572538632987;
                        end
                        else
                        begin
                            Result := 0.011418305881236825;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= -60934688.499999993 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            Result := 0.0007201217228127876;
                        end
                        else
                        begin
                            Result := 0.039153517977551892;
                        end;
                    end
                    else
                    begin
                        if features.dict_weight_per_unit <= 10869.000000000002 then
                        begin
                            if features.candidate_score <= 128432.50000000001 then
                            begin
                                if features.char_lm_context_score <= -7175.4999999999991 then
                                begin
                                    if features.char_lm_context_gain <= -1820.4999999999998 then
                                    begin
                                        Result := 0.028332638005114728;
                                    end
                                    else
                                    begin
                                        Result := -0.0098315706680536467;
                                    end;
                                end
                                else
                                begin
                                    if features.path_single_segments <= 3.5000000000000004 then
                                    begin
                                        Result := 0.013167126996762849;
                                    end
                                    else
                                    begin
                                        if features.chain_first_stage_score <= 222987.00000000003 then
                                        begin
                                            Result := -0.017514320214635611;
                                        end
                                        else
                                        begin
                                            Result := 0.03553610643462686;
                                        end;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.011320639168879182;
                            end;
                        end
                        else
                        begin
                            Result := 0.0088325963431174648;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_16(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_second_stage_score <= -20468598.999999996 then
        begin
            Result := 0.028364792751883815;
        end
        else
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                Result := 0.040298364330720787;
            end
            else
            begin
                Result := 0.030500599155878654;
            end;
        end;
    end
    else
    begin
        if features.path_segments <= 2.5000000000000004 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.042499749856929621;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if features.char_lm_context_score <= -6626.4999999999991 then
                    begin
                        if features.chain_first_stage_score <= -32045.499999999996 then
                        begin
                            Result := 0.018508608923275317;
                        end
                        else
                        begin
                            Result := -0.021414452693461816;
                        end;
                    end
                    else
                    begin
                        if features.candidate_score <= 102582.50000000001 then
                        begin
                            Result := -0.035175149902680398;
                        end
                        else
                        begin
                            if features.candidate_score <= 179983.00000000003 then
                            begin
                                Result := 0.019789557879397519;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -9341146.9999999981 then
                                begin
                                    Result := 0.026806533447322752;
                                end
                                else
                                begin
                                    Result := -0.021846324474834797;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -9852.4999999999982 then
                    begin
                        Result := 0.00069231287564418113;
                    end
                    else
                    begin
                        Result := -0.035584843588370871;
                    end;
                end;
            end;
        end
        else
        begin
            if features.legacy_rank <= 2.5000000000000004 then
            begin
                if features.chain_score_gap <= -52040049.499999993 then
                begin
                    if features.chain_second_stage_score <= -32334096.999999996 then
                    begin
                        if features.score_per_unit <= 10722.500000000002 then
                        begin
                            if features.char_lm_suffix_score <= -6134.4999999999991 then
                            begin
                                Result := -0.024024251322057641;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -79762850.999999985 then
                                begin
                                    Result := -0.018163515617676325;
                                end
                                else
                                begin
                                    Result := 0.028580654352201799;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.0085089906970572254;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -83244892.999999985 then
                        begin
                            Result := -0.037385634407189207;
                        end
                        else
                        begin
                            Result := -0.015623264025853316;
                        end;
                    end;
                end
                else
                begin
                    if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                    begin
                        Result := -0.0075860392363187416;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -55362432.999999993 then
                        begin
                            if features.candidate_score <= 95731.000000000015 then
                            begin
                                Result := 0.0034107382076260825;
                            end
                            else
                            begin
                                Result := 0.033200511883561344;
                            end;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -20341703.499999996 then
                            begin
                                Result := -0.0015085219719990792;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -16016177.499999998 then
                                begin
                                    Result := -0.0023724202324296255;
                                end
                                else
                                begin
                                    if features.path_single_segments <= 3.5000000000000004 then
                                    begin
                                        Result := 0.013953688871521942;
                                    end
                                    else
                                    begin
                                        Result := -0.0022898141542413695;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.chain_score_gap <= -18208077.499999996 then
                begin
                    if features.chain_score_gap <= -29696304.999999996 then
                    begin
                        if features.candidate_score <= 76536.000000000015 then
                        begin
                            if features.char_lm_score <= -5607.4999999999991 then
                            begin
                                Result := -0.032161239762123019;
                            end
                            else
                            begin
                                Result := 0.015288892713690416;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -6634.4999999999991 then
                            begin
                                Result := 0.0085842006808703169;
                            end
                            else
                            begin
                                Result := -0.041024447150785452;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.011431610391374419;
                    end;
                end
                else
                begin
                    Result := -0.03146385710770578;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_17(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_second_stage_score <= -20468598.999999996 then
        begin
            Result := 0.028140504794242505;
        end
        else
        begin
            if features.chain_score_gap <= -1.0000000180025095E-35 then
            begin
                Result := 0.029804954612655529;
            end
            else
            begin
                Result := 0.039599080270019731;
            end;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.041973240871681639;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                    begin
                        if features.char_lm_score <= -4513.4999999999991 then
                        begin
                            if features.candidate_score <= 23789.000000000004 then
                            begin
                                Result := 0.01917204389272207;
                            end
                            else
                            begin
                                Result := -0.025266481336470175;
                            end;
                        end
                        else
                        begin
                            Result := -0.0055155753244486511;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -122461489.49999999 then
                        begin
                            Result := -0.01600237537105902;
                        end
                        else
                        begin
                            Result := 0.024536559626026192;
                        end;
                    end;
                end
                else
                begin
                    if features.score_per_unit <= 24168.500000000004 then
                    begin
                        if features.chain_first_stage_score <= 43010.000000000007 then
                        begin
                            Result := -0.037331460852403957;
                        end
                        else
                        begin
                            Result := -0.0035805229886762338;
                        end;
                    end
                    else
                    begin
                        Result := 0.008302427964611777;
                    end;
                end;
            end;
        end
        else
        begin
            if features.legacy_rank <= 2.5000000000000004 then
            begin
                if features.chain_score_gap <= -59742350.999999993 then
                begin
                    if features.chain_second_stage_score <= -6376268.4999999991 then
                    begin
                        if features.char_lm_context_score <= -6525.4999999999991 then
                        begin
                            Result := -0.0143289197985222;
                        end
                        else
                        begin
                            Result := 0.013753603989209887;
                        end;
                    end
                    else
                    begin
                        Result := -0.02798817239463924;
                    end;
                end
                else
                begin
                    if features.path_single_segments <= 3.5000000000000004 then
                    begin
                        if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                        begin
                            if features.dict_weight_per_unit <= 5237.0000000000009 then
                            begin
                                Result := 0.0063485775522501842;
                            end
                            else
                            begin
                                if features.char_lm_context_score <= -6208.4999999999991 then
                                begin
                                    Result := -0.0059525960095487057;
                                end
                                else
                                begin
                                    Result := -0.032675321261621801;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -20341703.499999996 then
                            begin
                                if features.chain_second_stage_score <= 67401736.500000015 then
                                begin
                                    if features.char_lm_score <= -4208.4999999999991 then
                                    begin
                                        Result := 0.0023761438162773563;
                                    end
                                    else
                                    begin
                                        Result := 0.032028904310103391;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.014726334914063895;
                                end;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -67962788.499999985 then
                                begin
                                    Result := 0.043536939670866998;
                                end
                                else
                                begin
                                    Result := 0.0098196814216721644;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.candidate_score <= 110551.50000000001 then
                        begin
                            Result := -0.022978517581810225;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 84605502.000000015 then
                            begin
                                if features.chain_second_stage_score <= -5032054.9999999991 then
                                begin
                                    Result := 0.0074111622296897505;
                                end
                                else
                                begin
                                    Result := -0.018223543718928804;
                                end;
                            end
                            else
                            begin
                                Result := 0.02180792258501461;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.path_segments <= 10.500000000000002 then
                begin
                    if features.char_lm_context_gain <= -1758.4999999999998 then
                    begin
                        if features.chain_second_stage_score <= -3469666.9999999995 then
                        begin
                            Result := 0.030558020587059122;
                        end
                        else
                        begin
                            Result := -0.017719719523843436;
                        end;
                    end
                    else
                    begin
                        Result := -0.027621735090537523;
                    end;
                end
                else
                begin
                    Result := 0.006559782221093464;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_18(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_rank <= 1.5000000000000002 then
        begin
            if features.chain_second_stage_score <= -20468598.999999996 then
            begin
                Result := 0.026972433424298694;
            end
            else
            begin
                Result := 0.039002548746147198;
            end;
        end
        else
        begin
            if features.char_lm_suffix_score <= -7411.4999999999991 then
            begin
                Result := 0.0041860124383243684;
            end
            else
            begin
                Result := 0.029166737535298484;
            end;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.partial_match) <= 1.0000000180025095E-35 then
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if features.char_lm_context_gain <= -1160.4999999999998 then
                    begin
                        if features.score_per_unit <= 24927.500000000004 then
                        begin
                            if features.path_segments <= 4.5000000000000009 then
                            begin
                                Result := -0.03854547657868946;
                            end
                            else
                            begin
                                Result := 0.01782974148276506;
                            end;
                        end
                        else
                        begin
                            Result := -0.0084248034313328876;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_score <= -4513.4999999999991 then
                        begin
                            Result := -0.011976333097196644;
                        end
                        else
                        begin
                            Result := 0.0092894196005391567;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -11066.499999999998 then
                    begin
                        Result := 0.02543683716205274;
                    end
                    else
                    begin
                        if features.score_per_unit <= 35838.000000000007 then
                        begin
                            Result := -0.034876506379072678;
                        end
                        else
                        begin
                            Result := 0.013939292856582988;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := -0.04151094224076847;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -59011123.499999993 then
            begin
                if features.chain_second_stage_score <= -64024275.499999993 then
                begin
                    if features.candidate_score <= 186842.00000000003 then
                    begin
                        Result := -0.009037447830925055;
                    end
                    else
                    begin
                        Result := 0.036456378426030382;
                    end;
                end
                else
                begin
                    Result := -0.022873823390988812;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.0000000180025095E-35 then
                begin
                    if features.legacy_rank <= 2.5000000000000004 then
                    begin
                        if features.path_single_segments <= 1.5000000000000002 then
                        begin
                            Result := 0.0019512621931910498;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -1506.4999999999998 then
                            begin
                                Result := -0.034942225959375149;
                            end
                            else
                            begin
                                Result := -0.0073005556699952019;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := -0.029534917834659325;
                    end;
                end
                else
                begin
                    if features.dict_weight_per_unit <= 10636.500000000002 then
                    begin
                        if features.chain_score_gap <= -35118691.999999993 then
                        begin
                            if features.char_lm_score <= -5730.4999999999991 then
                            begin
                                Result := -0.028958468807220229;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -38535230.499999993 then
                                begin
                                    Result := 0.030555063836437045;
                                end
                                else
                                begin
                                    Result := -0.010256518292542606;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.chain_first_stage_score <= 157812.00000000003 then
                            begin
                                if features.legacy_rank <= 2.5000000000000004 then
                                begin
                                    Result := 0.0080475529516823227;
                                end
                                else
                                begin
                                    Result := -0.012497259348637942;
                                end;
                            end
                            else
                            begin
                                Result := -0.0080798213590575173;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -64024275.499999993 then
                        begin
                            Result := 0.042520268991767564;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -37824125.499999993 then
                            begin
                                Result := -0.0046186762606801775;
                            end
                            else
                            begin
                                if features.char_lm_score <= -3522.4999999999995 then
                                begin
                                    Result := 0.011469136453193354;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -2819.4999999999995 then
                                    begin
                                        Result := -0.029838842551624126;
                                    end
                                    else
                                    begin
                                        Result := 0.020210886346220862;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_19(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_rank <= 1.5000000000000002 then
        begin
            Result := 0.038171685184699163;
        end
        else
        begin
            if features.candidate_score <= 66757.000000000015 then
            begin
                if features.path_single_segments <= 3.5000000000000004 then
                begin
                    Result := 0.019310808609932388;
                end
                else
                begin
                    Result := -0.0089313820299291684;
                end;
            end
            else
            begin
                Result := 0.030816004240304805;
            end;
        end;
    end
    else
    begin
        if Ord(features.complete_match) <= 1.0000000180025095E-35 then
        begin
            Result := -0.041068330937830001;
        end
        else
        begin
            if features.legacy_rank <= 2.5000000000000004 then
            begin
                if features.chain_first_stage_score <= 43010.000000000007 then
                begin
                    if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
                    begin
                        if features.path_single_segments <= 1.5000000000000002 then
                        begin
                            Result := 0.0027524743790627096;
                        end
                        else
                        begin
                            Result := -0.011645432865733866;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_score <= -3655.4999999999995 then
                        begin
                            if features.char_lm_context_gain <= -1247.4999999999998 then
                            begin
                                if features.char_lm_context_gain <= -2048.4999999999995 then
                                begin
                                    Result := -0.00090581175252386263;
                                end
                                else
                                begin
                                    Result := -0.035159078147631181;
                                end;
                            end
                            else
                            begin
                                Result := -0.010373924934855365;
                            end;
                        end
                        else
                        begin
                            Result := 0.0098939977792719281;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -52040049.499999993 then
                    begin
                        Result := -0.012672528661863488;
                    end
                    else
                    begin
                        if features.path_single_segments <= 3.5000000000000004 then
                        begin
                            if features.chain_score_gap <= -9835736.4999999981 then
                            begin
                                if features.chain_rank <= 2.5000000000000004 then
                                begin
                                    Result := 0.0032029698760331696;
                                end
                                else
                                begin
                                    Result := 0.040921340266802601;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_score <= -3724.4999999999995 then
                                begin
                                    if features.char_lm_score <= -5438.4999999999991 then
                                    begin
                                        if features.path_max_segment_units <= 2.5000000000000004 then
                                        begin
                                            Result := -0.0057985476511107107;
                                        end
                                        else
                                        begin
                                            if features.path_single_segments <= 2.5000000000000004 then
                                            begin
                                                Result := 0.02389029364064878;
                                            end
                                            else
                                            begin
                                                Result := -0.0044394210704040288;
                                            end;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.020374591603171982;
                                    end;
                                end
                                else
                                begin
                                    if features.chain_first_stage_score <= 178232.50000000003 then
                                    begin
                                        Result := -0.018509281110632807;
                                    end
                                    else
                                    begin
                                        Result := 0.023857523475934995;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.chain_first_stage_score <= 282672.00000000006 then
                            begin
                                Result := -0.00092022985694243146;
                            end
                            else
                            begin
                                Result := -0.026451213423260612;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                begin
                    if features.char_lm_context_score <= -9852.4999999999982 then
                    begin
                        Result := -0.0046411571274301332;
                    end
                    else
                    begin
                        if features.path_single_segments <= 4.5000000000000009 then
                        begin
                            if features.char_lm_score <= -3299.4999999999995 then
                            begin
                                Result := -0.035977347195032934;
                            end
                            else
                            begin
                                Result := 0.016923156028711472;
                            end;
                        end
                        else
                        begin
                            Result := 0.011458020959677148;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_suffix_score <= -7165.4999999999991 then
                    begin
                        if features.candidate_score <= 125142.00000000001 then
                        begin
                            Result := -0.017340453823540429;
                        end
                        else
                        begin
                            Result := 0.035473242858376997;
                        end;
                    end
                    else
                    begin
                        if features.candidate_score <= 76536.000000000015 then
                        begin
                            Result := 0.0043165221636530934;
                        end
                        else
                        begin
                            if features.candidate_score <= 181962.00000000003 then
                            begin
                                Result := -0.03080546220588843;
                            end
                            else
                            begin
                                Result := -0.002037562354438032;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_20(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_second_stage_score <= -20468598.999999996 then
        begin
            if features.char_lm_suffix_score <= -7288.4999999999991 then
            begin
                Result := 0.011323588403748997;
            end
            else
            begin
                Result := 0.027401119888087831;
            end;
        end
        else
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                Result := 0.038051812769840064;
            end
            else
            begin
                Result := 0.027682919759674504;
            end;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if features.path_max_segment_units <= 5.5000000000000009 then
            begin
                Result := -0.040689466658451134;
            end
            else
            begin
                if features.score_per_unit <= 24168.500000000004 then
                begin
                    if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                    begin
                        Result := -0.028303374086920737;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -53550508.499999993 then
                        begin
                            Result := -0.01392569308671744;
                        end
                        else
                        begin
                            Result := 0.028541315113982287;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -10153.499999999998 then
                    begin
                        Result := 0.028901724333363531;
                    end
                    else
                    begin
                        if features.char_lm_score <= -4709.4999999999991 then
                        begin
                            Result := -0.022674826594012033;
                        end
                        else
                        begin
                            Result := 0.0076438795753816097;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -47595611.499999993 then
            begin
                if features.chain_score_gap <= -89371168.999999985 then
                begin
                    if features.candidate_score <= 194860.00000000003 then
                    begin
                        Result := -0.03081609800904906;
                    end
                    else
                    begin
                        Result := 0.016877303421795619;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= 55378264.000000007 then
                    begin
                        if features.char_lm_suffix_score <= -6134.4999999999991 then
                        begin
                            if features.chain_second_stage_score <= -67962788.499999985 then
                            begin
                                if features.char_lm_context_score <= -8679.4999999999982 then
                                begin
                                    Result := -0.029260087980322702;
                                end
                                else
                                begin
                                    Result := 0.019033193118955041;
                                end;
                            end
                            else
                            begin
                                if features.score_per_unit <= 929.00000000000011 then
                                begin
                                    Result := 0.019680043708264146;
                                end
                                else
                                begin
                                    if features.score_per_unit <= 10810.500000000002 then
                                    begin
                                        Result := -0.037381083136924891;
                                    end
                                    else
                                    begin
                                        Result := -0.0094815823676136432;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.0022683871351725968;
                        end;
                    end
                    else
                    begin
                        Result := -0.029167933886282887;
                    end;
                end;
            end
            else
            begin
                if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                begin
                    if features.legacy_rank <= 2.5000000000000004 then
                    begin
                        Result := -0.0047899159929833783;
                    end
                    else
                    begin
                        Result := -0.029243575864411522;
                    end;
                end
                else
                begin
                    if features.path_single_segments <= 1.5000000000000002 then
                    begin
                        Result := 0.013762024881818815;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -55362432.999999993 then
                        begin
                            if features.path_max_segment_units <= 2.5000000000000004 then
                            begin
                                Result := -0.0049883906925164605;
                            end
                            else
                            begin
                                Result := 0.03261024787052276;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_suffix_score <= -5737.4999999999991 then
                            begin
                                if features.text_units <= 9.5000000000000018 then
                                begin
                                    Result := 0.014163490906309919;
                                end
                                else
                                begin
                                    Result := -0.0059210772230213387;
                                end;
                            end
                            else
                            begin
                                if features.score_per_unit <= 12356.500000000002 then
                                begin
                                    if features.chain_second_stage_score <= 37882503.500000007 then
                                    begin
                                        Result := 0.016075953837495213;
                                    end
                                    else
                                    begin
                                        if features.char_lm_suffix_score <= -4870.4999999999991 then
                                        begin
                                            Result := -0.0078877804024719642;
                                        end
                                        else
                                        begin
                                            Result := 0.010073626091113575;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.024304408039566121;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_21(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_second_stage_score <= -20468598.999999996 then
        begin
            if features.char_lm_score <= -7067.4999999999991 then
            begin
                Result := 0.00050440189761431081;
            end
            else
            begin
                Result := 0.026037466410913385;
            end;
        end
        else
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                Result := 0.037439975100570067;
            end
            else
            begin
                Result := 0.026533442571109445;
            end;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.040334242587457755;
            end
            else
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    Result := -0.011941367784566915;
                end
                else
                begin
                    if features.char_lm_context_score <= -11066.499999999998 then
                    begin
                        Result := 0.023275645460188319;
                    end
                    else
                    begin
                        if features.score_per_unit <= 35838.000000000007 then
                        begin
                            Result := -0.032927596573757316;
                        end
                        else
                        begin
                            Result := 0.012113812575592886;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.legacy_rank <= 2.5000000000000004 then
            begin
                if features.chain_second_stage_score <= -64024275.499999993 then
                begin
                    if features.path_max_segment_units <= 2.5000000000000004 then
                    begin
                        Result := -0.0030121640692402176;
                    end
                    else
                    begin
                        if features.char_lm_score <= -6772.4999999999991 then
                        begin
                            Result := 0.046766674086991193;
                        end
                        else
                        begin
                            Result := 0.014254194283099257;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= 25555719.500000004 then
                    begin
                        if features.chain_first_stage_score <= 282672.00000000006 then
                        begin
                            if features.chain_first_stage_score <= 90784.500000000015 then
                            begin
                                if features.dict_weight_per_unit <= 6604.5000000000009 then
                                begin
                                    Result := 0.0010624000007217452;
                                end
                                else
                                begin
                                    if features.path_segments <= 3.5000000000000004 then
                                    begin
                                        Result := 0.0015436286413523254;
                                    end
                                    else
                                    begin
                                        Result := -0.014602239866204356;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_context_gain <= -769.49999999999989 then
                                begin
                                    Result := -0.0038209936101858961;
                                end
                                else
                                begin
                                    if features.dict_weight_per_unit <= 11017.500000000002 then
                                    begin
                                        if features.char_lm_context_gain <= -656.49999999999989 then
                                        begin
                                            Result := -0.015019908481676301;
                                        end
                                        else
                                        begin
                                            Result := 0.0074084265533050182;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.016261971963031634;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := -0.029026864190298571;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -6577.4999999999991 then
                        begin
                            Result := 0.014097096191129241;
                        end
                        else
                        begin
                            if features.char_lm_context_score <= -5878.4999999999991 then
                            begin
                                if features.chain_second_stage_score <= 47572848.000000007 then
                                begin
                                    if features.char_lm_score <= -4963.4999999999991 then
                                    begin
                                        Result := -0.015420808622018993;
                                    end
                                    else
                                    begin
                                        Result := 0.016197646538422806;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_suffix_score <= -5567.4999999999991 then
                                    begin
                                        Result := 0.012709946279134349;
                                    end
                                    else
                                    begin
                                        Result := -0.020989229427636452;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := 0.0068653922237983988;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.path_max_segment_units <= 3.5000000000000004 then
                begin
                    if features.char_lm_context_gain <= -989.49999999999989 then
                    begin
                        if features.chain_first_stage_score <= 18711.500000000004 then
                        begin
                            Result := -0.021038930654704212;
                        end
                        else
                        begin
                            Result := 0.005438509922177686;
                        end;
                    end
                    else
                    begin
                        Result := -0.029300259173658891;
                    end;
                end
                else
                begin
                    if features.chain_first_stage_score <= 253629.50000000003 then
                    begin
                        Result := -0.0055731741769734656;
                    end
                    else
                    begin
                        Result := 0.033962657221185591;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_22(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_score_gap <= -1.0000000180025095E-35 then
        begin
            if features.char_lm_score <= -7067.4999999999991 then
            begin
                Result := -0.0037509707614653636;
            end
            else
            begin
                if features.candidate_score <= 66757.000000000015 then
                begin
                    if features.dict_weight_per_unit <= 4263.5000000000009 then
                    begin
                        Result := 0.020309886735331732;
                    end
                    else
                    begin
                        Result := -0.026826542103807471;
                    end;
                end
                else
                begin
                    Result := 0.028508552978698455;
                end;
            end;
        end
        else
        begin
            if features.char_lm_score <= -6415.4999999999991 then
            begin
                Result := 0.028081406970947111;
            end
            else
            begin
                Result := 0.036925924123993273;
            end;
        end;
    end
    else
    begin
        if Ord(features.complete_match) <= 1.0000000180025095E-35 then
        begin
            Result := -0.040008986752265677;
        end
        else
        begin
            if features.legacy_rank <= 2.5000000000000004 then
            begin
                if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                begin
                    if features.score_per_unit <= 10810.500000000002 then
                    begin
                        Result := -0.0022047246049156748;
                    end
                    else
                    begin
                        if features.score_per_unit <= 24168.500000000004 then
                        begin
                            Result := -0.015226677382454822;
                        end
                        else
                        begin
                            Result := -0.0026520590252828054;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -35643245.499999993 then
                    begin
                        if features.score_per_unit <= 10722.500000000002 then
                        begin
                            if features.chain_score_gap <= -89371168.999999985 then
                            begin
                                Result := -0.03652216074833866;
                            end
                            else
                            begin
                                if features.path_single_segments <= 1.5000000000000002 then
                                begin
                                    Result := 0.0044011045440288891;
                                end
                                else
                                begin
                                    Result := -0.015052346342942073;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -6634.4999999999991 then
                            begin
                                Result := 0.027730833438569476;
                            end
                            else
                            begin
                                if features.path_max_segment_units <= 3.5000000000000004 then
                                begin
                                    if features.chain_score_gap <= -42757456.499999993 then
                                    begin
                                        Result := -0.0011960053754520228;
                                    end
                                    else
                                    begin
                                        Result := 0.022863870892303555;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.014535663153757905;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_score <= -3655.4999999999995 then
                        begin
                            if features.path_single_segments <= 1.5000000000000002 then
                            begin
                                Result := 0.016698373623022841;
                            end
                            else
                            begin
                                if features.chain_first_stage_score <= 174116.00000000003 then
                                begin
                                    Result := 0.0093874870303305886;
                                end
                                else
                                begin
                                    if features.char_lm_context_gain <= -675.49999999999989 then
                                    begin
                                        Result := -0.011876015598868504;
                                    end
                                    else
                                    begin
                                        Result := 0.0045654006918735609;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := -0.0088051766027740074;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_context_score <= -9852.4999999999982 then
                begin
                    if features.char_lm_score <= -6915.4999999999991 then
                    begin
                        Result := -0.0076168258112393888;
                    end
                    else
                    begin
                        Result := 0.028954504816725662;
                    end;
                end
                else
                begin
                    if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                    begin
                        Result := -0.033968884312880004;
                    end
                    else
                    begin
                        if features.char_lm_context_gain <= -1082.4999999999998 then
                        begin
                            if features.char_lm_score <= -4610.4999999999991 then
                            begin
                                Result := -0.0090917426269256606;
                            end
                            else
                            begin
                                Result := 0.03051393511935584;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -6228.4999999999991 then
                            begin
                                if features.candidate_score <= 148846.50000000003 then
                                begin
                                    Result := -0.03044729392614667;
                                end
                                else
                                begin
                                    Result := 0.020906661713856883;
                                end;
                            end
                            else
                            begin
                                if features.candidate_score <= 94252.500000000015 then
                                begin
                                    Result := 0.00010086410179401197;
                                end
                                else
                                begin
                                    Result := -0.037700314611529909;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_23(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_second_stage_score <= -20468598.999999996 then
        begin
            if features.char_lm_score <= -7067.4999999999991 then
            begin
                Result := -0.0032188920507263555;
            end
            else
            begin
                Result := 0.023920407115620351;
            end;
        end
        else
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                Result := 0.036522717354616978;
            end
            else
            begin
                if features.candidate_score <= 66757.000000000015 then
                begin
                    if features.chain_first_stage_score <= -66677.999999999985 then
                    begin
                        Result := 0.030779599710892135;
                    end
                    else
                    begin
                        Result := -0.016148445412271752;
                    end;
                end
                else
                begin
                    Result := 0.028431484919237492;
                end;
            end;
        end;
    end
    else
    begin
        if Ord(features.complete_match) <= 1.0000000180025095E-35 then
        begin
            Result := -0.039706028638612119;
        end
        else
        begin
            if features.legacy_rank <= 2.5000000000000004 then
            begin
                if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                begin
                    Result := -0.0080932135557526749;
                end
                else
                begin
                    if features.chain_score_gap <= -47595611.499999993 then
                    begin
                        if features.chain_second_stage_score <= -12721871.999999998 then
                        begin
                            if features.char_lm_context_score <= -6525.4999999999991 then
                            begin
                                if features.dict_weight_per_unit <= 10762.500000000002 then
                                begin
                                    Result := -0.01564738184278662;
                                end
                                else
                                begin
                                    if features.char_lm_context_score <= -7072.4999999999991 then
                                    begin
                                        Result := 0.010062361549091077;
                                    end
                                    else
                                    begin
                                        Result := -0.023575007589696832;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -73189794.499999985 then
                                begin
                                    Result := 0.0015341806349457204;
                                end
                                else
                                begin
                                    Result := 0.035748017678369687;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.text_units <= 7.5000000000000009 then
                            begin
                                Result := 0.012059770898306437;
                            end
                            else
                            begin
                                Result := -0.023522752553644066;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -64024275.499999993 then
                        begin
                            if features.path_max_segment_units <= 2.5000000000000004 then
                            begin
                                Result := 0.0037013640075535602;
                            end
                            else
                            begin
                                Result := 0.045279881750678007;
                            end;
                        end
                        else
                        begin
                            if features.path_single_segments <= 3.5000000000000004 then
                            begin
                                if features.chain_score_gap <= -9835736.4999999981 then
                                begin
                                    Result := 0.0023751910762972602;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= -38535230.499999993 then
                                    begin
                                        Result := -0.014196293759927309;
                                    end
                                    else
                                    begin
                                        Result := 0.012636992730716102;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.0049452564331189533;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                begin
                    if features.char_lm_context_score <= -9852.4999999999982 then
                    begin
                        Result := -0.0039322985860671981;
                    end
                    else
                    begin
                        if features.path_single_segments <= 4.5000000000000009 then
                        begin
                            Result := -0.034142972759248678;
                        end
                        else
                        begin
                            Result := 0.015411330291419363;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -9713.4999999999982 then
                    begin
                        Result := 0.030324888375711283;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -43548597.499999993 then
                        begin
                            if features.chain_first_stage_score <= 66275.500000000015 then
                            begin
                                Result := -0.0001789182367352758;
                            end
                            else
                            begin
                                if features.char_lm_score <= -6915.4999999999991 then
                                begin
                                    Result := 0.014592657857871207;
                                end
                                else
                                begin
                                    Result := -0.036480337551579166;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -18208077.499999996 then
                            begin
                                Result := 0.0081093979141111782;
                            end
                            else
                            begin
                                if features.dict_weight_per_unit <= 12830.000000000002 then
                                begin
                                    Result := -0.028391007834709693;
                                end
                                else
                                begin
                                    Result := 0.020615290379864964;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_24(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 1.5000000000000002 then
    begin
        if features.chain_second_stage_score <= -20468598.999999996 then
        begin
            if features.char_lm_suffix_score <= -8231.4999999999982 then
            begin
                Result := -0.016978518963458013;
            end
            else
            begin
                Result := 0.021912491050297536;
            end;
        end
        else
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                Result := 0.035976788168950197;
            end
            else
            begin
                Result := 0.023419412111837557;
            end;
        end;
    end
    else
    begin
        if Ord(features.complete_match) <= 1.0000000180025095E-35 then
        begin
            Result := -0.039440971128926264;
        end
        else
        begin
            if features.legacy_rank <= 2.5000000000000004 then
            begin
                if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                begin
                    Result := -0.0071536173578550964;
                end
                else
                begin
                    if features.chain_score_gap <= -35118691.999999993 then
                    begin
                        if features.score_per_unit <= 10722.500000000002 then
                        begin
                            if features.chain_score_gap <= -89371168.999999985 then
                            begin
                                Result := -0.036328526945598918;
                            end
                            else
                            begin
                                if features.text_units <= 18.500000000000004 then
                                begin
                                    Result := -0.010709674898454653;
                                end
                                else
                                begin
                                    Result := 0.014239692673243119;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -57796089.499999993 then
                            begin
                                Result := 0.019977452649332317;
                            end
                            else
                            begin
                                Result := -0.0033622141789173055;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -55362432.999999993 then
                        begin
                            if features.path_max_segment_units <= 2.5000000000000004 then
                            begin
                                Result := 0.0077630724176162525;
                            end
                            else
                            begin
                                Result := 0.040579723160697405;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -4963.4999999999991 then
                            begin
                                if features.path_single_segments <= 2.5000000000000004 then
                                begin
                                    Result := 0.0076603726950791699;
                                end
                                else
                                begin
                                    if features.text_units <= 10.500000000000002 then
                                    begin
                                        Result := 0.012676087467466859;
                                    end
                                    else
                                    begin
                                        Result := -0.011329279282924161;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_suffix_score <= -5737.4999999999991 then
                                begin
                                    Result := 0.033051469957564673;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -3655.4999999999995 then
                                    begin
                                        if features.char_lm_suffix_score <= -4870.4999999999991 then
                                        begin
                                            if features.score_per_unit <= 12356.500000000002 then
                                            begin
                                                if features.dict_weight <= 95798.500000000015 then
                                                begin
                                                    if features.chain_second_stage_score <= 86246410.500000015 then
                                                    begin
                                                        Result := 0.02341319490797646;
                                                    end
                                                    else
                                                    begin
                                                        Result := -0.015503198803374708;
                                                    end;
                                                end
                                                else
                                                begin
                                                    Result := -0.0065477123008198489;
                                                end;
                                            end
                                            else
                                            begin
                                                Result := 0.026127307861594964;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := 0.02999262824696915;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.char_lm_score <= -2561.4999999999995 then
                                        begin
                                            Result := -0.012219148270287354;
                                        end
                                        else
                                        begin
                                            Result := 0.029007679731892801;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                begin
                    if features.path_single_segments <= 4.5000000000000009 then
                    begin
                        Result := -0.030515565908765207;
                    end
                    else
                    begin
                        Result := 0.01235136385399903;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -43548597.499999993 then
                    begin
                        if features.chain_first_stage_score <= 66275.500000000015 then
                        begin
                            Result := 0.003265957431009511;
                        end
                        else
                        begin
                            Result := -0.033586918215516043;
                        end;
                    end
                    else
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            Result := -0.018686968628939895;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 15888871.000000002 then
                            begin
                                Result := 0.026908696474649756;
                            end
                            else
                            begin
                                Result := -0.013299177436365156;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_25(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 2.5000000000000004 then
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_second_stage_score <= -20468598.999999996 then
            begin
                if features.char_lm_suffix_score <= -7288.4999999999991 then
                begin
                    if features.char_lm_context_gain <= -807.49999999999989 then
                    begin
                        if features.candidate_score <= 86963.500000000015 then
                        begin
                            Result := -0.0061112856737451276;
                        end
                        else
                        begin
                            Result := 0.023430750035362588;
                        end;
                    end
                    else
                    begin
                        Result := -0.017452807031830022;
                    end;
                end
                else
                begin
                    Result := 0.023040689232943338;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.5000000000000002 then
                begin
                    Result := 0.035505935418579181;
                end
                else
                begin
                    Result := 0.022698864580925182;
                end;
            end;
        end
        else
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.03683155206792553;
            end
            else
            begin
                if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                begin
                    if features.candidate_score <= 48495.500000000007 then
                    begin
                        Result := 0.002890893027013711;
                    end
                    else
                    begin
                        Result := -0.010516976731032589;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -35118691.999999993 then
                    begin
                        if features.chain_second_stage_score <= -19121511.999999996 then
                        begin
                            if features.char_lm_context_score <= -6577.4999999999991 then
                            begin
                                if features.path_single_segments <= 3.5000000000000004 then
                                begin
                                    if features.char_lm_context_score <= -8871.4999999999982 then
                                    begin
                                        Result := -0.031005056776281719;
                                    end
                                    else
                                    begin
                                        if features.chain_score_gap <= -89371168.999999985 then
                                        begin
                                            Result := -0.012416112468763374;
                                        end
                                        else
                                        begin
                                            if features.chain_second_stage_score <= -55362432.999999993 then
                                            begin
                                                Result := 0.022531397463015454;
                                            end
                                            else
                                            begin
                                                if features.chain_score_gap <= -45818588.499999993 then
                                                begin
                                                    if features.dict_weight_per_unit <= 780.50000000000011 then
                                                    begin
                                                        Result := 0.024579651915588328;
                                                    end
                                                    else
                                                    begin
                                                        Result := -0.014141685749915431;
                                                    end;
                                                end
                                                else
                                                begin
                                                    Result := 0.017236807935237932;
                                                end;
                                            end;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.02797348387891219;
                                end;
                            end
                            else
                            begin
                                Result := 0.022959589095682503;
                            end;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -77340656.499999985 then
                            begin
                                Result := -0.029184693770902478;
                            end
                            else
                            begin
                                Result := -0.0079842826899181006;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -60934688.499999993 then
                        begin
                            if features.path_max_segment_units <= 2.5000000000000004 then
                            begin
                                Result := 0.0082958824408877977;
                            end
                            else
                            begin
                                Result := 0.047795770722616301;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -30639080.499999996 then
                            begin
                                Result := -0.0073880899291059246;
                            end
                            else
                            begin
                                Result := 0.0085744316922086138;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end
    else
    begin
        if features.chain_first_stage_score <= 1.0000000180025095E-35 then
        begin
            if features.path_single_segments <= 4.5000000000000009 then
            begin
                Result := -0.038865828289567778;
            end
            else
            begin
                Result := 0.005618923658531139;
            end;
        end
        else
        begin
            if features.char_lm_suffix_score <= -7165.4999999999991 then
            begin
                if features.candidate_score <= 125142.00000000001 then
                begin
                    Result := -0.0080230779044113323;
                end
                else
                begin
                    Result := 0.03553155578568732;
                end;
            end
            else
            begin
                if features.candidate_score <= 181962.00000000003 then
                begin
                    if features.candidate_score <= 95731.000000000015 then
                    begin
                        Result := -0.00024986599154201423;
                    end
                    else
                    begin
                        if features.char_lm_context_gain <= -1107.4999999999998 then
                        begin
                            Result := 0.0012431014675056754;
                        end
                        else
                        begin
                            Result := -0.041278992751921255;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.0042759247978451766;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_26(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 2.5000000000000004 then
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_second_stage_score <= -27494981.499999996 then
            begin
                if features.char_lm_suffix_score <= -7785.4999999999991 then
                begin
                    Result := -0.01124555336552864;
                end
                else
                begin
                    if features.score_per_unit <= 8684.5000000000018 then
                    begin
                        if features.chain_score_gap <= -62524478.999999993 then
                        begin
                            Result := -0.012168103150732313;
                        end
                        else
                        begin
                            if features.char_lm_suffix_score <= -6134.4999999999991 then
                            begin
                                Result := 0.0043582470080413029;
                            end
                            else
                            begin
                                Result := 0.034662406224867368;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.026467112554647378;
                    end;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.5000000000000002 then
                begin
                    Result := 0.035148926867300576;
                end
                else
                begin
                    if features.candidate_score <= 66757.000000000015 then
                    begin
                        if features.chain_first_stage_score <= -66677.999999999985 then
                        begin
                            Result := 0.029985142955295061;
                        end
                        else
                        begin
                            Result := -0.014452632340272491;
                        end;
                    end
                    else
                    begin
                        Result := 0.026462470730966994;
                    end;
                end;
            end;
        end
        else
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.03649136245110686;
            end
            else
            begin
                if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
                begin
                    if features.chain_score_gap <= -35118691.999999993 then
                    begin
                        if features.chain_second_stage_score <= -19121511.999999996 then
                        begin
                            if features.candidate_score <= 95731.000000000015 then
                            begin
                                if features.char_lm_score <= -4963.4999999999991 then
                                begin
                                    Result := -0.024779735040386171;
                                end
                                else
                                begin
                                    Result := 0.012692404675068134;
                                end;
                            end
                            else
                            begin
                                Result := 0.0082176608912628655;
                            end;
                        end
                        else
                        begin
                            Result := -0.012586195244398732;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -55362432.999999993 then
                        begin
                            if features.path_segments <= 8.5000000000000018 then
                            begin
                                if features.path_max_segment_units <= 2.5000000000000004 then
                                begin
                                    Result := 0.010173031824124526;
                                end
                                else
                                begin
                                    Result := 0.05220746911747174;
                                end;
                            end
                            else
                            begin
                                Result := 0.0032292096210377024;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 17062271.000000004 then
                            begin
                                if features.path_single_segments <= 1.5000000000000002 then
                                begin
                                    Result := 0.0053470900967181765;
                                end
                                else
                                begin
                                    Result := -0.0035149676902272568;
                                end;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -10732023.999999998 then
                                begin
                                    Result := 0.0013559364665814619;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= 142895111.00000003 then
                                    begin
                                        if features.chain_first_stage_score <= 176271.50000000003 then
                                        begin
                                            Result := 0.020569968749073308;
                                        end
                                        else
                                        begin
                                            if features.chain_score_gap <= -1.0000000180025095E-35 then
                                            begin
                                                Result := 0.027467203918784509;
                                            end
                                            else
                                            begin
                                                Result := -0.010284149544822334;
                                            end;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.00937964436765161;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_score <= -3940.4999999999995 then
                    begin
                        Result := -0.016673357894223258;
                    end
                    else
                    begin
                        Result := 0.0077135286943046848;
                    end;
                end;
            end;
        end;
    end
    else
    begin
        if features.chain_first_stage_score <= 18711.500000000004 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.038972274932674758;
            end
            else
            begin
                Result := -0.027815245872482391;
            end;
        end
        else
        begin
            if features.char_lm_suffix_score <= -7165.4999999999991 then
            begin
                if features.candidate_score <= 125142.00000000001 then
                begin
                    Result := -0.010689663710208477;
                end
                else
                begin
                    Result := 0.034492015868082759;
                end;
            end
            else
            begin
                Result := -0.014785372491134914;
            end;
        end;
    end;
end;

function long_final_ranker_tree_27(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 2.5000000000000004 then
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_second_stage_score <= -20468598.999999996 then
            begin
                if features.char_lm_suffix_score <= -7562.4999999999991 then
                begin
                    if features.path_segments <= 6.5000000000000009 then
                    begin
                        Result := 0.015546047119443766;
                    end
                    else
                    begin
                        Result := -0.024954709223155458;
                    end;
                end
                else
                begin
                    Result := 0.021073320397980485;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.5000000000000002 then
                begin
                    Result := 0.034722227166227346;
                end
                else
                begin
                    if features.candidate_score <= 66757.000000000015 then
                    begin
                        if features.chain_first_stage_score <= -66677.999999999985 then
                        begin
                            Result := 0.02750954424136821;
                        end
                        else
                        begin
                            Result := -0.014151645649072179;
                        end;
                    end
                    else
                    begin
                        Result := 0.024340740071165563;
                    end;
                end;
            end;
        end
        else
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.036139618303357171;
            end
            else
            begin
                if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                begin
                    Result := -0.0060285362635019175;
                end
                else
                begin
                    if features.chain_score_gap <= -20341703.499999996 then
                    begin
                        if features.chain_second_stage_score <= 11301783.000000002 then
                        begin
                            if features.candidate_score <= 106328.00000000001 then
                            begin
                                if features.char_lm_suffix_score <= -6023.4999999999991 then
                                begin
                                    Result := -0.025028620455476644;
                                end
                                else
                                begin
                                    Result := 0.0075024847704585305;
                                end;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -52040049.499999993 then
                                begin
                                    if features.char_lm_context_score <= -6525.4999999999991 then
                                    begin
                                        if features.chain_second_stage_score <= -55362432.999999993 then
                                        begin
                                            Result := 0.0086105575459318046;
                                        end
                                        else
                                        begin
                                            Result := -0.017527064705065362;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.char_lm_context_score <= -6152.4999999999991 then
                                        begin
                                            Result := 0.02666937094842774;
                                        end
                                        else
                                        begin
                                            Result := -0.0085714866724205217;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.017748246095849247;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.candidate_score <= 95731.000000000015 then
                            begin
                                if features.dict_weight <= 75154.500000000015 then
                                begin
                                    Result := -0.013928901121102318;
                                end
                                else
                                begin
                                    Result := 0.017158408413545618;
                                end;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -55593910.999999993 then
                                begin
                                    Result := -0.034160023298723051;
                                end
                                else
                                begin
                                    Result := -0.0081608866073058957;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -60934688.499999993 then
                        begin
                            Result := 0.043963170626530004;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 8106950.0000000009 then
                            begin
                                Result := 0.0021914742118594511;
                            end
                            else
                            begin
                                if features.text_units <= 9.5000000000000018 then
                                begin
                                    if features.chain_score_gap <= -1.0000000180025095E-35 then
                                    begin
                                        Result := 0.0019709591502424894;
                                    end
                                    else
                                    begin
                                        Result := 0.034366720398023506;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.010333321430757313;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end
    else
    begin
        if Ord(features.complete_dictionary) <= 1.0000000180025095E-35 then
        begin
            if features.path_max_segment_units <= 6.5000000000000009 then
            begin
                Result := -0.038763766430202712;
            end
            else
            begin
                if features.path_max_segment_units <= 7.5000000000000009 then
                begin
                    Result := 0.004586287655376017;
                end
                else
                begin
                    Result := -0.029702690542168845;
                end;
            end;
        end
        else
        begin
            if features.char_lm_context_gain <= -1758.4999999999998 then
            begin
                Result := 0.011424362178533261;
            end
            else
            begin
                if features.path_segments <= 10.500000000000002 then
                begin
                    Result := -0.019010999595617372;
                end
                else
                begin
                    Result := 0.0087506844905162438;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_28(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.038547147107426266;
    end
    else
    begin
        if Ord(features.legacy_top) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
            begin
                if features.chain_score_gap <= -59742350.999999993 then
                begin
                    if features.chain_second_stage_score <= -6376268.4999999991 then
                    begin
                        if features.chain_score_gap <= -122461489.49999999 then
                        begin
                            Result := -0.02222254890405579;
                        end
                        else
                        begin
                            Result := 0.0;
                        end;
                    end
                    else
                    begin
                        Result := -0.025831636381993175;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= -60934688.499999993 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            Result := 0.00085720097130219657;
                        end
                        else
                        begin
                            if features.path_segments <= 8.5000000000000018 then
                            begin
                                Result := 0.045269545235635485;
                            end
                            else
                            begin
                                Result := -0.00013211243589513562;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -6451.4999999999991 then
                        begin
                            if features.chain_score_gap <= -37824125.499999993 then
                            begin
                                Result := -0.021751033368651883;
                            end
                            else
                            begin
                                if features.score_per_unit <= 16409.000000000004 then
                                begin
                                    Result := 0.0013707254956132316;
                                end
                                else
                                begin
                                    if features.char_lm_context_gain <= -2134.4999999999995 then
                                    begin
                                        Result := 0.016302588384812324;
                                    end
                                    else
                                    begin
                                        Result := -0.022142503434410848;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                            begin
                                Result := -0.0028584785501456831;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -9835736.4999999981 then
                                begin
                                    if features.chain_second_stage_score <= 14389599.500000002 then
                                    begin
                                        Result := 0.013577155460951699;
                                    end
                                    else
                                    begin
                                        if features.text_units <= 11.500000000000002 then
                                        begin
                                            Result := 0.0061368945655206845;
                                        end
                                        else
                                        begin
                                            Result := -0.0092043745468809619;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    if features.text_units <= 9.5000000000000018 then
                                    begin
                                        Result := 0.03385722061163985;
                                    end
                                    else
                                    begin
                                        if features.chain_score_gap <= -999794.49999999988 then
                                        begin
                                            Result := 0.024526439602794135;
                                        end
                                        else
                                        begin
                                            if features.char_lm_context_gain <= -524.49999999999989 then
                                            begin
                                                if features.candidate_score <= 94252.500000000015 then
                                                begin
                                                    Result := -0.017082948416621602;
                                                end
                                                else
                                                begin
                                                    if features.char_lm_context_gain <= -769.49999999999989 then
                                                    begin
                                                        Result := -0.00046797245630549413;
                                                    end
                                                    else
                                                    begin
                                                        Result := 0.020922021960096744;
                                                    end;
                                                end;
                                            end
                                            else
                                            begin
                                                if features.char_lm_suffix_score <= -5685.4999999999991 then
                                                begin
                                                    Result := -0.029363459072317785;
                                                end
                                                else
                                                begin
                                                    Result := 0.0022957547370657696;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.score_per_unit <= 24168.500000000004 then
                begin
                    Result := -0.023254824421115549;
                end
                else
                begin
                    Result := 0.0;
                end;
            end;
        end
        else
        begin
            if features.chain_second_stage_score <= -20468598.999999996 then
            begin
                if features.score_per_unit <= 9317.5000000000018 then
                begin
                    if features.char_lm_suffix_score <= -7227.4999999999991 then
                    begin
                        Result := -0.013289092937066344;
                    end
                    else
                    begin
                        Result := 0.014526125523569198;
                    end;
                end
                else
                begin
                    Result := 0.024645298993677529;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.5000000000000002 then
                begin
                    Result := 0.034225159525513527;
                end
                else
                begin
                    if features.candidate_score <= 66757.000000000015 then
                    begin
                        if features.chain_first_stage_score <= -32045.499999999996 then
                        begin
                            Result := 0.02562719626518702;
                        end
                        else
                        begin
                            Result := -0.017448212333378982;
                        end;
                    end
                    else
                    begin
                        Result := 0.024608405948398956;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_29(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.038360632442209712;
    end
    else
    begin
        if Ord(features.legacy_top) <= 1.0000000180025095E-35 then
        begin
            if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
            begin
                if features.path_single_segments <= 3.5000000000000004 then
                begin
                    if features.chain_second_stage_score <= -64024275.499999993 then
                    begin
                        if features.dict_weight_per_unit <= 10762.500000000002 then
                        begin
                            if features.chain_second_stage_score <= -79482274.999999985 then
                            begin
                                Result := -0.012867555491484257;
                            end
                            else
                            begin
                                if features.path_max_segment_units <= 2.5000000000000004 then
                                begin
                                    Result := -0.0049710279804814732;
                                end
                                else
                                begin
                                    Result := 0.027440822610257574;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.040044116194612969;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -6023.4999999999991 then
                        begin
                            if features.dict_weight_per_unit <= 26998.000000000004 then
                            begin
                                if features.char_lm_context_gain <= -730.49999999999989 then
                                begin
                                    if features.char_lm_context_gain <= -1218.4999999999998 then
                                    begin
                                        if features.path_segments <= 3.5000000000000004 then
                                        begin
                                            Result := 0.018411634260713749;
                                        end
                                        else
                                        begin
                                            Result := -0.0011743320278476657;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.candidate_score <= 29431.500000000004 then
                                        begin
                                            Result := 0.024648527401063269;
                                        end
                                        else
                                        begin
                                            if features.candidate_score <= 154940.50000000003 then
                                            begin
                                                Result := -0.013936089165872197;
                                            end
                                            else
                                            begin
                                                if features.chain_second_stage_score <= -11925513.999999998 then
                                                begin
                                                    Result := 0.0203615054584711;
                                                end
                                                else
                                                begin
                                                    Result := -0.012614336551720203;
                                                end;
                                            end;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= -38535230.499999993 then
                                    begin
                                        Result := -0.019281169447770651;
                                    end
                                    else
                                    begin
                                        if features.chain_first_stage_score <= 102476.50000000001 then
                                        begin
                                            Result := -0.0049450491705468448;
                                        end
                                        else
                                        begin
                                            Result := 0.015484983242427109;
                                        end;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.031495802958968443;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -3655.4999999999995 then
                            begin
                                Result := 0.0085536923710448701;
                            end
                            else
                            begin
                                if features.char_lm_score <= -2819.4999999999995 then
                                begin
                                    Result := -0.015317776827243891;
                                end
                                else
                                begin
                                    Result := 0.015131485786607791;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 112772.00000000001 then
                    begin
                        if features.chain_first_stage_score <= 222987.00000000003 then
                        begin
                            Result := -0.023324570320908802;
                        end
                        else
                        begin
                            Result := 0.020129229952586342;
                        end;
                    end
                    else
                    begin
                        Result := -0.00073759417871560237;
                    end;
                end;
            end
            else
            begin
                if features.score_per_unit <= 24168.500000000004 then
                begin
                    Result := -0.022750258097110586;
                end
                else
                begin
                    Result := 0.0013094594142832822;
                end;
            end;
        end
        else
        begin
            if features.chain_second_stage_score <= -20468598.999999996 then
            begin
                if features.char_lm_suffix_score <= -7288.4999999999991 then
                begin
                    if features.chain_first_stage_score <= 77616.500000000015 then
                    begin
                        Result := -0.026800816112156296;
                    end
                    else
                    begin
                        if features.char_lm_context_gain <= -882.49999999999989 then
                        begin
                            Result := 0.024352935277307714;
                        end
                        else
                        begin
                            Result := -0.0057940884319870019;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.021260155866251088;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.5000000000000002 then
                begin
                    Result := 0.033843931387389226;
                end
                else
                begin
                    if features.candidate_score <= 66757.000000000015 then
                    begin
                        if features.chain_first_stage_score <= -66677.999999999985 then
                        begin
                            Result := 0.02895015249011372;
                        end
                        else
                        begin
                            Result := -0.025449536251212119;
                        end;
                    end
                    else
                    begin
                        Result := 0.023017106531043413;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_30(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 2.5000000000000004 then
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_second_stage_score <= -20468598.999999996 then
            begin
                if features.char_lm_suffix_score <= -7562.4999999999991 then
                begin
                    if features.chain_first_stage_score <= 80098.500000000015 then
                    begin
                        Result := -0.030796871489551108;
                    end
                    else
                    begin
                        if features.char_lm_context_gain <= -807.49999999999989 then
                        begin
                            Result := 0.01802249668436999;
                        end
                        else
                        begin
                            Result := -0.015780982328365615;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.01674847564240517;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.5000000000000002 then
                begin
                    Result := 0.033434186141904847;
                end
                else
                begin
                    if features.candidate_score <= 66757.000000000015 then
                    begin
                        if features.chain_first_stage_score <= -13807.499999999998 then
                        begin
                            Result := 0.01932593949348059;
                        end
                        else
                        begin
                            Result := -0.016183229738622792;
                        end;
                    end
                    else
                    begin
                        Result := 0.022066346249301014;
                    end;
                end;
            end;
        end
        else
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.035198935800858991;
            end
            else
            begin
                if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                begin
                    Result := -0.0034572899771548025;
                end
                else
                begin
                    if features.chain_score_gap <= -44289925.999999993 then
                    begin
                        if features.candidate_score <= 66757.000000000015 then
                        begin
                            Result := -0.027558312724118281;
                        end
                        else
                        begin
                            if features.chain_rank <= 2.5000000000000004 then
                            begin
                                if features.char_lm_suffix_score <= -6134.4999999999991 then
                                begin
                                    if features.char_lm_suffix_score <= -7102.4999999999991 then
                                    begin
                                        Result := 0.0034808352246328729;
                                    end
                                    else
                                    begin
                                        Result := -0.022829965427449247;
                                    end;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= 17062271.000000004 then
                                    begin
                                        Result := 0.014188329979907295;
                                    end
                                    else
                                    begin
                                        if features.text_units <= 8.5000000000000018 then
                                        begin
                                            Result := 0.023445000343585602;
                                        end
                                        else
                                        begin
                                            Result := -0.015447111605750005;
                                        end;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := 0.017453621992147353;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -60934688.499999993 then
                        begin
                            if features.candidate_score <= 95731.000000000015 then
                            begin
                                Result := 0.0;
                            end
                            else
                            begin
                                Result := 0.038676001132411056;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -4963.4999999999991 then
                            begin
                                if features.dict_weight_per_unit <= 10476.500000000002 then
                                begin
                                    Result := -0.0037119756961085629;
                                end
                                else
                                begin
                                    if features.chain_first_stage_score <= 270949.50000000006 then
                                    begin
                                        Result := 0.0098033211167206681;
                                    end
                                    else
                                    begin
                                        Result := -0.017227451603553628;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_suffix_score <= -5737.4999999999991 then
                                begin
                                    Result := 0.032939388622215779;
                                end
                                else
                                begin
                                    if features.chain_score_gap <= -9260846.9999999981 then
                                    begin
                                        if features.dict_weight <= 95798.500000000015 then
                                        begin
                                            Result := 0.016331714308444271;
                                        end
                                        else
                                        begin
                                            Result := -0.0019510205614499912;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.017331456811415277;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end
    else
    begin
        if features.chain_first_stage_score <= 18711.500000000004 then
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.038214025957638315;
            end
            else
            begin
                Result := -0.026055602831554954;
            end;
        end
        else
        begin
            if features.char_lm_suffix_score <= -7165.4999999999991 then
            begin
                if features.candidate_score <= 125142.00000000001 then
                begin
                    Result := -0.008352751908862685;
                end
                else
                begin
                    Result := 0.035360135353318854;
                end;
            end
            else
            begin
                Result := -0.017075378992371385;
            end;
        end;
    end;
end;

function long_final_ranker_tree_31(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 2.5000000000000004 then
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_second_stage_score <= -20468598.999999996 then
            begin
                if features.char_lm_suffix_score <= -7227.4999999999991 then
                begin
                    if features.path_segments <= 6.5000000000000009 then
                    begin
                        if features.candidate_score <= 86963.500000000015 then
                        begin
                            Result := -0.018240067642731988;
                        end
                        else
                        begin
                            Result := 0.02637435127312452;
                        end;
                    end
                    else
                    begin
                        Result := -0.019657094117392346;
                    end;
                end
                else
                begin
                    Result := 0.018221150303216496;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.5000000000000002 then
                begin
                    if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.034844319015065829;
                    end
                    else
                    begin
                        Result := 0.030333790159202293;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 66757.000000000015 then
                    begin
                        if features.char_lm_score <= -4096.4999999999991 then
                        begin
                            Result := -0.025162857068420391;
                        end
                        else
                        begin
                            Result := 0.013339275999151636;
                        end;
                    end
                    else
                    begin
                        Result := 0.02138626122637486;
                    end;
                end;
            end;
        end
        else
        begin
            if Ord(features.partial_match) <= 1.0000000180025095E-35 then
            begin
                if features.chain_score_gap <= -59742350.999999993 then
                begin
                    Result := -0.011544355713372636;
                end
                else
                begin
                    if features.chain_rank <= 1.0000000180025095E-35 then
                    begin
                        Result := -0.0051622418390623011;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -55362432.999999993 then
                        begin
                            if features.path_max_segment_units <= 2.5000000000000004 then
                            begin
                                if features.candidate_score <= 118326.00000000001 then
                                begin
                                    if features.chain_first_stage_score <= 55406.000000000007 then
                                    begin
                                        Result := 0.014142630008279812;
                                    end
                                    else
                                    begin
                                        Result := -0.034001638225151842;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.025124117127674844;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_context_score <= -7731.4999999999991 then
                                begin
                                    Result := 0.043698081650262267;
                                end
                                else
                                begin
                                    Result := 0.0040339842726116459;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.path_single_segments <= 1.5000000000000002 then
                            begin
                                if features.char_lm_score <= -3724.4999999999995 then
                                begin
                                    if features.chain_score_gap <= -35643245.499999993 then
                                    begin
                                        Result := -0.001224786450826442;
                                    end
                                    else
                                    begin
                                        if features.char_lm_context_score <= -7671.4999999999991 then
                                        begin
                                            Result := 0.0048474662036599343;
                                        end
                                        else
                                        begin
                                            Result := 0.02440387067463325;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.010361120267163999;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_score <= -6772.4999999999991 then
                                begin
                                    Result := -0.01848161734140286;
                                end
                                else
                                begin
                                    Result := 0.0047936155566626459;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := -0.034875667498775624;
            end;
        end;
    end
    else
    begin
        if Ord(features.partial_match) <= 1.0000000180025095E-35 then
        begin
            if features.char_lm_context_score <= -9852.4999999999982 then
            begin
                Result := 0.013720167600095364;
            end
            else
            begin
                if features.chain_first_stage_score <= 148576.00000000003 then
                begin
                    if features.chain_score_gap <= -20341703.499999996 then
                    begin
                        if features.chain_score_gap <= -27022060.999999996 then
                        begin
                            Result := -0.020263676079903235;
                        end
                        else
                        begin
                            Result := 0.028775571334106718;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_score <= -3258.4999999999995 then
                        begin
                            Result := -0.029577019325366636;
                        end
                        else
                        begin
                            Result := 0.022846138716741224;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -7671.4999999999991 then
                    begin
                        Result := 0.023390281565618728;
                    end
                    else
                    begin
                        Result := -0.011430491647437762;
                    end;
                end;
            end;
        end
        else
        begin
            Result := -0.038068562339193084;
        end;
    end;
end;

function long_final_ranker_tree_32(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 2.5000000000000004 then
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_second_stage_score <= -20468598.999999996 then
            begin
                if features.char_lm_suffix_score <= -7227.4999999999991 then
                begin
                    if features.path_segments <= 6.5000000000000009 then
                    begin
                        if features.candidate_score <= 86963.500000000015 then
                        begin
                            Result := -0.0067991610125861827;
                        end
                        else
                        begin
                            Result := 0.024697596893535984;
                        end;
                    end
                    else
                    begin
                        if features.chain_first_stage_score <= 129742.50000000001 then
                        begin
                            Result := -0.031958671152956426;
                        end
                        else
                        begin
                            Result := 0.00027305954324371865;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.017804822972515521;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.5000000000000002 then
                begin
                    if features.chain_first_stage_score <= 10622.000000000002 then
                    begin
                        Result := 0.034433468457204193;
                    end
                    else
                    begin
                        Result := 0.029815039700082441;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 66757.000000000015 then
                    begin
                        if features.char_lm_context_score <= -6049.4999999999991 then
                        begin
                            Result := -0.025963969069327384;
                        end
                        else
                        begin
                            Result := 0.011860924910840794;
                        end;
                    end
                    else
                    begin
                        Result := 0.021655750748754577;
                    end;
                end;
            end;
        end
        else
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.03454657526546473;
            end
            else
            begin
                if features.chain_second_stage_score <= -60934688.499999993 then
                begin
                    if features.path_max_segment_units <= 2.5000000000000004 then
                    begin
                        Result := -0.00070694913598944367;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -8679.4999999999982 then
                        begin
                            Result := 0.049198911162857295;
                        end
                        else
                        begin
                            Result := 0.015949108291738182;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= 1.0000000180025095E-35 then
                    begin
                        if features.chain_first_stage_score <= 87820.000000000015 then
                        begin
                            if features.chain_second_stage_score <= -47514492.499999993 then
                            begin
                                Result := -0.032452154920754678;
                            end
                            else
                            begin
                                Result := -0.0039155692282031047;
                            end;
                        end
                        else
                        begin
                            Result := 0.0037003030650428824;
                        end;
                    end
                    else
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            if features.path_segments <= 6.5000000000000009 then
                            begin
                                Result := 0.020506849269269652;
                            end
                            else
                            begin
                                Result := 0.0046914995916911744;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 142895111.00000003 then
                            begin
                                if features.char_lm_context_gain <= -1035.4999999999998 then
                                begin
                                    if features.dict_weight_per_unit <= 11415.000000000002 then
                                    begin
                                        Result := -0.028658864766563302;
                                    end
                                    else
                                    begin
                                        Result := 0.0058464677074995149;
                                    end;
                                end
                                else
                                begin
                                    if features.path_segments <= 5.5000000000000009 then
                                    begin
                                        if features.char_lm_context_score <= -6049.4999999999991 then
                                        begin
                                            Result := 0.03066203776721774;
                                        end
                                        else
                                        begin
                                            Result := 0.0;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.00090288823516039313;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.024313032875822725;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end
    else
    begin
        if Ord(features.complete_match) <= 1.0000000180025095E-35 then
        begin
            Result := -0.037913709345405881;
        end
        else
        begin
            if features.path_max_segment_units <= 7.5000000000000009 then
            begin
                if features.path_max_segment_units <= 3.5000000000000004 then
                begin
                    if features.char_lm_context_gain <= -1012.4999999999999 then
                    begin
                        Result := -0.0035932560967346901;
                    end
                    else
                    begin
                        Result := -0.025811411502225667;
                    end;
                end
                else
                begin
                    Result := 0.0090212765436500832;
                end;
            end
            else
            begin
                if features.chain_first_stage_score <= 43010.000000000007 then
                begin
                    Result := -0.030132776799011513;
                end
                else
                begin
                    Result := 0.00086310285414270148;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_33(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 2.5000000000000004 then
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_second_stage_score <= -20468598.999999996 then
            begin
                if features.char_lm_score <= -7467.9999999999991 then
                begin
                    Result := -0.027479343591318813;
                end
                else
                begin
                    if features.score_per_unit <= 9317.5000000000018 then
                    begin
                        if features.path_single_segments <= 3.5000000000000004 then
                        begin
                            if features.char_lm_score <= -5224.4999999999991 then
                            begin
                                Result := 0.0052575608115992874;
                            end
                            else
                            begin
                                Result := 0.029371006163404247;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_score <= -7915.4999999999991 then
                            begin
                                Result := -0.04443308038215063;
                            end
                            else
                            begin
                                Result := 0.00089123516399370218;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -100903400.99999999 then
                        begin
                            Result := -0.010412921318579091;
                        end
                        else
                        begin
                            Result := 0.021675233246995267;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.5000000000000002 then
                begin
                    if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.034160243554882626;
                    end
                    else
                    begin
                        Result := 0.029119209252727138;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 66757.000000000015 then
                    begin
                        if features.char_lm_score <= -4096.4999999999991 then
                        begin
                            Result := -0.027766033808471435;
                        end
                        else
                        begin
                            Result := 0.010507227945360399;
                        end;
                    end
                    else
                    begin
                        Result := 0.021887926944777789;
                    end;
                end;
            end;
        end
        else
        begin
            if Ord(features.partial_match) <= 1.0000000180025095E-35 then
            begin
                if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                begin
                    if features.score_per_unit <= 10810.500000000002 then
                    begin
                        Result := 0.0031152912995525408;
                    end
                    else
                    begin
                        Result := -0.0082163599301662196;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -49674397.499999993 then
                    begin
                        if features.chain_second_stage_score <= -6376268.4999999991 then
                        begin
                            if features.char_lm_context_score <= -6525.4999999999991 then
                            begin
                                Result := -0.0062936223708564033;
                            end
                            else
                            begin
                                Result := 0.020593759677559532;
                            end;
                        end
                        else
                        begin
                            Result := -0.014299296496317823;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -60934688.499999993 then
                        begin
                            if features.path_segments <= 8.5000000000000018 then
                            begin
                                Result := 0.039493175242969372;
                            end
                            else
                            begin
                                Result := 0.0030753161653389147;
                            end;
                        end
                        else
                        begin
                            if features.path_single_segments <= 3.5000000000000004 then
                            begin
                                if features.char_lm_score <= -4963.4999999999991 then
                                begin
                                    Result := 0.0064771035581322762;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= 53256438.500000007 then
                                    begin
                                        Result := 0.027543832291821974;
                                    end
                                    else
                                    begin
                                        if features.chain_score_gap <= -20341703.499999996 then
                                        begin
                                            Result := -0.001758856390205952;
                                        end
                                        else
                                        begin
                                            Result := 0.013635753432977944;
                                        end;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.0037704135182943612;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := -0.034265860445289217;
            end;
        end;
    end
    else
    begin
        if Ord(features.partial_match) <= 1.0000000180025095E-35 then
        begin
            if features.chain_first_stage_score <= 1.0000000180025095E-35 then
            begin
                if features.score_per_unit <= 23506.500000000004 then
                begin
                    if features.path_single_segments <= 4.5000000000000009 then
                    begin
                        Result := -0.027643932396332335;
                    end
                    else
                    begin
                        Result := 0.01267323194669564;
                    end;
                end
                else
                begin
                    Result := 0.0051631429255328621;
                end;
            end
            else
            begin
                if features.score_per_unit <= 12903.500000000002 then
                begin
                    Result := -0.0075202456393019231;
                end
                else
                begin
                    Result := 0.023402298950651275;
                end;
            end;
        end
        else
        begin
            Result := -0.037792422044350842;
        end;
    end;
end;

function long_final_ranker_tree_34(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.037652729729872422;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                if features.chain_first_stage_score <= 10622.000000000002 then
                begin
                    if features.path_segments <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.026100204283502126;
                    end
                    else
                    begin
                        Result := 0.035185320881013102;
                    end;
                end
                else
                begin
                    if features.char_lm_suffix_score <= -8045.4999999999991 then
                    begin
                        Result := -0.017912495447013017;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -6492.4999999999991 then
                        begin
                            if features.chain_first_stage_score <= 102476.50000000001 then
                            begin
                                if features.char_lm_suffix_score <= -7018.4999999999991 then
                                begin
                                    Result := -0.009529410317092573;
                                end
                                else
                                begin
                                    Result := 0.023442865619501631;
                                end;
                            end
                            else
                            begin
                                Result := 0.022161519428099598;
                            end;
                        end
                        else
                        begin
                            Result := 0.029227490131956416;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.candidate_score <= 66757.000000000015 then
                begin
                    if features.char_lm_context_score <= -6101.4999999999991 then
                    begin
                        Result := -0.024818312536890787;
                    end
                    else
                    begin
                        Result := 0.010443274873411451;
                    end;
                end
                else
                begin
                    Result := 0.018402380306675032;
                end;
            end;
        end
        else
        begin
            if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
            begin
                if features.path_single_segments <= 1.5000000000000002 then
                begin
                    if features.char_lm_suffix_score <= -7411.4999999999991 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            Result := 0.0015831510468970428;
                        end
                        else
                        begin
                            Result := 0.030681624159583129;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -6807.4999999999991 then
                        begin
                            Result := -0.0051004846757767893;
                        end
                        else
                        begin
                            if features.candidate_score <= 116852.00000000001 then
                            begin
                                if features.chain_rank <= 1.5000000000000002 then
                                begin
                                    if features.score_per_unit <= 9757.5000000000018 then
                                    begin
                                        Result := 0.010082764521334666;
                                    end
                                    else
                                    begin
                                        Result := 0.042117597691267189;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.0099336581235118081;
                                end;
                            end
                            else
                            begin
                                if features.candidate_score <= 154940.50000000003 then
                                begin
                                    if features.char_lm_context_gain <= -844.49999999999989 then
                                    begin
                                        if features.dict_weight_per_unit <= 20088.500000000004 then
                                        begin
                                            Result := -0.022488033334372486;
                                        end
                                        else
                                        begin
                                            Result := 0.011603773393913426;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.0081510059058434291;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_context_gain <= -563.49999999999989 then
                                    begin
                                        Result := 0.020480678052294022;
                                    end
                                    else
                                    begin
                                        Result := -0.002499626708906375;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_first_stage_score <= 43010.000000000007 then
                    begin
                        Result := -0.0077246164876553268;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -8679.4999999999982 then
                        begin
                            if features.char_lm_context_score <= -9196.4999999999982 then
                            begin
                                Result := -0.01108369964141661;
                            end
                            else
                            begin
                                Result := 0.032580193617164702;
                            end;
                        end
                        else
                        begin
                            if features.dict_weight_per_unit <= 12830.000000000002 then
                            begin
                                if features.legacy_rank <= 2.5000000000000004 then
                                begin
                                    Result := 0.002052786263633072;
                                end
                                else
                                begin
                                    Result := -0.012609870098398411;
                                end;
                            end
                            else
                            begin
                                if features.candidate_score <= 191835.50000000003 then
                                begin
                                    Result := 0.022714404991453441;
                                end
                                else
                                begin
                                    Result := -0.010366542597681511;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.score_per_unit <= 24927.500000000004 then
                begin
                    Result := -0.01949808982284135;
                end
                else
                begin
                    Result := 0.0052198890352425018;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_35(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 2.5000000000000004 then
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_second_stage_score <= -20468598.999999996 then
            begin
                if features.char_lm_score <= -6415.4999999999991 then
                begin
                    if features.candidate_score <= 91317.000000000015 then
                    begin
                        Result := -0.034619286339842383;
                    end
                    else
                    begin
                        if features.path_segments <= 6.5000000000000009 then
                        begin
                            Result := 0.025163055993295363;
                        end
                        else
                        begin
                            Result := -0.0089944686037956943;
                        end;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 55030.500000000007 then
                    begin
                        Result := -0.0090099528050624714;
                    end
                    else
                    begin
                        Result := 0.016784387278434024;
                    end;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.5000000000000002 then
                begin
                    if features.char_lm_score <= -3892.4999999999995 then
                    begin
                        Result := 0.029063269112335619;
                    end
                    else
                    begin
                        Result := 0.034501314241620527;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 66757.000000000015 then
                    begin
                        if features.char_lm_context_score <= -6049.4999999999991 then
                        begin
                            Result := -0.040765253878314207;
                        end
                        else
                        begin
                            Result := 0.0063834084074373808;
                        end;
                    end
                    else
                    begin
                        Result := 0.018431671001458972;
                    end;
                end;
            end;
        end
        else
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.033590486085094309;
            end
            else
            begin
                if features.chain_second_stage_score <= -60934688.499999993 then
                begin
                    if features.path_max_segment_units <= 2.5000000000000004 then
                    begin
                        Result := -0.0060505494825592778;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -68891241.499999985 then
                        begin
                            Result := 0.0020884484554636782;
                        end
                        else
                        begin
                            Result := 0.041384333898575217;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -75824563.999999985 then
                    begin
                        Result := -0.01551684127630879;
                    end
                    else
                    begin
                        if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                        begin
                            Result := -0.0019962445168810695;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -9835736.4999999981 then
                            begin
                                if features.chain_second_stage_score <= 11301783.000000002 then
                                begin
                                    if features.char_lm_score <= -4963.4999999999991 then
                                    begin
                                        if features.candidate_score <= 106328.00000000001 then
                                        begin
                                            Result := -0.013760873220170012;
                                        end
                                        else
                                        begin
                                            Result := 0.0095063708105529356;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.033097738394687874;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.0024690032473892228;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_score <= -5016.4999999999991 then
                                begin
                                    if features.path_segments <= 8.5000000000000018 then
                                    begin
                                        Result := 0.011061937105472326;
                                    end
                                    else
                                    begin
                                        Result := -0.012174794570744763;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -4709.4999999999991 then
                                    begin
                                        if features.chain_first_stage_score <= 131999.00000000003 then
                                        begin
                                            Result := 0.053441359483873088;
                                        end
                                        else
                                        begin
                                            Result := 0.0051678541451456962;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.015117704354395941;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end
    else
    begin
        if features.chain_first_stage_score <= 1.0000000180025095E-35 then
        begin
            Result := -0.036975545034796317;
        end
        else
        begin
            if features.chain_score_gap <= -43548597.499999993 then
            begin
                if features.chain_first_stage_score <= 66275.500000000015 then
                begin
                    Result := 0.006303119600660355;
                end
                else
                begin
                    Result := -0.028065320734100955;
                end;
            end
            else
            begin
                if features.score_per_unit <= 11771.500000000002 then
                begin
                    if features.chain_score_gap <= -18208077.499999996 then
                    begin
                        Result := 0.012800267746665029;
                    end
                    else
                    begin
                        Result := -0.02070746037781513;
                    end;
                end
                else
                begin
                    Result := 0.028250166642519958;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_36(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.legacy_rank <= 2.5000000000000004 then
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                if features.chain_second_stage_score <= -20468598.999999996 then
                begin
                    if features.char_lm_context_score <= -7978.4999999999991 then
                    begin
                        if features.path_segments <= 5.5000000000000009 then
                        begin
                            Result := 0.019075854919317091;
                        end
                        else
                        begin
                            Result := -0.01680716176478354;
                        end;
                    end
                    else
                    begin
                        Result := 0.015312972883675649;
                    end;
                end
                else
                begin
                    if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                    begin
                        if features.path_segments <= 1.0000000180025095E-35 then
                        begin
                            Result := 0.025063633759073937;
                        end
                        else
                        begin
                            Result := 0.034761954039467774;
                        end;
                    end
                    else
                    begin
                        Result := 0.027586766718909955;
                    end;
                end;
            end
            else
            begin
                if features.candidate_score <= 66757.000000000015 then
                begin
                    if features.score_per_unit <= 4727.5000000000009 then
                    begin
                        if features.char_lm_context_gain <= -946.49999999999989 then
                        begin
                            Result := -0.01866003084266216;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -694.49999999999989 then
                            begin
                                Result := 0.027231051207257207;
                            end
                            else
                            begin
                                Result := -0.00057777634822647641;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := -0.039349906933169386;
                    end;
                end
                else
                begin
                    Result := 0.017419461872515286;
                end;
            end;
        end
        else
        begin
            if Ord(features.complete_match) <= 1.0000000180025095E-35 then
            begin
                Result := -0.033328326839479429;
            end
            else
            begin
                if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                begin
                    Result := -0.0019914387056758419;
                end
                else
                begin
                    if features.path_single_segments <= 3.5000000000000004 then
                    begin
                        if features.chain_second_stage_score <= -64024275.499999993 then
                        begin
                            if features.dict_weight <= 120968.00000000001 then
                            begin
                                Result := 0.0026093039250249411;
                            end
                            else
                            begin
                                Result := 0.035133698557334107;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_score <= -7731.4999999999991 then
                            begin
                                Result := -0.0011960520567775642;
                            end
                            else
                            begin
                                if features.chain_first_stage_score <= 133056.50000000003 then
                                begin
                                    if features.score_per_unit <= 12564.500000000002 then
                                    begin
                                        Result := 0.010615355632398731;
                                    end
                                    else
                                    begin
                                        Result := 0.037508725198678497;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.0046274100975434475;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.candidate_score <= 110551.50000000001 then
                        begin
                            Result := -0.022233036017582527;
                        end
                        else
                        begin
                            if features.chain_first_stage_score <= 282672.00000000006 then
                            begin
                                Result := 0.0081175155003411492;
                            end
                            else
                            begin
                                Result := -0.022042472400067386;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end
    else
    begin
        if Ord(features.complete_match) <= 1.0000000180025095E-35 then
        begin
            Result := -0.037434176867694888;
        end
        else
        begin
            if features.char_lm_context_score <= -9852.4999999999982 then
            begin
                Result := 0.012868751813232944;
            end
            else
            begin
                if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                begin
                    if features.char_lm_score <= -3258.4999999999995 then
                    begin
                        Result := -0.026616477675701612;
                    end
                    else
                    begin
                        Result := 0.022977868822515284;
                    end;
                end
                else
                begin
                    if features.char_lm_suffix_score <= -7165.4999999999991 then
                    begin
                        if features.candidate_score <= 133090.50000000003 then
                        begin
                            Result := -0.011397867638290681;
                        end
                        else
                        begin
                            Result := 0.029429079783977307;
                        end;
                    end
                    else
                    begin
                        if features.dict_weight <= 77009.500000000015 then
                        begin
                            Result := 0.0037804457453375806;
                        end
                        else
                        begin
                            if features.char_lm_suffix_score <= -5123.4999999999991 then
                            begin
                                Result := -0.02700535582276525;
                            end
                            else
                            begin
                                Result := 0.014365722536344853;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_37(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.partial_match) <= 1.0000000180025095E-35 then
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                if features.chain_second_stage_score <= -20468598.999999996 then
                begin
                    if features.char_lm_score <= -6415.4999999999991 then
                    begin
                        Result := -0.0067558447579494588;
                    end
                    else
                    begin
                        Result := 0.015178087898314187;
                    end;
                end
                else
                begin
                    if features.char_lm_score <= -3892.4999999999995 then
                    begin
                        if features.dict_weight_per_unit <= 13679.000000000002 then
                        begin
                            Result := 0.026040155146999484;
                        end
                        else
                        begin
                            Result := 0.033488176210972082;
                        end;
                    end
                    else
                    begin
                        Result := 0.033888801006870792;
                    end;
                end;
            end
            else
            begin
                if features.candidate_score <= 66757.000000000015 then
                begin
                    if features.chain_first_stage_score <= -66677.999999999985 then
                    begin
                        Result := 0.020604002547237217;
                    end
                    else
                    begin
                        if features.char_lm_score <= -4709.4999999999991 then
                        begin
                            if features.char_lm_score <= -5224.4999999999991 then
                            begin
                                Result := -0.023325642623139093;
                            end
                            else
                            begin
                                Result := 0.031665904870844828;
                            end;
                        end
                        else
                        begin
                            Result := -0.038267111388450556;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_suffix_score <= -6134.4999999999991 then
                    begin
                        if features.char_lm_context_gain <= -769.49999999999989 then
                        begin
                            if features.char_lm_score <= -6915.4999999999991 then
                            begin
                                Result := -0.0073588551940618821;
                            end
                            else
                            begin
                                Result := 0.023348227664347167;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -502.49999999999994 then
                            begin
                                Result := -0.021469763486959701;
                            end
                            else
                            begin
                                Result := 0.0098745328321381293;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.022459767016872762;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_first_stage_score <= 1.0000000180025095E-35 then
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if features.score_per_unit <= 10399.500000000002 then
                    begin
                        Result := 0.0037351467913816043;
                    end
                    else
                    begin
                        Result := -0.0075668189651150585;
                    end;
                end
                else
                begin
                    if features.path_single_segments <= 4.5000000000000009 then
                    begin
                        if features.char_lm_context_score <= -9852.4999999999982 then
                        begin
                            Result := -0.00037786624984691337;
                        end
                        else
                        begin
                            Result := -0.027742800524646682;
                        end;
                    end
                    else
                    begin
                        Result := 0.013486579265948409;
                    end;
                end;
            end
            else
            begin
                if features.chain_score_gap <= -59742350.999999993 then
                begin
                    if features.chain_second_stage_score <= -38535230.499999993 then
                    begin
                        if features.score_per_unit <= 10609.500000000002 then
                        begin
                            Result := -0.01413201903890941;
                        end
                        else
                        begin
                            Result := 0.0096587344646232327;
                        end;
                    end
                    else
                    begin
                        Result := -0.017897034146893052;
                    end;
                end
                else
                begin
                    if features.score_per_unit <= 11286.500000000002 then
                    begin
                        if features.path_single_segments <= 3.5000000000000004 then
                        begin
                            if features.chain_first_stage_score <= 214000.50000000003 then
                            begin
                                Result := 0.0094998966494754533;
                            end
                            else
                            begin
                                Result := -0.0115572398344758;
                            end;
                        end
                        else
                        begin
                            Result := -0.0042726885754599143;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -64024275.499999993 then
                        begin
                            Result := 0.045429215519542814;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -37824125.499999993 then
                            begin
                                Result := -0.0010363910123190058;
                            end
                            else
                            begin
                                if features.char_lm_score <= -6772.4999999999991 then
                                begin
                                    if features.candidate_score <= 133804.50000000003 then
                                    begin
                                        Result := 0.013057692925170249;
                                    end
                                    else
                                    begin
                                        Result := -0.02444043717235498;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.017452534380764138;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end
    else
    begin
        Result := -0.037315167490462493;
    end;
end;

function long_final_ranker_tree_38(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.037216806920084895;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_second_stage_score <= -20468598.999999996 then
            begin
                if features.candidate_score <= 76536.000000000015 then
                begin
                    if features.char_lm_score <= -6518.4999999999991 then
                    begin
                        Result := -0.038256424086115959;
                    end
                    else
                    begin
                        Result := 0.0019381782825606845;
                    end;
                end
                else
                begin
                    if features.char_lm_suffix_score <= -6134.4999999999991 then
                    begin
                        if features.path_segments <= 6.5000000000000009 then
                        begin
                            Result := 0.015526579313119397;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -43880677.499999993 then
                            begin
                                Result := 0.0094077066058831336;
                            end
                            else
                            begin
                                Result := -0.011043214906599458;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.025524960058343839;
                    end;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.5000000000000002 then
                begin
                    if features.char_lm_score <= -3892.4999999999995 then
                    begin
                        Result := 0.027424156565858022;
                    end
                    else
                    begin
                        Result := 0.033810626858939034;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 66757.000000000015 then
                    begin
                        if features.char_lm_score <= -4208.4999999999991 then
                        begin
                            Result := -0.026811562555760404;
                        end
                        else
                        begin
                            Result := 0.0046491799418462276;
                        end;
                    end
                    else
                    begin
                        Result := 0.018260319559702649;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_first_stage_score <= 1.0000000180025095E-35 then
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    Result := -0.0021922906632230892;
                end
                else
                begin
                    if features.score_per_unit <= 23506.500000000004 then
                    begin
                        Result := -0.024168377041314536;
                    end
                    else
                    begin
                        Result := 0.0088819922377897792;
                    end;
                end;
            end
            else
            begin
                if features.chain_score_gap <= -59742350.999999993 then
                begin
                    Result := -0.0087267475788376722;
                end
                else
                begin
                    if features.path_segments <= 8.5000000000000018 then
                    begin
                        if features.candidate_score <= 154940.50000000003 then
                        begin
                            if features.char_lm_score <= -3724.4999999999995 then
                            begin
                                if features.legacy_rank <= 2.5000000000000004 then
                                begin
                                    if features.chain_score_gap <= -20341703.499999996 then
                                    begin
                                        Result := 0.0039810937098156886;
                                    end
                                    else
                                    begin
                                        if features.char_lm_suffix_score <= -4932.4999999999991 then
                                        begin
                                            if features.chain_second_stage_score <= -60934688.499999993 then
                                            begin
                                                Result := 0.035905514351644338;
                                            end
                                            else
                                            begin
                                                if features.chain_second_stage_score <= -16016177.499999998 then
                                                begin
                                                    Result := -0.0031260756022987476;
                                                end
                                                else
                                                begin
                                                    if features.chain_first_stage_score <= 133056.50000000003 then
                                                    begin
                                                        Result := 0.019981576734151258;
                                                    end
                                                    else
                                                    begin
                                                        if features.char_lm_context_gain <= -712.49999999999989 then
                                                        begin
                                                            Result := -0.010250825161488175;
                                                        end
                                                        else
                                                        begin
                                                            Result := 0.018584283659715074;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := 0.04491623694605619;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    if features.path_segments <= 5.5000000000000009 then
                                    begin
                                        Result := 0.014321024580550965;
                                    end
                                    else
                                    begin
                                        Result := -0.02603853217699071;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.0081088218599679636;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -694.49999999999989 then
                            begin
                                if features.path_single_segments <= 2.5000000000000004 then
                                begin
                                    Result := 0.043444404818574395;
                                end
                                else
                                begin
                                    Result := -0.00068672134380150197;
                                end;
                            end
                            else
                            begin
                                if features.score_per_unit <= 11678.500000000002 then
                                begin
                                    Result := -0.013541522182419408;
                                end
                                else
                                begin
                                    Result := 0.019927395848116258;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.00176528667209298;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_39(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.037136887175201659;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                if features.chain_second_stage_score <= -20468598.999999996 then
                begin
                    if features.char_lm_score <= -6518.4999999999991 then
                    begin
                        Result := -0.011662332483905004;
                    end
                    else
                    begin
                        Result := 0.01212157525475337;
                    end;
                end
                else
                begin
                    if features.char_lm_score <= -3892.4999999999995 then
                    begin
                        if features.dict_weight_per_unit <= 15302.000000000002 then
                        begin
                            Result := 0.02513544445812221;
                        end
                        else
                        begin
                            Result := 0.033628528324501722;
                        end;
                    end
                    else
                    begin
                        Result := 0.033300178798178877;
                    end;
                end;
            end
            else
            begin
                if features.candidate_score <= 86963.500000000015 then
                begin
                    if features.path_single_segments <= 3.5000000000000004 then
                    begin
                        if features.char_lm_score <= -3522.4999999999995 then
                        begin
                            if features.char_lm_score <= -4326.4999999999991 then
                            begin
                                Result := 0.0012214022915781767;
                            end
                            else
                            begin
                                Result := -0.024728801428943643;
                            end;
                        end
                        else
                        begin
                            Result := 0.024752942796159413;
                        end;
                    end
                    else
                    begin
                        Result := -0.028585090344959339;
                    end;
                end
                else
                begin
                    Result := 0.016763431849306645;
                end;
            end;
        end
        else
        begin
            if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
            begin
                if features.chain_score_gap <= -59742350.999999993 then
                begin
                    if features.chain_second_stage_score <= 17062271.000000004 then
                    begin
                        Result := -0.0021230958261934108;
                    end
                    else
                    begin
                        Result := -0.024119358218135614;
                    end;
                end
                else
                begin
                    if features.chain_first_stage_score <= 33380.500000000007 then
                    begin
                        if features.path_single_segments <= 1.5000000000000002 then
                        begin
                            Result := 0.0075822177206423605;
                        end
                        else
                        begin
                            Result := -0.0063222897032744335;
                        end;
                    end
                    else
                    begin
                        if features.score_per_unit <= 11286.500000000002 then
                        begin
                            if features.path_single_segments <= 3.5000000000000004 then
                            begin
                                if features.chain_first_stage_score <= 214000.50000000003 then
                                begin
                                    if features.score_per_unit <= 11167.000000000002 then
                                    begin
                                        if features.char_lm_suffix_score <= -6451.4999999999991 then
                                        begin
                                            if features.char_lm_context_score <= -8269.4999999999982 then
                                            begin
                                                Result := 0.013848409837395931;
                                            end
                                            else
                                            begin
                                                Result := -0.003288665726646153;
                                            end;
                                        end
                                        else
                                        begin
                                            if features.char_lm_suffix_score <= -5275.4999999999991 then
                                            begin
                                                if features.candidate_score <= 122140.50000000001 then
                                                begin
                                                    if features.char_lm_score <= -5118.4999999999991 then
                                                    begin
                                                        Result := 0.0091075960910368108;
                                                    end
                                                    else
                                                    begin
                                                        Result := 0.032037302588861748;
                                                    end;
                                                end
                                                else
                                                begin
                                                    if features.text_units <= 13.500000000000002 then
                                                    begin
                                                        Result := -0.014458544814691348;
                                                    end
                                                    else
                                                    begin
                                                        Result := 0.017089874569747979;
                                                    end;
                                                end;
                                            end
                                            else
                                            begin
                                                Result := 0.0026640080898297498;
                                            end;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.path_segments <= 5.5000000000000009 then
                                        begin
                                            Result := -0.032207135396769199;
                                        end
                                        else
                                        begin
                                            Result := 0.0066708765123428323;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.01154174229739708;
                                end;
                            end
                            else
                            begin
                                Result := -0.0037979229816798295;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -55362432.999999993 then
                            begin
                                Result := 0.038277200754002254;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -37824125.499999993 then
                                begin
                                    Result := -0.0022834971511951217;
                                end
                                else
                                begin
                                    Result := 0.01686647695186437;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_score <= -3940.4999999999995 then
                begin
                    Result := -0.015639768937539315;
                end
                else
                begin
                    Result := 0.016011672152633615;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_40(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.037041528397354487;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                if features.chain_second_stage_score <= -20468598.999999996 then
                begin
                    if features.chain_second_stage_score <= -60934688.499999993 then
                    begin
                        Result := -0.018710704099707848;
                    end
                    else
                    begin
                        if features.char_lm_score <= -7067.4999999999991 then
                        begin
                            Result := -0.017721434806509777;
                        end
                        else
                        begin
                            Result := 0.013562544660743288;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_score <= -3892.4999999999995 then
                    begin
                        if features.dict_weight_per_unit <= 15302.000000000002 then
                        begin
                            Result := 0.024283874867787235;
                        end
                        else
                        begin
                            Result := 0.033263858030360589;
                        end;
                    end
                    else
                    begin
                        Result := 0.032977219626544652;
                    end;
                end;
            end
            else
            begin
                if features.candidate_score <= 86963.500000000015 then
                begin
                    if features.path_single_segments <= 3.5000000000000004 then
                    begin
                        if features.char_lm_score <= -5224.4999999999991 then
                        begin
                            Result := -0.018334589211792228;
                        end
                        else
                        begin
                            Result := 0.0096920822221655926;
                        end;
                    end
                    else
                    begin
                        Result := -0.027668616976645535;
                    end;
                end
                else
                begin
                    if features.char_lm_context_gain <= -730.49999999999989 then
                    begin
                        Result := 0.023972311469201649;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -6724.4999999999991 then
                        begin
                            Result := -0.01129208331844877;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -656.49999999999989 then
                            begin
                                Result := -0.011677698821567493;
                            end
                            else
                            begin
                                Result := 0.018863575186271572;
                            end;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
            begin
                if features.chain_score_gap <= -59742350.999999993 then
                begin
                    Result := -0.0077651494785710871;
                end
                else
                begin
                    if features.path_single_segments <= 1.5000000000000002 then
                    begin
                        if features.char_lm_score <= -3724.4999999999995 then
                        begin
                            if features.chain_first_stage_score <= 87820.000000000015 then
                            begin
                                if features.dict_weight_per_unit <= 5237.0000000000009 then
                                begin
                                    Result := 0.026756556749615551;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= -11925513.999999998 then
                                    begin
                                        Result := -0.026393827048559436;
                                    end
                                    else
                                    begin
                                        Result := 0.0067505919267652785;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := 0.019933831403665937;
                            end;
                        end
                        else
                        begin
                            Result := -0.0047673056204874222;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -9196.4999999999982 then
                        begin
                            Result := -0.026547121439503742;
                        end
                        else
                        begin
                            if features.score_per_unit <= 16409.000000000004 then
                            begin
                                if features.char_lm_context_score <= -8679.4999999999982 then
                                begin
                                    Result := 0.025396360783794664;
                                end
                                else
                                begin
                                    if features.char_lm_suffix_score <= -7491.4999999999991 then
                                    begin
                                        if features.char_lm_context_gain <= -481.49999999999994 then
                                        begin
                                            Result := -0.032348433401066613;
                                        end
                                        else
                                        begin
                                            Result := 0.017283207245616876;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.dict_weight_per_unit <= 12830.000000000002 then
                                        begin
                                            if features.legacy_rank <= 2.5000000000000004 then
                                            begin
                                                Result := 0.0063023284742804581;
                                            end
                                            else
                                            begin
                                                Result := -0.014747810853748307;
                                            end;
                                        end
                                        else
                                        begin
                                            if features.candidate_score <= 191835.50000000003 then
                                            begin
                                                Result := 0.0270599269763965;
                                            end
                                            else
                                            begin
                                                Result := -0.011306891215398891;
                                            end;
                                        end;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.016278084974564483;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.score_per_unit <= 24168.500000000004 then
                begin
                    Result := -0.018229053124293616;
                end
                else
                begin
                    Result := 0.0062521150649791782;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_41(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.partial_match) <= 1.0000000180025095E-35 then
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                if features.chain_second_stage_score <= -20468598.999999996 then
                begin
                    if features.chain_first_stage_score <= 166841.50000000003 then
                    begin
                        if features.chain_second_stage_score <= -60934688.499999993 then
                        begin
                            Result := -0.024905882652538226;
                        end
                        else
                        begin
                            Result := 0.011697012808027795;
                        end;
                    end
                    else
                    begin
                        Result := -0.018000838524113025;
                    end;
                end
                else
                begin
                    if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                    begin
                        if features.dict_weight_per_unit <= 3870.5000000000005 then
                        begin
                            if features.char_lm_score <= -4560.4999999999991 then
                            begin
                                Result := 0.01284095186196183;
                            end
                            else
                            begin
                                Result := 0.029710671576089039;
                            end;
                        end
                        else
                        begin
                            Result := 0.034214291842685041;
                        end;
                    end
                    else
                    begin
                        Result := 0.024144533348766012;
                    end;
                end;
            end
            else
            begin
                if features.candidate_score <= 66757.000000000015 then
                begin
                    if features.path_segments <= 5.5000000000000009 then
                    begin
                        Result := 0.016007560561252993;
                    end
                    else
                    begin
                        if features.char_lm_score <= -4760.4999999999991 then
                        begin
                            if features.dict_weight_per_unit <= 3870.5000000000005 then
                            begin
                                Result := 0.016391508083983996;
                            end
                            else
                            begin
                                Result := -0.035251370493154473;
                            end;
                        end
                        else
                        begin
                            Result := -0.036314028010736916;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.013119658307171765;
                end;
            end;
        end
        else
        begin
            if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
            begin
                if features.chain_score_gap <= -43548597.499999993 then
                begin
                    if features.path_single_segments <= 3.5000000000000004 then
                    begin
                        Result := 0.0;
                    end
                    else
                    begin
                        Result := -0.019439696809860331;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= -60934688.499999993 then
                    begin
                        if features.path_segments <= 8.5000000000000018 then
                        begin
                            if features.path_max_segment_units <= 2.5000000000000004 then
                            begin
                                Result := 0.0035448471676562225;
                            end
                            else
                            begin
                                Result := 0.04937119521466881;
                            end;
                        end
                        else
                        begin
                            Result := -0.011597555156788971;
                        end;
                    end
                    else
                    begin
                        if features.path_single_segments <= 1.5000000000000002 then
                        begin
                            if features.char_lm_score <= -3724.4999999999995 then
                            begin
                                if features.chain_second_stage_score <= -7792774.4999999991 then
                                begin
                                    if features.text_units <= 9.5000000000000018 then
                                    begin
                                        Result := -0.02219295372354467;
                                    end
                                    else
                                    begin
                                        if features.char_lm_suffix_score <= -7288.4999999999991 then
                                        begin
                                            Result := 0.026556419338080787;
                                        end
                                        else
                                        begin
                                            Result := -0.0041149976691416349;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.018123455554667944;
                                end;
                            end
                            else
                            begin
                                Result := -0.0045571266016473525;
                            end;
                        end
                        else
                        begin
                            if features.chain_first_stage_score <= 27672.000000000004 then
                            begin
                                Result := -0.0073556412668716277;
                            end
                            else
                            begin
                                if features.text_units <= 10.500000000000002 then
                                begin
                                    if features.candidate_score <= 110551.50000000001 then
                                    begin
                                        Result := 0.0086260923699098702;
                                    end
                                    else
                                    begin
                                        Result := 0.029474564159312225;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_context_score <= -7614.4999999999991 then
                                    begin
                                        Result := -0.010511061607343507;
                                    end
                                    else
                                    begin
                                        Result := 0.0068962487470176125;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.score_per_unit <= 24168.500000000004 then
                begin
                    if features.legacy_rank <= 2.5000000000000004 then
                    begin
                        Result := -0.0078217594068004381;
                    end
                    else
                    begin
                        Result := -0.024756654567105674;
                    end;
                end
                else
                begin
                    Result := 0.0056841698617251975;
                end;
            end;
        end;
    end
    else
    begin
        Result := -0.036950114719212938;
    end;
end;

function long_final_ranker_tree_42(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.036883799472221673;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                if features.chain_second_stage_score <= -20468598.999999996 then
                begin
                    if features.dict_weight_per_unit <= 11734.500000000002 then
                    begin
                        if features.dict_weight_per_unit <= 9351.5000000000018 then
                        begin
                            Result := -0.0048519719812597653;
                        end
                        else
                        begin
                            Result := 0.018163557657689004;
                        end;
                    end
                    else
                    begin
                        Result := -0.027337366260759822;
                    end;
                end
                else
                begin
                    if features.char_lm_score <= -3892.4999999999995 then
                    begin
                        if features.dict_weight_per_unit <= 13679.000000000002 then
                        begin
                            Result := 0.022655783045654312;
                        end
                        else
                        begin
                            Result := 0.032006087346264471;
                        end;
                    end
                    else
                    begin
                        Result := 0.032396705174890239;
                    end;
                end;
            end
            else
            begin
                if features.candidate_score <= 76536.000000000015 then
                begin
                    if features.path_single_segments <= 3.5000000000000004 then
                    begin
                        if features.char_lm_suffix_score <= -5245.4999999999991 then
                        begin
                            if features.path_max_segment_units <= 2.5000000000000004 then
                            begin
                                Result := -0.024887199445039632;
                            end
                            else
                            begin
                                Result := 0.0037561591473508319;
                            end;
                        end
                        else
                        begin
                            Result := 0.020891064219113818;
                        end;
                    end
                    else
                    begin
                        Result := -0.035363743503231522;
                    end;
                end
                else
                begin
                    if features.char_lm_context_gain <= -730.49999999999989 then
                    begin
                        Result := 0.020280258591064793;
                    end
                    else
                    begin
                        if features.char_lm_context_gain <= -636.49999999999989 then
                        begin
                            Result := -0.016071654151243821;
                        end
                        else
                        begin
                            if features.char_lm_context_score <= -6724.4999999999991 then
                            begin
                                Result := -0.0051773576175086281;
                            end
                            else
                            begin
                                Result := 0.019465767548031705;
                            end;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.legacy_rank <= 2.5000000000000004 then
            begin
                if features.chain_first_stage_score <= 87237.000000000015 then
                begin
                    Result := 0.0012407853574931979;
                end
                else
                begin
                    if features.chain_score_gap <= -49674397.499999993 then
                    begin
                        if features.chain_second_stage_score <= 14389599.500000002 then
                        begin
                            if features.char_lm_context_score <= -6525.4999999999991 then
                            begin
                                if features.char_lm_suffix_score <= -7102.4999999999991 then
                                begin
                                    Result := 0.013986830889105045;
                                end
                                else
                                begin
                                    Result := -0.015842030573074234;
                                end;
                            end
                            else
                            begin
                                Result := 0.023699810506511577;
                            end;
                        end
                        else
                        begin
                            Result := -0.019124199302982609;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -8231.4999999999982 then
                        begin
                            Result := 0.033034168855548378;
                        end
                        else
                        begin
                            if features.dict_weight_per_unit <= 11299.500000000002 then
                            begin
                                if features.dict_weight <= 122800.50000000001 then
                                begin
                                    if features.char_lm_score <= -4035.4999999999995 then
                                    begin
                                        Result := 0.014889373431482897;
                                    end
                                    else
                                    begin
                                        Result := -0.008756004040090885;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -4035.4999999999995 then
                                    begin
                                        if features.dict_weight <= 124429.00000000001 then
                                        begin
                                            Result := -0.034584333075832287;
                                        end
                                        else
                                        begin
                                            Result := -5.2597790899881067E-05;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.025554152180849533;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := 0.015601771026069071;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.dict_weight <= 142545.00000000003 then
                begin
                    if features.char_lm_context_gain <= -1349.4999999999998 then
                    begin
                        Result := 0.00073773414462019937;
                    end
                    else
                    begin
                        Result := -0.02275241111111688;
                    end;
                end
                else
                begin
                    if features.char_lm_suffix_score <= -6162.4999999999991 then
                    begin
                        Result := 0.020975979452214584;
                    end
                    else
                    begin
                        Result := -0.022896226934927863;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_43(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.036790451566292369;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                if features.chain_second_stage_score <= -20468598.999999996 then
                begin
                    if features.dict_weight_per_unit <= 11415.000000000002 then
                    begin
                        if features.chain_first_stage_score <= 87237.000000000015 then
                        begin
                            Result := -0.012945053737087597;
                        end
                        else
                        begin
                            Result := 0.015988067058589756;
                        end;
                    end
                    else
                    begin
                        Result := -0.022728263285937651;
                    end;
                end
                else
                begin
                    if features.char_lm_score <= -3892.4999999999995 then
                    begin
                        if features.dict_weight_per_unit <= 13679.000000000002 then
                        begin
                            Result := 0.022170035096053087;
                        end
                        else
                        begin
                            Result := 0.031809530271753005;
                        end;
                    end
                    else
                    begin
                        Result := 0.032010090221217528;
                    end;
                end;
            end
            else
            begin
                if features.candidate_score <= 66757.000000000015 then
                begin
                    if features.chain_first_stage_score <= -66677.999999999985 then
                    begin
                        Result := 0.016869100898303846;
                    end
                    else
                    begin
                        if features.path_single_segments <= 3.5000000000000004 then
                        begin
                            if features.path_max_segment_units <= 2.5000000000000004 then
                            begin
                                Result := -0.033051751127518479;
                            end
                            else
                            begin
                                Result := 0.00046071693011978323;
                            end;
                        end
                        else
                        begin
                            Result := -0.043299267903373108;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_score <= -7467.9999999999991 then
                    begin
                        Result := -0.016426389604616124;
                    end
                    else
                    begin
                        if features.char_lm_context_gain <= -730.49999999999989 then
                        begin
                            Result := 0.021068579374511585;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -582.49999999999989 then
                            begin
                                Result := -0.0083105491906543712;
                            end
                            else
                            begin
                                Result := 0.01535548397867623;
                            end;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_first_stage_score <= 1.0000000180025095E-35 then
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    Result := -0.00093613874184987243;
                end
                else
                begin
                    Result := -0.017932642839199823;
                end;
            end
            else
            begin
                if features.chain_score_gap <= -59742350.999999993 then
                begin
                    Result := -0.0067228166001591302;
                end
                else
                begin
                    if features.path_segments <= 8.5000000000000018 then
                    begin
                        if features.candidate_score <= 154940.50000000003 then
                        begin
                            if features.char_lm_score <= -3724.4999999999995 then
                            begin
                                if features.char_lm_context_gain <= -844.49999999999989 then
                                begin
                                    if features.input_syllable_count <= 10.500000000000002 then
                                    begin
                                        if features.char_lm_context_gain <= -989.49999999999989 then
                                        begin
                                            Result := 0.018324769999973029;
                                        end
                                        else
                                        begin
                                            if features.chain_first_stage_score <= 87820.000000000015 then
                                            begin
                                                Result := 0.019563941225967187;
                                            end
                                            else
                                            begin
                                                Result := -0.023588303732082982;
                                            end;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.chain_second_stage_score <= 103760811.00000001 then
                                        begin
                                            if features.dict_weight_per_unit <= 7808.5000000000009 then
                                            begin
                                                Result := 0.0092189437014473311;
                                            end
                                            else
                                            begin
                                                Result := -0.01524379325207164;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := 0.033849578047604613;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    if features.legacy_rank <= 2.5000000000000004 then
                                    begin
                                        if features.chain_score_gap <= -20981126.499999996 then
                                        begin
                                            Result := 0.0073592615538078518;
                                        end
                                        else
                                        begin
                                            Result := 0.027170621048534779;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.022794075136526204;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.0079453503883267166;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -636.49999999999989 then
                            begin
                                Result := 0.032267388434779547;
                            end
                            else
                            begin
                                Result := 0.0098667995522325677;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.0021879661462291923;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_44(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.036728105909850449;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                if features.chain_second_stage_score <= -20468598.999999996 then
                begin
                    if features.score_per_unit <= 11473.500000000002 then
                    begin
                        if features.score_per_unit <= 10476.500000000002 then
                        begin
                            Result := 0.0007771239033937924;
                        end
                        else
                        begin
                            Result := 0.025009905012944127;
                        end;
                    end
                    else
                    begin
                        Result := -0.019841573177052735;
                    end;
                end
                else
                begin
                    if features.dict_weight_per_unit <= 15302.000000000002 then
                    begin
                        if features.char_lm_score <= -3892.4999999999995 then
                        begin
                            Result := 0.021834728944000258;
                        end
                        else
                        begin
                            Result := 0.030087984140305581;
                        end;
                    end
                    else
                    begin
                        Result := 0.033719759115451851;
                    end;
                end;
            end
            else
            begin
                if features.candidate_score <= 66757.000000000015 then
                begin
                    if features.path_segments <= 6.5000000000000009 then
                    begin
                        if features.char_lm_suffix_score <= -5245.4999999999991 then
                        begin
                            Result := -0.021386935660468006;
                        end
                        else
                        begin
                            Result := 0.029154620165542055;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_score <= -4814.4999999999991 then
                        begin
                            Result := 0.0074681163839569161;
                        end
                        else
                        begin
                            Result := -0.045186915354121726;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_suffix_score <= -6134.4999999999991 then
                    begin
                        if features.char_lm_context_gain <= -769.49999999999989 then
                        begin
                            if features.candidate_score <= 86963.500000000015 then
                            begin
                                Result := -0.010519558066996761;
                            end
                            else
                            begin
                                Result := 0.019613051570634369;
                            end;
                        end
                        else
                        begin
                            if features.candidate_score <= 191835.50000000003 then
                            begin
                                Result := -0.025824489621067325;
                            end
                            else
                            begin
                                Result := 0.010380191665303771;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.018172771899365253;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_first_stage_score <= 1.0000000180025095E-35 then
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    Result := -0.00048082611319354271;
                end
                else
                begin
                    if features.score_per_unit <= 23506.500000000004 then
                    begin
                        Result := -0.021191947637982243;
                    end
                    else
                    begin
                        Result := 0.0075575863375853111;
                    end;
                end;
            end
            else
            begin
                if features.score_per_unit <= 11286.500000000002 then
                begin
                    if features.chain_score_gap <= -59742350.999999993 then
                    begin
                        Result := -0.0083382129680125341;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -8231.4999999999982 then
                        begin
                            Result := 0.026555302371743493;
                        end
                        else
                        begin
                            if features.char_lm_context_score <= -6875.4999999999991 then
                            begin
                                Result := -0.0013837576344938401;
                            end
                            else
                            begin
                                Result := 0.0092810654258303898;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -53550508.499999993 then
                    begin
                        if features.chain_second_stage_score <= -71541965.999999985 then
                        begin
                            Result := 0.018394621192530353;
                        end
                        else
                        begin
                            Result := -0.014329124376696535;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -55362432.999999993 then
                        begin
                            Result := 0.039097846213958211;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -14724454.999999998 then
                            begin
                                if features.dict_weight_per_unit <= 11881.500000000002 then
                                begin
                                    Result := 0.015853469684313611;
                                end
                                else
                                begin
                                    if features.chain_score_gap <= -29696304.999999996 then
                                    begin
                                        Result := 0.014638810805348132;
                                    end
                                    else
                                    begin
                                        Result := -0.033193177502045694;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -35643245.499999993 then
                                begin
                                    Result := -0.0031877682017236305;
                                end
                                else
                                begin
                                    Result := 0.02110198637706991;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_45(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.036654149259492237;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_second_stage_score <= -20468598.999999996 then
            begin
                if features.score_per_unit <= 9317.5000000000018 then
                begin
                    if features.path_single_segments <= 3.5000000000000004 then
                    begin
                        if features.char_lm_score <= -5224.4999999999991 then
                        begin
                            if features.candidate_score <= 55030.500000000007 then
                            begin
                                Result := -0.03242961247358804;
                            end
                            else
                            begin
                                Result := -0.00031889746222591114;
                            end;
                        end
                        else
                        begin
                            Result := 0.03191882278628648;
                        end;
                    end
                    else
                    begin
                        if features.dict_weight_per_unit <= 6197.5000000000009 then
                        begin
                            Result := -0.005905336586987284;
                        end
                        else
                        begin
                            Result := -0.037870671646276624;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.0096352904019235044;
                end;
            end
            else
            begin
                if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                begin
                    if features.dict_weight_per_unit <= 3870.5000000000005 then
                    begin
                        if features.char_lm_score <= -4096.4999999999991 then
                        begin
                            if features.path_single_segments <= 2.5000000000000004 then
                            begin
                                Result := 0.015495945357980288;
                            end
                            else
                            begin
                                Result := -0.017149563431170418;
                            end;
                        end
                        else
                        begin
                            Result := 0.029718266480393184;
                        end;
                    end
                    else
                    begin
                        Result := 0.033412709879321552;
                    end;
                end
                else
                begin
                    if features.score_per_unit <= 3548.5000000000005 then
                    begin
                        if features.chain_rank <= 1.5000000000000002 then
                        begin
                            Result := 0.017223642884454261;
                        end
                        else
                        begin
                            Result := -0.022333129530604373;
                        end;
                    end
                    else
                    begin
                        Result := 0.020343194417175338;
                    end;
                end;
            end;
        end
        else
        begin
            if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
            begin
                if features.chain_score_gap <= -44289925.999999993 then
                begin
                    if features.candidate_score <= 150514.00000000003 then
                    begin
                        Result := -0.0066817866801593337;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -7102.4999999999991 then
                        begin
                            Result := 0.037991719330577337;
                        end
                        else
                        begin
                            if features.char_lm_context_score <= -6577.4999999999991 then
                            begin
                                Result := -0.016585205045748886;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -10184703.999999998 then
                                begin
                                    Result := 0.02604694406372705;
                                end
                                else
                                begin
                                    Result := -0.0081043172284410402;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.path_single_segments <= 1.5000000000000002 then
                    begin
                        Result := 0.015334816218921249;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -9196.4999999999982 then
                        begin
                            Result := -0.022802746113361864;
                        end
                        else
                        begin
                            if features.char_lm_context_score <= -8679.4999999999982 then
                            begin
                                if features.chain_first_stage_score <= 43010.000000000007 then
                                begin
                                    Result := -0.0046964451058764166;
                                end
                                else
                                begin
                                    Result := 0.035795724601585754;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_context_score <= -5933.4999999999991 then
                                begin
                                    if features.score_per_unit <= 10722.500000000002 then
                                    begin
                                        if features.chain_first_stage_score <= 154252.50000000003 then
                                        begin
                                            Result := 0.0021566517970617502;
                                        end
                                        else
                                        begin
                                            Result := -0.015145319086322691;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.0092987486533404329;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -3522.4999999999995 then
                                    begin
                                        Result := 0.020663608387498988;
                                    end
                                    else
                                    begin
                                        Result := -0.0048098410114982074;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_score <= -4513.4999999999991 then
                begin
                    if features.char_lm_context_score <= -10322.499999999998 then
                    begin
                        Result := 0.016614024540176162;
                    end
                    else
                    begin
                        Result := -0.017692153616759954;
                    end;
                end
                else
                begin
                    Result := 0.0092060487879827464;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_46(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.036584994112970247;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_second_stage_score <= -20468598.999999996 then
            begin
                if features.score_per_unit <= 8684.5000000000018 then
                begin
                    if features.chain_score_gap <= -62524478.999999993 then
                    begin
                        Result := -0.034249375632667466;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -6261.4999999999991 then
                        begin
                            if features.text_units <= 9.5000000000000018 then
                            begin
                                Result := 0.015909468020455248;
                            end
                            else
                            begin
                                Result := -0.019115170756864353;
                            end;
                        end
                        else
                        begin
                            Result := 0.017585673649995796;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.0094567491415463185;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.5000000000000002 then
                begin
                    if features.char_lm_score <= -3892.4999999999995 then
                    begin
                        if features.dict_weight_per_unit <= 15302.000000000002 then
                        begin
                            Result := 0.019760725890421525;
                        end
                        else
                        begin
                            Result := 0.031547093284577561;
                        end;
                    end
                    else
                    begin
                        Result := 0.031261670359845083;
                    end;
                end
                else
                begin
                    if features.score_per_unit <= 11286.500000000002 then
                    begin
                        if features.text_units <= 12.500000000000002 then
                        begin
                            Result := 0.010228753161716883;
                        end
                        else
                        begin
                            if features.char_lm_score <= -4709.4999999999991 then
                            begin
                                Result := 0.0037861122406287052;
                            end
                            else
                            begin
                                Result := -0.027579598675232797;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_score <= -4263.4999999999991 then
                        begin
                            Result := 0.026704024318218271;
                        end
                        else
                        begin
                            Result := -0.010216089208762503;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.legacy_rank <= 2.5000000000000004 then
            begin
                if features.chain_score_gap <= -83244892.999999985 then
                begin
                    if features.score_per_unit <= 10178.500000000002 then
                    begin
                        Result := -0.026604371346162763;
                    end
                    else
                    begin
                        Result := 0.0047082534905673844;
                    end;
                end
                else
                begin
                    if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.0011997879164975798;
                    end
                    else
                    begin
                        if features.score_per_unit <= 11286.500000000002 then
                        begin
                            if features.path_single_segments <= 3.5000000000000004 then
                            begin
                                if features.dict_weight_per_unit <= 7808.5000000000009 then
                                begin
                                    Result := 0.018655871930807269;
                                end
                                else
                                begin
                                    Result := 0.0056412919403512549;
                                end;
                            end
                            else
                            begin
                                Result := -0.0057571932447135661;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -57796089.499999993 then
                            begin
                                Result := 0.03738113769309772;
                            end
                            else
                            begin
                                if features.chain_first_stage_score <= 133056.50000000003 then
                                begin
                                    if features.score_per_unit <= 12564.500000000002 then
                                    begin
                                        if features.chain_first_stage_score <= 124020.50000000001 then
                                        begin
                                            Result := 0.0015076433386530706;
                                        end
                                        else
                                        begin
                                            Result := 0.032840529768968729;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.038755168639260054;
                                    end;
                                end
                                else
                                begin
                                    if features.path_segments <= 5.5000000000000009 then
                                    begin
                                        Result := -0.014041623967303518;
                                    end
                                    else
                                    begin
                                        if features.char_lm_score <= -4963.4999999999991 then
                                        begin
                                            Result := 0.0024415051044419911;
                                        end
                                        else
                                        begin
                                            Result := 0.021607473571461318;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.chain_first_stage_score <= 128906.50000000001 then
                begin
                    if features.char_lm_context_gain <= -1383.4999999999998 then
                    begin
                        Result := 0.0045092689740714826;
                    end
                    else
                    begin
                        Result := -0.021645435506169933;
                    end;
                end
                else
                begin
                    if features.score_per_unit <= 12903.500000000002 then
                    begin
                        Result := -0.0037550490344216403;
                    end
                    else
                    begin
                        Result := 0.035363183375159049;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_47(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.036530659520987559;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_second_stage_score <= -20468598.999999996 then
            begin
                if features.path_max_segment_units <= 2.5000000000000004 then
                begin
                    if features.dict_weight_per_unit <= 4263.5000000000009 then
                    begin
                        Result := 0.014795482865494239;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -49674397.499999993 then
                        begin
                            Result := -0.043016323774674736;
                        end
                        else
                        begin
                            if features.chain_first_stage_score <= 142793.50000000003 then
                            begin
                                if features.candidate_score <= 79747.500000000015 then
                                begin
                                    Result := -0.021007601431431228;
                                end
                                else
                                begin
                                    if features.char_lm_context_gain <= -749.49999999999989 then
                                    begin
                                        Result := 0.023306149326719015;
                                    end
                                    else
                                    begin
                                        Result := -0.0083693391510633874;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.03557089564807827;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_score <= -6772.4999999999991 then
                    begin
                        Result := -0.014332750860312445;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -45677944.999999993 then
                        begin
                            if features.chain_first_stage_score <= 144377.00000000003 then
                            begin
                                Result := -0.0076983208982672876;
                            end
                            else
                            begin
                                Result := 0.022099592014187864;
                            end;
                        end
                        else
                        begin
                            Result := 0.023471657941647298;
                        end;
                    end;
                end;
            end
            else
            begin
                if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                begin
                    if features.dict_weight_per_unit <= 3870.5000000000005 then
                    begin
                        if features.char_lm_score <= -4560.4999999999991 then
                        begin
                            Result := 0.0066338546058982437;
                        end
                        else
                        begin
                            Result := 0.028154331364046298;
                        end;
                    end
                    else
                    begin
                        Result := 0.032624510342952655;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -41862482.999999993 then
                    begin
                        Result := -0.012073916787338367;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= 102022708.00000001 then
                        begin
                            Result := 0.017035893380681448;
                        end
                        else
                        begin
                            Result := 0.026944010749234974;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_first_stage_score <= 43010.000000000007 then
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    Result := 0.0013376157986086808;
                end
                else
                begin
                    Result := -0.015566787178133269;
                end;
            end
            else
            begin
                if features.score_per_unit <= 11286.500000000002 then
                begin
                    if features.chain_score_gap <= -59742350.999999993 then
                    begin
                        Result := -0.0095979559212477014;
                    end
                    else
                    begin
                        if features.score_per_unit <= 11167.000000000002 then
                        begin
                            Result := 0.0069919434028943243;
                        end
                        else
                        begin
                            Result := -0.017339824285150622;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -53550508.499999993 then
                    begin
                        Result := -0.0036913576264067578;
                    end
                    else
                    begin
                        if features.dict_weight <= 178405.50000000003 then
                        begin
                            if features.candidate_score <= 154940.50000000003 then
                            begin
                                if features.chain_first_stage_score <= 133056.50000000003 then
                                begin
                                    if features.score_per_unit <= 12564.500000000002 then
                                    begin
                                        if features.char_lm_context_gain <= -1279.4999999999998 then
                                        begin
                                            Result := -0.013114403333730677;
                                        end
                                        else
                                        begin
                                            Result := 0.01958845616358711;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.042924779336152019;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_context_gain <= -1218.4999999999998 then
                                    begin
                                        Result := 0.035468161953489619;
                                    end
                                    else
                                    begin
                                        Result := -0.0048199961998082871;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.score_per_unit <= 11678.500000000002 then
                                begin
                                    Result := -0.00043900083717736995;
                                end
                                else
                                begin
                                    Result := 0.04275519794986872;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.0089169946729351843;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_48(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.036464133439282898;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.chain_rank <= 1.5000000000000002 then
            begin
                if features.chain_second_stage_score <= -27494981.499999996 then
                begin
                    if features.char_lm_context_gain <= -618.49999999999989 then
                    begin
                        Result := 0.0050478315256295269;
                    end
                    else
                    begin
                        Result := -0.022805126016174907;
                    end;
                end
                else
                begin
                    if features.char_lm_score <= -3892.4999999999995 then
                    begin
                        if features.dict_weight_per_unit <= 15302.000000000002 then
                        begin
                            Result := 0.018332478900934715;
                        end
                        else
                        begin
                            Result := 0.030365663738018873;
                        end;
                    end
                    else
                    begin
                        Result := 0.030129705575671829;
                    end;
                end;
            end
            else
            begin
                if features.candidate_score <= 66757.000000000015 then
                begin
                    if features.path_max_segment_units <= 2.5000000000000004 then
                    begin
                        if features.dict_weight_per_unit <= 870.50000000000011 then
                        begin
                            Result := -0.0059462009949568431;
                        end
                        else
                        begin
                            Result := -0.045260497280770716;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_score <= -4263.4999999999991 then
                        begin
                            Result := -0.01121435434846943;
                        end
                        else
                        begin
                            Result := 0.017820411632322255;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_suffix_score <= -6134.4999999999991 then
                    begin
                        if features.char_lm_context_gain <= -769.49999999999989 then
                        begin
                            Result := 0.011271213621941412;
                        end
                        else
                        begin
                            if features.candidate_score <= 189036.50000000003 then
                            begin
                                Result := -0.029223735653357525;
                            end
                            else
                            begin
                                Result := 0.0099868886513232481;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.014349779213756252;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_first_stage_score <= 90784.500000000015 then
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    Result := 0.0011667092962782206;
                end
                else
                begin
                    if features.char_lm_context_gain <= -946.49999999999989 then
                    begin
                        Result := -0.0034609875492234905;
                    end
                    else
                    begin
                        Result := -0.026390542651979675;
                    end;
                end;
            end
            else
            begin
                if features.path_single_segments <= 2.5000000000000004 then
                begin
                    if features.chain_score_gap <= -52757794.999999993 then
                    begin
                        Result := -0.0066893149902831897;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -7227.4999999999991 then
                        begin
                            Result := 0.027570595219611169;
                        end
                        else
                        begin
                            if features.score_per_unit <= 11473.500000000002 then
                            begin
                                if features.char_lm_suffix_score <= -7057.4999999999991 then
                                begin
                                    Result := -0.021354716950626507;
                                end
                                else
                                begin
                                    Result := 0.0084942933031573655;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_context_gain <= -502.49999999999994 then
                                begin
                                    if features.chain_score_gap <= -11575270.999999998 then
                                    begin
                                        Result := 0.0086936802341533188;
                                    end
                                    else
                                    begin
                                        Result := 0.031045983110130737;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -4760.4999999999991 then
                                    begin
                                        Result := -0.031846850626918562;
                                    end
                                    else
                                    begin
                                        Result := 0.021672183279064026;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_context_gain <= -769.49999999999989 then
                    begin
                        if features.char_lm_context_gain <= -1133.4999999999998 then
                        begin
                            Result := 0.01089953365342773;
                        end
                        else
                        begin
                            Result := -0.018798530136615168;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_score <= -5069.4999999999991 then
                        begin
                            Result := -0.00044802370316037078;
                        end
                        else
                        begin
                            if features.char_lm_score <= -3777.4999999999995 then
                            begin
                                if features.char_lm_context_gain <= -431.49999999999994 then
                                begin
                                    Result := 0.029743178013117488;
                                end
                                else
                                begin
                                    Result := 0.00020029403714315783;
                                end;
                            end
                            else
                            begin
                                Result := -0.024771956152525657;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_49(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.036408105646495291;
    end
    else
    begin
        if features.chain_score_gap <= -45818588.499999993 then
        begin
            if features.candidate_score <= 66757.000000000015 then
            begin
                if features.dict_weight_per_unit <= 1190.5000000000002 then
                begin
                    if features.char_lm_suffix_score <= -6231.4999999999991 then
                    begin
                        Result := 0.026477805965854296;
                    end
                    else
                    begin
                        Result := -0.016589278452629221;
                    end;
                end
                else
                begin
                    if features.char_lm_suffix_score <= -5737.4999999999991 then
                    begin
                        Result := -0.05104305219661489;
                    end
                    else
                    begin
                        Result := -0.010135249424079231;
                    end;
                end;
            end
            else
            begin
                if features.chain_score_gap <= -131664660.49999999 then
                begin
                    Result := -0.024788883897496231;
                end
                else
                begin
                    if features.chain_rank <= 2.5000000000000004 then
                    begin
                        if features.char_lm_suffix_score <= -6134.4999999999991 then
                        begin
                            if features.char_lm_context_score <= -7335.4999999999991 then
                            begin
                                if features.score_per_unit <= 9426.0000000000018 then
                                begin
                                    Result := -0.025780025379866889;
                                end
                                else
                                begin
                                    Result := 0.0054953904625722342;
                                end;
                            end
                            else
                            begin
                                Result := -0.033988678467547842;
                            end;
                        end
                        else
                        begin
                            if features.candidate_score <= 91317.000000000015 then
                            begin
                                Result := 0.028795083085342343;
                            end
                            else
                            begin
                                Result := -0.001612454137316947;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.024722319556066873;
                    end;
                end;
            end;
        end
        else
        begin
            if features.legacy_rank <= 1.5000000000000002 then
            begin
                if features.chain_rank <= 1.0000000180025095E-35 then
                begin
                    if features.path_segments <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.014410101372410387;
                    end
                    else
                    begin
                        Result := 0.031000788221410218;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= -27494981.499999996 then
                    begin
                        if features.char_lm_suffix_score <= -6261.4999999999991 then
                        begin
                            if features.score_per_unit <= 9317.5000000000018 then
                            begin
                                if features.dict_weight_per_unit <= 6197.5000000000009 then
                                begin
                                    Result := 0.0041700747364593052;
                                end
                                else
                                begin
                                    Result := -0.025586281581083867;
                                end;
                            end
                            else
                            begin
                                Result := 0.0052184213483854359;
                            end;
                        end
                        else
                        begin
                            Result := 0.025499157898618136;
                        end;
                    end
                    else
                    begin
                        if features.chain_rank <= 1.5000000000000002 then
                        begin
                            Result := 0.018417381190536153;
                        end
                        else
                        begin
                            if features.score_per_unit <= 11167.000000000002 then
                            begin
                                if features.chain_score_gap <= -20341703.499999996 then
                                begin
                                    if features.char_lm_context_gain <= -712.49999999999989 then
                                    begin
                                        Result := 0.031883934249742479;
                                    end
                                    else
                                    begin
                                        Result := -0.0054556887059420724;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -4208.4999999999991 then
                                    begin
                                        Result := -0.021547565279865549;
                                    end
                                    else
                                    begin
                                        if features.path_max_segment_units <= 2.5000000000000004 then
                                        begin
                                            Result := -0.019715790827614071;
                                        end
                                        else
                                        begin
                                            Result := 0.027654655437336563;
                                        end;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := 0.020346494553684303;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
                begin
                    if features.path_single_segments <= 1.5000000000000002 then
                    begin
                        Result := 0.015427773964563039;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -9196.4999999999982 then
                        begin
                            Result := -0.026037184163019325;
                        end
                        else
                        begin
                            Result := 0.0083958369922415236;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_score <= -4513.4999999999991 then
                    begin
                        if features.char_lm_context_score <= -10322.499999999998 then
                        begin
                            Result := 0.016613808341078194;
                        end
                        else
                        begin
                            Result := -0.018766290219882031;
                        end;
                    end
                    else
                    begin
                        Result := 0.0061475806170072835;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_50(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.036351340479215448;
    end
    else
    begin
        if features.char_lm_score <= -4096.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 11599.500000000002 then
            begin
                if features.chain_score_gap <= -62524478.999999993 then
                begin
                    if features.path_single_segments <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.0091972463235850122;
                    end
                    else
                    begin
                        Result := -0.016014446994288879;
                    end;
                end
                else
                begin
                    if features.path_max_segment_units <= 5.5000000000000009 then
                    begin
                        if features.chain_rank <= 1.5000000000000002 then
                        begin
                            if features.path_single_segments <= 2.5000000000000004 then
                            begin
                                Result := 0.014564822098005394;
                            end
                            else
                            begin
                                Result := 0.0048596086198490415;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -1423.4999999999998 then
                            begin
                                Result := -0.020518593371507975;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -64024275.499999993 then
                                begin
                                    if features.path_single_segments <= 2.5000000000000004 then
                                    begin
                                        if features.char_lm_context_gain <= -730.49999999999989 then
                                        begin
                                            Result := 0.037976000968386041;
                                        end
                                        else
                                        begin
                                            Result := -0.0015917144602304915;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.score_per_unit <= 6774.0000000000009 then
                                        begin
                                            Result := -0.028214489245923485;
                                        end
                                        else
                                        begin
                                            Result := 0.01261745480038364;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    if features.text_units <= 16.500000000000004 then
                                    begin
                                        if features.chain_second_stage_score <= -57796089.499999993 then
                                        begin
                                            Result := -0.037529904862533436;
                                        end
                                        else
                                        begin
                                            if features.char_lm_context_gain <= -712.49999999999989 then
                                            begin
                                                if features.chain_first_stage_score <= 116887.50000000001 then
                                                begin
                                                    Result := 0.012274599676284706;
                                                end
                                                else
                                                begin
                                                    Result := -0.0070738967181261546;
                                                end;
                                            end
                                            else
                                            begin
                                                if features.candidate_score <= 76536.000000000015 then
                                                begin
                                                    Result := -0.029536271364564631;
                                                end
                                                else
                                                begin
                                                    if features.char_lm_suffix_score <= -5764.4999999999991 then
                                                    begin
                                                        if features.path_single_segments <= 2.5000000000000004 then
                                                        begin
                                                            Result := 0.0014041848518671785;
                                                        end
                                                        else
                                                        begin
                                                            Result := -0.032982434570643968;
                                                        end;
                                                    end
                                                    else
                                                    begin
                                                        Result := 0.010663936203207226;
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.chain_second_stage_score <= 4810167.5000000009 then
                                        begin
                                            Result := 0.022735377899272668;
                                        end
                                        else
                                        begin
                                            Result := -0.0040476105866400812;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -20341703.499999996 then
                        begin
                            Result := 0.037310007437835434;
                        end
                        else
                        begin
                            if features.score_per_unit <= 22834.500000000004 then
                            begin
                                if features.char_lm_score <= -5730.4999999999991 then
                                begin
                                    Result := -0.022965657897518858;
                                end
                                else
                                begin
                                    Result := -0.0037192495429932962;
                                end;
                            end
                            else
                            begin
                                Result := 0.0060780092968375369;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.path_single_segments <= 1.5000000000000002 then
                begin
                    if features.chain_score_gap <= -45818588.499999993 then
                    begin
                        Result := -0.0043639964261854257;
                    end
                    else
                    begin
                        Result := 0.024917665636582112;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -8974.4999999999982 then
                    begin
                        Result := -0.024448627613631025;
                    end
                    else
                    begin
                        Result := 0.012872473949728819;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -7113512.4999999991 then
            begin
                if features.char_lm_score <= -3460.4999999999995 then
                begin
                    if features.char_lm_score <= -3724.4999999999995 then
                    begin
                        Result := 0.0085970862462112271;
                    end
                    else
                    begin
                        Result := -0.024599411079713421;
                    end;
                end
                else
                begin
                    Result := 0.020940868204213592;
                end;
            end
            else
            begin
                Result := 0.025446243194845303;
            end;
        end;
    end;
end;

function long_final_ranker_tree_51(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.036276560490627059;
    end
    else
    begin
        if features.char_lm_score <= -4465.4999999999991 then
        begin
            if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
            begin
                if features.path_single_segments <= 3.5000000000000004 then
                begin
                    if features.chain_score_gap <= -35118691.999999993 then
                    begin
                        if features.char_lm_context_gain <= -502.49999999999994 then
                        begin
                            if features.char_lm_context_gain <= -730.49999999999989 then
                            begin
                                if features.candidate_score <= 154940.50000000003 then
                                begin
                                    if features.chain_score_gap <= -89371168.999999985 then
                                    begin
                                        if features.char_lm_context_gain <= -903.49999999999989 then
                                        begin
                                            if features.char_lm_context_gain <= -1383.4999999999998 then
                                            begin
                                                Result := 0.0065041809677297566;
                                            end
                                            else
                                            begin
                                                Result := -0.041692825882900512;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := 0.005150640041570548;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.chain_second_stage_score <= -71541965.999999985 then
                                        begin
                                            Result := 0.022098911867401917;
                                        end
                                        else
                                        begin
                                            Result := -0.0048926858926641647;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.02711791144578193;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_suffix_score <= -6231.4999999999991 then
                                begin
                                    if features.chain_second_stage_score <= -86170659.999999985 then
                                    begin
                                        Result := 0.011844652630726201;
                                    end
                                    else
                                    begin
                                        Result := -0.040552213945259007;
                                    end;
                                end
                                else
                                begin
                                    if features.chain_score_gap <= -84765334.999999985 then
                                    begin
                                        Result := -0.028472994705837494;
                                    end
                                    else
                                    begin
                                        Result := 0.011404207612377839;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.018403893377390835;
                        end;
                    end
                    else
                    begin
                        if features.path_single_segments <= 1.5000000000000002 then
                        begin
                            Result := 0.017403208472549801;
                        end
                        else
                        begin
                            if features.char_lm_score <= -6634.4999999999991 then
                            begin
                                Result := -0.0054135247647139617;
                            end
                            else
                            begin
                                Result := 0.011693793285090631;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 110551.50000000001 then
                    begin
                        if features.text_units <= 17.500000000000004 then
                        begin
                            Result := -0.026879413697052899;
                        end
                        else
                        begin
                            Result := 0.012738816930654503;
                        end;
                    end
                    else
                    begin
                        Result := 0.0048831062380558206;
                    end;
                end;
            end
            else
            begin
                Result := -0.011010255076173906;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -9260846.9999999981 then
            begin
                if features.path_single_segments <= 2.5000000000000004 then
                begin
                    if features.chain_second_stage_score <= 27318902.000000004 then
                    begin
                        Result := 0.032784428967369633;
                    end
                    else
                    begin
                        Result := 0.0067175016232333849;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -40225207.999999993 then
                    begin
                        Result := -0.028726953680080672;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= 67401736.500000015 then
                        begin
                            if features.candidate_score <= 83710.000000000015 then
                            begin
                                Result := -0.0060497176678930816;
                            end
                            else
                            begin
                                Result := 0.038946990245588523;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -3603.4999999999995 then
                            begin
                                Result := -0.02155000559947411;
                            end
                            else
                            begin
                                Result := 0.015432118366323039;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.030325327196875352;
                    end
                    else
                    begin
                        Result := 0.017991445390396179;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= 78989567.000000015 then
                    begin
                        Result := -0.0018810924020747348;
                    end
                    else
                    begin
                        if features.char_lm_score <= -3724.4999999999995 then
                        begin
                            Result := 0.029574991089625659;
                        end
                        else
                        begin
                            Result := -0.00053541378343514672;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_52(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.036210847905038514;
    end
    else
    begin
        if features.char_lm_score <= -3892.4999999999995 then
        begin
            if features.dict_weight_per_unit <= 11299.500000000002 then
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if features.path_single_segments <= 3.5000000000000004 then
                    begin
                        if features.char_lm_context_score <= -6675.4999999999991 then
                        begin
                            if features.char_lm_score <= -6634.4999999999991 then
                            begin
                                if features.char_lm_context_gain <= -675.49999999999989 then
                                begin
                                    if features.dict_weight_per_unit <= 8609.0000000000018 then
                                    begin
                                        if features.path_single_segments <= 1.5000000000000002 then
                                        begin
                                            if features.score_per_unit <= 6774.0000000000009 then
                                            begin
                                                Result := 0.018435078145848886;
                                            end
                                            else
                                            begin
                                                Result := -0.017159012324027903;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := -0.034957279652078135;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.0;
                                    end;
                                end
                                else
                                begin
                                    if features.path_segments <= 7.5000000000000009 then
                                    begin
                                        Result := 0.029770247136561026;
                                    end
                                    else
                                    begin
                                        if features.chain_second_stage_score <= -64024275.499999993 then
                                        begin
                                            Result := 0.016389374984423097;
                                        end
                                        else
                                        begin
                                            Result := -0.021775781267570668;
                                        end;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := 0.006374545882563319;
                            end;
                        end
                        else
                        begin
                            Result := 0.014092763935140869;
                        end;
                    end
                    else
                    begin
                        if features.candidate_score <= 83710.000000000015 then
                        begin
                            Result := -0.022362954126880195;
                        end
                        else
                        begin
                            if features.char_lm_score <= -5069.4999999999991 then
                            begin
                                Result := -0.0039036073022549749;
                            end
                            else
                            begin
                                Result := 0.014165865388352902;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_context_gain <= -1423.4999999999998 then
                    begin
                        Result := 0.01237140787194381;
                    end
                    else
                    begin
                        Result := -0.018106698778715152;
                    end;
                end;
            end
            else
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    if features.path_segments <= 4.5000000000000009 then
                    begin
                        Result := 0.029699113750838904;
                    end
                    else
                    begin
                        if features.char_lm_score <= -6315.4999999999991 then
                        begin
                            if features.char_lm_context_gain <= -524.49999999999989 then
                            begin
                                Result := 0.011360748234808513;
                            end
                            else
                            begin
                                Result := -0.029931763347838904;
                            end;
                        end
                        else
                        begin
                            Result := 0.015720419912550524;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_first_stage_score <= 116887.50000000001 then
                    begin
                        if features.char_lm_score <= -5730.4999999999991 then
                        begin
                            if features.char_lm_suffix_score <= -7597.4999999999991 then
                            begin
                                if features.candidate_score <= 113058.50000000001 then
                                begin
                                    Result := -0.022348768067011623;
                                end
                                else
                                begin
                                    Result := 0.0099655622893961102;
                                end;
                            end
                            else
                            begin
                                Result := -0.023761618237626209;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -1107.4999999999998 then
                            begin
                                Result := 0.016229807097359571;
                            end
                            else
                            begin
                                Result := -0.0052447092926308815;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -6693.4999999999991 then
                        begin
                            if features.chain_first_stage_score <= 231700.00000000003 then
                            begin
                                Result := 0.034713635034091493;
                            end
                            else
                            begin
                                Result := -0.0009698326510311616;
                            end;
                        end
                        else
                        begin
                            Result := 0.010134841482368828;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.legacy_rank <= 1.5000000000000002 then
            begin
                if features.chain_rank <= 1.5000000000000002 then
                begin
                    Result := 0.029064008003374414;
                end
                else
                begin
                    if features.chain_second_stage_score <= 100857689.50000001 then
                    begin
                        Result := -0.0098920631457572288;
                    end
                    else
                    begin
                        Result := 0.026607501370304733;
                    end;
                end;
            end
            else
            begin
                Result := 0.0087314272185215029;
            end;
        end;
    end;
end;

function long_final_ranker_tree_53(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.036141217240971871;
    end
    else
    begin
        if features.char_lm_score <= -4096.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 11599.500000000002 then
            begin
                if features.chain_score_gap <= -49674397.499999993 then
                begin
                    if features.path_segments <= 4.5000000000000009 then
                    begin
                        if features.chain_score_gap <= -131664660.49999999 then
                        begin
                            Result := -0.014882798350977932;
                        end
                        else
                        begin
                            Result := 0.023629362828824562;
                        end;
                    end
                    else
                    begin
                        if Ord(features.legacy_top) <= 1.0000000180025095E-35 then
                        begin
                            Result := -0.0059035051164409271;
                        end
                        else
                        begin
                            if features.chain_rank <= 2.5000000000000004 then
                            begin
                                if features.char_lm_context_score <= -6675.4999999999991 then
                                begin
                                    Result := -0.043795695439330561;
                                end
                                else
                                begin
                                    Result := -0.0097238815120676281;
                                end;
                            end
                            else
                            begin
                                Result := 0.0024843826322781737;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
                    begin
                        if features.path_single_segments <= 2.5000000000000004 then
                        begin
                            if features.char_lm_context_score <= -6875.4999999999991 then
                            begin
                                Result := 0.0086242773137333809;
                            end
                            else
                            begin
                                Result := 0.015766706904579906;
                            end;
                        end
                        else
                        begin
                            if features.candidate_score <= 48495.500000000007 then
                            begin
                                Result := -0.014471822695287519;
                            end
                            else
                            begin
                                if features.char_lm_score <= -5016.4999999999991 then
                                begin
                                    if features.chain_score_gap <= -31354499.999999996 then
                                    begin
                                        if features.char_lm_suffix_score <= -5889.4999999999991 then
                                        begin
                                            Result := -0.030841035402016517;
                                        end
                                        else
                                        begin
                                            Result := 0.020152966773085031;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.00037019816164420602;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.013556384974406836;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.score_per_unit <= 22834.500000000004 then
                        begin
                            if features.char_lm_suffix_score <= -7355.4999999999991 then
                            begin
                                Result := -0.028720691122778686;
                            end
                            else
                            begin
                                Result := -0.0061425826546409532;
                            end;
                        end
                        else
                        begin
                            Result := 0.0068754377273741252;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_context_gain <= -456.49999999999994 then
                begin
                    if features.char_lm_suffix_score <= -7411.4999999999991 then
                    begin
                        if features.path_single_segments <= 1.5000000000000002 then
                        begin
                            Result := 0.014076886406577586;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -79482274.999999985 then
                            begin
                                Result := 0.020447489300627182;
                            end
                            else
                            begin
                                Result := -0.022011791714415838;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -53550508.499999993 then
                        begin
                            Result := 0.00010136765873276603;
                        end
                        else
                        begin
                            Result := 0.020818233858651666;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -2087111.4999999998 then
                    begin
                        Result := 0.016698424520951667;
                    end
                    else
                    begin
                        if Ord(features.legacy_top) <= 1.0000000180025095E-35 then
                        begin
                            Result := -0.029686355241193844;
                        end
                        else
                        begin
                            Result := 0.0058623853767068232;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -6389736.9999999991 then
            begin
                if features.path_single_segments <= 2.5000000000000004 then
                begin
                    Result := 0.013169470554569084;
                end
                else
                begin
                    if features.chain_score_gap <= -18943678.499999996 then
                    begin
                        if features.chain_first_stage_score <= -13807.499999999998 then
                        begin
                            Result := 0.011880417307095539;
                        end
                        else
                        begin
                            Result := -0.030952088515442289;
                        end;
                    end
                    else
                    begin
                        Result := 0.013885160194461305;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_score <= -3258.4999999999995 then
                begin
                    Result := 0.019596027392797082;
                end
                else
                begin
                    Result := 0.030364793771654349;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_54(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.036100725918903585;
    end
    else
    begin
        if features.char_lm_score <= -4465.4999999999991 then
        begin
            if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
            begin
                if features.chain_score_gap <= -62524478.999999993 then
                begin
                    if features.chain_rank <= 2.5000000000000004 then
                    begin
                        if Ord(features.legacy_top) <= 1.0000000180025095E-35 then
                        begin
                            if features.chain_score_gap <= -89371168.999999985 then
                            begin
                                Result := -0.020606461462590583;
                            end
                            else
                            begin
                                Result := 0.0032896459417358897;
                            end;
                        end
                        else
                        begin
                            Result := -0.030508572292479424;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -131664660.49999999 then
                        begin
                            Result := -0.025009285821540508;
                        end
                        else
                        begin
                            Result := 0.018417568909266768;
                        end;
                    end;
                end
                else
                begin
                    if features.path_single_segments <= 1.5000000000000002 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            Result := 0.0096665418203370993;
                        end
                        else
                        begin
                            if features.dict_weight <= 51655.000000000007 then
                            begin
                                Result := 0.036283988018568109;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -48222823.499999993 then
                                begin
                                    Result := -0.016542548708620444;
                                end
                                else
                                begin
                                    Result := 0.01884885219608463;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -9196.4999999999982 then
                        begin
                            Result := -0.020522652558129871;
                        end
                        else
                        begin
                            if features.path_single_segments <= 3.5000000000000004 then
                            begin
                                if features.char_lm_score <= -5730.4999999999991 then
                                begin
                                    if features.chain_second_stage_score <= -64024275.499999993 then
                                    begin
                                        if features.dict_weight_per_unit <= 11881.500000000002 then
                                        begin
                                            Result := 0.0070726130179410629;
                                        end
                                        else
                                        begin
                                            Result := 0.041185647187874722;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.chain_score_gap <= -32230640.999999996 then
                                        begin
                                            Result := -0.030363247439563194;
                                        end
                                        else
                                        begin
                                            if features.dict_weight_per_unit <= 4263.5000000000009 then
                                            begin
                                                Result := -0.024661535111714625;
                                            end
                                            else
                                            begin
                                                Result := 0.0057715472657661549;
                                            end;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= 53256438.500000007 then
                                    begin
                                        if features.legacy_rank <= 2.5000000000000004 then
                                        begin
                                            Result := 0.014570468582775555;
                                        end
                                        else
                                        begin
                                            Result := -0.013976673123547013;
                                        end;
                                    end
                                    else
                                    begin
                                        if Ord(features.legacy_top) <= 1.0000000180025095E-35 then
                                        begin
                                            Result := -0.023124803193255373;
                                        end
                                        else
                                        begin
                                            Result := 0.0096806176302519503;
                                        end;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.dict_weight_per_unit <= 9351.5000000000018 then
                                begin
                                    if features.text_units <= 17.500000000000004 then
                                    begin
                                        Result := -0.015350803643526516;
                                    end
                                    else
                                    begin
                                        if features.chain_score_gap <= -17680160.999999996 then
                                        begin
                                            Result := 0.027051442225480542;
                                        end
                                        else
                                        begin
                                            Result := -0.011455673315509975;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.0055425551247477974;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := -0.0099844697227921934;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -30706224.999999996 then
            begin
                if features.path_single_segments <= 2.5000000000000004 then
                begin
                    Result := 0.0089526403290190529;
                end
                else
                begin
                    if features.chain_first_stage_score <= -13807.499999999998 then
                    begin
                        Result := 0.013128798239137101;
                    end
                    else
                    begin
                        Result := -0.02944063545003945;
                    end;
                end;
            end
            else
            begin
                if features.chain_second_stage_score <= 30070907.500000004 then
                begin
                    if features.legacy_rank <= 1.5000000000000002 then
                    begin
                        Result := 0.030328862280320865;
                    end
                    else
                    begin
                        Result := 0.0059091427320614245;
                    end;
                end
                else
                begin
                    Result := 0.016897185155209393;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_55(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.partial_match) <= 1.0000000180025095E-35 then
    begin
        if features.char_lm_score <= -4263.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 11415.000000000002 then
            begin
                if features.chain_score_gap <= -34246216.999999993 then
                begin
                    if features.path_segments <= 3.5000000000000004 then
                    begin
                        if features.chain_score_gap <= -122461489.49999999 then
                        begin
                            Result := -0.011272652355432936;
                        end
                        else
                        begin
                            Result := 0.030875057573996816;
                        end;
                    end
                    else
                    begin
                        if features.legacy_rank <= 1.5000000000000002 then
                        begin
                            if features.chain_second_stage_score <= -75170768.499999985 then
                            begin
                                Result := 0.00082953376356723659;
                            end
                            else
                            begin
                                if features.char_lm_suffix_score <= -5547.4999999999991 then
                                begin
                                    Result := -0.033766576492233247;
                                end
                                else
                                begin
                                    Result := 0.0;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -5730.4999999999991 then
                            begin
                                Result := -0.01252353161438002;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= 31744429.500000004 then
                                begin
                                    if features.chain_score_gap <= -59742350.999999993 then
                                    begin
                                        Result := -0.0018331754977043383;
                                    end
                                    else
                                    begin
                                        Result := 0.02372108261322604;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.015886654416004769;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.legacy_rank <= 2.5000000000000004 then
                    begin
                        if features.path_single_segments <= 2.5000000000000004 then
                        begin
                            if features.score_per_unit <= 10810.500000000002 then
                            begin
                                if features.char_lm_context_score <= -7549.4999999999991 then
                                begin
                                    if features.chain_second_stage_score <= -64024275.499999993 then
                                    begin
                                        Result := 0.028919964334309389;
                                    end
                                    else
                                    begin
                                        if features.chain_second_stage_score <= -22453883.499999996 then
                                        begin
                                            Result := -0.0097712837972355592;
                                        end
                                        else
                                        begin
                                            Result := 0.0084949534738080253;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.016417125835826961;
                                end;
                            end
                            else
                            begin
                                Result := 0.00094943698794483662;
                            end;
                        end
                        else
                        begin
                            Result := 0.0012451971383492322;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -18208077.499999996 then
                        begin
                            Result := 0.017816422772640776;
                        end
                        else
                        begin
                            Result := -0.021914749674515222;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.path_segments <= 7.5000000000000009 then
                begin
                    if features.chain_score_gap <= -80717555.999999985 then
                    begin
                        Result := -0.018228515354558293;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -9082.4999999999982 then
                        begin
                            if features.path_segments <= 3.5000000000000004 then
                            begin
                                Result := 0.020855797511700476;
                            end
                            else
                            begin
                                Result := -0.008393175769533778;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -55362432.999999993 then
                            begin
                                Result := 0.043781143422929693;
                            end
                            else
                            begin
                                if features.candidate_score <= 138130.50000000003 then
                                begin
                                    Result := 0.024585655788318429;
                                end
                                else
                                begin
                                    Result := 0.012425890333537831;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.0058946512039091828;
                end;
            end;
        end
        else
        begin
            if features.char_lm_score <= -3258.4999999999995 then
            begin
                if features.score_per_unit <= 3548.5000000000005 then
                begin
                    if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                    begin
                        Result := 0.016171610126871801;
                    end
                    else
                    begin
                        if features.char_lm_score <= -3991.4999999999995 then
                        begin
                            Result := 0.0069207358763687899;
                        end
                        else
                        begin
                            Result := -0.035636418011604915;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.017260984961009477;
                end;
            end
            else
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    Result := 0.031518143996802521;
                end
                else
                begin
                    Result := 0.0017523339362224505;
                end;
            end;
        end;
    end
    else
    begin
        Result := -0.036054404963049423;
    end;
end;

function long_final_ranker_tree_56(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035987123916292524;
    end
    else
    begin
        if features.char_lm_score <= -5069.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 10762.500000000002 then
            begin
                if features.chain_rank <= 2.5000000000000004 then
                begin
                    if features.chain_score_gap <= -34246216.999999993 then
                    begin
                        if features.char_lm_context_gain <= -404.49999999999994 then
                        begin
                            if Ord(features.legacy_top) <= 1.0000000180025095E-35 then
                            begin
                                Result := -0.012513806533668143;
                            end
                            else
                            begin
                                Result := -0.03676858856330175;
                            end;
                        end
                        else
                        begin
                            Result := 0.013564964349435346;
                        end;
                    end
                    else
                    begin
                        if features.path_max_segment_units <= 5.5000000000000009 then
                        begin
                            if features.chain_first_stage_score <= 38375.500000000007 then
                            begin
                                Result := 0.015716363204695813;
                            end
                            else
                            begin
                                if features.chain_first_stage_score <= 96987.000000000015 then
                                begin
                                    if features.char_lm_context_gain <= -1247.4999999999998 then
                                    begin
                                        Result := 0.017697255771073946;
                                    end
                                    else
                                    begin
                                        if features.chain_second_stage_score <= -75170768.499999985 then
                                        begin
                                            Result := 0.016023652612772842;
                                        end
                                        else
                                        begin
                                            if features.text_units <= 13.500000000000002 then
                                            begin
                                                Result := -0.027616658503730036;
                                            end
                                            else
                                            begin
                                                Result := 0.0087049172068922494;
                                            end;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_context_gain <= -1314.4999999999998 then
                                    begin
                                        Result := -0.028980602093872706;
                                    end
                                    else
                                    begin
                                        if features.char_lm_context_gain <= -544.49999999999989 then
                                        begin
                                            Result := 0.0096179912540754059;
                                        end
                                        else
                                        begin
                                            Result := -0.0089460533925561237;
                                        end;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.score_per_unit <= 22834.500000000004 then
                            begin
                                Result := -0.016551715474908475;
                            end
                            else
                            begin
                                Result := 0.011714462235588776;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -131664660.49999999 then
                    begin
                        Result := -0.011690677268401879;
                    end
                    else
                    begin
                        Result := 0.029578018190859295;
                    end;
                end;
            end
            else
            begin
                if features.chain_score_gap <= -52757794.999999993 then
                begin
                    Result := -0.0061010062557759256;
                end
                else
                begin
                    if features.path_single_segments <= 2.5000000000000004 then
                    begin
                        if features.chain_second_stage_score <= -51349360.499999993 then
                        begin
                            Result := 0.035096174470186897;
                        end
                        else
                        begin
                            Result := 0.01333603076532292;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_score <= -6315.4999999999991 then
                        begin
                            Result := -0.013639216471878985;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 22220565.000000004 then
                            begin
                                Result := 0.015782206654864753;
                            end
                            else
                            begin
                                Result := -0.0079989044294448437;
                            end;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.char_lm_score <= -3258.4999999999995 then
            begin
                if features.score_per_unit <= 3548.5000000000005 then
                begin
                    if features.chain_first_stage_score <= 55406.000000000007 then
                    begin
                        if features.chain_first_stage_score <= 33380.500000000007 then
                        begin
                            if features.chain_second_stage_score <= -36481495.999999993 then
                            begin
                                Result := -0.032526110157240586;
                            end
                            else
                            begin
                                if features.chain_first_stage_score <= -32045.499999999996 then
                                begin
                                    Result := 0.020756024319757843;
                                end
                                else
                                begin
                                    Result := -0.0094673755114328129;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.026376127481517186;
                        end;
                    end
                    else
                    begin
                        Result := -0.03150835237942777;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -131664660.49999999 then
                    begin
                        Result := -0.028907169401444284;
                    end
                    else
                    begin
                        Result := 0.014712032789999276;
                    end;
                end;
            end
            else
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    Result := 0.031242923476034828;
                end
                else
                begin
                    Result := 0.0050188087372719323;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_57(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035923882527859129;
    end
    else
    begin
        if features.char_lm_score <= -4465.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 10476.500000000002 then
            begin
                if features.path_single_segments <= 3.5000000000000004 then
                begin
                    if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
                    begin
                        if features.chain_second_stage_score <= -10184703.999999998 then
                        begin
                            if features.dict_weight_per_unit <= 3870.5000000000005 then
                            begin
                                if features.chain_score_gap <= -127081972.99999999 then
                                begin
                                    Result := -0.017321490360431631;
                                end
                                else
                                begin
                                    if features.chain_first_stage_score <= -126691.99999999999 then
                                    begin
                                        Result := -0.010551667748396653;
                                    end
                                    else
                                    begin
                                        Result := 0.02690621907087528;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -62524478.999999993 then
                                begin
                                    if features.char_lm_score <= -4862.4999999999991 then
                                    begin
                                        Result := -0.03003577016329291;
                                    end
                                    else
                                    begin
                                        Result := 0.014146638680298491;
                                    end;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= -67962788.499999985 then
                                    begin
                                        if features.path_single_segments <= 2.5000000000000004 then
                                        begin
                                            Result := 0.023060560074264238;
                                        end
                                        else
                                        begin
                                            Result := -0.012352615266984005;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.char_lm_suffix_score <= -6059.4999999999991 then
                                        begin
                                            if features.chain_score_gap <= -34246216.999999993 then
                                            begin
                                                Result := -0.025047913348414424;
                                            end
                                            else
                                            begin
                                                Result := -0.0045341482956783238;
                                            end;
                                        end
                                        else
                                        begin
                                            if features.dict_weight_per_unit <= 8965.5000000000018 then
                                            begin
                                                Result := 0.031485974694240727;
                                            end
                                            else
                                            begin
                                                Result := -0.013507264889188417;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.dict_weight <= 120968.00000000001 then
                            begin
                                if features.path_segments <= 1.0000000180025095E-35 then
                                begin
                                    Result := 0.0014550205498903318;
                                end
                                else
                                begin
                                    Result := 0.017723815122092451;
                                end;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -999794.49999999988 then
                                begin
                                    Result := -0.018839712144311602;
                                end
                                else
                                begin
                                    Result := 0.0097947029002178054;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.score_per_unit <= 22834.500000000004 then
                        begin
                            Result := -0.015374567491780186;
                        end
                        else
                        begin
                            Result := 0.0089488047430082273;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.011500314081237993;
                end;
            end
            else
            begin
                if features.chain_score_gap <= -48222823.499999993 then
                begin
                    if features.char_lm_score <= -6634.4999999999991 then
                    begin
                        Result := 0.025570755086848571;
                    end
                    else
                    begin
                        Result := -0.0095996853754240028;
                    end;
                end
                else
                begin
                    if features.path_segments <= 5.5000000000000009 then
                    begin
                        if features.char_lm_suffix_score <= -7057.4999999999991 then
                        begin
                            if features.chain_first_stage_score <= 109886.50000000001 then
                            begin
                                Result := -0.0033932077611417478;
                            end
                            else
                            begin
                                Result := 0.024827628940710236;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 63339318.000000007 then
                            begin
                                Result := 0.025976501724734802;
                            end
                            else
                            begin
                                Result := -0.0074104879069268534;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.0082275242176381349;
                    end;
                end;
            end;
        end
        else
        begin
            if features.char_lm_score <= -3258.4999999999995 then
            begin
                if features.chain_score_gap <= -30706224.999999996 then
                begin
                    if features.path_single_segments <= 2.5000000000000004 then
                    begin
                        Result := 0.0090775233149561416;
                    end
                    else
                    begin
                        Result := -0.021404417785429161;
                    end;
                end
                else
                begin
                    Result := 0.015776545830677481;
                end;
            end
            else
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    Result := 0.031743675356494687;
                end
                else
                begin
                    Result := 0.0053033839314305595;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_58(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035866920484395166;
    end
    else
    begin
        if features.char_lm_score <= -4465.4999999999991 then
        begin
            if features.chain_score_gap <= -52040049.499999993 then
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    if features.dict_weight_per_unit <= 5520.0000000000009 then
                    begin
                        if features.text_units <= 11.500000000000002 then
                        begin
                            Result := -0.016386978079165691;
                        end
                        else
                        begin
                            Result := 0.017213789527498032;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -64024275.499999993 then
                        begin
                            Result := -0.0080343059256570305;
                        end
                        else
                        begin
                            Result := -0.04866523762431247;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.0;
                end;
            end
            else
            begin
                if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
                begin
                    if features.path_single_segments <= 2.5000000000000004 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            if features.chain_second_stage_score <= -75170768.499999985 then
                            begin
                                Result := 0.032932099293867569;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -57796089.499999993 then
                                begin
                                    Result := -0.025568698866826032;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -5933.4999999999991 then
                                    begin
                                        Result := -0.0034359610326469637;
                                    end
                                    else
                                    begin
                                        Result := 0.010798201173631745;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.candidate_score <= 136724.00000000003 then
                            begin
                                if features.chain_second_stage_score <= 43913953.000000007 then
                                begin
                                    if features.chain_score_gap <= -34246216.999999993 then
                                    begin
                                        Result := 0.0014540349820812537;
                                    end
                                    else
                                    begin
                                        Result := 0.025194136661165864;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.00019360086471441467;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_context_gain <= -712.49999999999989 then
                                begin
                                    Result := 0.016247090117027008;
                                end
                                else
                                begin
                                    if features.chain_first_stage_score <= 153044.00000000003 then
                                    begin
                                        if features.chain_second_stage_score <= 12710763.500000002 then
                                        begin
                                            Result := 0.0042745110058368778;
                                        end
                                        else
                                        begin
                                            Result := -0.033331395322109769;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.0079875019797652717;
                                    end;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -5989.4999999999991 then
                        begin
                            if features.dict_weight_per_unit <= 9351.5000000000018 then
                            begin
                                Result := -0.012079825399718249;
                            end
                            else
                            begin
                                if features.char_lm_suffix_score <= -7227.4999999999991 then
                                begin
                                    Result := -0.015767640448939788;
                                end
                                else
                                begin
                                    Result := 0.0060770532594748459;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.path_single_segments <= 4.5000000000000009 then
                            begin
                                Result := 0.014701488816031436;
                            end
                            else
                            begin
                                Result := -0.0077323925932484489;
                            end;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.0098752232658922585;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -9260846.9999999981 then
            begin
                if features.path_single_segments <= 2.5000000000000004 then
                begin
                    if features.chain_score_gap <= -10732023.999999998 then
                    begin
                        Result := 0.014477191497312232;
                    end
                    else
                    begin
                        Result := -0.02187100586415909;
                    end;
                end
                else
                begin
                    Result := -0.0089049174081830482;
                end;
            end
            else
            begin
                if features.char_lm_score <= -3258.4999999999995 then
                begin
                    if features.char_lm_score <= -3460.4999999999995 then
                    begin
                        if features.chain_score_gap <= -2087111.4999999998 then
                        begin
                            Result := 0.038520122456571423;
                        end
                        else
                        begin
                            Result := 0.016096339342569106;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -2931978.9999999995 then
                        begin
                            Result := -0.031459152127522073;
                        end
                        else
                        begin
                            Result := 0.0079127352461706383;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.028342048437644311;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_59(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.03580902655998211;
    end
    else
    begin
        if features.char_lm_score <= -3892.4999999999995 then
        begin
            if features.dict_weight_per_unit <= 10476.500000000002 then
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    if features.chain_second_stage_score <= -28923338.999999996 then
                    begin
                        if features.char_lm_context_gain <= -730.49999999999989 then
                        begin
                            if features.char_lm_context_gain <= -903.49999999999989 then
                            begin
                                Result := -0.007299289817986743;
                            end
                            else
                            begin
                                Result := 0.011708243528951643;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -481.49999999999994 then
                            begin
                                if features.dict_weight <= 113080.50000000001 then
                                begin
                                    Result := -0.033868957418703979;
                                end
                                else
                                begin
                                    Result := -0.0073079441644368854;
                                end;
                            end
                            else
                            begin
                                if features.dict_weight_per_unit <= 5889.5000000000009 then
                                begin
                                    Result := 0.031891457989604528;
                                end
                                else
                                begin
                                    Result := -0.010635848917227323;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -29696304.999999996 then
                        begin
                            Result := -0.0077998428378476363;
                        end
                        else
                        begin
                            if features.dict_weight_per_unit <= 3870.5000000000005 then
                            begin
                                if features.chain_score_gap <= -17680160.999999996 then
                                begin
                                    Result := 0.033842110127629658;
                                end
                                else
                                begin
                                    Result := -0.00056555405667639525;
                                end;
                            end
                            else
                            begin
                                if features.chain_first_stage_score <= 72742.500000000015 then
                                begin
                                    Result := 0.020833539360730988;
                                end
                                else
                                begin
                                    if features.char_lm_context_score <= -7671.4999999999991 then
                                    begin
                                        Result := -0.010161000659437276;
                                    end
                                    else
                                    begin
                                        Result := 0.009739224535571335;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.score_per_unit <= 15654.000000000002 then
                    begin
                        Result := -0.02017625242472822;
                    end
                    else
                    begin
                        Result := 0.019021946198564715;
                    end;
                end;
            end
            else
            begin
                if features.chain_score_gap <= -40225207.999999993 then
                begin
                    if features.char_lm_score <= -6634.4999999999991 then
                    begin
                        Result := 0.025607198725955637;
                    end
                    else
                    begin
                        Result := -0.0050741485493988256;
                    end;
                end
                else
                begin
                    if features.char_lm_score <= -6772.4999999999991 then
                    begin
                        Result := -0.0032977593930866179;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -3469666.9999999995 then
                        begin
                            if features.path_max_segment_units <= 2.5000000000000004 then
                            begin
                                Result := 0.0025400075736490483;
                            end
                            else
                            begin
                                Result := 0.031060001341031141;
                            end;
                        end
                        else
                        begin
                            if features.dict_weight_per_unit <= 11881.500000000002 then
                            begin
                                if features.char_lm_context_score <= -6875.4999999999991 then
                                begin
                                    Result := -0.0078792297438624644;
                                end
                                else
                                begin
                                    Result := 0.010450329359559992;
                                end;
                            end
                            else
                            begin
                                Result := 0.015444472837615837;
                            end;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -2931978.9999999995 then
            begin
                if features.char_lm_score <= -2978.4999999999995 then
                begin
                    if features.chain_first_stage_score <= 80098.500000000015 then
                    begin
                        if features.chain_first_stage_score <= -13807.499999999998 then
                        begin
                            Result := 0.015186761810340361;
                        end
                        else
                        begin
                            Result := -0.032493318477319462;
                        end;
                    end
                    else
                    begin
                        Result := 0.012050602533330474;
                    end;
                end
                else
                begin
                    Result := 0.031568901578348248;
                end;
            end
            else
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    Result := 0.02643725549766077;
                end
                else
                begin
                    if features.chain_second_stage_score <= 108561290.00000001 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            Result := -0.010080324873591454;
                        end
                        else
                        begin
                            Result := 0.027091794497115285;
                        end;
                    end
                    else
                    begin
                        Result := -0.018097258403208617;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_60(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035768738000882545;
    end
    else
    begin
        if features.char_lm_suffix_score <= -5475.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 11415.000000000002 then
            begin
                if features.path_max_segment_units <= 9.5000000000000018 then
                begin
                    if features.chain_score_gap <= -34246216.999999993 then
                    begin
                        if features.path_segments <= 4.5000000000000009 then
                        begin
                            Result := 0.01941766639263021;
                        end
                        else
                        begin
                            if features.char_lm_suffix_score <= -6261.4999999999991 then
                            begin
                                if features.chain_second_stage_score <= -64024275.499999993 then
                                begin
                                    if features.candidate_score <= 144005.00000000003 then
                                    begin
                                        if features.dict_weight_per_unit <= 3870.5000000000005 then
                                        begin
                                            Result := 0.02153332324700951;
                                        end
                                        else
                                        begin
                                            if features.chain_rank <= 2.5000000000000004 then
                                            begin
                                                Result := -0.025210600030347141;
                                            end
                                            else
                                            begin
                                                Result := 0.015695577587531085;
                                            end;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.022640941511290751;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_context_gain <= -807.49999999999989 then
                                    begin
                                        Result := -0.013342411142013958;
                                    end
                                    else
                                    begin
                                        Result := -0.044608921991977295;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.chain_first_stage_score <= 43010.000000000007 then
                                begin
                                    if features.char_lm_suffix_score <= -5704.4999999999991 then
                                    begin
                                        Result := -0.04043614216864793;
                                    end
                                    else
                                    begin
                                        Result := 0.016679605559268246;
                                    end;
                                end
                                else
                                begin
                                    if features.dict_weight <= 92601.000000000015 then
                                    begin
                                        Result := 0.025727193618932397;
                                    end
                                    else
                                    begin
                                        if features.candidate_score <= 112772.00000000001 then
                                        begin
                                            if features.path_segments <= 5.5000000000000009 then
                                            begin
                                                Result := 0.011136546964018629;
                                            end
                                            else
                                            begin
                                                Result := -0.037489544931189125;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := 0.0094180670955227603;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.path_single_segments <= 2.5000000000000004 then
                        begin
                            if features.chain_second_stage_score <= -64024275.499999993 then
                            begin
                                Result := 0.025837837749594743;
                            end
                            else
                            begin
                                if features.char_lm_context_score <= -7549.4999999999991 then
                                begin
                                    Result := -0.0012995480482518678;
                                end
                                else
                                begin
                                    if features.path_single_segments <= 1.0000000180025095E-35 then
                                    begin
                                        if features.chain_second_stage_score <= 21295313.500000004 then
                                        begin
                                            if features.path_segments <= 1.5000000000000002 then
                                            begin
                                                if features.candidate_score <= 130002.00000000001 then
                                                begin
                                                    Result := -0.014123025150357673;
                                                end
                                                else
                                                begin
                                                    Result := 0.012982956912606067;
                                                end;
                                            end
                                            else
                                            begin
                                                Result := 0.025733829932222195;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := -0.021288072082645521;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.chain_score_gap <= -2087111.4999999998 then
                                        begin
                                            if features.chain_second_stage_score <= -3469666.9999999995 then
                                            begin
                                                Result := 0.020883747054353672;
                                            end
                                            else
                                            begin
                                                Result := -0.0101268660410085;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := 0.017481977554951126;
                                        end;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := -0.0025856174890143257;
                        end;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 194860.00000000003 then
                    begin
                        Result := -0.018513655061238019;
                    end
                    else
                    begin
                        Result := 0.006591589366158326;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_suffix_score <= -7411.4999999999991 then
                begin
                    Result := 0.0015673348741498067;
                end
                else
                begin
                    Result := 0.016079836825178575;
                end;
            end;
        end
        else
        begin
            if features.chain_second_stage_score <= 12710763.500000002 then
            begin
                Result := 0.023938055010597464;
            end
            else
            begin
                if features.chain_score_gap <= -44917436.999999993 then
                begin
                    Result := -0.013187604966822253;
                end
                else
                begin
                    Result := 0.012215833866228685;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_61(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035704948486142696;
    end
    else
    begin
        if features.char_lm_score <= -3892.4999999999995 then
        begin
            if features.dict_weight_per_unit <= 11415.000000000002 then
            begin
                if features.chain_second_stage_score <= 100857689.50000001 then
                begin
                    if features.path_single_segments <= 3.5000000000000004 then
                    begin
                        if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
                        begin
                            if features.dict_weight_per_unit <= 7074.5000000000009 then
                            begin
                                if features.chain_second_stage_score <= -79482274.999999985 then
                                begin
                                    if features.score_per_unit <= 5180.0000000000009 then
                                    begin
                                        Result := 0.015855583474269498;
                                    end
                                    else
                                    begin
                                        Result := -0.018339759247305128;
                                    end;
                                end
                                else
                                begin
                                    if features.path_max_segment_units <= 2.5000000000000004 then
                                    begin
                                        Result := 0.0060861435650775581;
                                    end
                                    else
                                    begin
                                        Result := 0.0205136258491002;
                                    end;
                                end;
                            end
                            else
                            begin
                                if Ord(features.legacy_top) <= 1.0000000180025095E-35 then
                                begin
                                    if features.dict_weight <= 146619.00000000003 then
                                    begin
                                        if features.char_lm_score <= -6634.4999999999991 then
                                        begin
                                            Result := -0.015301811090832351;
                                        end
                                        else
                                        begin
                                            Result := 0.0056100039306377194;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.score_per_unit <= 10722.500000000002 then
                                        begin
                                            Result := 0.00013196471817723322;
                                        end
                                        else
                                        begin
                                            if features.char_lm_score <= -4610.4999999999991 then
                                            begin
                                                Result := 0.033036274884053259;
                                            end
                                            else
                                            begin
                                                Result := -0.0097854077571602142;
                                            end;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    if features.chain_rank <= 1.5000000000000002 then
                                    begin
                                        if features.path_single_segments <= 2.5000000000000004 then
                                        begin
                                            Result := 0.0090396268928060047;
                                        end
                                        else
                                        begin
                                            Result := -0.0052120381604939016;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.char_lm_context_gain <= -730.49999999999989 then
                                        begin
                                            if features.dict_weight_per_unit <= 9884.0000000000018 then
                                            begin
                                                Result := -0.014504921206133201;
                                            end
                                            else
                                            begin
                                                Result := 0.014536283664157658;
                                            end;
                                        end
                                        else
                                        begin
                                            if features.chain_first_stage_score <= 178232.50000000003 then
                                            begin
                                                Result := -0.043476235684316258;
                                            end
                                            else
                                            begin
                                                Result := 0.00012725822523428366;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.score_per_unit <= 24168.500000000004 then
                            begin
                                Result := -0.012633551693203059;
                            end
                            else
                            begin
                                Result := 0.011363217986203839;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.text_units <= 16.500000000000004 then
                        begin
                            if features.candidate_score <= 110551.50000000001 then
                            begin
                                if features.chain_second_stage_score <= -27494981.499999996 then
                                begin
                                    Result := -0.031197243271883068;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= -23768986.499999996 then
                                    begin
                                        Result := 0.023099400486801935;
                                    end
                                    else
                                    begin
                                        Result := -0.014634763608886913;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.000191811637374096;
                            end;
                        end
                        else
                        begin
                            Result := 0.0033632718821337624;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.032555979856178682;
                end;
            end
            else
            begin
                if features.char_lm_context_score <= -8974.4999999999982 then
                begin
                    Result := -0.0036954874800242845;
                end
                else
                begin
                    if features.path_segments <= 6.5000000000000009 then
                    begin
                        Result := 0.017932999153848245;
                    end
                    else
                    begin
                        Result := 0.006876265906393811;
                    end;
                end;
            end;
        end
        else
        begin
            if features.char_lm_score <= -3258.4999999999995 then
            begin
                if features.char_lm_context_gain <= -275.49999999999994 then
                begin
                    Result := 0.015796860689657161;
                end
                else
                begin
                    Result := -0.015759844796066413;
                end;
            end
            else
            begin
                if Ord(features.legacy_top) <= 1.0000000180025095E-35 then
                begin
                    Result := 0.0043428149897239334;
                end
                else
                begin
                    Result := 0.030389434343623602;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_62(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035652832325751997;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4778.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 11415.000000000002 then
            begin
                if features.path_single_segments <= 3.5000000000000004 then
                begin
                    if features.char_lm_suffix_score <= -6059.4999999999991 then
                    begin
                        if features.candidate_score <= 194860.00000000003 then
                        begin
                            if features.char_lm_context_gain <= -712.49999999999989 then
                            begin
                                if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
                                begin
                                    Result := 0.0049608629538917728;
                                end
                                else
                                begin
                                    Result := -0.011006584136756361;
                                end;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -20468598.999999996 then
                                begin
                                    if features.text_units <= 15.500000000000002 then
                                    begin
                                        if features.char_lm_context_score <= -6925.4999999999991 then
                                        begin
                                            if features.char_lm_suffix_score <= -7411.4999999999991 then
                                            begin
                                                Result := 0.00016842387592108131;
                                            end
                                            else
                                            begin
                                                Result := -0.042804717575430577;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := 0.0027815233234235498;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.chain_second_stage_score <= -47514492.499999993 then
                                        begin
                                            Result := 0.03011037674619824;
                                        end
                                        else
                                        begin
                                            Result := -0.020426029459902621;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.0021831603789115991;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.014295997109054055;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -127081972.99999999 then
                        begin
                            Result := -0.033243887317003333;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -19121511.999999996 then
                            begin
                                if features.dict_weight_per_unit <= 9351.5000000000018 then
                                begin
                                    if features.chain_first_stage_score <= 43010.000000000007 then
                                    begin
                                        Result := -0.0037434315452569283;
                                    end
                                    else
                                    begin
                                        Result := 0.043569500855970202;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.0;
                                end;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -50555175.499999993 then
                                begin
                                    Result := -0.011023085119813991;
                                end
                                else
                                begin
                                    Result := 0.0089760610989042672;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.text_units <= 16.500000000000004 then
                    begin
                        if features.chain_score_gap <= -34246216.999999993 then
                        begin
                            Result := -0.027214291096143151;
                        end
                        else
                        begin
                            Result := -0.0062721117470206081;
                        end;
                    end
                    else
                    begin
                        Result := 0.0029416164737073834;
                    end;
                end;
            end
            else
            begin
                if features.chain_score_gap <= -77340656.499999985 then
                begin
                    if features.candidate_score <= 194860.00000000003 then
                    begin
                        Result := -0.030086881147880933;
                    end
                    else
                    begin
                        Result := 0.014626824668116845;
                    end;
                end
                else
                begin
                    if features.path_segments <= 6.5000000000000009 then
                    begin
                        if features.char_lm_context_score <= -8592.4999999999982 then
                        begin
                            if features.legacy_rank <= 1.5000000000000002 then
                            begin
                                Result := 0.016851753994192253;
                            end
                            else
                            begin
                                Result := -0.0075325329342989375;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 55378264.000000007 then
                            begin
                                Result := 0.022403778049359061;
                            end
                            else
                            begin
                                if features.char_lm_context_score <= -6417.4999999999991 then
                                begin
                                    Result := -0.015474961264337757;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -3724.4999999999995 then
                                    begin
                                        Result := 0.018304333924784186;
                                    end
                                    else
                                    begin
                                        Result := -0.020131926384364524;
                                    end;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.006638258980639699;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -20341703.499999996 then
            begin
                Result := 0.00036817662472604195;
            end
            else
            begin
                if features.chain_second_stage_score <= 89263497.000000015 then
                begin
                    Result := 0.031093612949742364;
                end
                else
                begin
                    Result := 0.017362506385906553;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_63(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035610639754211103;
    end
    else
    begin
        if features.char_lm_suffix_score <= -5412.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 11415.000000000002 then
            begin
                if features.chain_score_gap <= -34246216.999999993 then
                begin
                    if features.path_segments <= 4.5000000000000009 then
                    begin
                        Result := 0.016799000716379655;
                    end
                    else
                    begin
                        if features.legacy_rank <= 1.5000000000000002 then
                        begin
                            if features.dict_weight <= 95798.500000000015 then
                            begin
                                Result := -0.012995454662944272;
                            end
                            else
                            begin
                                Result := -0.038549805900598817;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -5730.4999999999991 then
                            begin
                                Result := -0.013269893671971905;
                            end
                            else
                            begin
                                Result := 0.0088656263017650224;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.path_max_segment_units <= 10.500000000000002 then
                    begin
                        if features.char_lm_context_score <= -7614.4999999999991 then
                        begin
                            if features.chain_score_gap <= -21719169.999999996 then
                            begin
                                if features.input_syllable_count <= 10.500000000000002 then
                                begin
                                    Result := 0.031362243610579432;
                                end
                                else
                                begin
                                    Result := -0.00068291354841329779;
                                end;
                            end
                            else
                            begin
                                Result := -0.0032512808252083848;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_score <= -6208.4999999999991 then
                            begin
                                if features.path_single_segments <= 1.0000000180025095E-35 then
                                begin
                                    if features.chain_second_stage_score <= 21295313.500000004 then
                                    begin
                                        Result := 0.0041296130082644896;
                                    end
                                    else
                                    begin
                                        Result := -0.019281764873680426;
                                    end;
                                end
                                else
                                begin
                                    if features.path_single_segments <= 2.5000000000000004 then
                                    begin
                                        if features.chain_score_gap <= -999794.49999999988 then
                                        begin
                                            Result := 0.0037703823254108225;
                                        end
                                        else
                                        begin
                                            Result := 0.02081436943069408;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.chain_second_stage_score <= -6376268.4999999991 then
                                        begin
                                            Result := 0.01389234754628362;
                                        end
                                        else
                                        begin
                                            if features.chain_second_stage_score <= 36652805.000000007 then
                                            begin
                                                if features.chain_second_stage_score <= 21295313.500000004 then
                                                begin
                                                    Result := -0.0015923219444605506;
                                                end
                                                else
                                                begin
                                                    Result := -0.025339815077236687;
                                                end;
                                            end
                                            else
                                            begin
                                                Result := 0.016541866724234817;
                                            end;
                                        end;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.0057812391396078631;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := -0.013777702568050457;
                    end;
                end;
            end
            else
            begin
                if features.chain_second_stage_score <= 59813173.500000007 then
                begin
                    if features.path_segments <= 7.5000000000000009 then
                    begin
                        if features.chain_score_gap <= -80717555.999999985 then
                        begin
                            Result := -0.021187662209349069;
                        end
                        else
                        begin
                            if features.char_lm_context_score <= -8974.4999999999982 then
                            begin
                                Result := 0.00068435307961408091;
                            end
                            else
                            begin
                                if features.candidate_score <= 139721.50000000003 then
                                begin
                                    Result := 0.026501118305815162;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= -22453883.499999996 then
                                    begin
                                        Result := 0.033769140307235129;
                                    end
                                    else
                                    begin
                                        Result := 0.009548167376798972;
                                    end;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_score <= -6315.4999999999991 then
                        begin
                            Result := -0.01364413421715318;
                        end
                        else
                        begin
                            Result := 0.0070960737613112853;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.016499770413099437;
                end;
            end;
        end
        else
        begin
            if features.chain_second_stage_score <= 12710763.500000002 then
            begin
                Result := 0.024015829431515975;
            end
            else
            begin
                if features.chain_score_gap <= -44917436.999999993 then
                begin
                    Result := -0.013829441678290149;
                end
                else
                begin
                    if features.path_single_segments <= 3.5000000000000004 then
                    begin
                        Result := 0.013841013173792873;
                    end
                    else
                    begin
                        Result := -0.0028054520975868513;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_64(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035552908132876336;
    end
    else
    begin
        if features.chain_score_gap <= -49674397.499999993 then
        begin
            if features.char_lm_score <= -6772.4999999999991 then
            begin
                Result := 0.025526719211304678;
            end
            else
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    if features.dict_weight <= 82189.500000000015 then
                    begin
                        if features.chain_first_stage_score <= 43010.000000000007 then
                        begin
                            Result := -0.020897107046107304;
                        end
                        else
                        begin
                            Result := 0.022509902681398852;
                        end;
                    end
                    else
                    begin
                        Result := -0.034313997503372044;
                    end;
                end
                else
                begin
                    Result := -0.0025910630092136522;
                end;
            end;
        end
        else
        begin
            if features.char_lm_suffix_score <= -6023.4999999999991 then
            begin
                if features.dict_weight_per_unit <= 10762.500000000002 then
                begin
                    if features.chain_score_gap <= -34246216.999999993 then
                    begin
                        if features.chain_first_stage_score <= 110809.50000000001 then
                        begin
                            if features.score_per_unit <= 7999.5000000000009 then
                            begin
                                if features.chain_second_stage_score <= -75170768.499999985 then
                                begin
                                    Result := 0.013262790598598959;
                                end
                                else
                                begin
                                    Result := -0.03267239129444021;
                                end;
                            end
                            else
                            begin
                                Result := 0.017838996771870796;
                            end;
                        end
                        else
                        begin
                            Result := -0.03540762699943046;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -24814660.499999996 then
                        begin
                            if features.char_lm_score <= -5730.4999999999991 then
                            begin
                                if features.chain_second_stage_score <= -71541965.999999985 then
                                begin
                                    Result := -0.010647223456869626;
                                end
                                else
                                begin
                                    Result := 0.034087327502810329;
                                end;
                            end
                            else
                            begin
                                Result := -0.0087763009746785973;
                            end;
                        end
                        else
                        begin
                            if features.path_max_segment_units <= 9.5000000000000018 then
                            begin
                                if features.dict_weight <= 170723.50000000003 then
                                begin
                                    Result := 0.0016047509649835064;
                                end
                                else
                                begin
                                    if features.path_single_segments <= 2.5000000000000004 then
                                    begin
                                        Result := 0.0059974892680008359;
                                    end
                                    else
                                    begin
                                        Result := -0.031309092218383294;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.01543404526785367;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.path_single_segments <= 2.5000000000000004 then
                    begin
                        if features.chain_first_stage_score <= 100005.00000000001 then
                        begin
                            Result := 0.003052637670460441;
                        end
                        else
                        begin
                            Result := 0.018898068701535858;
                        end;
                    end
                    else
                    begin
                        Result := 0.0006122036383789689;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_score <= -3258.4999999999995 then
                begin
                    if features.path_single_segments <= 3.5000000000000004 then
                    begin
                        if features.chain_second_stage_score <= -1.0000000180025095E-35 then
                        begin
                            Result := 0.033065226761244418;
                        end
                        else
                        begin
                            if features.char_lm_score <= -5278.4999999999991 then
                            begin
                                if features.text_units <= 16.500000000000004 then
                                begin
                                    Result := 0.041751157402310522;
                                end
                                else
                                begin
                                    Result := -0.00078806868413206616;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_score <= -4963.4999999999991 then
                                begin
                                    if features.char_lm_context_gain <= -1188.4999999999998 then
                                    begin
                                        Result := 0.025133734407044733;
                                    end
                                    else
                                    begin
                                        Result := -0.0048574435860983074;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.012493692055851839;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.dict_weight <= 58244.000000000007 then
                        begin
                            if features.text_units <= 14.500000000000002 then
                            begin
                                Result := -0.033513888330866951;
                            end
                            else
                            begin
                                Result := 0.012825345043272266;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -5069.4999999999991 then
                            begin
                                Result := -0.014710475577175279;
                            end
                            else
                            begin
                                Result := 0.01267924887463668;
                            end;
                        end;
                    end;
                end
                else
                begin
                    Result := 0.025839859342044604;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_65(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035507716589349703;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4633.4999999999991 then
        begin
            if features.path_single_segments <= 2.5000000000000004 then
            begin
                if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
                begin
                    if features.chain_score_gap <= -44289925.999999993 then
                    begin
                        if features.dict_weight_per_unit <= 1483.5000000000002 then
                        begin
                            if features.chain_score_gap <= -122461489.49999999 then
                            begin
                                Result := -0.014308415754387538;
                            end
                            else
                            begin
                                Result := 0.030455565506729756;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -730.49999999999989 then
                            begin
                                if features.chain_second_stage_score <= -38535230.499999993 then
                                begin
                                    if features.chain_first_stage_score <= 43010.000000000007 then
                                    begin
                                        Result := -0.020869846638341155;
                                    end
                                    else
                                    begin
                                        if features.legacy_rank <= 2.5000000000000004 then
                                        begin
                                            Result := 0.021827311560336276;
                                        end
                                        else
                                        begin
                                            Result := -0.013187124752733136;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -4709.4999999999991 then
                                    begin
                                        Result := -0.025998845715577402;
                                    end
                                    else
                                    begin
                                        Result := 0.0070481101315393504;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_suffix_score <= -6134.4999999999991 then
                                begin
                                    Result := -0.033939599665702709;
                                end
                                else
                                begin
                                    if features.char_lm_context_gain <= -675.49999999999989 then
                                    begin
                                        Result := -0.031110820251773332;
                                    end
                                    else
                                    begin
                                        Result := 0.012124060069947347;
                                    end;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.010638306963792742;
                    end;
                end
                else
                begin
                    if features.score_per_unit <= 22834.500000000004 then
                    begin
                        if features.char_lm_suffix_score <= -7288.4999999999991 then
                        begin
                            Result := -0.030037487749712325;
                        end
                        else
                        begin
                            Result := -0.0075555779245428251;
                        end;
                    end
                    else
                    begin
                        Result := 0.013823429700943028;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_suffix_score <= -5989.4999999999991 then
                begin
                    if features.dict_weight <= 154760.50000000003 then
                    begin
                        if features.chain_score_gap <= -26402679.999999996 then
                        begin
                            if features.chain_first_stage_score <= 55406.000000000007 then
                            begin
                                if features.char_lm_context_gain <= -1012.4999999999999 then
                                begin
                                    Result := -0.023306697488902475;
                                end
                                else
                                begin
                                    Result := 0.01374917148215558;
                                end;
                            end
                            else
                            begin
                                Result := -0.041324388811776039;
                            end;
                        end
                        else
                        begin
                            Result := -0.0052678633798928023;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -14613411.499999998 then
                        begin
                            if features.char_lm_context_gain <= -481.49999999999994 then
                            begin
                                Result := -0.0020063920298521863;
                            end
                            else
                            begin
                                Result := 0.031989884403315433;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -481.49999999999994 then
                            begin
                                Result := 0.0046510532615732835;
                            end
                            else
                            begin
                                Result := -0.024484360239496884;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 44322.000000000007 then
                    begin
                        if features.dict_weight <= 28679.000000000004 then
                        begin
                            if features.char_lm_suffix_score <= -5704.4999999999991 then
                            begin
                                Result := -0.024602910854024076;
                            end
                            else
                            begin
                                Result := 0.0090644255321684283;
                            end;
                        end
                        else
                        begin
                            Result := -0.034190257470603232;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -23768986.499999996 then
                        begin
                            Result := 0.026210695007554061;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -50555175.499999993 then
                            begin
                                Result := -0.020803333309065287;
                            end
                            else
                            begin
                                Result := 0.0065196096024989466;
                            end;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.char_lm_score <= -3074.4999999999995 then
            begin
                Result := 0.014940639111212288;
            end
            else
            begin
                Result := 0.028077285021363231;
            end;
        end;
    end;
end;

function long_final_ranker_tree_66(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035457201009613394;
    end
    else
    begin
        if features.char_lm_score <= -3892.4999999999995 then
        begin
            if features.chain_score_gap <= -34246216.999999993 then
            begin
                if features.candidate_score <= 152888.00000000003 then
                begin
                    if features.char_lm_score <= -5069.4999999999991 then
                    begin
                        if features.chain_rank <= 2.5000000000000004 then
                        begin
                            if features.char_lm_context_gain <= -730.49999999999989 then
                            begin
                                if features.path_single_segments <= 2.5000000000000004 then
                                begin
                                    if features.chain_first_stage_score <= 108512.00000000001 then
                                    begin
                                        Result := 0.0049168714301815915;
                                    end
                                    else
                                    begin
                                        Result := -0.019736803228931586;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.03085293629566789;
                                end;
                            end
                            else
                            begin
                                Result := -0.036795292578117617;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -5382.4999999999991 then
                            begin
                                Result := 0.020078080740895211;
                            end
                            else
                            begin
                                Result := -0.01710113775801278;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= 12710763.500000002 then
                        begin
                            if features.chain_first_stage_score <= 43010.000000000007 then
                            begin
                                if features.chain_first_stage_score <= -13807.499999999998 then
                                begin
                                    Result := 0.013953468523982791;
                                end
                                else
                                begin
                                    Result := -0.028773048305500201;
                                end;
                            end
                            else
                            begin
                                if features.score_per_unit <= 6774.0000000000009 then
                                begin
                                    Result := 0.038690219632625006;
                                end
                                else
                                begin
                                    if features.candidate_score <= 112772.00000000001 then
                                    begin
                                        if features.char_lm_suffix_score <= -5764.4999999999991 then
                                        begin
                                            Result := 0.0099875993308103928;
                                        end
                                        else
                                        begin
                                            Result := -0.040368833440748264;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.028223864534666868;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := -0.014021194586417724;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_suffix_score <= -7102.4999999999991 then
                    begin
                        Result := 0.038181916620625776;
                    end
                    else
                    begin
                        Result := -0.00031839800224670896;
                    end;
                end;
            end
            else
            begin
                if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
                begin
                    if features.path_single_segments <= 2.5000000000000004 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            if features.char_lm_context_score <= -7175.4999999999991 then
                            begin
                                Result := -0.0018548608397711758;
                            end
                            else
                            begin
                                if features.candidate_score <= 113058.50000000001 then
                                begin
                                    Result := 0.0030377552751674297;
                                end
                                else
                                begin
                                    Result := 0.018744010875038547;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.path_segments <= 7.5000000000000009 then
                            begin
                                if features.chain_second_stage_score <= 55378264.000000007 then
                                begin
                                    Result := 0.017504950828894694;
                                end
                                else
                                begin
                                    Result := 0.0034036937857018579;
                                end;
                            end
                            else
                            begin
                                Result := 0.0023261699928246275;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_score <= -6315.4999999999991 then
                        begin
                            Result := -0.012040179143782753;
                        end
                        else
                        begin
                            Result := 0.0040709477601639657;
                        end;
                    end;
                end
                else
                begin
                    if features.score_per_unit <= 24168.500000000004 then
                    begin
                        Result := -0.01144887801453243;
                    end
                    else
                    begin
                        Result := 0.013177446210089861;
                    end;
                end;
            end;
        end
        else
        begin
            if features.char_lm_score <= -2978.4999999999995 then
            begin
                if features.chain_score_gap <= -2931978.9999999995 then
                begin
                    if features.char_lm_score <= -3724.4999999999995 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            Result := 0.037373293299818991;
                        end
                        else
                        begin
                            Result := -0.0058358910434943524;
                        end;
                    end
                    else
                    begin
                        Result := -0.0076463598600644859;
                    end;
                end
                else
                begin
                    Result := 0.017622511051080945;
                end;
            end
            else
            begin
                Result := 0.029196063906212481;
            end;
        end;
    end;
end;

function long_final_ranker_tree_67(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035405899219686177;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4665.4999999999991 then
        begin
            if features.chain_score_gap <= -34246216.999999993 then
            begin
                if features.path_segments <= 4.5000000000000009 then
                begin
                    if features.chain_score_gap <= -131664660.49999999 then
                    begin
                        Result := -0.0099638200170096974;
                    end
                    else
                    begin
                        Result := 0.022720645595977286;
                    end;
                end
                else
                begin
                    if features.char_lm_score <= -5069.4999999999991 then
                    begin
                        if features.candidate_score <= 152888.00000000003 then
                        begin
                            if features.chain_second_stage_score <= -86170659.999999985 then
                            begin
                                Result := 0.0033239639411989756;
                            end
                            else
                            begin
                                if features.dict_weight <= 21251.000000000004 then
                                begin
                                    if features.char_lm_score <= -5327.4999999999991 then
                                    begin
                                        Result := 0.024109468743336103;
                                    end
                                    else
                                    begin
                                        Result := -0.027951122787406069;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_suffix_score <= -5716.4999999999991 then
                                    begin
                                        if features.char_lm_context_gain <= -712.49999999999989 then
                                        begin
                                            if features.chain_rank <= 2.5000000000000004 then
                                            begin
                                                Result := -0.02350578647701991;
                                            end
                                            else
                                            begin
                                                Result := 0.016685334575542804;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := -0.045241885423577204;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.013988065141618896;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.score_per_unit <= 11879.500000000002 then
                            begin
                                if features.score_per_unit <= 11286.500000000002 then
                                begin
                                    Result := 0.0022289513818909011;
                                end
                                else
                                begin
                                    Result := -0.032564906409467166;
                                end;
                            end
                            else
                            begin
                                Result := 0.020455359485790338;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= 12710763.500000002 then
                        begin
                            if features.chain_score_gap <= -105370372.99999999 then
                            begin
                                Result := -0.018113143569550912;
                            end
                            else
                            begin
                                Result := 0.016978541394728656;
                            end;
                        end
                        else
                        begin
                            Result := -0.0094309259823819117;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.path_single_segments <= 4.5000000000000009 then
                begin
                    if features.path_max_segment_units <= 9.5000000000000018 then
                    begin
                        if features.char_lm_score <= -6772.4999999999991 then
                        begin
                            Result := -0.002325852094625787;
                        end
                        else
                        begin
                            if features.path_max_segment_units <= 2.5000000000000004 then
                            begin
                                if features.char_lm_score <= -5668.4999999999991 then
                                begin
                                    if features.chain_score_gap <= -9260846.9999999981 then
                                    begin
                                        Result := 0.015569057207522923;
                                    end
                                    else
                                    begin
                                        if features.path_segments <= 3.5000000000000004 then
                                        begin
                                            Result := 0.018154507150564398;
                                        end
                                        else
                                        begin
                                            if features.char_lm_suffix_score <= -6768.4999999999991 then
                                            begin
                                                Result := -0.017429454116599404;
                                            end
                                            else
                                            begin
                                                Result := 0.0045643226673081237;
                                            end;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.0078852920047118805;
                                end;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -6376268.4999999991 then
                                begin
                                    Result := 0.022647993330881785;
                                end
                                else
                                begin
                                    if features.path_single_segments <= 1.5000000000000002 then
                                    begin
                                        if features.char_lm_suffix_score <= -6492.4999999999991 then
                                        begin
                                            Result := -0.0028752280609684257;
                                        end
                                        else
                                        begin
                                            if features.chain_score_gap <= -9835736.4999999981 then
                                            begin
                                                Result := -0.0091197649386276919;
                                            end
                                            else
                                            begin
                                                Result := 0.019016649464290349;
                                            end;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.0029482667393574261;
                                    end;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := -0.0089995808108847899;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 147034.50000000003 then
                    begin
                        Result := -0.027084445590349514;
                    end
                    else
                    begin
                        Result := 0.006530784626983881;
                    end;
                end;
            end;
        end
        else
        begin
            Result := 0.021198183192956011;
        end;
    end;
end;

function long_final_ranker_tree_68(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035335529158278076;
    end
    else
    begin
        if features.char_lm_score <= -3258.4999999999995 then
        begin
            if features.chain_score_gap <= -49674397.499999993 then
            begin
                if features.path_segments <= 4.5000000000000009 then
                begin
                    if features.chain_score_gap <= -127081972.99999999 then
                    begin
                        Result := -0.016020973997635152;
                    end
                    else
                    begin
                        Result := 0.024303797808033014;
                    end;
                end
                else
                begin
                    if features.legacy_rank <= 1.5000000000000002 then
                    begin
                        if features.score_per_unit <= 6774.0000000000009 then
                        begin
                            Result := 0.0011383443206955141;
                        end
                        else
                        begin
                            Result := -0.02816842710037807;
                        end;
                    end
                    else
                    begin
                        Result := -0.00031012663036546065;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_score <= -5869.4999999999991 then
                begin
                    if features.chain_first_stage_score <= 87237.000000000015 then
                    begin
                        if features.chain_first_stage_score <= 55406.000000000007 then
                        begin
                            if features.path_max_segment_units <= 9.5000000000000018 then
                            begin
                                Result := 0.001829686381874696;
                            end
                            else
                            begin
                                Result := -0.016690045771958203;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -6228.4999999999991 then
                            begin
                                Result := -0.03503481105458979;
                            end
                            else
                            begin
                                Result := 0.0023348395690820042;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.path_single_segments <= 2.5000000000000004 then
                        begin
                            if features.path_max_segment_units <= 2.5000000000000004 then
                            begin
                                if features.char_lm_context_gain <= -730.49999999999989 then
                                begin
                                    Result := -0.010199997399313716;
                                end
                                else
                                begin
                                    Result := 0.016569536604907804;
                                end;
                            end
                            else
                            begin
                                if features.path_segments <= 7.5000000000000009 then
                                begin
                                    if features.candidate_score <= 118326.00000000001 then
                                    begin
                                        Result := 0.0066444458761304864;
                                    end
                                    else
                                    begin
                                        Result := 0.028289072056953073;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.0023510471366172065;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := -0.0056662252746310614;
                        end;
                    end;
                end
                else
                begin
                    if features.dict_weight_per_unit <= 11599.500000000002 then
                    begin
                        if features.legacy_rank <= 2.5000000000000004 then
                        begin
                            if features.path_single_segments <= 2.5000000000000004 then
                            begin
                                if features.score_per_unit <= 10722.500000000002 then
                                begin
                                    if features.chain_first_stage_score <= 185864.50000000003 then
                                    begin
                                        if features.path_segments <= 1.0000000180025095E-35 then
                                        begin
                                            Result := -0.0017126232228379557;
                                        end
                                        else
                                        begin
                                            Result := 0.015446112151575393;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.014941953579590356;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.002426078713609575;
                                end;
                            end
                            else
                            begin
                                if features.legacy_rank <= 1.5000000000000002 then
                                begin
                                    if features.char_lm_context_gain <= -749.49999999999989 then
                                    begin
                                        if features.char_lm_context_gain <= -1082.4999999999998 then
                                        begin
                                            Result := -0.014963066702206056;
                                        end
                                        else
                                        begin
                                            Result := 0.017048256871360048;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.char_lm_context_gain <= -376.49999999999994 then
                                        begin
                                            Result := -0.017148884660810902;
                                        end
                                        else
                                        begin
                                            Result := 0.0081531815043580369;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -5607.4999999999991 then
                                    begin
                                        Result := -0.01019764499546783;
                                    end
                                    else
                                    begin
                                        Result := 0.015386346310024512;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.candidate_score <= 106328.00000000001 then
                            begin
                                Result := 0.0054380525154379081;
                            end
                            else
                            begin
                                Result := -0.027515378173351424;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.012469471781430038;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_first_stage_score <= 87820.000000000015 then
            begin
                Result := 0.031282576064437739;
            end
            else
            begin
                Result := 0.0089177524551820805;
            end;
        end;
    end;
end;

function long_final_ranker_tree_69(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035290676010378171;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4665.4999999999991 then
        begin
            if features.path_single_segments <= 2.5000000000000004 then
            begin
                if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
                begin
                    if features.chain_score_gap <= -52040049.499999993 then
                    begin
                        if features.dict_weight <= 92601.000000000015 then
                        begin
                            if features.chain_score_gap <= -64318240.999999993 then
                            begin
                                Result := 0.0;
                            end
                            else
                            begin
                                Result := 0.031059870728186872;
                            end;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -59742350.999999993 then
                            begin
                                Result := -0.00086045231630274468;
                            end
                            else
                            begin
                                if features.score_per_unit <= 12107.500000000002 then
                                begin
                                    Result := -0.041903625137014115;
                                end
                                else
                                begin
                                    Result := 0.0022502402076410009;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            if features.char_lm_score <= -5869.4999999999991 then
                            begin
                                if features.chain_second_stage_score <= -67962788.499999985 then
                                begin
                                    Result := 0.021184375720152387;
                                end
                                else
                                begin
                                    Result := -0.0075995889136309565;
                                end;
                            end
                            else
                            begin
                                Result := 0.0076250145143268904;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -712.49999999999989 then
                            begin
                                Result := 0.016045396692323396;
                            end
                            else
                            begin
                                Result := 0.0061451398833285223;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.score_per_unit <= 24168.500000000004 then
                    begin
                        Result := -0.011374891301021314;
                    end
                    else
                    begin
                        Result := 0.015981086293289978;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_context_score <= -6925.4999999999991 then
                begin
                    if features.chain_score_gap <= -35118691.999999993 then
                    begin
                        if features.dict_weight <= 120968.00000000001 then
                        begin
                            Result := -0.037645080080633275;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -54241435.499999993 then
                            begin
                                Result := 0.016577785524299952;
                            end
                            else
                            begin
                                Result := -0.018845743552008323;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -7853.4999999999991 then
                        begin
                            Result := -0.01265208041000911;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -7792774.4999999991 then
                            begin
                                if features.chain_score_gap <= -2087111.4999999998 then
                                begin
                                    Result := 0.026829133721306474;
                                end
                                else
                                begin
                                    if features.path_segments <= 10.500000000000002 then
                                    begin
                                        if features.char_lm_context_gain <= -656.49999999999989 then
                                        begin
                                            Result := -0.013038581082270335;
                                        end
                                        else
                                        begin
                                            Result := 0.031154725483698353;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.030448845391893273;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.dict_weight_per_unit <= 12520.500000000002 then
                                begin
                                    Result := -0.016971171548509224;
                                end
                                else
                                begin
                                    Result := 0.015415283053881457;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.legacy_rank <= 1.5000000000000002 then
                    begin
                        if features.text_units <= 11.500000000000002 then
                        begin
                            if features.char_lm_context_gain <= -694.49999999999989 then
                            begin
                                Result := -0.0026792707971729827;
                            end
                            else
                            begin
                                Result := -0.037350907211315842;
                            end;
                        end
                        else
                        begin
                            Result := 0.0033280183055825283;
                        end;
                    end
                    else
                    begin
                        if features.path_single_segments <= 3.5000000000000004 then
                        begin
                            if features.char_lm_context_gain <= -376.49999999999994 then
                            begin
                                if features.char_lm_context_gain <= -730.49999999999989 then
                                begin
                                    Result := 0.002525004156740192;
                                end
                                else
                                begin
                                    Result := 0.032422949284622096;
                                end;
                            end
                            else
                            begin
                                Result := -0.0067059388941378634;
                            end;
                        end
                        else
                        begin
                            Result := -0.0053326487840183344;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            Result := 0.020257172858778899;
        end;
    end;
end;

function long_final_ranker_tree_70(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035231247328770823;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4744.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 12069.500000000002 then
            begin
                if features.chain_score_gap <= -49674397.499999993 then
                begin
                    if features.path_segments <= 4.5000000000000009 then
                    begin
                        if features.chain_score_gap <= -74189239.499999985 then
                        begin
                            Result := -0.0037504611791653155;
                        end
                        else
                        begin
                            Result := 0.02746203845093596;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -54241435.499999993 then
                        begin
                            if features.chain_score_gap <= -122461489.49999999 then
                            begin
                                Result := -0.031345197073337563;
                            end
                            else
                            begin
                                Result := -0.0027770201785893285;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -67962788.499999985 then
                            begin
                                Result := 0.0081313547697505883;
                            end
                            else
                            begin
                                Result := -0.037039793908592945;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.path_segments <= 8.5000000000000018 then
                    begin
                        if features.chain_second_stage_score <= -64024275.499999993 then
                        begin
                            Result := 0.021566148918487377;
                        end
                        else
                        begin
                            if features.legacy_rank <= 2.5000000000000004 then
                            begin
                                if features.char_lm_context_score <= -7549.4999999999991 then
                                begin
                                    if features.path_segments <= 7.5000000000000009 then
                                    begin
                                        Result := 0.00067935136452845931;
                                    end
                                    else
                                    begin
                                        Result := -0.016475884158667107;
                                    end;
                                end
                                else
                                begin
                                    if features.path_single_segments <= 3.5000000000000004 then
                                    begin
                                        if features.chain_second_stage_score <= -1518635.9999999998 then
                                        begin
                                            if features.chain_first_stage_score <= 137050.50000000003 then
                                            begin
                                                if features.score_per_unit <= 11286.500000000002 then
                                                begin
                                                    Result := 0.0025129993265805015;
                                                end
                                                else
                                                begin
                                                    Result := 0.03495829374485665;
                                                end;
                                            end
                                            else
                                            begin
                                                Result := 0.037134474298210436;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := 0.0063305724820092264;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.010672585356022639;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -20341703.499999996 then
                                begin
                                    Result := 0.018691831448242859;
                                end
                                else
                                begin
                                    if features.char_lm_context_score <= -9852.4999999999982 then
                                    begin
                                        Result := 0.010788090945326687;
                                    end
                                    else
                                    begin
                                        Result := -0.024518444879396771;
                                    end;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -67962788.499999985 then
                        begin
                            Result := -0.026773058198984803;
                        end
                        else
                        begin
                            Result := -0.002153106500177348;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.path_single_segments <= 1.5000000000000002 then
                begin
                    if features.char_lm_context_score <= -8592.4999999999982 then
                    begin
                        Result := 0.0028900574115077737;
                    end
                    else
                    begin
                        Result := 0.021630793403328106;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -4544670.4999999991 then
                    begin
                        if features.chain_score_gap <= -42757456.499999993 then
                        begin
                            if features.char_lm_suffix_score <= -6656.4999999999991 then
                            begin
                                Result := 0.02072142316750028;
                            end
                            else
                            begin
                                Result := -0.016970437097322929;
                            end;
                        end
                        else
                        begin
                            Result := 0.027848668370634377;
                        end;
                    end
                    else
                    begin
                        if features.path_max_segment_units <= 3.5000000000000004 then
                        begin
                            Result := -0.0089702501715967706;
                        end
                        else
                        begin
                            Result := 0.012249481598936776;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_first_stage_score <= 10622.000000000002 then
            begin
                Result := 0.026929669645979704;
            end
            else
            begin
                if features.score_per_unit <= 3548.5000000000005 then
                begin
                    if features.chain_second_stage_score <= 100857689.50000001 then
                    begin
                        Result := -0.036602399765987587;
                    end
                    else
                    begin
                        Result := 0.0087851478812741093;
                    end;
                end
                else
                begin
                    Result := 0.015518842585086847;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_71(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035192777214243284;
    end
    else
    begin
        if features.char_lm_suffix_score <= -6261.4999999999991 then
        begin
            if features.legacy_rank <= 1.5000000000000002 then
            begin
                if features.char_lm_context_gain <= -1107.4999999999998 then
                begin
                    if features.path_single_segments <= 2.5000000000000004 then
                    begin
                        if features.dict_weight <= 113080.50000000001 then
                        begin
                            Result := 0.0030616139151472899;
                        end
                        else
                        begin
                            Result := 0.023635729938556668;
                        end;
                    end
                    else
                    begin
                        Result := -0.021807480032570079;
                    end;
                end
                else
                begin
                    if features.dict_weight_per_unit <= 12069.500000000002 then
                    begin
                        if features.path_segments <= 9.5000000000000018 then
                        begin
                            if features.chain_rank <= 2.5000000000000004 then
                            begin
                                if features.chain_rank <= 1.5000000000000002 then
                                begin
                                    Result := -0.011683881295180214;
                                end
                                else
                                begin
                                    if features.char_lm_context_gain <= -788.49999999999989 then
                                    begin
                                        Result := -0.0068190378819599304;
                                    end
                                    else
                                    begin
                                        Result := -0.041918063433051218;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := 0.011434347835944832;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -524.49999999999989 then
                            begin
                                Result := 0.018412673861556841;
                            end
                            else
                            begin
                                Result := -0.01310843920053157;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.0057757361374342567;
                    end;
                end;
            end
            else
            begin
                if features.chain_second_stage_score <= -60934688.499999993 then
                begin
                    if features.candidate_score <= 123730.00000000001 then
                    begin
                        if features.path_single_segments <= 2.5000000000000004 then
                        begin
                            Result := 0.0092418426775276105;
                        end
                        else
                        begin
                            Result := -0.017540884027187797;
                        end;
                    end
                    else
                    begin
                        Result := 0.024895574486860143;
                    end;
                end
                else
                begin
                    if features.chain_first_stage_score <= 137050.50000000003 then
                    begin
                        if features.legacy_rank <= 2.5000000000000004 then
                        begin
                            Result := 0.00049148209806101158;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -989.49999999999989 then
                            begin
                                Result := 0.0015810391263862565;
                            end
                            else
                            begin
                                Result := -0.026381652531822689;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -30639080.499999996 then
                        begin
                            if features.chain_second_stage_score <= -55362432.999999993 then
                            begin
                                Result := 0.015487391558489492;
                            end
                            else
                            begin
                                Result := -0.019105617031243173;
                            end;
                        end
                        else
                        begin
                            if features.path_single_segments <= 2.5000000000000004 then
                            begin
                                if features.char_lm_score <= -5607.4999999999991 then
                                begin
                                    if features.path_max_segment_units <= 3.5000000000000004 then
                                    begin
                                        if features.dict_weight_per_unit <= 10762.500000000002 then
                                        begin
                                            Result := 0.0049437326838945705;
                                        end
                                        else
                                        begin
                                            Result := 0.046199919293155041;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.0073617845893575997;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.0074702354701665355;
                                end;
                            end
                            else
                            begin
                                Result := -0.001431121368765565;
                            end;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.char_lm_score <= -3074.4999999999995 then
            begin
                if Ord(features.source_local_rerank) <= 1.0000000180025095E-35 then
                begin
                    if features.path_single_segments <= 1.5000000000000002 then
                    begin
                        if features.legacy_rank <= 2.5000000000000004 then
                        begin
                            Result := 0.014844990249912732;
                        end
                        else
                        begin
                            Result := -0.010829239984494171;
                        end;
                    end
                    else
                    begin
                        Result := 0.00495350182486534;
                    end;
                end
                else
                begin
                    if features.char_lm_context_gain <= -1082.4999999999998 then
                    begin
                        Result := -0.018414599901388964;
                    end
                    else
                    begin
                        if features.chain_first_stage_score <= 1.0000000180025095E-35 then
                        begin
                            Result := 0.011105661030991761;
                        end
                        else
                        begin
                            Result := -0.020836982847483202;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := 0.024178146737222204;
            end;
        end;
    end;
end;

function long_final_ranker_tree_72(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035156945416500149;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4665.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 11599.500000000002 then
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    if features.chain_rank <= 1.5000000000000002 then
                    begin
                        if features.char_lm_suffix_score <= -6023.4999999999991 then
                        begin
                            Result := -0.0045691278709780779;
                        end
                        else
                        begin
                            if features.path_single_segments <= 2.5000000000000004 then
                            begin
                                if features.path_segments <= 1.0000000180025095E-35 then
                                begin
                                    if features.char_lm_context_gain <= -1423.4999999999998 then
                                    begin
                                        Result := -0.026910572270491394;
                                    end
                                    else
                                    begin
                                        if features.char_lm_score <= -4760.4999999999991 then
                                        begin
                                            if features.candidate_score <= 138130.50000000003 then
                                            begin
                                                Result := -0.031379065267657109;
                                            end
                                            else
                                            begin
                                                Result := 0.01514431206308323;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := 0.012557101925517653;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.015727705357678871;
                                end;
                            end
                            else
                            begin
                                Result := -0.0030503921729639078;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.dict_weight_per_unit <= 7808.5000000000009 then
                        begin
                            Result := 0.0021997674767706933;
                        end
                        else
                        begin
                            if features.char_lm_score <= -5933.4999999999991 then
                            begin
                                if features.char_lm_score <= -6315.4999999999991 then
                                begin
                                    Result := -0.017345209257034047;
                                end
                                else
                                begin
                                    Result := 0.022963684674427238;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_context_gain <= -749.49999999999989 then
                                begin
                                    if features.chain_score_gap <= -48874815.499999993 then
                                    begin
                                        Result := -0.032725640380518221;
                                    end
                                    else
                                    begin
                                        if features.chain_score_gap <= -20341703.499999996 then
                                        begin
                                            Result := 0.027338014794686828;
                                        end
                                        else
                                        begin
                                            Result := -0.016739854451384505;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.037080185761807903;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
                    begin
                        if features.char_lm_suffix_score <= -7018.4999999999991 then
                        begin
                            if features.char_lm_suffix_score <= -7165.4999999999991 then
                            begin
                                if features.path_single_segments <= 2.5000000000000004 then
                                begin
                                    if features.chain_score_gap <= -53550508.499999993 then
                                    begin
                                        Result := -0.014570915745056033;
                                    end
                                    else
                                    begin
                                        Result := 0.01445395034354446;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.011902472913771327;
                                end;
                            end
                            else
                            begin
                                Result := -0.022504774175350111;
                            end;
                        end
                        else
                        begin
                            if features.path_single_segments <= 3.5000000000000004 then
                            begin
                                if features.legacy_rank <= 2.5000000000000004 then
                                begin
                                    Result := 0.012427506608385434;
                                end
                                else
                                begin
                                    if features.dict_weight <= 95798.500000000015 then
                                    begin
                                        Result := 0.0068598504200125601;
                                    end
                                    else
                                    begin
                                        Result := -0.027691974324351103;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.0032520679066284273;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := -0.0061423090077036592;
                    end;
                end;
            end
            else
            begin
                if features.path_single_segments <= 1.5000000000000002 then
                begin
                    Result := 0.017701956041101329;
                end
                else
                begin
                    if features.chain_second_stage_score <= -55362432.999999993 then
                    begin
                        Result := 0.023370563798050397;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -52040049.499999993 then
                        begin
                            Result := -0.025162895899037155;
                        end
                        else
                        begin
                            if features.char_lm_score <= -6315.4999999999991 then
                            begin
                                Result := -0.015729797679522081;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= 75108345.500000015 then
                                begin
                                    Result := 0.010164433778876759;
                                end
                                else
                                begin
                                    Result := -0.0082586774362334477;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            Result := 0.0198149459179899;
        end;
    end;
end;

function long_final_ranker_tree_73(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.partial_match) <= 1.0000000180025095E-35 then
    begin
        if features.char_lm_suffix_score <= -4744.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 11599.500000000002 then
            begin
                if features.chain_score_gap <= -127081972.99999999 then
                begin
                    if features.char_lm_score <= -5607.4999999999991 then
                    begin
                        Result := 0.007577663210975567;
                    end
                    else
                    begin
                        Result := -0.037132462202297531;
                    end;
                end
                else
                begin
                    if features.path_single_segments <= 2.5000000000000004 then
                    begin
                        if features.char_lm_suffix_score <= -5475.4999999999991 then
                        begin
                            if features.chain_second_stage_score <= -64024275.499999993 then
                            begin
                                if features.chain_score_gap <= -89371168.999999985 then
                                begin
                                    Result := -0.010198482183992146;
                                end
                                else
                                begin
                                    if features.char_lm_context_gain <= -712.49999999999989 then
                                    begin
                                        Result := 0.023510190662452475;
                                    end
                                    else
                                    begin
                                        Result := -0.0026019191283615209;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= 26075009.000000004 then
                                begin
                                    if features.char_lm_suffix_score <= -5794.4999999999991 then
                                    begin
                                        Result := -0.00052034840166171302;
                                    end
                                    else
                                    begin
                                        if features.dict_weight_per_unit <= 8965.5000000000018 then
                                        begin
                                            Result := -2.6352373875757456E-06;
                                        end
                                        else
                                        begin
                                            Result := -0.033093546732575745;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    if features.chain_first_stage_score <= 133056.50000000003 then
                                    begin
                                        if features.char_lm_score <= -4657.4999999999991 then
                                        begin
                                            Result := 0.025938790438700808;
                                        end
                                        else
                                        begin
                                            Result := -0.0039547312849734948;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.0075196753660431645;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.010823287775488032;
                        end;
                    end
                    else
                    begin
                        if features.legacy_rank <= 1.5000000000000002 then
                        begin
                            if features.score_per_unit <= 9580.5000000000018 then
                            begin
                                if features.dict_weight_per_unit <= 7425.0000000000009 then
                                begin
                                    if features.text_units <= 17.500000000000004 then
                                    begin
                                        Result := -0.012242759110987206;
                                    end
                                    else
                                    begin
                                        Result := 0.018476044874723114;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -5016.4999999999991 then
                                    begin
                                        Result := -0.037028028566614538;
                                    end
                                    else
                                    begin
                                        Result := -0.0019212620240617281;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_score <= -4657.4999999999991 then
                                begin
                                    Result := 0.0084264275008917328;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= 59813173.500000007 then
                                    begin
                                        Result := -0.050835661256225004;
                                    end
                                    else
                                    begin
                                        Result := 0.00059575583821854395;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -694.49999999999989 then
                            begin
                                if features.char_lm_context_gain <= -1107.4999999999998 then
                                begin
                                    if features.char_lm_suffix_score <= -7491.4999999999991 then
                                    begin
                                        Result := -0.019954296718535259;
                                    end
                                    else
                                    begin
                                        Result := 0.020945643339850707;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.011805908202484708;
                                end;
                            end
                            else
                            begin
                                if features.path_single_segments <= 3.5000000000000004 then
                                begin
                                    Result := 0.023773336798528884;
                                end
                                else
                                begin
                                    Result := -0.003679938840168919;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.chain_score_gap <= -52757794.999999993 then
                begin
                    if features.chain_second_stage_score <= -57796089.499999993 then
                    begin
                        Result := 0.011322675589151525;
                    end
                    else
                    begin
                        Result := -0.025584247370846542;
                    end;
                end
                else
                begin
                    if features.char_lm_suffix_score <= -7411.4999999999991 then
                    begin
                        Result := -0.0015755066672883656;
                    end
                    else
                    begin
                        Result := 0.013802594825785202;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_second_stage_score <= 96268274.000000015 then
            begin
                Result := 0.026309493871851688;
            end
            else
            begin
                Result := 0.011202756973276327;
            end;
        end;
    end
    else
    begin
        Result := -0.035083650633692551;
    end;
end;

function long_final_ranker_tree_74(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.035028949930451365;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4744.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 11599.500000000002 then
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    if features.chain_rank <= 1.5000000000000002 then
                    begin
                        if features.path_single_segments <= 2.5000000000000004 then
                        begin
                            if features.char_lm_score <= -6069.4999999999991 then
                            begin
                                Result := -0.0079401420806435238;
                            end
                            else
                            begin
                                Result := 0.0080128460238972805;
                            end;
                        end
                        else
                        begin
                            if features.score_per_unit <= 9580.5000000000018 then
                            begin
                                if features.score_per_unit <= 7397.0000000000009 then
                                begin
                                    if features.chain_first_stage_score <= 80098.500000000015 then
                                    begin
                                        Result := -0.018498327119550368;
                                    end
                                    else
                                    begin
                                        Result := 0.012172784199825761;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_context_score <= -6101.4999999999991 then
                                    begin
                                        Result := -0.040121703911616527;
                                    end
                                    else
                                    begin
                                        Result := 0.0057467827792027091;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := 0.0037830272038937383;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_first_stage_score <= 140224.50000000003 then
                        begin
                            if features.score_per_unit <= 11347.500000000002 then
                            begin
                                if features.chain_rank <= 2.5000000000000004 then
                                begin
                                    Result := -0.0069204437484272456;
                                end
                                else
                                begin
                                    Result := 0.018823216787686687;
                                end;
                            end
                            else
                            begin
                                Result := -0.027261345648115772;
                            end;
                        end
                        else
                        begin
                            if features.path_segments <= 9.5000000000000018 then
                            begin
                                Result := -0.042029968566919769;
                            end
                            else
                            begin
                                Result := 0.0;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.legacy_rank <= 2.5000000000000004 then
                    begin
                        if features.char_lm_context_score <= -7284.4999999999991 then
                        begin
                            if features.chain_first_stage_score <= 157812.00000000003 then
                            begin
                                if features.chain_first_stage_score <= 148576.00000000003 then
                                begin
                                    Result := 0.0015853195571561209;
                                end
                                else
                                begin
                                    Result := 0.039411028635586993;
                                end;
                            end
                            else
                            begin
                                Result := -0.019616978949507761;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 42661919.500000007 then
                            begin
                                Result := 0.013934106436950998;
                            end
                            else
                            begin
                                if features.char_lm_score <= -4263.4999999999991 then
                                begin
                                    Result := -0.010973551670614071;
                                end
                                else
                                begin
                                    Result := 0.014188975529468866;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -18208077.499999996 then
                        begin
                            Result := 0.0074305986901618253;
                        end
                        else
                        begin
                            Result := -0.019281678732844067;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.path_single_segments <= 1.5000000000000002 then
                begin
                    Result := 0.015788149807247284;
                end
                else
                begin
                    if features.chain_second_stage_score <= -55362432.999999993 then
                    begin
                        Result := 0.025827614724489044;
                    end
                    else
                    begin
                        if features.char_lm_score <= -6315.4999999999991 then
                        begin
                            if features.chain_second_stage_score <= -23768986.499999996 then
                            begin
                                Result := 0.01209807531026494;
                            end
                            else
                            begin
                                Result := -0.02684488144736346;
                            end;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -53550508.499999993 then
                            begin
                                Result := -0.022199460758982714;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= 53256438.500000007 then
                                begin
                                    Result := 0.011680240496836629;
                                end
                                else
                                begin
                                    if features.char_lm_context_score <= -6049.4999999999991 then
                                    begin
                                        Result := -0.023795863309236911;
                                    end
                                    else
                                    begin
                                        Result := 0.0042598173979129499;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_second_stage_score <= 96268274.000000015 then
            begin
                Result := 0.024574529218204206;
            end
            else
            begin
                Result := 0.0094491438048421913;
            end;
        end;
    end;
end;

function long_final_ranker_tree_75(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.034977491672497973;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4744.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 11881.500000000002 then
            begin
                if features.char_lm_suffix_score <= -5704.4999999999991 then
                begin
                    if features.chain_score_gap <= -34246216.999999993 then
                    begin
                        if features.chain_second_stage_score <= -75170768.499999985 then
                        begin
                            if features.chain_score_gap <= -162538238.99999997 then
                            begin
                                Result := -0.028713152603931816;
                            end
                            else
                            begin
                                Result := 0.010387392049233489;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -5069.4999999999991 then
                            begin
                                if features.chain_score_gap <= -36477344.499999993 then
                                begin
                                    if features.dict_weight_per_unit <= 1325.5000000000002 then
                                    begin
                                        Result := 0.0087878103992931802;
                                    end
                                    else
                                    begin
                                        if features.char_lm_context_score <= -7122.4999999999991 then
                                        begin
                                            if features.dict_weight_per_unit <= 10636.500000000002 then
                                            begin
                                                Result := -0.019318977463679051;
                                            end
                                            else
                                            begin
                                                Result := 0.0068088751395690957;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := -0.030585104481366882;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.045538399989156653;
                                end;
                            end
                            else
                            begin
                                if features.chain_first_stage_score <= 18711.500000000004 then
                                begin
                                    Result := -0.024554733130149591;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= -23768986.499999996 then
                                    begin
                                        Result := 0.040237690342232471;
                                    end
                                    else
                                    begin
                                        Result := -0.0053614901906580501;
                                    end;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -13297010.999999998 then
                        begin
                            if features.chain_second_stage_score <= 5989375.0000000009 then
                            begin
                                if features.char_lm_score <= -6915.4999999999991 then
                                begin
                                    Result := -0.010642475399964876;
                                end
                                else
                                begin
                                    if features.char_lm_context_gain <= -346.49999999999994 then
                                    begin
                                        if features.dict_weight_per_unit <= 11155.500000000002 then
                                        begin
                                            Result := 0.014778877703781342;
                                        end
                                        else
                                        begin
                                            Result := 0.042448710408747384;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.018090467531826724;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.014324342261581875;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 26075009.000000004 then
                            begin
                                Result := -0.0030803773888066991;
                            end
                            else
                            begin
                                if features.chain_first_stage_score <= 188414.00000000003 then
                                begin
                                    if features.char_lm_context_gain <= -903.49999999999989 then
                                    begin
                                        Result := -0.00022588788261162859;
                                    end
                                    else
                                    begin
                                        if features.char_lm_context_score <= -6525.4999999999991 then
                                        begin
                                            Result := 0.033121795573346338;
                                        end
                                        else
                                        begin
                                            Result := 0.0;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.016037837233838264;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= 42661919.500000007 then
                    begin
                        Result := 0.0092412855142856229;
                    end
                    else
                    begin
                        Result := 0.00089314425506461549;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_context_score <= -8269.4999999999982 then
                begin
                    if features.chain_score_gap <= -999794.49999999988 then
                    begin
                        Result := 0.017844708780224622;
                    end
                    else
                    begin
                        Result := -0.0087263819069815576;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -53550508.499999993 then
                    begin
                        if features.chain_first_stage_score <= 131999.00000000003 then
                        begin
                            Result := -0.034543306189789222;
                        end
                        else
                        begin
                            Result := 0.01414214655096932;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= 75108345.500000015 then
                        begin
                            if features.chain_first_stage_score <= 240800.00000000003 then
                            begin
                                Result := 0.01884931846642509;
                            end
                            else
                            begin
                                Result := -0.0035563294291769123;
                            end;
                        end
                        else
                        begin
                            Result := -0.0014693152594307613;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            Result := 0.017806979535278836;
        end;
    end;
end;

function long_final_ranker_tree_76(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.034908639592813144;
    end
    else
    begin
        if features.char_lm_suffix_score <= -5412.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 11881.500000000002 then
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    if features.char_lm_context_gain <= -730.49999999999989 then
                    begin
                        if features.char_lm_context_score <= -7230.4999999999991 then
                        begin
                            if features.dict_weight_per_unit <= 10636.500000000002 then
                            begin
                                if features.path_segments <= 6.5000000000000009 then
                                begin
                                    Result := -0.0027258137182463167;
                                end
                                else
                                begin
                                    Result := -0.0219463289226716;
                                end;
                            end
                            else
                            begin
                                Result := 0.01072189322592876;
                            end;
                        end
                        else
                        begin
                            Result := 0.0068561184213563704;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= 31744429.500000004 then
                        begin
                            if features.dict_weight <= 94184.500000000015 then
                            begin
                                if features.char_lm_score <= -5869.4999999999991 then
                                begin
                                    Result := -0.026480138741957499;
                                end
                                else
                                begin
                                    Result := 0.006355067541881464;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_score <= -5933.4999999999991 then
                                begin
                                    if features.char_lm_suffix_score <= -7288.4999999999991 then
                                    begin
                                        Result := -0.033871622291894693;
                                    end
                                    else
                                    begin
                                        if features.path_segments <= 10.500000000000002 then
                                        begin
                                            if features.chain_second_stage_score <= -16016177.499999998 then
                                            begin
                                                Result := 0.033788504921532;
                                            end
                                            else
                                            begin
                                                if features.char_lm_context_score <= -7549.4999999999991 then
                                                begin
                                                    Result := -0.02936350096315744;
                                                end
                                                else
                                                begin
                                                    Result := 0.018012653898475377;
                                                end;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := -0.027779588280269652;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    if features.path_segments <= 10.500000000000002 then
                                    begin
                                        if features.chain_score_gap <= -3720366.4999999995 then
                                        begin
                                            Result := -0.051422615016466215;
                                        end
                                        else
                                        begin
                                            Result := -0.012155612184041788;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.0021668456108595098;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.007054001055671835;
                        end;
                    end;
                end
                else
                begin
                    if features.legacy_rank <= 2.5000000000000004 then
                    begin
                        if features.text_units <= 13.500000000000002 then
                        begin
                            if features.dict_weight <= 122800.50000000001 then
                            begin
                                Result := 0.0041388975760449521;
                            end
                            else
                            begin
                                if features.char_lm_score <= -5668.4999999999991 then
                                begin
                                    Result := 0.0057332779067882315;
                                end
                                else
                                begin
                                    Result := -0.027566691650683178;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.path_segments <= 8.5000000000000018 then
                            begin
                                if features.chain_rank <= 1.0000000180025095E-35 then
                                begin
                                    Result := -0.0040951541247501271;
                                end
                                else
                                begin
                                    if features.score_per_unit <= 11347.500000000002 then
                                    begin
                                        Result := 0.031091848614136865;
                                    end
                                    else
                                    begin
                                        Result := 0.0;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := 0.004599719792629034;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -9852.4999999999982 then
                        begin
                            Result := 0.022072197756753235;
                        end
                        else
                        begin
                            Result := -0.013854759625331193;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.path_max_segment_units <= 2.5000000000000004 then
                begin
                    if features.char_lm_score <= -5668.4999999999991 then
                    begin
                        Result := -0.01783912977211112;
                    end
                    else
                    begin
                        Result := 0.0061951916372258841;
                    end;
                end
                else
                begin
                    Result := 0.013045050497652578;
                end;
            end;
        end
        else
        begin
            if features.chain_second_stage_score <= 12710763.500000002 then
            begin
                Result := 0.019398916547145841;
            end
            else
            begin
                if features.chain_score_gap <= -44917436.999999993 then
                begin
                    Result := -0.018639996316817977;
                end
                else
                begin
                    Result := 0.0095666609359844439;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_77(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.03485783305205363;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4744.4999999999991 then
        begin
            if features.chain_score_gap <= -127081972.99999999 then
            begin
                if features.char_lm_score <= -5607.4999999999991 then
                begin
                    Result := 0.0062996613479391591;
                end
                else
                begin
                    Result := -0.03943744403306914;
                end;
            end
            else
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    if features.path_segments <= 5.5000000000000009 then
                    begin
                        if Ord(features.source_local_rerank) <= 1.0000000180025095E-35 then
                        begin
                            if features.char_lm_suffix_score <= -7411.4999999999991 then
                            begin
                                Result := -0.0079824994766387863;
                            end
                            else
                            begin
                                Result := 0.013721604328539005;
                            end;
                        end
                        else
                        begin
                            Result := -0.0045062990724834169;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -31354499.999999996 then
                        begin
                            if features.dict_weight_per_unit <= 4263.5000000000009 then
                            begin
                                Result := 0.0093984259965588113;
                            end
                            else
                            begin
                                if features.score_per_unit <= 10810.500000000002 then
                                begin
                                    if features.path_segments <= 6.5000000000000009 then
                                    begin
                                        Result := -0.0039059809496193656;
                                    end
                                    else
                                    begin
                                        Result := -0.044443431225867316;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.0033411035082952555;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.input_syllable_count <= 10.500000000000002 then
                            begin
                                if features.chain_score_gap <= -20341703.499999996 then
                                begin
                                    Result := 0.025739875511639396;
                                end
                                else
                                begin
                                    Result := -0.024377196671157737;
                                end;
                            end
                            else
                            begin
                                if features.path_segments <= 6.5000000000000009 then
                                begin
                                    Result := 0.013024780491728161;
                                end
                                else
                                begin
                                    Result := -0.0020500000609064428;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_rank <= 1.0000000180025095E-35 then
                    begin
                        Result := -0.0050975344594565075;
                    end
                    else
                    begin
                        if features.path_segments <= 8.5000000000000018 then
                        begin
                            if features.candidate_score <= 131226.50000000003 then
                            begin
                                if features.char_lm_score <= -5869.4999999999991 then
                                begin
                                    Result := -0.0056854960159830352;
                                end
                                else
                                begin
                                    if features.dict_weight <= 122800.50000000001 then
                                    begin
                                        if features.path_single_segments <= 3.5000000000000004 then
                                        begin
                                            if features.chain_score_gap <= -10732023.999999998 then
                                            begin
                                                Result := 0.0087915843952449304;
                                            end
                                            else
                                            begin
                                                Result := 0.025522645784716091;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := -0.0097640922738325767;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.0069227329745522462;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.dict_weight <= 135367.50000000003 then
                                begin
                                    if features.char_lm_context_score <= -6724.4999999999991 then
                                    begin
                                        Result := 0.009172820555001163;
                                    end
                                    else
                                    begin
                                        Result := 0.044873722633911997;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_context_score <= -6626.4999999999991 then
                                    begin
                                        if features.score_per_unit <= 13198.500000000002 then
                                        begin
                                            Result := 0.025762677038468892;
                                        end
                                        else
                                        begin
                                            if features.char_lm_context_score <= -7614.4999999999991 then
                                            begin
                                                Result := 0.01402589649200957;
                                            end
                                            else
                                            begin
                                                Result := -0.026614558729059688;
                                            end;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.00077471510947520704;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -675.49999999999989 then
                            begin
                                Result := -0.016212611240484991;
                            end
                            else
                            begin
                                if features.input_syllable_count <= 15.500000000000002 then
                                begin
                                    Result := -0.017867522686324255;
                                end
                                else
                                begin
                                    Result := 0.0090576252890688259;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_score_gap <= -20341703.499999996 then
            begin
                Result := -0.0020471092500943667;
            end
            else
            begin
                Result := 0.020316463721285299;
            end;
        end;
    end;
end;

function long_final_ranker_tree_78(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.034805912020293532;
    end
    else
    begin
        if features.chain_score_gap <= -127081972.99999999 then
        begin
            Result := -0.033126918048946609;
        end
        else
        begin
            if features.char_lm_suffix_score <= -4633.4999999999991 then
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    if features.path_segments <= 5.5000000000000009 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            Result := 0.00075978504275803747;
                        end
                        else
                        begin
                            if features.score_per_unit <= 7397.0000000000009 then
                            begin
                                Result := 0.031855417002608709;
                            end
                            else
                            begin
                                Result := 0.0090434501383177927;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.text_units <= 11.500000000000002 then
                        begin
                            if features.char_lm_context_gain <= -769.49999999999989 then
                            begin
                                if features.candidate_score <= 97668.500000000015 then
                                begin
                                    if features.char_lm_context_gain <= -863.49999999999989 then
                                    begin
                                        Result := -0.023014149684439069;
                                    end
                                    else
                                    begin
                                        Result := 0.015240984459484;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.010616919253022137;
                                end;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -14724454.999999998 then
                                begin
                                    Result := -0.0018862879941867357;
                                end
                                else
                                begin
                                    if features.chain_score_gap <= -999794.49999999988 then
                                    begin
                                        Result := -0.051460655925739035;
                                    end
                                    else
                                    begin
                                        Result := -0.01459884652721485;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_suffix_score <= -6134.4999999999991 then
                            begin
                                if features.chain_second_stage_score <= -47514492.499999993 then
                                begin
                                    Result := 0.0036727369823592827;
                                end
                                else
                                begin
                                    if features.chain_score_gap <= -31354499.999999996 then
                                    begin
                                        Result := -0.046488614883404472;
                                    end
                                    else
                                    begin
                                        if features.path_segments <= 7.5000000000000009 then
                                        begin
                                            Result := 0.0025223331334006281;
                                        end
                                        else
                                        begin
                                            if features.char_lm_context_gain <= -431.49999999999994 then
                                            begin
                                                Result := -0.023986288260201535;
                                            end
                                            else
                                            begin
                                                Result := 0.0059374402972851388;
                                            end;
                                        end;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_context_score <= -6525.4999999999991 then
                                begin
                                    Result := 0.019656259780877292;
                                end
                                else
                                begin
                                    Result := 0.00045540854782400927;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                    begin
                        Result := -0.0031340316197233146;
                    end
                    else
                    begin
                        if features.path_single_segments <= 3.5000000000000004 then
                        begin
                            if features.char_lm_suffix_score <= -5412.4999999999991 then
                            begin
                                if features.chain_second_stage_score <= 57463472.000000007 then
                                begin
                                    if features.chain_second_stage_score <= 25555719.500000004 then
                                    begin
                                        Result := 0.0070590032510472805;
                                    end
                                    else
                                    begin
                                        if features.chain_first_stage_score <= 133056.50000000003 then
                                        begin
                                            if features.char_lm_context_score <= -7022.4999999999991 then
                                            begin
                                                Result := 0.00073521668053176832;
                                            end
                                            else
                                            begin
                                                Result := 0.039769366667984536;
                                            end;
                                        end
                                        else
                                        begin
                                            if features.char_lm_context_score <= -6675.4999999999991 then
                                            begin
                                                Result := 0.016745444779723971;
                                            end
                                            else
                                            begin
                                                if features.candidate_score <= 131899.00000000003 then
                                                begin
                                                    Result := 0.028266780286497352;
                                                end
                                                else
                                                begin
                                                    Result := -0.01900727319844055;
                                                end;
                                            end;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.013658197919777187;
                                end;
                            end
                            else
                            begin
                                if features.candidate_score <= 19859.500000000004 then
                                begin
                                    Result := -0.011134571340928335;
                                end
                                else
                                begin
                                    if features.chain_first_stage_score <= 89058.500000000015 then
                                    begin
                                        Result := 0.044395696370756188;
                                    end
                                    else
                                    begin
                                        Result := 0.015455367515390712;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := -0.0020933913063156321;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := 0.017145298808080512;
            end;
        end;
    end;
end;

function long_final_ranker_tree_79(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.03473418668606084;
    end
    else
    begin
        if features.char_lm_score <= -4963.4999999999991 then
        begin
            if features.path_single_segments <= 2.5000000000000004 then
            begin
                if Ord(features.source_rule_fallback) <= 1.0000000180025095E-35 then
                begin
                    if features.chain_score_gap <= -52040049.499999993 then
                    begin
                        if features.dict_weight_per_unit <= 1483.5000000000002 then
                        begin
                            if features.chain_second_stage_score <= -79482274.999999985 then
                            begin
                                if features.chain_second_stage_score <= -108992813.49999999 then
                                begin
                                    Result := 0.014709378966644739;
                                end
                                else
                                begin
                                    Result := -0.031226394806630108;
                                end;
                            end
                            else
                            begin
                                Result := 0.032046524644409255;
                            end;
                        end
                        else
                        begin
                            Result := -0.013283149221175695;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -51349360.499999993 then
                        begin
                            if features.chain_first_stage_score <= 80098.500000000015 then
                            begin
                                Result := -0.007299258520338271;
                            end
                            else
                            begin
                                Result := 0.025743955181518435;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_score <= -7549.4999999999991 then
                            begin
                                if features.path_segments <= 7.5000000000000009 then
                                begin
                                    Result := 0.0015257486712808117;
                                end
                                else
                                begin
                                    Result := -0.017691673984981268;
                                end;
                            end
                            else
                            begin
                                Result := 0.0096052226182650816;
                            end;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.010747927312768864;
                end;
            end
            else
            begin
                if features.chain_second_stage_score <= -23768986.499999996 then
                begin
                    if features.char_lm_suffix_score <= -6162.4999999999991 then
                    begin
                        Result := -0.0046205651435850953;
                    end
                    else
                    begin
                        Result := 0.025819477257443567;
                    end;
                end
                else
                begin
                    Result := -0.010967556083744072;
                end;
            end;
        end
        else
        begin
            if features.char_lm_score <= -3258.4999999999995 then
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    if features.path_max_segment_units <= 3.5000000000000004 then
                    begin
                        if features.chain_score_gap <= -2931978.9999999995 then
                        begin
                            if features.char_lm_context_gain <= -712.49999999999989 then
                            begin
                                if features.char_lm_context_gain <= -924.49999999999989 then
                                begin
                                    Result := -0.018402508364328132;
                                end
                                else
                                begin
                                    Result := 0.024084834051618213;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_score <= -4709.4999999999991 then
                                begin
                                    Result := 0.0038263438404191629;
                                end
                                else
                                begin
                                    Result := -0.028548296507986258;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.0038088149011363892;
                        end;
                    end
                    else
                    begin
                        if features.path_segments <= 5.5000000000000009 then
                        begin
                            Result := 0.02406703857352786;
                        end
                        else
                        begin
                            Result := 0.0026702857589426272;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_first_stage_score <= 27672.000000000004 then
                    begin
                        Result := -0.0017504343760160583;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -20981126.499999996 then
                        begin
                            if features.chain_second_stage_score <= 12710763.500000002 then
                            begin
                                if features.chain_score_gap <= -79762850.999999985 then
                                begin
                                    Result := -0.00051754081614522403;
                                end
                                else
                                begin
                                    Result := 0.044514388015584549;
                                end;
                            end
                            else
                            begin
                                Result := -0.0016004730799145941;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 42661919.500000007 then
                            begin
                                if features.char_lm_context_gain <= -863.49999999999989 then
                                begin
                                    Result := 0.002860895672651742;
                                end
                                else
                                begin
                                    Result := 0.048153751630448417;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_score <= -4263.4999999999991 then
                                begin
                                    Result := 0.0048801984130172494;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -3724.4999999999995 then
                                    begin
                                        Result := 0.035337974409263513;
                                    end
                                    else
                                    begin
                                        Result := 0.0;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := 0.022838654286918711;
            end;
        end;
    end;
end;

function long_final_ranker_tree_80(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.034669459308128779;
    end
    else
    begin
        if features.char_lm_suffix_score <= -5412.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 10476.500000000002 then
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    Result := -0.0066132735367857732;
                end
                else
                begin
                    if features.path_max_segment_units <= 9.5000000000000018 then
                    begin
                        if features.chain_first_stage_score <= 159528.00000000003 then
                        begin
                            if features.chain_first_stage_score <= 131999.00000000003 then
                            begin
                                if features.dict_weight_per_unit <= 10267.500000000002 then
                                begin
                                    if features.chain_second_stage_score <= 22220565.000000004 then
                                    begin
                                        if features.char_lm_context_gain <= -863.49999999999989 then
                                        begin
                                            Result := 0.0067633764457782335;
                                        end
                                        else
                                        begin
                                            Result := -0.0071108642838824659;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.chain_second_stage_score <= 57463472.000000007 then
                                        begin
                                            Result := 0.034120315336654571;
                                        end
                                        else
                                        begin
                                            Result := -0.022046144224759364;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.014190574551581448;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_context_score <= -7789.4999999999991 then
                                begin
                                    Result := 0.04139812729648118;
                                end
                                else
                                begin
                                    Result := 0.0021588063889161103;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_score <= -7122.4999999999991 then
                            begin
                                Result := -0.025364152524851219;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -19121511.999999996 then
                                begin
                                    Result := 0.02716484084455522;
                                end
                                else
                                begin
                                    if features.char_lm_context_score <= -6774.4999999999991 then
                                    begin
                                        Result := 0.018042599708954055;
                                    end
                                    else
                                    begin
                                        Result := -0.02213028869565322;
                                    end;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := -0.011931036725266759;
                    end;
                end;
            end
            else
            begin
                if features.chain_second_stage_score <= 57463472.000000007 then
                begin
                    if features.char_lm_score <= -4963.4999999999991 then
                    begin
                        if features.path_single_segments <= 2.5000000000000004 then
                        begin
                            if features.chain_first_stage_score <= 77616.500000000015 then
                            begin
                                Result := -0.0041526566509771743;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -50555175.499999993 then
                                begin
                                    Result := -0.010447589229588456;
                                end
                                else
                                begin
                                    Result := 0.012588726994656853;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := -0.0019604626407249848;
                        end;
                    end
                    else
                    begin
                        Result := 0.016354908453063182;
                    end;
                end
                else
                begin
                    Result := -0.021031590472286768;
                end;
            end;
        end
        else
        begin
            if features.chain_second_stage_score <= 28697187.500000004 then
            begin
                if Ord(features.source_local_rerank) <= 1.0000000180025095E-35 then
                begin
                    Result := 0.021537557972348777;
                end
                else
                begin
                    Result := 0.0036692524893194361;
                end;
            end
            else
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    if features.char_lm_suffix_score <= -4665.4999999999991 then
                    begin
                        if features.chain_score_gap <= -7113512.4999999991 then
                        begin
                            Result := -0.025493276098601282;
                        end
                        else
                        begin
                            Result := 0.0011921717278355912;
                        end;
                    end
                    else
                    begin
                        Result := 0.012109392371659965;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -30706224.999999996 then
                    begin
                        Result := -0.0062694803447830554;
                    end
                    else
                    begin
                        if features.char_lm_score <= -3777.4999999999995 then
                        begin
                            if features.char_lm_context_gain <= -376.49999999999994 then
                            begin
                                if features.score_per_unit <= 6417.5000000000009 then
                                begin
                                    Result := -0.0072729907714158305;
                                end
                                else
                                begin
                                    if features.chain_first_stage_score <= 130790.00000000001 then
                                    begin
                                        Result := 0.047485083020064073;
                                    end
                                    else
                                    begin
                                        Result := 0.018776344865561637;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.00089411507462462615;
                            end;
                        end
                        else
                        begin
                            Result := -0.00038408794551711114;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_81(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.034630842828011148;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4665.4999999999991 then
        begin
            if features.legacy_rank <= 1.5000000000000002 then
            begin
                if features.path_segments <= 5.5000000000000009 then
                begin
                    if features.dict_weight <= 124429.00000000001 then
                    begin
                        if features.char_lm_context_score <= -6525.4999999999991 then
                        begin
                            Result := -0.0016789248550722624;
                        end
                        else
                        begin
                            Result := 0.012841871428826325;
                        end;
                    end
                    else
                    begin
                        Result := 0.017837284488690982;
                    end;
                end
                else
                begin
                    if features.char_lm_suffix_score <= -6059.4999999999991 then
                    begin
                        if features.char_lm_suffix_score <= -6323.4999999999991 then
                        begin
                            if features.chain_first_stage_score <= 159528.00000000003 then
                            begin
                                if features.char_lm_suffix_score <= -6849.4999999999991 then
                                begin
                                    Result := -0.021278643511041133;
                                end
                                else
                                begin
                                    if features.chain_first_stage_score <= 87237.000000000015 then
                                    begin
                                        Result := 0.016009540508468988;
                                    end
                                    else
                                    begin
                                        Result := -0.011198641365618345;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := 0.0035693505155804084;
                            end;
                        end
                        else
                        begin
                            if features.dict_weight_per_unit <= 11155.500000000002 then
                            begin
                                if features.chain_rank <= 1.5000000000000002 then
                                begin
                                    Result := -0.010181285407645143;
                                end
                                else
                                begin
                                    Result := -0.043424538374091833;
                                end;
                            end
                            else
                            begin
                                Result := 0.0076818755802003655;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.text_units <= 11.500000000000002 then
                        begin
                            if features.char_lm_context_score <= -5629.4999999999991 then
                            begin
                                Result := -0.0079071003286792126;
                            end
                            else
                            begin
                                Result := -0.038315864715886973;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_suffix_score <= -5191.4999999999991 then
                            begin
                                Result := 0.0090701719841862708;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -6389736.9999999991 then
                                begin
                                    Result := -0.029651777965383139;
                                end
                                else
                                begin
                                    Result := 0.0021790187894743609;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.0000000180025095E-35 then
                begin
                    Result := -0.0030957426385422142;
                end
                else
                begin
                    if features.path_segments <= 8.5000000000000018 then
                    begin
                        if features.text_units <= 13.500000000000002 then
                        begin
                            if features.chain_second_stage_score <= 31744429.500000004 then
                            begin
                                if features.char_lm_context_score <= -9196.4999999999982 then
                                begin
                                    Result := -0.017538036782813994;
                                end
                                else
                                begin
                                    if features.dict_weight <= 152632.50000000003 then
                                    begin
                                        if features.chain_first_stage_score <= 66275.500000000015 then
                                        begin
                                            if features.char_lm_context_gain <= -730.49999999999989 then
                                            begin
                                                Result := 0.019502194985496952;
                                            end
                                            else
                                            begin
                                                Result := -0.016043514252331088;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := -0.0023884251226404213;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.024426330674919033;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -33582753.499999993 then
                                begin
                                    Result := -0.0092540290564620126;
                                end
                                else
                                begin
                                    Result := 0.020018725637760283;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 36652805.000000007 then
                            begin
                                Result := 0.027007680474730733;
                            end
                            else
                            begin
                                Result := -0.01704279834052122;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_context_gain <= -675.49999999999989 then
                        begin
                            Result := -0.016130501500542484;
                        end
                        else
                        begin
                            if features.dict_weight_per_unit <= 12297.500000000002 then
                            begin
                                if features.dict_weight_per_unit <= 10869.000000000002 then
                                begin
                                    Result := 0.0;
                                end
                                else
                                begin
                                    Result := 0.020101149632256583;
                                end;
                            end
                            else
                            begin
                                Result := -0.018042013475261045;
                            end;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            Result := 0.016889981356847328;
        end;
    end;
end;

function long_final_ranker_tree_82(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.partial_match) <= 1.0000000180025095E-35 then
    begin
        if features.char_lm_score <= -4963.4999999999991 then
        begin
            if features.dict_weight_per_unit <= 10476.500000000002 then
            begin
                if features.chain_first_stage_score <= 140224.50000000003 then
                begin
                    if features.chain_score_gap <= -8600494.9999999981 then
                    begin
                        if features.chain_first_stage_score <= 107215.00000000001 then
                        begin
                            if features.chain_first_stage_score <= 85599.500000000015 then
                            begin
                                if features.chain_first_stage_score <= 43010.000000000007 then
                                begin
                                    if features.chain_score_gap <= -35643245.499999993 then
                                    begin
                                        if features.char_lm_score <= -5327.4999999999991 then
                                        begin
                                            if features.dict_weight_per_unit <= 1370.5000000000002 then
                                            begin
                                                Result := 0.016661556897856252;
                                            end
                                            else
                                            begin
                                                Result := -0.026650718602832215;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := -0.032144220113527251;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.014134917357804672;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.015308504888907455;
                                end;
                            end
                            else
                            begin
                                Result := -0.016382795064905472;
                            end;
                        end
                        else
                        begin
                            Result := 0.022323075043940491;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -3469666.9999999995 then
                        begin
                            Result := -0.014668469293320559;
                        end
                        else
                        begin
                            if features.path_max_segment_units <= 5.5000000000000009 then
                            begin
                                Result := 0.0052041923000993558;
                            end
                            else
                            begin
                                Result := -0.011904752820705588;
                            end;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.013008813591716585;
                end;
            end
            else
            begin
                Result := 0.0026979841496297735;
            end;
        end
        else
        begin
            if features.char_lm_score <= -3258.4999999999995 then
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    if features.path_max_segment_units <= 3.5000000000000004 then
                    begin
                        if features.dict_weight_per_unit <= 13679.000000000002 then
                        begin
                            if features.dict_weight_per_unit <= 11299.500000000002 then
                            begin
                                if features.text_units <= 9.5000000000000018 then
                                begin
                                    Result := -0.01519853579644161;
                                end
                                else
                                begin
                                    Result := 0.0048384836959799327;
                                end;
                            end
                            else
                            begin
                                Result := -0.018758243476056796;
                            end;
                        end
                        else
                        begin
                            Result := 0.01405533664207597;
                        end;
                    end
                    else
                    begin
                        Result := 0.014259409459128156;
                    end;
                end
                else
                begin
                    if features.chain_first_stage_score <= 27672.000000000004 then
                    begin
                        Result := -0.00052551450711871425;
                    end
                    else
                    begin
                        if features.chain_first_stage_score <= 92148.000000000015 then
                        begin
                            if features.chain_score_gap <= -33582753.499999993 then
                            begin
                                Result := 0.0037082606530098937;
                            end
                            else
                            begin
                                Result := 0.036622568690487106;
                            end;
                        end
                        else
                        begin
                            if features.dict_weight_per_unit <= 12830.000000000002 then
                            begin
                                if features.chain_second_stage_score <= 45306048.000000007 then
                                begin
                                    if features.char_lm_score <= -4465.4999999999991 then
                                    begin
                                        if features.char_lm_context_gain <= -844.49999999999989 then
                                        begin
                                            Result := -0.0020881596578112478;
                                        end
                                        else
                                        begin
                                            Result := 0.029799458801881597;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.012382319348527621;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_score <= -4465.4999999999991 then
                                    begin
                                        if features.dict_weight_per_unit <= 8965.5000000000018 then
                                        begin
                                            Result := 0.013753979128148736;
                                        end
                                        else
                                        begin
                                            Result := -0.022012602476349199;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.0084705805176430136;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_context_score <= -6417.4999999999991 then
                                begin
                                    Result := -0.0052404329648009316;
                                end
                                else
                                begin
                                    Result := 0.040671276583042926;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.chain_first_stage_score <= 87820.000000000015 then
                begin
                    Result := 0.02917579681550625;
                end
                else
                begin
                    Result := 0.0065034768922830576;
                end;
            end;
        end;
    end
    else
    begin
        Result := -0.03456341460041025;
    end;
end;

function long_final_ranker_tree_83(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.034491338417712798;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4665.4999999999991 then
        begin
            if features.legacy_rank <= 1.5000000000000002 then
            begin
                if features.path_single_segments <= 2.5000000000000004 then
                begin
                    if features.path_segments <= 7.5000000000000009 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            if features.dict_weight_per_unit <= 15302.000000000002 then
                            begin
                                if features.input_syllable_count <= 10.500000000000002 then
                                begin
                                    Result := -0.0079967293740128842;
                                end
                                else
                                begin
                                    Result := 0.0053214645561082217;
                                end;
                            end
                            else
                            begin
                                Result := 0.017282675106810225;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_score <= -5694.4999999999991 then
                            begin
                                if features.char_lm_suffix_score <= -5737.4999999999991 then
                                begin
                                    Result := 0.0059932399887838552;
                                end
                                else
                                begin
                                    Result := 0.019636548568153993;
                                end;
                            end
                            else
                            begin
                                Result := -0.010709692539943133;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -6096.4999999999991 then
                        begin
                            if features.chain_second_stage_score <= -43880677.499999993 then
                            begin
                                Result := 0.0;
                            end
                            else
                            begin
                                Result := -0.033921939769434716;
                            end;
                        end
                        else
                        begin
                            Result := 0.011775807673930987;
                        end;
                    end;
                end
                else
                begin
                    if features.input_syllable_count <= 9.5000000000000018 then
                    begin
                        Result := -0.031209846955376142;
                    end
                    else
                    begin
                        if features.score_per_unit <= 6774.0000000000009 then
                        begin
                            if features.chain_second_stage_score <= 31744429.500000004 then
                            begin
                                if features.path_single_segments <= 4.5000000000000009 then
                                begin
                                    Result := 0.024499395137329284;
                                end
                                else
                                begin
                                    Result := -0.011788540030794648;
                                end;
                            end
                            else
                            begin
                                Result := -0.013649369367986575;
                            end;
                        end
                        else
                        begin
                            if features.candidate_score <= 250008.50000000003 then
                            begin
                                Result := -0.012738633575241695;
                            end
                            else
                            begin
                                Result := 0.016234220057692546;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_score <= -4263.4999999999991 then
                begin
                    if features.chain_second_stage_score <= 57463472.000000007 then
                    begin
                        if features.char_lm_score <= -4963.4999999999991 then
                        begin
                            if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                            begin
                                Result := -0.0051043676839966443;
                            end
                            else
                            begin
                                if features.path_single_segments <= 2.5000000000000004 then
                                begin
                                    if features.candidate_score <= 148846.50000000003 then
                                    begin
                                        if features.char_lm_score <= -5495.4999999999991 then
                                        begin
                                            if features.score_per_unit <= 5427.0000000000009 then
                                            begin
                                                Result := 0.023291560823598907;
                                            end
                                            else
                                            begin
                                                if features.char_lm_suffix_score <= -7227.4999999999991 then
                                                begin
                                                    Result := 0.0035636415100489677;
                                                end
                                                else
                                                begin
                                                    Result := -0.011542107716431018;
                                                end;
                                            end;
                                        end
                                        else
                                        begin
                                            if features.chain_first_stage_score <= 134501.00000000003 then
                                            begin
                                                Result := 0.023676302973292492;
                                            end
                                            else
                                            begin
                                                Result := -0.016260296314836067;
                                            end;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.char_lm_score <= -5607.4999999999991 then
                                        begin
                                            if features.dict_weight_per_unit <= 12069.500000000002 then
                                            begin
                                                Result := 0.034990476801165037;
                                            end
                                            else
                                            begin
                                                Result := 0.0079672955831354923;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := -0.0037072740437516117;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.0044385569684652392;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.014502550942604922;
                        end;
                    end
                    else
                    begin
                        Result := -0.015079044905517746;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 19859.500000000004 then
                    begin
                        Result := -0.016370167888636163;
                    end
                    else
                    begin
                        Result := 0.019913891296601146;
                    end;
                end;
            end;
        end
        else
        begin
            Result := 0.017478199391005748;
        end;
    end;
end;

function long_final_ranker_tree_84(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.034441313867799514;
    end
    else
    begin
        if features.char_lm_suffix_score <= -5412.4999999999991 then
        begin
            if features.legacy_rank <= 1.5000000000000002 then
            begin
                if features.score_per_unit <= 13198.500000000002 then
                begin
                    if features.path_segments <= 6.5000000000000009 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            if features.score_per_unit <= 9580.5000000000018 then
                            begin
                                Result := -0.020212266201612112;
                            end
                            else
                            begin
                                if features.char_lm_suffix_score <= -5654.4999999999991 then
                                begin
                                    Result := 0.0088080630300562783;
                                end
                                else
                                begin
                                    Result := -0.026695620181094341;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.0099476916809590633;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= 28697187.500000004 then
                        begin
                            if features.dict_weight_per_unit <= 7074.5000000000009 then
                            begin
                                if features.char_lm_context_score <= -7335.4999999999991 then
                                begin
                                    if features.char_lm_context_score <= -7731.4999999999991 then
                                    begin
                                        Result := 0.0038791805484564555;
                                    end
                                    else
                                    begin
                                        Result := -0.032610363982308668;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.012615659221555577;
                                end;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -31354499.999999996 then
                                begin
                                    Result := -0.038643116697783864;
                                end
                                else
                                begin
                                    if features.chain_score_gap <= -7808187.4999999991 then
                                    begin
                                        Result := 0.0093987167757024013;
                                    end
                                    else
                                    begin
                                        Result := -0.015709811703242947;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.0016359214414754196;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_score <= -6150.4999999999991 then
                    begin
                        Result := -0.012381051075494009;
                    end
                    else
                    begin
                        Result := 0.01789874586904297;
                    end;
                end;
            end
            else
            begin
                if features.chain_rank <= 1.0000000180025095E-35 then
                begin
                    Result := -0.0023424720655684595;
                end
                else
                begin
                    if features.chain_second_stage_score <= 57463472.000000007 then
                    begin
                        if features.char_lm_score <= -4963.4999999999991 then
                        begin
                            if features.path_single_segments <= 2.5000000000000004 then
                            begin
                                if features.char_lm_context_score <= -6472.4999999999991 then
                                begin
                                    Result := 0.011253310272223451;
                                end
                                else
                                begin
                                    Result := -0.015776783609708543;
                                end;
                            end
                            else
                            begin
                                Result := -0.00061543206556518323;
                            end;
                        end
                        else
                        begin
                            Result := 0.018141563112343571;
                        end;
                    end
                    else
                    begin
                        Result := -0.013130602436175969;
                    end;
                end;
            end;
        end
        else
        begin
            if features.chain_second_stage_score <= 28697187.500000004 then
            begin
                Result := 0.017127033901974429;
            end
            else
            begin
                if features.legacy_rank <= 1.5000000000000002 then
                begin
                    if features.chain_second_stage_score <= 100857689.50000001 then
                    begin
                        if features.char_lm_score <= -4155.4999999999991 then
                        begin
                            Result := 0.0031362444593974774;
                        end
                        else
                        begin
                            if features.dict_weight_per_unit <= 140.50000000000003 then
                            begin
                                Result := 0.015036817863738138;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -6389736.9999999991 then
                                begin
                                    Result := -0.035372633893220179;
                                end
                                else
                                begin
                                    Result := -0.007232834149766134;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.011645138498641527;
                    end;
                end
                else
                begin
                    if features.score_per_unit <= 12564.500000000002 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            if features.dict_weight_per_unit <= 4497.5000000000009 then
                            begin
                                Result := -0.014608434430750565;
                            end
                            else
                            begin
                                Result := 0.025913941280134356;
                            end;
                        end
                        else
                        begin
                            Result := -0.0017383634272010373;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -14613411.499999998 then
                        begin
                            Result := 0.0;
                        end
                        else
                        begin
                            Result := 0.040675680817466399;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_85(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.partial_match) <= 1.0000000180025095E-35 then
    begin
        if features.char_lm_suffix_score <= -4665.4999999999991 then
        begin
            if Ord(features.legacy_top) <= 1.0000000180025095E-35 then
            begin
                if features.char_lm_suffix_score <= -4870.4999999999991 then
                begin
                    if Ord(features.source_chain) <= 1.0000000180025095E-35 then
                    begin
                        Result := -0.0034706592986543747;
                    end
                    else
                    begin
                        if features.path_segments <= 8.5000000000000018 then
                        begin
                            if features.chain_score_gap <= -59011123.499999993 then
                            begin
                                Result := -0.0048913184537396539;
                            end
                            else
                            begin
                                if features.chain_rank <= 2.5000000000000004 then
                                begin
                                    if features.char_lm_score <= -6772.4999999999991 then
                                    begin
                                        Result := -0.0044490384680608208;
                                    end
                                    else
                                    begin
                                        Result := 0.010013837601660823;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.035542860630051736;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -636.49999999999989 then
                            begin
                                Result := -0.018035133015397387;
                            end
                            else
                            begin
                                if features.score_per_unit <= 10476.500000000002 then
                                begin
                                    Result := -0.0055421401447628806;
                                end
                                else
                                begin
                                    if features.score_per_unit <= 12220.000000000002 then
                                    begin
                                        Result := 0.019781167713903019;
                                    end
                                    else
                                    begin
                                        Result := -0.014599650678444617;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= 99407977.000000015 then
                    begin
                        Result := 0.034614617314554876;
                    end
                    else
                    begin
                        Result := -0.011214713196074923;
                    end;
                end;
            end
            else
            begin
                if features.score_per_unit <= 13800.500000000002 then
                begin
                    if features.path_segments <= 6.5000000000000009 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            if features.chain_score_gap <= -21719169.999999996 then
                            begin
                                Result := 0.0099815156732008265;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -1.0000000180025095E-35 then
                                begin
                                    Result := -0.038483747627331331;
                                end
                                else
                                begin
                                    if features.char_lm_context_score <= -7230.4999999999991 then
                                    begin
                                        if features.char_lm_context_score <= -9082.4999999999982 then
                                        begin
                                            Result := 0.016637314101239937;
                                        end
                                        else
                                        begin
                                            Result := -0.024010746283205951;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.0011726849494076599;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.score_per_unit <= 11167.000000000002 then
                            begin
                                Result := 0.014300279231362796;
                            end
                            else
                            begin
                                Result := -0.00041556039061049624;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -31354499.999999996 then
                        begin
                            if features.dict_weight_per_unit <= 5237.0000000000009 then
                            begin
                                Result := 0.0099217949591400879;
                            end
                            else
                            begin
                                if features.text_units <= 17.500000000000004 then
                                begin
                                    Result := -0.042264263815570628;
                                end
                                else
                                begin
                                    Result := -0.0075936625433227654;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_suffix_score <= -6096.4999999999991 then
                            begin
                                if features.chain_second_stage_score <= -43880677.499999993 then
                                begin
                                    if features.chain_second_stage_score <= -60934688.499999993 then
                                    begin
                                        Result := -0.0155470995997998;
                                    end
                                    else
                                    begin
                                        Result := 0.019650852112865422;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.017754853468453728;
                                end;
                            end
                            else
                            begin
                                if features.path_single_segments <= 2.5000000000000004 then
                                begin
                                    if features.char_lm_suffix_score <= -4805.4999999999991 then
                                    begin
                                        Result := 0.016372105338697152;
                                    end
                                    else
                                    begin
                                        Result := -0.021854528434852014;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.0073675940624796724;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_score <= -6228.4999999999991 then
                    begin
                        Result := -0.019380757454539526;
                    end
                    else
                    begin
                        Result := 0.01468036586725447;
                    end;
                end;
            end;
        end
        else
        begin
            Result := 0.015429710165282886;
        end;
    end
    else
    begin
        Result := -0.0343639612390437;
    end;
end;

function long_final_ranker_tree_86(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.034307125638765951;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4665.4999999999991 then
        begin
            if Ord(features.legacy_top) <= 1.0000000180025095E-35 then
            begin
                if features.char_lm_suffix_score <= -4870.4999999999991 then
                begin
                    if features.chain_first_stage_score <= 27672.000000000004 then
                    begin
                        if features.char_lm_context_gain <= -882.49999999999989 then
                        begin
                            Result := 0.002847930347779522;
                        end
                        else
                        begin
                            Result := -0.012683019195249376;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -67862832.499999985 then
                        begin
                            Result := -0.0088950729588992382;
                        end
                        else
                        begin
                            if features.chain_rank <= 2.5000000000000004 then
                            begin
                                Result := 0.0069101219235609065;
                            end
                            else
                            begin
                                Result := 0.041888965831343154;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= 100857689.50000001 then
                    begin
                        Result := 0.03327033268439205;
                    end
                    else
                    begin
                        Result := -0.010648406270127253;
                    end;
                end;
            end
            else
            begin
                if features.path_segments <= 4.5000000000000009 then
                begin
                    if features.dict_weight <= 77009.500000000015 then
                    begin
                        Result := 8.8725591205552313E-06;
                    end
                    else
                    begin
                        Result := 0.020866539417965596;
                    end;
                end
                else
                begin
                    if features.text_units <= 10.500000000000002 then
                    begin
                        if features.path_max_segment_units <= 3.5000000000000004 then
                        begin
                            if features.chain_second_stage_score <= 65201574.000000007 then
                            begin
                                if features.path_segments <= 5.5000000000000009 then
                                begin
                                    if features.char_lm_suffix_score <= -5654.4999999999991 then
                                    begin
                                        Result := -0.0055106817378231384;
                                    end
                                    else
                                    begin
                                        Result := 0.027296334120870274;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.018682065794031821;
                                end;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= 93640530.500000015 then
                                begin
                                    Result := -0.041773746671558809;
                                end
                                else
                                begin
                                    Result := 0.0049359371212197994;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.019643157064514496;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_context_gain <= -1133.4999999999998 then
                        begin
                            Result := 0.016308817411834205;
                        end
                        else
                        begin
                            if features.char_lm_suffix_score <= -6134.4999999999991 then
                            begin
                                if features.chain_first_stage_score <= 262591.00000000006 then
                                begin
                                    if features.chain_first_stage_score <= 191222.50000000003 then
                                    begin
                                        if features.chain_second_stage_score <= -47514492.499999993 then
                                        begin
                                            Result := 0.0018488556120884634;
                                        end
                                        else
                                        begin
                                            if features.chain_score_gap <= -33582753.499999993 then
                                            begin
                                                Result := -0.04533989025657105;
                                            end
                                            else
                                            begin
                                                Result := -0.012096642665091577;
                                            end;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.char_lm_suffix_score <= -6584.4999999999991 then
                                        begin
                                            Result := 0.022356313375075248;
                                        end
                                        else
                                        begin
                                            Result := -0.012209811356698026;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.033543635936941416;
                                end;
                            end
                            else
                            begin
                                if features.path_single_segments <= 2.5000000000000004 then
                                begin
                                    if features.char_lm_suffix_score <= -4805.4999999999991 then
                                    begin
                                        Result := 0.0077571938790698194;
                                    end
                                    else
                                    begin
                                        Result := -0.022426513415526522;
                                    end;
                                end
                                else
                                begin
                                    if features.char_lm_context_gain <= -404.49999999999994 then
                                    begin
                                        if features.char_lm_context_gain <= -656.49999999999989 then
                                        begin
                                            if features.char_lm_score <= -4657.4999999999991 then
                                            begin
                                                Result := 0.020495769613197372;
                                            end
                                            else
                                            begin
                                                Result := -0.015711906062722991;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := -0.021646383876176942;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.0098034155159077551;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.dict_weight <= 253826.00000000003 then
            begin
                Result := 0.016746461578593989;
            end
            else
            begin
                Result := -0.015837853689656494;
            end;
        end;
    end;
end;

function long_final_ranker_tree_87(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.034244339899511034;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4665.4999999999991 then
        begin
            if features.legacy_rank <= 1.5000000000000002 then
            begin
                if features.path_segments <= 4.5000000000000009 then
                begin
                    if features.dict_weight <= 77009.500000000015 then
                    begin
                        if features.chain_score_gap <= -21719169.999999996 then
                        begin
                            Result := 0.023082768195377197;
                        end
                        else
                        begin
                            if features.text_units <= 7.5000000000000009 then
                            begin
                                Result := -0.01374945263118455;
                            end
                            else
                            begin
                                if features.char_lm_score <= -4560.4999999999991 then
                                begin
                                    Result := -0.0056450495462211057;
                                end
                                else
                                begin
                                    Result := 0.017897599131551738;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.020484337953743822;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -6367.4999999999991 then
                    begin
                        if features.chain_second_stage_score <= 65201574.000000007 then
                        begin
                            if features.chain_second_stage_score <= 28697187.500000004 then
                            begin
                                if features.chain_first_stage_score <= 262591.00000000006 then
                                begin
                                    if features.candidate_score <= 237417.50000000003 then
                                    begin
                                        Result := -0.0084972976360347605;
                                    end
                                    else
                                    begin
                                        Result := 0.024623811512661131;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.030197668941514173;
                                end;
                            end
                            else
                            begin
                                Result := 0.0085736117596567317;
                            end;
                        end
                        else
                        begin
                            Result := -0.03270225246816811;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -5694.4999999999991 then
                        begin
                            Result := 0.0053645347361511971;
                        end
                        else
                        begin
                            if features.dict_weight <= 174737.50000000003 then
                            begin
                                if features.char_lm_context_score <= -5491.4999999999991 then
                                begin
                                    Result := -0.030793276964029257;
                                end
                                else
                                begin
                                    Result := -0.0011005790487569693;
                                end;
                            end
                            else
                            begin
                                Result := 0.0042743993034156831;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_score <= -5730.4999999999991 then
                begin
                    if features.dict_weight <= 142545.00000000003 then
                    begin
                        Result := -0.0040290007067578263;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -51349360.499999993 then
                        begin
                            if features.char_lm_context_score <= -7731.4999999999991 then
                            begin
                                Result := 0.030747423328678213;
                            end
                            else
                            begin
                                Result := 0.00023774998686173024;
                            end;
                        end
                        else
                        begin
                            Result := -0.00072939193943806133;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_second_stage_score <= -25586281.999999996 then
                    begin
                        if features.chain_score_gap <= -131664660.49999999 then
                        begin
                            Result := -0.012567341065274783;
                        end
                        else
                        begin
                            Result := 0.026531547989804029;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -59011123.499999993 then
                        begin
                            Result := -0.013335836496811224;
                        end
                        else
                        begin
                            if features.path_max_segment_units <= 2.5000000000000004 then
                            begin
                                if features.chain_second_stage_score <= 1.0000000180025095E-35 then
                                begin
                                    Result := -0.0014946259542551025;
                                end
                                else
                                begin
                                    if features.chain_first_stage_score <= 174116.00000000003 then
                                    begin
                                        Result := 0.022448673705841794;
                                    end
                                    else
                                    begin
                                        Result := -0.0088446971302393543;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -999794.49999999988 then
                                begin
                                    if features.chain_score_gap <= -9835736.4999999981 then
                                    begin
                                        Result := 0.0016678973542787064;
                                    end
                                    else
                                    begin
                                        Result := 0.036204700825131914;
                                    end;
                                end
                                else
                                begin
                                    if features.path_single_segments <= 1.5000000000000002 then
                                    begin
                                        Result := 0.0067367385833516438;
                                    end
                                    else
                                    begin
                                        if features.text_units <= 9.5000000000000018 then
                                        begin
                                            Result := 0.018715390680869106;
                                        end
                                        else
                                        begin
                                            Result := -0.014819666589622619;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            Result := 0.014234788582863939;
        end;
    end;
end;

function long_final_ranker_tree_88(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.034176011304130227;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4665.4999999999991 then
        begin
            if features.legacy_rank <= 1.5000000000000002 then
            begin
                if features.dict_weight_per_unit <= 12520.500000000002 then
                begin
                    if features.path_single_segments <= 2.5000000000000004 then
                    begin
                        if features.char_lm_context_score <= -6525.4999999999991 then
                        begin
                            if features.text_units <= 13.500000000000002 then
                            begin
                                if features.chain_second_stage_score <= -38535230.499999993 then
                                begin
                                    if features.char_lm_suffix_score <= -7057.4999999999991 then
                                    begin
                                        Result := -0.0048936010979386893;
                                    end
                                    else
                                    begin
                                        Result := 0.021890135835498752;
                                    end;
                                end
                                else
                                begin
                                    if features.path_max_segment_units <= 2.5000000000000004 then
                                    begin
                                        Result := -0.013504991333198586;
                                    end
                                    else
                                    begin
                                        Result := 0.0027767832148073734;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.016740544419041579;
                            end;
                        end
                        else
                        begin
                            Result := 0.005098289909710999;
                        end;
                    end
                    else
                    begin
                        if features.text_units <= 9.5000000000000018 then
                        begin
                            Result := -0.035481739692750612;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -10184703.999999998 then
                            begin
                                if features.dict_weight_per_unit <= 6197.5000000000009 then
                                begin
                                    Result := 0.022069214937156086;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= -32334096.999999996 then
                                    begin
                                        if features.char_lm_score <= -6415.4999999999991 then
                                        begin
                                            Result := 0.0080183055166600913;
                                        end
                                        else
                                        begin
                                            Result := -0.028893619279550194;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.char_lm_context_gain <= -600.49999999999989 then
                                        begin
                                            Result := 0.026034576357655423;
                                        end
                                        else
                                        begin
                                            Result := -0.010258599646653229;
                                        end;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_context_score <= -5491.4999999999991 then
                                begin
                                    if features.chain_rank <= 1.5000000000000002 then
                                    begin
                                        Result := -0.010871015686041114;
                                    end
                                    else
                                    begin
                                        Result := -0.031750514218583145;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.0076787952643487247;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.char_lm_context_score <= -5414.4999999999991 then
                    begin
                        if features.dict_weight <= 148112.50000000003 then
                        begin
                            Result := -0.0012950130567529077;
                        end
                        else
                        begin
                            Result := 0.017835589888083182;
                        end;
                    end
                    else
                    begin
                        Result := -0.019138723242091191;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_suffix_score <= -6451.4999999999991 then
                begin
                    if features.chain_first_stage_score <= 127420.50000000001 then
                    begin
                        Result := -0.0036004889333043745;
                    end
                    else
                    begin
                        if features.chain_first_stage_score <= 181980.50000000003 then
                        begin
                            if features.dict_weight <= 150082.50000000003 then
                            begin
                                if features.char_lm_context_gain <= -1058.4999999999998 then
                                begin
                                    Result := 0.019822011842650734;
                                end
                                else
                                begin
                                    if features.char_lm_context_gain <= -788.49999999999989 then
                                    begin
                                        Result := -0.027369975188387553;
                                    end
                                    else
                                    begin
                                        Result := 0.0089164380899512969;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := 0.021427253375350473;
                            end;
                        end
                        else
                        begin
                            if features.path_single_segments <= 2.5000000000000004 then
                            begin
                                Result := 0.013757302310900842;
                            end
                            else
                            begin
                                Result := -0.019744089685756028;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.text_units <= 7.5000000000000009 then
                    begin
                        Result := 0.028810344101546731;
                    end
                    else
                    begin
                        if features.chain_first_stage_score <= 27672.000000000004 then
                        begin
                            Result := -0.0058098075483091491;
                        end
                        else
                        begin
                            Result := 0.0089480550411748967;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            if features.dict_weight <= 253826.00000000003 then
            begin
                Result := 0.018353054531491081;
            end
            else
            begin
                Result := -0.016045381860840712;
            end;
        end;
    end;
end;

function long_final_ranker_tree_89(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.034096696759048875;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.char_lm_score <= -3299.4999999999995 then
            begin
                if features.path_single_segments <= 2.5000000000000004 then
                begin
                    if features.char_lm_context_score <= -6525.4999999999991 then
                    begin
                        if features.dict_weight_per_unit <= 12069.500000000002 then
                        begin
                            if features.dict_weight <= 150082.50000000003 then
                            begin
                                if features.candidate_score <= 112772.00000000001 then
                                begin
                                    if features.chain_second_stage_score <= -64024275.499999993 then
                                    begin
                                        Result := 0.015325494940578431;
                                    end
                                    else
                                    begin
                                        if features.chain_score_gap <= -1.0000000180025095E-35 then
                                        begin
                                            Result := -0.030905101227351919;
                                        end
                                        else
                                        begin
                                            if features.dict_weight <= 370.50000000000006 then
                                            begin
                                                Result := -0.023361446816900576;
                                            end
                                            else
                                            begin
                                                if features.char_lm_score <= -6150.4999999999991 then
                                                begin
                                                    Result := -0.020438913583318945;
                                                end
                                                else
                                                begin
                                                    Result := 0.010489305911192079;
                                                end;
                                            end;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.0047044322577861394;
                                end;
                            end
                            else
                            begin
                                Result := -0.019864168815379963;
                            end;
                        end
                        else
                        begin
                            Result := 0.01444871050906159;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -14613411.499999998 then
                        begin
                            Result := 0.024884774421311564;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -2931978.9999999995 then
                            begin
                                Result := -0.024606337703231739;
                            end
                            else
                            begin
                                Result := 0.0075847803599076611;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 19859.500000000004 then
                    begin
                        Result := 0.0091313357512133129;
                    end
                    else
                    begin
                        if features.text_units <= 10.500000000000002 then
                        begin
                            Result := -0.026928314364821109;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -749.49999999999989 then
                            begin
                                Result := 0.0067057803197013112;
                            end
                            else
                            begin
                                if features.chain_rank <= 1.5000000000000002 then
                                begin
                                    Result := -0.0051617464115966578;
                                end
                                else
                                begin
                                    if features.char_lm_context_gain <= -481.49999999999994 then
                                    begin
                                        if features.chain_second_stage_score <= 9825698.5000000019 then
                                        begin
                                            Result := -0.012400213643799242;
                                        end
                                        else
                                        begin
                                            Result := -0.051490624243288131;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.0027623891233070495;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := 0.021468936673099185;
            end;
        end
        else
        begin
            if features.char_lm_suffix_score <= -5412.4999999999991 then
            begin
                if features.chain_second_stage_score <= 57463472.000000007 then
                begin
                    if features.char_lm_score <= -4963.4999999999991 then
                    begin
                        if features.dict_weight_per_unit <= 13160.500000000002 then
                        begin
                            if features.dict_weight_per_unit <= 12069.500000000002 then
                            begin
                                Result := 0.0028063950657918465;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= 36652805.000000007 then
                                begin
                                    if features.char_lm_context_score <= -8592.4999999999982 then
                                    begin
                                        Result := -0.023500546733280243;
                                    end
                                    else
                                    begin
                                        Result := 0.030529291056872306;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.034094238899107406;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -1133.4999999999998 then
                            begin
                                Result := 0.0017256858247106891;
                            end
                            else
                            begin
                                Result := -0.023415044946607882;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_first_stage_score <= 38375.500000000007 then
                        begin
                            Result := 0.0;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -59011123.499999993 then
                            begin
                                Result := -0.0059052187706274181;
                            end
                            else
                            begin
                                Result := 0.027412930685053863;
                            end;
                        end;
                    end;
                end
                else
                begin
                    Result := -0.019308335043613178;
                end;
            end
            else
            begin
                Result := 0.014048211818114059;
            end;
        end;
    end;
end;

function long_final_ranker_tree_90(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.03403403918654304;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.char_lm_score <= -3299.4999999999995 then
            begin
                if features.char_lm_suffix_score <= -5716.4999999999991 then
                begin
                    if features.dict_weight_per_unit <= 11881.500000000002 then
                    begin
                        if features.chain_first_stage_score <= 140224.50000000003 then
                        begin
                            if features.dict_weight_per_unit <= 9884.0000000000018 then
                            begin
                                if features.text_units <= 16.500000000000004 then
                                begin
                                    Result := -0.014169999517446956;
                                end
                                else
                                begin
                                    Result := 0.013786456609202087;
                                end;
                            end
                            else
                            begin
                                Result := 0.0047078335668106416;
                            end;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -999794.49999999988 then
                            begin
                                Result := -0.037161645456437402;
                            end
                            else
                            begin
                                if features.text_units <= 19.500000000000004 then
                                begin
                                    if features.chain_second_stage_score <= -30639080.499999996 then
                                    begin
                                        Result := 0.025257491425619505;
                                    end
                                    else
                                    begin
                                        if features.chain_first_stage_score <= 214000.50000000003 then
                                        begin
                                            if features.char_lm_suffix_score <= -6426.4999999999991 then
                                            begin
                                                Result := -0.012644876682192009;
                                            end
                                            else
                                            begin
                                                Result := 0.013376859721893284;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := -0.029152493878603455;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.034614386878261127;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.0073605854384963323;
                    end;
                end
                else
                begin
                    if features.chain_first_stage_score <= -32045.499999999996 then
                    begin
                        Result := 0.026214571822776891;
                    end
                    else
                    begin
                        if features.path_single_segments <= 2.5000000000000004 then
                        begin
                            if features.char_lm_score <= -3460.4999999999995 then
                            begin
                                Result := 0.0050782047152927072;
                            end
                            else
                            begin
                                Result := -0.01718650043550039;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -4709.4999999999991 then
                            begin
                                Result := 0.011579053514995254;
                            end
                            else
                            begin
                                if features.chain_score_gap <= -7808187.4999999991 then
                                begin
                                    Result := -0.030322156791317976;
                                end
                                else
                                begin
                                    Result := -0.0066655666108901383;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := 0.023373973179525054;
            end;
        end
        else
        begin
            if Ord(features.source_chain) <= 1.0000000180025095E-35 then
            begin
                if features.legacy_rank <= 2.5000000000000004 then
                begin
                    Result := 0.0012409135530386845;
                end
                else
                begin
                    Result := -0.0162478088992252;
                end;
            end
            else
            begin
                if features.chain_score_gap <= -59742350.999999993 then
                begin
                    Result := -0.0044604639177868634;
                end
                else
                begin
                    if features.char_lm_score <= -6915.4999999999991 then
                    begin
                        Result := -0.0078129724754222758;
                    end
                    else
                    begin
                        if features.text_units <= 10.500000000000002 then
                        begin
                            Result := 0.017397632041161081;
                        end
                        else
                        begin
                            if features.char_lm_suffix_score <= -4932.4999999999991 then
                            begin
                                if features.chain_second_stage_score <= 35246252.000000007 then
                                begin
                                    if features.score_per_unit <= 11678.500000000002 then
                                    begin
                                        if features.char_lm_context_score <= -7175.4999999999991 then
                                        begin
                                            Result := -0.0012344695551190583;
                                        end
                                        else
                                        begin
                                            Result := 0.01323035308486975;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.chain_first_stage_score <= 246591.00000000003 then
                                        begin
                                            if features.candidate_score <= 154940.50000000003 then
                                            begin
                                                Result := -0.0032268769219150504;
                                            end
                                            else
                                            begin
                                                Result := 0.033134646935470739;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := -0.01662568833030249;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.0062098512374582871;
                                end;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= 139036826.50000003 then
                                begin
                                    Result := 0.029510349094086619;
                                end
                                else
                                begin
                                    Result := -0.0096398741586286741;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_91(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.033967142071547482;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4665.4999999999991 then
        begin
            if features.legacy_rank <= 1.5000000000000002 then
            begin
                if features.char_lm_suffix_score <= -6134.4999999999991 then
                begin
                    if features.candidate_score <= 648.50000000000011 then
                    begin
                        Result := -0.0387835124749202;
                    end
                    else
                    begin
                        if features.path_segments <= 6.5000000000000009 then
                        begin
                            Result := -0.001605409668228513;
                        end
                        else
                        begin
                            if features.char_lm_suffix_score <= -6323.4999999999991 then
                            begin
                                Result := -0.0080983114335551176;
                            end
                            else
                            begin
                                if features.char_lm_context_score <= -6675.4999999999991 then
                                begin
                                    Result := -0.033600412584866512;
                                end
                                else
                                begin
                                    Result := 0.008777768802006175;
                                end;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.path_single_segments <= 2.5000000000000004 then
                    begin
                        if features.path_max_segment_units <= 2.5000000000000004 then
                        begin
                            if features.text_units <= 7.5000000000000009 then
                            begin
                                Result := -0.020203553014720207;
                            end
                            else
                            begin
                                if features.char_lm_score <= -4560.4999999999991 then
                                begin
                                    if features.char_lm_suffix_score <= -5866.4999999999991 then
                                    begin
                                        Result := 0.0081509740497828151;
                                    end
                                    else
                                    begin
                                        Result := -0.019532449138703546;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.011025820253815625;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= 12710763.500000002 then
                            begin
                                Result := 0.017398571735190875;
                            end
                            else
                            begin
                                Result := 0.00038308918779757017;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_second_stage_score <= -22453883.499999996 then
                        begin
                            Result := 0.013457650314883709;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -376.49999999999994 then
                            begin
                                if features.char_lm_context_gain <= -656.49999999999989 then
                                begin
                                    Result := -0.0038588903839458515;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= 31744429.500000004 then
                                    begin
                                        Result := -0.038542700051755294;
                                    end
                                    else
                                    begin
                                        Result := -0.012388721324801557;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := 0.0071571843412916959;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_suffix_score <= -6768.4999999999991 then
                begin
                    if features.char_lm_suffix_score <= -7165.4999999999991 then
                    begin
                        if features.path_single_segments <= 2.5000000000000004 then
                        begin
                            if features.char_lm_context_score <= -8592.4999999999982 then
                            begin
                                Result := -0.0017305075880558721;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= -34709942.999999993 then
                                begin
                                    Result := 0.03135573872974453;
                                end
                                else
                                begin
                                    Result := 0.0020308962111282311;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -86170659.999999985 then
                            begin
                                Result := 0.018418291210815983;
                            end
                            else
                            begin
                                Result := -0.01868056089065994;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := -0.0097507440367813059;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 79747.500000000015 then
                    begin
                        if features.dict_weight <= 75154.500000000015 then
                        begin
                            Result := 0.0081816752331171239;
                        end
                        else
                        begin
                            Result := 0.038207902825075891;
                        end;
                    end
                    else
                    begin
                        if features.legacy_rank <= 2.5000000000000004 then
                        begin
                            if features.chain_rank <= 2.5000000000000004 then
                            begin
                                if features.char_lm_context_gain <= -346.49999999999994 then
                                begin
                                    Result := 0.006780279641738338;
                                end
                                else
                                begin
                                    Result := -0.011481907772823272;
                                end;
                            end
                            else
                            begin
                                Result := 0.033672135876355071;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_score <= -4709.4999999999991 then
                            begin
                                Result := -0.018769291734200038;
                            end
                            else
                            begin
                                Result := 0.014626191893634143;
                            end;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            Result := 0.015517586124138248;
        end;
    end;
end;

function long_final_ranker_tree_92(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if features.comment_length <= 1.0000000180025095E-35 then
    begin
        if features.char_lm_suffix_score <= -4665.4999999999991 then
        begin
            if features.legacy_rank <= 1.5000000000000002 then
            begin
                if features.path_single_segments <= 2.5000000000000004 then
                begin
                    if features.char_lm_suffix_score <= -6134.4999999999991 then
                    begin
                        if features.char_lm_context_gain <= -1133.4999999999998 then
                        begin
                            Result := 0.008023791350282479;
                        end
                        else
                        begin
                            if features.chain_second_stage_score <= -47514492.499999993 then
                            begin
                                Result := 0.0077858356209586123;
                            end
                            else
                            begin
                                if features.candidate_score <= 76536.000000000015 then
                                begin
                                    Result := -0.036691375653737597;
                                end
                                else
                                begin
                                    if features.path_segments <= 7.5000000000000009 then
                                    begin
                                        if features.chain_second_stage_score <= -20468598.999999996 then
                                        begin
                                            Result := 0.015133883661613824;
                                        end
                                        else
                                        begin
                                            Result := -0.0093497333718038228;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := -0.02120068932109772;
                                    end;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.0037773844950822876;
                    end;
                end
                else
                begin
                    if features.candidate_score <= 250008.50000000003 then
                    begin
                        if features.chain_second_stage_score <= -10184703.999999998 then
                        begin
                            if features.char_lm_context_score <= -7915.4999999999991 then
                            begin
                                Result := -0.018385980668240178;
                            end
                            else
                            begin
                                if features.path_segments <= 11.500000000000002 then
                                begin
                                    Result := 0.0086830195093330342;
                                end
                                else
                                begin
                                    Result := -0.023898285950375013;
                                end;
                            end;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -4544670.4999999991 then
                            begin
                                Result := -0.028464887948434995;
                            end
                            else
                            begin
                                Result := -0.0099049427789140339;
                            end;
                        end;
                    end
                    else
                    begin
                        Result := 0.014495164724601899;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_score <= -4263.4999999999991 then
                begin
                    if features.path_max_segment_units <= 4.5000000000000009 then
                    begin
                        if features.score_per_unit <= 5427.0000000000009 then
                        begin
                            Result := 0.016936070929426172;
                        end
                        else
                        begin
                            if features.char_lm_score <= -6915.4999999999991 then
                            begin
                                if features.chain_score_gap <= -39298151.499999993 then
                                begin
                                    Result := 0.01113949483542406;
                                end
                                else
                                begin
                                    Result := -0.014167671020273612;
                                end;
                            end
                            else
                            begin
                                if features.chain_second_stage_score <= 57463472.000000007 then
                                begin
                                    if features.score_per_unit <= 10476.500000000002 then
                                    begin
                                        if features.score_per_unit <= 9580.5000000000018 then
                                        begin
                                            Result := 0.0067829889822760255;
                                        end
                                        else
                                        begin
                                            Result := -0.010734204504203818;
                                        end;
                                    end
                                    else
                                    begin
                                        if features.chain_score_gap <= -40225207.999999993 then
                                        begin
                                            Result := -0.0026580331984110668;
                                        end
                                        else
                                        begin
                                            if features.chain_first_stage_score <= 118098.50000000001 then
                                            begin
                                                if features.char_lm_score <= -5551.4999999999991 then
                                                begin
                                                    Result := -0.011887551522252897;
                                                end
                                                else
                                                begin
                                                    Result := 0.012330074161054588;
                                                end;
                                            end
                                            else
                                            begin
                                                Result := 0.015664415196688923;
                                            end;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.0081855086898852212;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -9574.4999999999982 then
                        begin
                            Result := 0.018112998185134555;
                        end
                        else
                        begin
                            if features.legacy_rank <= 2.5000000000000004 then
                            begin
                                Result := -0.0024792010220513624;
                            end
                            else
                            begin
                                Result := -0.023323052777341015;
                            end;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -999794.49999999988 then
                    begin
                        Result := 0.026585863948515299;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -5301.4999999999991 then
                        begin
                            Result := 0.023996561316074597;
                        end
                        else
                        begin
                            Result := -0.0052149115356131355;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            Result := 0.016577621275361026;
        end;
    end
    else
    begin
        Result := -0.033882914802898706;
    end;
end;

function long_final_ranker_tree_93(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.033812366823530719;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.char_lm_score <= -3299.4999999999995 then
            begin
                if features.char_lm_suffix_score <= -6134.4999999999991 then
                begin
                    if features.candidate_score <= 76536.000000000015 then
                    begin
                        Result := -0.021967629955398211;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -8120.4999999999991 then
                        begin
                            Result := 0.0054804594605044367;
                        end
                        else
                        begin
                            Result := -0.0094554939581608117;
                        end;
                    end;
                end
                else
                begin
                    if features.path_single_segments <= 2.5000000000000004 then
                    begin
                        if features.path_max_segment_units <= 3.5000000000000004 then
                        begin
                            if features.char_lm_suffix_score <= -5949.4999999999991 then
                            begin
                                Result := 0.017769293147194918;
                            end
                            else
                            begin
                                if features.char_lm_context_score <= -6472.4999999999991 then
                                begin
                                    if features.chain_score_gap <= -48874815.499999993 then
                                    begin
                                        Result := -0.032371656022157316;
                                    end
                                    else
                                    begin
                                        if features.chain_score_gap <= -20341703.499999996 then
                                        begin
                                            Result := 0.028584499945559724;
                                        end
                                        else
                                        begin
                                            Result := -0.0096890617884876559;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    if features.dict_weight_per_unit <= 11299.500000000002 then
                                    begin
                                        Result := 0.0077186397432596997;
                                    end
                                    else
                                    begin
                                        Result := -0.01149259166863768;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := 0.012939354218846962;
                        end;
                    end
                    else
                    begin
                        Result := -0.0067263127631191355;
                    end;
                end;
            end
            else
            begin
                Result := 0.023037651810076255;
            end;
        end
        else
        begin
            if features.char_lm_suffix_score <= -6231.4999999999991 then
            begin
                if features.chain_second_stage_score <= -60934688.499999993 then
                begin
                    if features.chain_first_stage_score <= 55406.000000000007 then
                    begin
                        Result := 0.029523269079869265;
                    end
                    else
                    begin
                        if features.candidate_score <= 123730.00000000001 then
                        begin
                            Result := -0.014654671961366213;
                        end
                        else
                        begin
                            Result := 0.014486153258453221;
                        end;
                    end;
                end
                else
                begin
                    if features.chain_first_stage_score <= 137050.50000000003 then
                    begin
                        Result := -0.0053062720864785777;
                    end
                    else
                    begin
                        if features.chain_first_stage_score <= 178232.50000000003 then
                        begin
                            Result := 0.015734842949897725;
                        end
                        else
                        begin
                            if features.char_lm_score <= -6315.4999999999991 then
                            begin
                                Result := -0.024402213098572417;
                            end
                            else
                            begin
                                Result := 0.005708406181792392;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                if features.char_lm_score <= -5607.4999999999991 then
                begin
                    Result := 0.032821111449741681;
                end
                else
                begin
                    if features.char_lm_suffix_score <= -4870.4999999999991 then
                    begin
                        if features.score_per_unit <= 12903.500000000002 then
                        begin
                            if features.dict_weight <= 122800.50000000001 then
                            begin
                                if features.chain_first_stage_score <= 27672.000000000004 then
                                begin
                                    Result := -0.0061669656913868557;
                                end
                                else
                                begin
                                    if features.chain_second_stage_score <= 65201574.000000007 then
                                    begin
                                        Result := 0.023806911021027249;
                                    end
                                    else
                                    begin
                                        if features.char_lm_context_gain <= -968.49999999999989 then
                                        begin
                                            if features.char_lm_suffix_score <= -5475.4999999999991 then
                                            begin
                                                Result := -0.01670135441743734;
                                            end
                                            else
                                            begin
                                                Result := 0.029681265149342148;
                                            end;
                                        end
                                        else
                                        begin
                                            if features.char_lm_context_gain <= -563.49999999999989 then
                                            begin
                                                Result := -0.029141868111044904;
                                            end
                                            else
                                            begin
                                                Result := 0.013581115763323662;
                                            end;
                                        end;
                                    end;
                                end;
                            end
                            else
                            begin
                                Result := -0.0036301279937496628;
                            end;
                        end
                        else
                        begin
                            Result := 0.020398295892144792;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_score <= -3655.4999999999995 then
                        begin
                            Result := 0.031679276137472429;
                        end
                        else
                        begin
                            Result := 0.0005963388144882998;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_94(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.033757076450549775;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.char_lm_score <= -3299.4999999999995 then
            begin
                if features.chain_first_stage_score <= -66677.999999999985 then
                begin
                    Result := 0.021641020170061601;
                end
                else
                begin
                    if features.char_lm_score <= -5869.4999999999991 then
                    begin
                        if features.chain_first_stage_score <= 77616.500000000015 then
                        begin
                            if features.char_lm_context_gain <= -1082.4999999999998 then
                            begin
                                Result := -0.0014339014199640872;
                            end
                            else
                            begin
                                Result := -0.038881564841460603;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_context_gain <= -524.49999999999989 then
                            begin
                                if features.chain_second_stage_score <= -34709942.999999993 then
                                begin
                                    Result := 0.009540751720786696;
                                end
                                else
                                begin
                                    if features.dict_weight_per_unit <= 10267.500000000002 then
                                    begin
                                        Result := -0.027300841624828355;
                                    end
                                    else
                                    begin
                                        Result := 0.0055840651329042363;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.dict_weight <= 143554.50000000003 then
                                begin
                                    Result := 0.0083748328279771734;
                                end
                                else
                                begin
                                    if features.chain_first_stage_score <= 180036.00000000003 then
                                    begin
                                        Result := -0.04764516767190257;
                                    end
                                    else
                                    begin
                                        Result := -0.010194491359536728;
                                    end;
                                end;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.chain_score_gap <= -14613411.499999998 then
                        begin
                            if features.chain_score_gap <= -34246216.999999993 then
                            begin
                                if features.char_lm_context_score <= -5878.4999999999991 then
                                begin
                                    if features.chain_first_stage_score <= 43010.000000000007 then
                                    begin
                                        Result := -0.021429060702410237;
                                    end
                                    else
                                    begin
                                        if features.dict_weight <= 92601.000000000015 then
                                        begin
                                            Result := 0.034173631696886961;
                                        end
                                        else
                                        begin
                                            Result := -0.0015768883656685664;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    Result := -0.028911985259678422;
                                end;
                            end
                            else
                            begin
                                Result := 0.019790734129917758;
                            end;
                        end
                        else
                        begin
                            if features.chain_score_gap <= -6389736.9999999991 then
                            begin
                                Result := -0.023592705700911373;
                            end
                            else
                            begin
                                if features.dict_weight_per_unit <= 13679.000000000002 then
                                begin
                                    if features.chain_score_gap <= -5320636.9999999991 then
                                    begin
                                        Result := 0.029189212022821591;
                                    end
                                    else
                                    begin
                                        Result := -0.0044389576208260602;
                                    end;
                                end
                                else
                                begin
                                    Result := 0.013589467952024818;
                                end;
                            end;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := 0.020122979707239814;
            end;
        end
        else
        begin
            if features.char_lm_score <= -4963.4999999999991 then
            begin
                if features.chain_second_stage_score <= -60934688.499999993 then
                begin
                    if features.char_lm_score <= -6518.4999999999991 then
                    begin
                        if features.score_per_unit <= 10722.500000000002 then
                        begin
                            Result := -0.021747290287160572;
                        end
                        else
                        begin
                            Result := 0.018773116703696677;
                        end;
                    end
                    else
                    begin
                        Result := 0.022604063651851622;
                    end;
                end
                else
                begin
                    if features.chain_score_gap <= -59742350.999999993 then
                    begin
                        Result := -0.016833798364123603;
                    end
                    else
                    begin
                        Result := 0.00084516023278933649;
                    end;
                end;
            end
            else
            begin
                if features.chain_first_stage_score <= 43010.000000000007 then
                begin
                    Result := 0.0024282211197505718;
                end
                else
                begin
                    if features.score_per_unit <= 13037.500000000002 then
                    begin
                        if features.chain_first_stage_score <= 92148.000000000015 then
                        begin
                            Result := 0.026922502121760495;
                        end
                        else
                        begin
                            if features.chain_first_stage_score <= 108512.00000000001 then
                            begin
                                Result := -0.0097402203777811978;
                            end
                            else
                            begin
                                Result := 0.010638414385934115;
                            end;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_context_score <= -6417.4999999999991 then
                        begin
                            Result := -0.0031975945644851789;
                        end
                        else
                        begin
                            Result := 0.046154048685745616;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

function long_final_ranker_tree_95(
    const features: TncLongFinalRankerFeatures): Double;
begin
    if Ord(features.complete_match) <= 1.0000000180025095E-35 then
    begin
        Result := -0.033668258422056487;
    end
    else
    begin
        if features.legacy_rank <= 1.5000000000000002 then
        begin
            if features.char_lm_score <= -3299.4999999999995 then
            begin
                if features.chain_first_stage_score <= -66677.999999999985 then
                begin
                    Result := 0.022590050227789125;
                end
                else
                begin
                    if features.path_single_segments <= 2.5000000000000004 then
                    begin
                        if features.chain_first_stage_score <= 262591.00000000006 then
                        begin
                            if features.dict_weight <= 335.50000000000006 then
                            begin
                                if features.char_lm_context_score <= -7122.4999999999991 then
                                begin
                                    Result := -0.023616551740892371;
                                end
                                else
                                begin
                                    Result := -0.00096425893622490528;
                                end;
                            end
                            else
                            begin
                                if features.candidate_score <= 50064.000000000007 then
                                begin
                                    Result := 0.020308536244051326;
                                end
                                else
                                begin
                                    if features.path_max_segment_units <= 3.5000000000000004 then
                                    begin
                                        if features.char_lm_context_gain <= -1160.4999999999998 then
                                        begin
                                            Result := 0.0096133697592707349;
                                        end
                                        else
                                        begin
                                            if features.candidate_score <= 76536.000000000015 then
                                            begin
                                                Result := -0.024063908422726901;
                                            end
                                            else
                                            begin
                                                if features.score_per_unit <= 12356.500000000002 then
                                                begin
                                                    Result := -0.0011701681817814598;
                                                end
                                                else
                                                begin
                                                    Result := -0.01919185115136731;
                                                end;
                                            end;
                                        end;
                                    end
                                    else
                                    begin
                                        Result := 0.010041635753672128;
                                    end;
                                end;
                            end;
                        end
                        else
                        begin
                            Result := -0.02797221370358411;
                        end;
                    end
                    else
                    begin
                        if features.dict_weight <= 235904.00000000003 then
                        begin
                            Result := -0.012141692752501602;
                        end
                        else
                        begin
                            Result := 0.0077305083575300833;
                        end;
                    end;
                end;
            end
            else
            begin
                Result := 0.021569245077041846;
            end;
        end
        else
        begin
            if features.char_lm_suffix_score <= -6231.4999999999991 then
            begin
                if features.path_max_segment_units <= 9.5000000000000018 then
                begin
                    Result := 0.0016088731790652306;
                end
                else
                begin
                    Result := -0.015649232026302629;
                end;
            end
            else
            begin
                if features.text_units <= 7.5000000000000009 then
                begin
                    Result := 0.026384994020734204;
                end
                else
                begin
                    if features.char_lm_context_score <= -6925.4999999999991 then
                    begin
                        if features.char_lm_score <= -5327.4999999999991 then
                        begin
                            Result := 0.013573076812008698;
                        end
                        else
                        begin
                            Result := -0.013740317337418368;
                        end;
                    end
                    else
                    begin
                        if features.char_lm_suffix_score <= -6134.4999999999991 then
                        begin
                            if features.dict_weight <= 120968.00000000001 then
                            begin
                                Result := -0.0064626543562366799;
                            end
                            else
                            begin
                                Result := 0.036145294887225683;
                            end;
                        end
                        else
                        begin
                            if features.char_lm_suffix_score <= -4870.4999999999991 then
                            begin
                                if features.dict_weight <= 131664.50000000003 then
                                begin
                                    if features.chain_first_stage_score <= 55406.000000000007 then
                                    begin
                                        Result := -0.0061910463585732566;
                                    end
                                    else
                                    begin
                                        if features.char_lm_suffix_score <= -5301.4999999999991 then
                                        begin
                                            if features.dict_weight <= 112066.50000000001 then
                                            begin
                                                if features.path_single_segments <= 3.5000000000000004 then
                                                begin
                                                    Result := 0.036599229898042984;
                                                end
                                                else
                                                begin
                                                    Result := -0.0041562424701259548;
                                                end;
                                            end
                                            else
                                            begin
                                                if features.chain_first_stage_score <= 123118.50000000001 then
                                                begin
                                                    Result := -0.0021868844521902584;
                                                end
                                                else
                                                begin
                                                    Result := 0.028366479969697909;
                                                end;
                                            end;
                                        end
                                        else
                                        begin
                                            Result := 0.00052912613055879033;
                                        end;
                                    end;
                                end
                                else
                                begin
                                    if features.dict_weight_per_unit <= 10869.000000000002 then
                                    begin
                                        Result := -0.01341462628780289;
                                    end
                                    else
                                    begin
                                        Result := 0.0048825440253688389;
                                    end;
                                end;
                            end
                            else
                            begin
                                if features.char_lm_score <= -3522.4999999999995 then
                                begin
                                    Result := 0.026235868010956252;
                                end
                                else
                                begin
                                    Result := -0.000403080803297333;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
function long_final_ranker_score(
    const features: TncLongFinalRankerFeatures): Int64;
var
    score: Double;
begin
    score := 0.0;
    score := score + long_final_ranker_tree_0(features);
    score := score + long_final_ranker_tree_1(features);
    score := score + long_final_ranker_tree_2(features);
    score := score + long_final_ranker_tree_3(features);
    score := score + long_final_ranker_tree_4(features);
    score := score + long_final_ranker_tree_5(features);
    score := score + long_final_ranker_tree_6(features);
    score := score + long_final_ranker_tree_7(features);
    score := score + long_final_ranker_tree_8(features);
    score := score + long_final_ranker_tree_9(features);
    score := score + long_final_ranker_tree_10(features);
    score := score + long_final_ranker_tree_11(features);
    score := score + long_final_ranker_tree_12(features);
    score := score + long_final_ranker_tree_13(features);
    score := score + long_final_ranker_tree_14(features);
    score := score + long_final_ranker_tree_15(features);
    score := score + long_final_ranker_tree_16(features);
    score := score + long_final_ranker_tree_17(features);
    score := score + long_final_ranker_tree_18(features);
    score := score + long_final_ranker_tree_19(features);
    score := score + long_final_ranker_tree_20(features);
    score := score + long_final_ranker_tree_21(features);
    score := score + long_final_ranker_tree_22(features);
    score := score + long_final_ranker_tree_23(features);
    score := score + long_final_ranker_tree_24(features);
    score := score + long_final_ranker_tree_25(features);
    score := score + long_final_ranker_tree_26(features);
    score := score + long_final_ranker_tree_27(features);
    score := score + long_final_ranker_tree_28(features);
    score := score + long_final_ranker_tree_29(features);
    score := score + long_final_ranker_tree_30(features);
    score := score + long_final_ranker_tree_31(features);
    score := score + long_final_ranker_tree_32(features);
    score := score + long_final_ranker_tree_33(features);
    score := score + long_final_ranker_tree_34(features);
    score := score + long_final_ranker_tree_35(features);
    score := score + long_final_ranker_tree_36(features);
    score := score + long_final_ranker_tree_37(features);
    score := score + long_final_ranker_tree_38(features);
    score := score + long_final_ranker_tree_39(features);
    score := score + long_final_ranker_tree_40(features);
    score := score + long_final_ranker_tree_41(features);
    score := score + long_final_ranker_tree_42(features);
    score := score + long_final_ranker_tree_43(features);
    score := score + long_final_ranker_tree_44(features);
    score := score + long_final_ranker_tree_45(features);
    score := score + long_final_ranker_tree_46(features);
    score := score + long_final_ranker_tree_47(features);
    score := score + long_final_ranker_tree_48(features);
    score := score + long_final_ranker_tree_49(features);
    score := score + long_final_ranker_tree_50(features);
    score := score + long_final_ranker_tree_51(features);
    score := score + long_final_ranker_tree_52(features);
    score := score + long_final_ranker_tree_53(features);
    score := score + long_final_ranker_tree_54(features);
    score := score + long_final_ranker_tree_55(features);
    score := score + long_final_ranker_tree_56(features);
    score := score + long_final_ranker_tree_57(features);
    score := score + long_final_ranker_tree_58(features);
    score := score + long_final_ranker_tree_59(features);
    score := score + long_final_ranker_tree_60(features);
    score := score + long_final_ranker_tree_61(features);
    score := score + long_final_ranker_tree_62(features);
    score := score + long_final_ranker_tree_63(features);
    score := score + long_final_ranker_tree_64(features);
    score := score + long_final_ranker_tree_65(features);
    score := score + long_final_ranker_tree_66(features);
    score := score + long_final_ranker_tree_67(features);
    score := score + long_final_ranker_tree_68(features);
    score := score + long_final_ranker_tree_69(features);
    score := score + long_final_ranker_tree_70(features);
    score := score + long_final_ranker_tree_71(features);
    score := score + long_final_ranker_tree_72(features);
    score := score + long_final_ranker_tree_73(features);
    score := score + long_final_ranker_tree_74(features);
    score := score + long_final_ranker_tree_75(features);
    score := score + long_final_ranker_tree_76(features);
    score := score + long_final_ranker_tree_77(features);
    score := score + long_final_ranker_tree_78(features);
    score := score + long_final_ranker_tree_79(features);
    score := score + long_final_ranker_tree_80(features);
    score := score + long_final_ranker_tree_81(features);
    score := score + long_final_ranker_tree_82(features);
    score := score + long_final_ranker_tree_83(features);
    score := score + long_final_ranker_tree_84(features);
    score := score + long_final_ranker_tree_85(features);
    score := score + long_final_ranker_tree_86(features);
    score := score + long_final_ranker_tree_87(features);
    score := score + long_final_ranker_tree_88(features);
    score := score + long_final_ranker_tree_89(features);
    score := score + long_final_ranker_tree_90(features);
    score := score + long_final_ranker_tree_91(features);
    score := score + long_final_ranker_tree_92(features);
    score := score + long_final_ranker_tree_93(features);
    score := score + long_final_ranker_tree_94(features);
    score := score + long_final_ranker_tree_95(features);
    Result := Trunc(score * c_long_final_ranker_score_scale);
end;

function long_final_ranker_self_test: Boolean;
var
    features: TncLongFinalRankerFeatures;
begin
    FillChar(features, SizeOf(features), 0);
    if long_final_ranker_score(features) <>
        c_long_final_ranker_reference_score then
    begin
        Exit(False);
    end;

    features.candidate_score := -1000000;
    features.dict_weight := -1000000;
    features.has_dict_weight := False;
    features.source_user := False;
    features.source_chain := False;
    features.source_pattern := False;
    features.source_redup := False;
    features.source_local_rerank := False;
    features.source_rule_fallback := False;
    features.legacy_rank := -1000000;
    features.legacy_top := False;
    features.chain_rank := -1000000;
    features.chain_present := False;
    features.chain_first_stage_score := -1000000;
    features.chain_second_stage_score := -1000000;
    features.chain_score_gap := -1000000;
    features.complete_match := False;
    features.partial_match := False;
    features.text_units := -1000000;
    features.comment_length := -1000000;
    features.unit_delta := -1000000;
    features.path_available := False;
    features.path_confidence_score := -1000000;
    features.path_confidence_tier := -1000000;
    features.path_segments := -1000000;
    features.path_single_segments := -1000000;
    features.path_max_segment_units := -1000000;
    features.char_lm_score := -1000000;
    features.char_lm_suffix_score := -1000000;
    features.char_lm_context_score := -1000000;
    features.char_lm_context_gain := -1000000;
    features.has_left_context := False;
    features.query_choice_bonus := -1000000;
    features.latest_query_choice := False;
    features.query_path_bonus := -1000000;
    features.query_path_penalty := -1000000;
    features.input_syllable_count := -1000000;
    features.score_per_unit := -1000000;
    features.dict_weight_per_unit := -1000000;
    features.complete_user := False;
    features.complete_dictionary := False;
    features.complete_chain := False;
    if long_final_ranker_score(features) <>
        c_long_final_ranker_reference_score_low then
    begin
        Exit(False);
    end;

    features.candidate_score := 1000000;
    features.dict_weight := 1000000;
    features.has_dict_weight := True;
    features.source_user := True;
    features.source_chain := True;
    features.source_pattern := True;
    features.source_redup := True;
    features.source_local_rerank := True;
    features.source_rule_fallback := True;
    features.legacy_rank := 1000000;
    features.legacy_top := True;
    features.chain_rank := 1000000;
    features.chain_present := True;
    features.chain_first_stage_score := 1000000;
    features.chain_second_stage_score := 1000000;
    features.chain_score_gap := 1000000;
    features.complete_match := True;
    features.partial_match := True;
    features.text_units := 1000000;
    features.comment_length := 1000000;
    features.unit_delta := 1000000;
    features.path_available := True;
    features.path_confidence_score := 1000000;
    features.path_confidence_tier := 1000000;
    features.path_segments := 1000000;
    features.path_single_segments := 1000000;
    features.path_max_segment_units := 1000000;
    features.char_lm_score := 1000000;
    features.char_lm_suffix_score := 1000000;
    features.char_lm_context_score := 1000000;
    features.char_lm_context_gain := 1000000;
    features.has_left_context := True;
    features.query_choice_bonus := 1000000;
    features.latest_query_choice := True;
    features.query_path_bonus := 1000000;
    features.query_path_penalty := 1000000;
    features.input_syllable_count := 1000000;
    features.score_per_unit := 1000000;
    features.dict_weight_per_unit := 1000000;
    features.complete_user := True;
    features.complete_dictionary := True;
    features.complete_chain := True;
    if long_final_ranker_score(features) <>
        c_long_final_ranker_reference_score_high then
    begin
        Exit(False);
    end;

    features.candidate_score := 137;
    features.dict_weight := -274;
    features.has_dict_weight := False;
    features.source_user := True;
    features.source_chain := False;
    features.source_pattern := True;
    features.source_redup := False;
    features.source_local_rerank := True;
    features.source_rule_fallback := False;
    features.legacy_rank := -1370;
    features.legacy_top := False;
    features.chain_rank := -1644;
    features.chain_present := False;
    features.chain_first_stage_score := -1918;
    features.chain_second_stage_score := 2055;
    features.chain_score_gap := -2192;
    features.complete_match := False;
    features.partial_match := True;
    features.text_units := 2603;
    features.comment_length := -2740;
    features.unit_delta := 2877;
    features.path_available := True;
    features.path_confidence_score := 3151;
    features.path_confidence_tier := -3288;
    features.path_segments := 3425;
    features.path_single_segments := -3562;
    features.path_max_segment_units := 3699;
    features.char_lm_score := -3836;
    features.char_lm_suffix_score := 3973;
    features.char_lm_context_score := -4110;
    features.char_lm_context_gain := 4247;
    features.has_left_context := True;
    features.query_choice_bonus := 4521;
    features.latest_query_choice := True;
    features.query_path_bonus := 4795;
    features.query_path_penalty := -4932;
    features.input_syllable_count := 5069;
    features.score_per_unit := -5206;
    features.dict_weight_per_unit := 5343;
    features.complete_user := True;
    features.complete_dictionary := False;
    features.complete_chain := True;
    Result := long_final_ranker_score(features) =
        c_long_final_ranker_reference_score_mixed;
end;

end.
