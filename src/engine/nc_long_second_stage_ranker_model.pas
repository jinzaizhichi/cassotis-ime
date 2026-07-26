unit nc_long_second_stage_ranker_model;

interface

type
    TncLongSecondStageFeatures = record
        first_stage_score: Integer;
        base_score: Integer;
        char_lm_score: Integer;
        char_lm_suffix_score: Integer;
        char_lm_context_score: Integer;
        char_lm_context_gain: Integer;
        char_lm_per_unit: Integer;
        word_lm_bonus: Integer;
        word_lm_per_boundary: Integer;
        lexical_weight_sum: Integer;
        lexical_weight_min: Integer;
        lexical_weight_max: Integer;
        lexical_weight_mean: Integer;
        lexical_weight_per_unit: Integer;
        lexical_known_ratio: Integer;
        lexical_top_ratio: Integer;
        lexical_rank_sum: Integer;
        lexical_rank_max: Integer;
        lexical_margin_sum: Integer;
        lexical_margin_min: Integer;
        first_segment_weight: Integer;
        last_segment_weight: Integer;
        segments: Integer;
        single_segments: Integer;
        multi_segments: Integer;
        max_segment_units: Integer;
        min_segment_units: Integer;
        segment_units_square_sum: Integer;
        first_segment_units: Integer;
        last_segment_units: Integer;
        anchor_units: Integer;
        has_anchor: Boolean;
        baseline_lineage: Boolean;
        original_rank: Integer;
        input_syllable_count: Integer;
        has_left_context: Boolean;
        query_path_bonus: Integer;
        query_path_penalty: Integer;
        score_per_segment: Integer;
    end;

const
    c_long_second_stage_ranker_feature_count: Integer = 39;
    c_long_second_stage_ranker_tree_count: Integer = 56;
    c_long_second_stage_ranker_score_scale: Double = 100000000.0;
    c_long_second_stage_ranker_reference_score: Int64 = 157505380;
    c_long_second_stage_ranker_reference_score_low: Int64 = -117822779;
    c_long_second_stage_ranker_reference_score_high: Int64 = 122668723;
    c_long_second_stage_ranker_reference_score_mixed: Int64 = 144867595;

function long_second_stage_ranker_score(
    const features: TncLongSecondStageFeatures): Int64;
function long_second_stage_ranker_self_test: Boolean;

implementation

{ LightGBM LambdaRank model trained on document-separated long-sentence
  candidate groups. The generated unit has no LightGBM runtime dependency.
  Training report SHA-256: 1C7217C69B3A3B461F92E810506AB9D79FA7D2DB8E09098CB6B7A551964F6287
  LightGBM model SHA-256: EA3DD294FABBA0238AB9E236FA20D9891C0B71C130FDD0DEB8648F2F248514BA }

function long_ranker_tree_0(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.original_rank <= 2.5000000000000004 then
    begin
        if features.char_lm_context_score <= -6403.4999999999991 then
        begin
            if features.lexical_rank_max <= 1.5000000000000002 then
            begin
                Result := 0.033084064541901631;
            end
            else
            begin
                Result := 0.0095756093972638248;
            end;
        end
        else
        begin
            Result := 0.053335234371503164;
        end;
    end
    else
    begin
        if features.original_rank <= 4.5000000000000009 then
        begin
            if features.char_lm_context_score <= -6085.4999999999991 then
            begin
                Result := -0.030366153769995186;
            end
            else
            begin
                Result := 0.019424766648555768;
            end;
        end
        else
        begin
            if features.char_lm_context_score <= -4893.4999999999991 then
            begin
                Result := -0.055717957753840364;
            end
            else
            begin
                Result := 0.014750535495233589;
            end;
        end;
    end;
end;

function long_ranker_tree_1(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.original_rank <= 3.5000000000000004 then
    begin
        if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
        begin
            Result := -0.044585864011765022;
        end
        else
        begin
            if features.original_rank <= 1.5000000000000002 then
            begin
                if features.char_lm_suffix_score <= -6953.4999999999991 then
                begin
                    Result := -0.01104853177685924;
                end
                else
                begin
                    Result := 0.038539963102365793;
                end;
            end
            else
            begin
                if features.char_lm_suffix_score <= -4971.4999999999991 then
                begin
                    Result := 0.00012272211637304661;
                end
                else
                begin
                    Result := 0.034470907898971059;
                end;
            end;
        end;
    end
    else
    begin
        if features.char_lm_score <= -4582.4999999999991 then
        begin
            Result := -0.045711680871639536;
        end
        else
        begin
            Result := 0.0059660597418492644;
        end;
    end;
end;

function long_ranker_tree_2(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.original_rank <= 3.5000000000000004 then
    begin
        if features.char_lm_score <= -4629.4999999999991 then
        begin
            if features.lexical_top_ratio <= 839.50000000000011 then
            begin
                Result := -0.025668383400355786;
            end
            else
            begin
                if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
                begin
                    Result := -0.039024123597998721;
                end
                else
                begin
                    Result := 0.01256951204563864;
                end;
            end;
        end
        else
        begin
            Result := 0.03429325261988448;
        end;
    end
    else
    begin
        if features.char_lm_score <= -4582.4999999999991 then
        begin
            if features.original_rank <= 5.5000000000000009 then
            begin
                Result := -0.027172661760014136;
            end
            else
            begin
                Result := -0.054306738481193481;
            end;
        end
        else
        begin
            Result := -0.00092609287285831037;
        end;
    end;
end;

function long_ranker_tree_3(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4604.4999999999991 then
    begin
        if features.score_per_segment <= 12620.500000000002 then
        begin
            Result := -0.037803930913244008;
        end
        else
        begin
            if features.lexical_top_ratio <= 839.50000000000011 then
            begin
                Result := -0.026587694880538859;
            end
            else
            begin
                Result := 0.0094589358528310158;
            end;
        end;
    end
    else
    begin
        if features.lexical_margin_sum <= -24.499999999999996 then
        begin
            if features.lexical_weight_mean <= 779.50000000000011 then
            begin
                Result := 0.016085520529514296;
            end
            else
            begin
                Result := -0.010738596297839374;
            end;
        end
        else
        begin
            if features.lexical_rank_sum <= 5.5000000000000009 then
            begin
                Result := 0.050086613654692871;
            end
            else
            begin
                Result := 0.02657023029031096;
            end;
        end;
    end;
end;

function long_ranker_tree_4(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4231.9999999999991 then
    begin
        if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
        begin
            Result := -0.052079463871906193;
        end
        else
        begin
            if features.score_per_segment <= 12620.500000000002 then
            begin
                if features.char_lm_score <= -4773.4999999999991 then
                begin
                    Result := -0.029795386839409702;
                end
                else
                begin
                    Result := 0.000816291146523095;
                end;
            end
            else
            begin
                if features.lexical_margin_min <= -328.49999999999994 then
                begin
                    Result := -0.020034213474661538;
                end
                else
                begin
                    Result := 0.013517494765866347;
                end;
            end;
        end;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4505.4999999999991 then
        begin
            Result := 0.021550345515266758;
        end
        else
        begin
            Result := 0.046347212775443146;
        end;
    end;
end;

function long_ranker_tree_5(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.original_rank <= 2.5000000000000004 then
    begin
        if features.char_lm_score <= -4604.4999999999991 then
        begin
            if features.char_lm_suffix_score <= -6722.4999999999991 then
            begin
                Result := -0.0090844618285388853;
            end
            else
            begin
                Result := 0.013746859747076387;
            end;
        end
        else
        begin
            Result := 0.033390746563074149;
        end;
    end
    else
    begin
        if features.char_lm_score <= -4231.9999999999991 then
        begin
            if features.original_rank <= 5.5000000000000009 then
            begin
                if features.segment_units_square_sum <= 18.500000000000004 then
                begin
                    Result := -0.041467908727018728;
                end
                else
                begin
                    Result := -0.01547760864001433;
                end;
            end
            else
            begin
                Result := -0.049796070698775861;
            end;
        end
        else
        begin
            Result := 0.015588613165711406;
        end;
    end;
end;

function long_ranker_tree_6(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.original_rank <= 3.5000000000000004 then
    begin
        if features.char_lm_score <= -4773.4999999999991 then
        begin
            if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
            begin
                Result := -0.038304030843590124;
            end
            else
            begin
                Result := 0.0012353942751132357;
            end;
        end
        else
        begin
            if features.char_lm_score <= -3314.9999999999995 then
            begin
                Result := 0.022779011497681315;
            end
            else
            begin
                Result := 0.050778904561743311;
            end;
        end;
    end
    else
    begin
        if features.char_lm_suffix_score <= -5431.4999999999991 then
        begin
            Result := -0.039423073817951099;
        end
        else
        begin
            if features.original_rank <= 6.5000000000000009 then
            begin
                Result := 0.011427571829408711;
            end
            else
            begin
                Result := -0.031885792756138183;
            end;
        end;
    end;
end;

function long_ranker_tree_7(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.original_rank <= 2.5000000000000004 then
    begin
        if features.char_lm_score <= -4806.4999999999991 then
        begin
            if features.score_per_segment <= 17661.000000000004 then
            begin
                Result := -0.0083052292118177169;
            end
            else
            begin
                Result := 0.012271279549408804;
            end;
        end
        else
        begin
            Result := 0.028651065432975735;
        end;
    end
    else
    begin
        if features.char_lm_score <= -4604.4999999999991 then
        begin
            if features.original_rank <= 5.5000000000000009 then
            begin
                Result := -0.02367966831988589;
            end
            else
            begin
                Result := -0.047253148861810979;
            end;
        end
        else
        begin
            if features.char_lm_score <= -3518.9999999999995 then
            begin
                Result := -0.0028576324289278734;
            end
            else
            begin
                Result := 0.03506541329364686;
            end;
        end;
    end;
end;

function long_ranker_tree_8(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.original_rank <= 3.5000000000000004 then
    begin
        if features.char_lm_score <= -4231.9999999999991 then
        begin
            if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
            begin
                Result := -0.036802611445886362;
            end
            else
            begin
                if features.lexical_margin_sum <= -333.99999999999994 then
                begin
                    Result := -0.019885052366529578;
                end
                else
                begin
                    Result := 0.010013595971265121;
                end;
            end;
        end
        else
        begin
            Result := 0.033440913231175595;
        end;
    end
    else
    begin
        if features.char_lm_score <= -4341.4999999999991 then
        begin
            if features.original_rank <= 5.5000000000000009 then
            begin
                Result := -0.025100129455172922;
            end
            else
            begin
                Result := -0.047630765704229604;
            end;
        end
        else
        begin
            Result := 0.0088005801103473429;
        end;
    end;
end;

function long_ranker_tree_9(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.original_rank <= 2.5000000000000004 then
    begin
        if features.char_lm_context_score <= -6446.4999999999991 then
        begin
            Result := 0.0040803402792192207;
        end
        else
        begin
            if features.char_lm_context_score <= -5022.4999999999991 then
            begin
                Result := 0.02166274936605039;
            end
            else
            begin
                Result := 0.046389550176770357;
            end;
        end;
    end
    else
    begin
        if features.char_lm_context_score <= -6029.4999999999991 then
        begin
            if features.original_rank <= 5.5000000000000009 then
            begin
                if features.lexical_weight_min <= 604.50000000000011 then
                begin
                    Result := -0.023082763891864613;
                end
                else
                begin
                    Result := 0.012932542832012358;
                end;
            end
            else
            begin
                Result := -0.042892766955008627;
            end;
        end
        else
        begin
            Result := 0.0091534948990801349;
        end;
    end;
end;

function long_ranker_tree_10(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4629.4999999999991 then
    begin
        if features.score_per_segment <= 12895.500000000002 then
        begin
            if features.lexical_weight_mean <= 721.50000000000011 then
            begin
                Result := -0.042166304353063941;
            end
            else
            begin
                Result := -0.020539962397649193;
            end;
        end
        else
        begin
            if features.lexical_margin_sum <= -116.49999999999999 then
            begin
                Result := -0.017527159564422742;
            end
            else
            begin
                Result := 0.0056857968047838601;
            end;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3696.9999999999995 then
        begin
            if features.lexical_margin_sum <= -24.499999999999996 then
            begin
                Result := -0.0018821394124738018;
            end
            else
            begin
                Result := 0.020853063923723287;
            end;
        end
        else
        begin
            Result := 0.036710167443948227;
        end;
    end;
end;

function long_ranker_tree_11(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.original_rank <= 4.5000000000000009 then
    begin
        if features.char_lm_score <= -4629.4999999999991 then
        begin
            if features.original_rank <= 2.5000000000000004 then
            begin
                if features.lexical_margin_sum <= -88.499999999999986 then
                begin
                    Result := -0.011814147463083695;
                end
                else
                begin
                    Result := 0.0084957569032827873;
                end;
            end
            else
            begin
                Result := -0.019919796078604841;
            end;
        end
        else
        begin
            if features.char_lm_suffix_score <= -4505.4999999999991 then
            begin
                Result := 0.017889594183641642;
            end
            else
            begin
                Result := 0.043256243231714966;
            end;
        end;
    end
    else
    begin
        if features.char_lm_suffix_score <= -5783.4999999999991 then
        begin
            Result := -0.041791845871839643;
        end
        else
        begin
            Result := -0.013031668778950008;
        end;
    end;
end;

function long_ranker_tree_12(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.original_rank <= 2.5000000000000004 then
    begin
        if features.char_lm_score <= -4773.4999999999991 then
        begin
            if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
            begin
                Result := -0.030535068316706552;
            end
            else
            begin
                Result := 0.0038094333500260412;
            end;
        end
        else
        begin
            Result := 0.024566734690390411;
        end;
    end
    else
    begin
        if features.char_lm_suffix_score <= -5431.4999999999991 then
        begin
            if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
            begin
                Result := -0.048010296101774076;
            end
            else
            begin
                Result := -0.023332712383637415;
            end;
        end
        else
        begin
            if features.char_lm_score <= -3696.9999999999995 then
            begin
                Result := -0.002982966525234543;
            end
            else
            begin
                Result := 0.029087573741953268;
            end;
        end;
    end;
end;

function long_ranker_tree_13(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4534.4999999999991 then
    begin
        if features.original_rank <= 3.5000000000000004 then
        begin
            if features.char_lm_suffix_score <= -6698.4999999999991 then
            begin
                Result := -0.016226268576363279;
            end
            else
            begin
                if features.lexical_rank_max <= 1.5000000000000002 then
                begin
                    Result := 0.011637711633091054;
                end
                else
                begin
                    Result := -0.0081696912243403846;
                end;
            end;
        end
        else
        begin
            Result := -0.031865715575309039;
        end;
    end
    else
    begin
        if features.original_rank <= 4.5000000000000009 then
        begin
            if features.char_lm_score <= -3314.9999999999995 then
            begin
                Result := 0.020995277320771701;
            end
            else
            begin
                Result := 0.043774983111161764;
            end;
        end
        else
        begin
            Result := -0.0045414553996211823;
        end;
    end;
end;

function long_ranker_tree_14(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.original_rank <= 4.5000000000000009 then
    begin
        if features.char_lm_score <= -4231.9999999999991 then
        begin
            if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
            begin
                Result := -0.036226961274660983;
            end
            else
            begin
                if features.original_rank <= 1.5000000000000002 then
                begin
                    Result := 0.013058262458309355;
                end
                else
                begin
                    Result := -0.0050768682214488436;
                end;
            end;
        end
        else
        begin
            if features.lexical_margin_min <= -499.49999999999994 then
            begin
                Result := -0.027103523590168807;
            end
            else
            begin
                Result := 0.029283910773797002;
            end;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3823.9999999999995 then
        begin
            Result := -0.0333879127263794;
        end
        else
        begin
            Result := 0.015308174915351079;
        end;
    end;
end;

function long_ranker_tree_15(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4773.4999999999991 then
    begin
        if features.original_rank <= 3.5000000000000004 then
        begin
            if features.original_rank <= 1.5000000000000002 then
            begin
                Result := 0.0063256694678993954;
            end
            else
            begin
                Result := -0.01136179456020384;
            end;
        end
        else
        begin
            Result := -0.03369207455731088;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3314.9999999999995 then
        begin
            if features.original_rank <= 5.5000000000000009 then
            begin
                if features.lexical_margin_min <= -368.49999999999994 then
                begin
                    Result := -0.0081673432111169803;
                end
                else
                begin
                    Result := 0.017485386788419287;
                end;
            end
            else
            begin
                Result := -0.020733814518065632;
            end;
        end
        else
        begin
            Result := 0.041194490475551383;
        end;
    end;
end;

function long_ranker_tree_16(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4629.4999999999991 then
    begin
        if features.original_rank <= 2.5000000000000004 then
        begin
            if features.lexical_margin_sum <= -88.499999999999986 then
            begin
                Result := -0.013921823934611909;
            end
            else
            begin
                Result := 0.0060364720069291718;
            end;
        end
        else
        begin
            if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
            begin
                Result := -0.046076430370062968;
            end
            else
            begin
                Result := -0.022534475333129151;
            end;
        end;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4505.4999999999991 then
        begin
            if features.original_rank <= 4.5000000000000009 then
            begin
                Result := 0.016358074612748252;
            end
            else
            begin
                Result := -0.01590756599362592;
            end;
        end
        else
        begin
            Result := 0.03717185101894744;
        end;
    end;
end;

function long_ranker_tree_17(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4773.4999999999991 then
    begin
        if features.original_rank <= 3.5000000000000004 then
        begin
            if features.char_lm_context_score <= -8689.4999999999982 then
            begin
                Result := -0.043535657110895624;
            end
            else
            begin
                if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
                begin
                    Result := -0.027861790371793496;
                end
                else
                begin
                    Result := 0.0018131166972727216;
                end;
            end;
        end
        else
        begin
            Result := -0.031151468602180245;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3696.9999999999995 then
        begin
            if features.original_rank <= 4.5000000000000009 then
            begin
                Result := 0.013552797180056163;
            end
            else
            begin
                Result := -0.015793715678203656;
            end;
        end
        else
        begin
            Result := 0.032200311311066578;
        end;
    end;
end;

function long_ranker_tree_18(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4534.4999999999991 then
    begin
        if features.original_rank <= 3.5000000000000004 then
        begin
            if features.lexical_margin_sum <= -88.499999999999986 then
            begin
                Result := -0.013349272981420404;
            end
            else
            begin
                if features.char_lm_suffix_score <= -6982.4999999999991 then
                begin
                    Result := -0.015811974432510239;
                end
                else
                begin
                    Result := 0.0085805577010251103;
                end;
            end;
        end
        else
        begin
            Result := -0.030127975925645228;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3696.9999999999995 then
        begin
            if features.original_rank <= 6.5000000000000009 then
            begin
                Result := 0.012889162598523518;
            end
            else
            begin
                Result := -0.029857443878483634;
            end;
        end
        else
        begin
            Result := 0.032710994404117372;
        end;
    end;
end;

function long_ranker_tree_19(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_suffix_score <= -5385.4999999999991 then
    begin
        if features.original_rank <= 2.5000000000000004 then
        begin
            if features.char_lm_suffix_score <= -6676.4999999999991 then
            begin
                Result := -0.013595639230558888;
            end
            else
            begin
                if features.lexical_margin_sum <= -95.499999999999986 then
                begin
                    Result := -0.0098122269382090212;
                end
                else
                begin
                    Result := 0.015167211459950092;
                end;
            end;
        end
        else
        begin
            if features.original_rank <= 6.5000000000000009 then
            begin
                Result := -0.018229952335946317;
            end
            else
            begin
                Result := -0.043300470227047909;
            end;
        end;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4505.4999999999991 then
        begin
            Result := 0.011380476312758877;
        end
        else
        begin
            Result := 0.034833248489913815;
        end;
    end;
end;

function long_ranker_tree_20(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_suffix_score <= -5605.4999999999991 then
    begin
        if features.original_rank <= 2.5000000000000004 then
        begin
            if features.lexical_margin_sum <= -88.499999999999986 then
            begin
                if features.lexical_weight_mean <= 621.50000000000011 then
                begin
                    Result := 0.024543789436879591;
                end
                else
                begin
                    Result := -0.02088983224324616;
                end;
            end
            else
            begin
                Result := 0.0074079647429158985;
            end;
        end
        else
        begin
            Result := -0.025470300826060863;
        end;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4505.4999999999991 then
        begin
            if features.original_rank <= 5.5000000000000009 then
            begin
                Result := 0.014222421568021648;
            end
            else
            begin
                Result := -0.023902540725863963;
            end;
        end
        else
        begin
            Result := 0.034024185303883389;
        end;
    end;
end;

function long_ranker_tree_21(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4629.4999999999991 then
    begin
        if features.original_rank <= 3.5000000000000004 then
        begin
            if features.lexical_top_ratio <= 839.50000000000011 then
            begin
                Result := -0.018797413225943162;
            end
            else
            begin
                if features.score_per_segment <= 17661.000000000004 then
                begin
                    Result := -0.0069139475673235321;
                end
                else
                begin
                    Result := 0.0099044611789585162;
                end;
            end;
        end
        else
        begin
            Result := -0.02871145923600606;
        end;
    end
    else
    begin
        if features.original_rank <= 1.5000000000000002 then
        begin
            Result := 0.028174077434811456;
        end
        else
        begin
            if features.char_lm_suffix_score <= -4894.4999999999991 then
            begin
                Result := -0.0018606071170095392;
            end
            else
            begin
                Result := 0.019690773053233836;
            end;
        end;
    end;
end;

function long_ranker_tree_22(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4753.4999999999991 then
    begin
        if features.original_rank <= 2.5000000000000004 then
        begin
            if features.score_per_segment <= 17486.500000000004 then
            begin
                Result := -0.012697511172528927;
            end
            else
            begin
                Result := 0.0084691496513698318;
            end;
        end
        else
        begin
            if features.original_rank <= 5.5000000000000009 then
            begin
                Result := -0.018629632009074339;
            end
            else
            begin
                Result := -0.038059444196031529;
            end;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3314.9999999999995 then
        begin
            if features.original_rank <= 4.5000000000000009 then
            begin
                Result := 0.013997276803281082;
            end
            else
            begin
                Result := -0.010836086076868361;
            end;
        end
        else
        begin
            Result := 0.039227913898709346;
        end;
    end;
end;

function long_ranker_tree_23(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4604.4999999999991 then
    begin
        if features.original_rank <= 2.5000000000000004 then
        begin
            if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
            begin
                Result := -0.029076482049336654;
            end
            else
            begin
                Result := 0.0029666502575846072;
            end;
        end
        else
        begin
            if features.original_rank <= 5.5000000000000009 then
            begin
                Result := -0.016992554275948986;
            end
            else
            begin
                Result := -0.038198262446135244;
            end;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3314.9999999999995 then
        begin
            if features.original_rank <= 5.5000000000000009 then
            begin
                Result := 0.014157596369732956;
            end
            else
            begin
                Result := -0.015828956066364988;
            end;
        end
        else
        begin
            Result := 0.035678729315111846;
        end;
    end;
end;

function long_ranker_tree_24(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4806.4999999999991 then
    begin
        if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
        begin
            Result := -0.040219273346798604;
        end
        else
        begin
            if features.original_rank <= 1.5000000000000002 then
            begin
                Result := 0.0075547744548145404;
            end
            else
            begin
                Result := -0.015901604833769938;
            end;
        end;
    end
    else
    begin
        if features.original_rank <= 1.5000000000000002 then
        begin
            Result := 0.023916515108854158;
        end
        else
        begin
            if features.lexical_margin_min <= -371.49999999999994 then
            begin
                Result := -0.015416218206062258;
            end
            else
            begin
                if features.char_lm_per_unit <= -331.49999999999994 then
                begin
                    Result := 0.0017039083552492741;
                end
                else
                begin
                    Result := 0.021637838474668256;
                end;
            end;
        end;
    end;
end;

function long_ranker_tree_25(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4629.4999999999991 then
    begin
        if features.original_rank <= 2.5000000000000004 then
        begin
            if features.char_lm_suffix_score <= -6676.4999999999991 then
            begin
                Result := -0.015142471859561774;
            end
            else
            begin
                Result := 0.0058151060518804448;
            end;
        end
        else
        begin
            if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
            begin
                Result := -0.040945323383287324;
            end
            else
            begin
                Result := -0.019012371470240652;
            end;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3696.9999999999995 then
        begin
            if features.original_rank <= 4.5000000000000009 then
            begin
                Result := 0.011677416335399329;
            end
            else
            begin
                Result := -0.011938184488016824;
            end;
        end
        else
        begin
            Result := 0.029321098345521591;
        end;
    end;
end;

function long_ranker_tree_26(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_suffix_score <= -5605.4999999999991 then
    begin
        if features.original_rank <= 2.5000000000000004 then
        begin
            Result := -0.00059447288030692303;
        end
        else
        begin
            if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
            begin
                Result := -0.041320740153543867;
            end
            else
            begin
                Result := -0.018297187850899167;
            end;
        end;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4505.4999999999991 then
        begin
            if features.original_rank <= 5.5000000000000009 then
            begin
                if features.lexical_margin_min <= -648.49999999999989 then
                begin
                    Result := -0.049804711615858366;
                end
                else
                begin
                    Result := 0.011986534053901515;
                end;
            end
            else
            begin
                Result := -0.021253280206142755;
            end;
        end
        else
        begin
            Result := 0.02973619318608399;
        end;
    end;
end;

function long_ranker_tree_27(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_suffix_score <= -5409.9999999999991 then
    begin
        if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
        begin
            Result := -0.038404310575916929;
        end
        else
        begin
            if features.original_rank <= 5.5000000000000009 then
            begin
                if features.lexical_margin_sum <= -333.99999999999994 then
                begin
                    Result := -0.021752765309568194;
                end
                else
                begin
                    if features.char_lm_suffix_score <= -6698.4999999999991 then
                    begin
                        Result := -0.013822451462851661;
                    end
                    else
                    begin
                        Result := 0.0068585800195393783;
                    end;
                end;
            end
            else
            begin
                Result := -0.030961065025239109;
            end;
        end;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4791.4999999999991 then
        begin
            Result := 0.0088799127657028642;
        end
        else
        begin
            Result := 0.026023770317673143;
        end;
    end;
end;

function long_ranker_tree_28(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4753.4999999999991 then
    begin
        if features.original_rank <= 2.5000000000000004 then
        begin
            if features.lexical_top_ratio <= 839.50000000000011 then
            begin
                Result := -0.024034926495312352;
            end
            else
            begin
                if features.single_segments <= 2.5000000000000004 then
                begin
                    Result := 0.008024183493305654;
                end
                else
                begin
                    Result := -0.01007717908328914;
                end;
            end;
        end
        else
        begin
            Result := -0.02362720005007431;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3314.9999999999995 then
        begin
            if features.original_rank <= 3.5000000000000004 then
            begin
                Result := 0.013252743910187319;
            end
            else
            begin
                Result := -0.0025394443586445456;
            end;
        end
        else
        begin
            Result := 0.032873728822134435;
        end;
    end;
end;

function long_ranker_tree_29(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4231.9999999999991 then
    begin
        if features.original_rank <= 5.5000000000000009 then
        begin
            if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
            begin
                Result := -0.033463516689142173;
            end
            else
            begin
                if features.lexical_margin_min <= -368.49999999999994 then
                begin
                    Result := -0.019003084964187521;
                end
                else
                begin
                    if features.single_segments <= 4.5000000000000009 then
                    begin
                        Result := 0.0044498638165852006;
                    end
                    else
                    begin
                        Result := -0.020010417927889511;
                    end;
                end;
            end;
        end
        else
        begin
            Result := -0.032243216988284501;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3314.9999999999995 then
        begin
            Result := 0.013943714443709249;
        end
        else
        begin
            Result := 0.033399893606167103;
        end;
    end;
end;

function long_ranker_tree_30(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4806.4999999999991 then
    begin
        if features.original_rank <= 5.5000000000000009 then
        begin
            if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
            begin
                Result := -0.032665476992492844;
            end
            else
            begin
                if features.char_lm_suffix_score <= -6698.4999999999991 then
                begin
                    Result := -0.015329764610455644;
                end
                else
                begin
                    Result := 0.0005760030519212691;
                end;
            end;
        end
        else
        begin
            Result := -0.035255568914499588;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3314.9999999999995 then
        begin
            if features.original_rank <= 2.5000000000000004 then
            begin
                Result := 0.016390297302578509;
            end
            else
            begin
                Result := 0.0011135208175655181;
            end;
        end
        else
        begin
            Result := 0.035689093482389106;
        end;
    end;
end;

function long_ranker_tree_31(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4534.4999999999991 then
    begin
        if features.original_rank <= 3.5000000000000004 then
        begin
            if features.lexical_margin_sum <= -88.499999999999986 then
            begin
                if features.base_score <= 168567.50000000003 then
                begin
                    Result := -0.022515057773068631;
                end
                else
                begin
                    Result := 0.01539074949063614;
                end;
            end
            else
            begin
                Result := 0.00048089515342271302;
            end;
        end
        else
        begin
            Result := -0.024236424118329474;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3823.9999999999995 then
        begin
            if features.original_rank <= 6.5000000000000009 then
            begin
                Result := 0.010667146470827652;
            end
            else
            begin
                Result := -0.037412546840542064;
            end;
        end
        else
        begin
            Result := 0.025038329572399928;
        end;
    end;
end;

function long_ranker_tree_32(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4199.4999999999991 then
    begin
        if features.original_rank <= 5.5000000000000009 then
        begin
            if features.char_lm_score <= -5646.4999999999991 then
            begin
                if features.score_per_segment <= 18767.500000000004 then
                begin
                    Result := -0.019621594516095943;
                end
                else
                begin
                    Result := 0.00065416848473470539;
                end;
            end
            else
            begin
                if features.lexical_margin_min <= -368.49999999999994 then
                begin
                    Result := -0.016784686767646061;
                end
                else
                begin
                    Result := 0.0048287356650219991;
                end;
            end;
        end
        else
        begin
            Result := -0.03269286369004791;
        end;
    end
    else
    begin
        if features.lexical_margin_min <= -537.99999999999989 then
        begin
            Result := -0.022743274103184791;
        end
        else
        begin
            Result := 0.021354339587275551;
        end;
    end;
end;

function long_ranker_tree_33(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_context_score <= -6403.4999999999991 then
    begin
        if features.original_rank <= 3.5000000000000004 then
        begin
            Result := -0.0020041489435966824;
        end
        else
        begin
            if features.lexical_rank_sum <= 4.5000000000000009 then
            begin
                Result := 0.030215498715300406;
            end
            else
            begin
                Result := -0.023707873417909236;
            end;
        end;
    end
    else
    begin
        if features.lexical_rank_sum <= 7.5000000000000009 then
        begin
            if features.char_lm_per_unit <= -353.49999999999994 then
            begin
                Result := 0.011035339947733114;
            end
            else
            begin
                Result := 0.031443192721128409;
            end;
        end
        else
        begin
            if features.char_lm_per_unit <= -346.49999999999994 then
            begin
                Result := -0.014833851206778721;
            end
            else
            begin
                Result := 0.0086444723027385411;
            end;
        end;
    end;
end;

function long_ranker_tree_34(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4806.4999999999991 then
    begin
        if features.original_rank <= 5.5000000000000009 then
        begin
            if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
            begin
                Result := -0.031369657303434113;
            end
            else
            begin
                if features.lexical_margin_min <= -391.49999999999994 then
                begin
                    Result := -0.024913262848268811;
                end
                else
                begin
                    Result := -0.0020433825051657064;
                end;
            end;
        end
        else
        begin
            Result := -0.033516014582342137;
        end;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4505.4999999999991 then
        begin
            if features.original_rank <= 5.5000000000000009 then
            begin
                Result := 0.010819522456047717;
            end
            else
            begin
                Result := -0.016143456935738404;
            end;
        end
        else
        begin
            Result := 0.026641531805871112;
        end;
    end;
end;

function long_ranker_tree_35(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_suffix_score <= -6291.4999999999991 then
    begin
        if features.score_per_segment <= 18767.500000000004 then
        begin
            Result := -0.022513541807780112;
        end
        else
        begin
            Result := -0.0010706697159462693;
        end;
    end
    else
    begin
        if features.original_rank <= 4.5000000000000009 then
        begin
            if features.char_lm_score <= -4231.9999999999991 then
            begin
                if features.lexical_rank_max <= 2.5000000000000004 then
                begin
                    Result := 0.0077241315725509515;
                end
                else
                begin
                    Result := -0.013551902513164776;
                end;
            end
            else
            begin
                if features.lexical_weight_sum <= 5642.5000000000009 then
                begin
                    Result := 0.024443783221536834;
                end
                else
                begin
                    Result := 0.0069740109381386329;
                end;
            end;
        end
        else
        begin
            Result := -0.011267533370923202;
        end;
    end;
end;

function long_ranker_tree_36(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_suffix_score <= -6291.4999999999991 then
    begin
        if features.original_rank <= 3.5000000000000004 then
        begin
            if features.lexical_margin_min <= -37.499999999999993 then
            begin
                Result := -0.02275637261888408;
            end
            else
            begin
                Result := -0.0028107975294373545;
            end;
        end
        else
        begin
            Result := -0.02955033688425926;
        end;
    end
    else
    begin
        if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
        begin
            Result := -0.036673846091058233;
        end
        else
        begin
            if features.char_lm_suffix_score <= -4791.4999999999991 then
            begin
                if features.original_rank <= 1.5000000000000002 then
                begin
                    Result := 0.015364323134996024;
                end
                else
                begin
                    Result := 0.00011701965502162154;
                end;
            end
            else
            begin
                Result := 0.02400996680488365;
            end;
        end;
    end;
end;

function long_ranker_tree_37(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_suffix_score <= -5605.4999999999991 then
    begin
        if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
        begin
            Result := -0.033676088485160113;
        end
        else
        begin
            if features.lexical_margin_sum <= -333.99999999999994 then
            begin
                if features.base_score <= 144235.00000000003 then
                begin
                    Result := -0.03023128092235329;
                end
                else
                begin
                    Result := 0.010502462629436755;
                end;
            end
            else
            begin
                if features.char_lm_suffix_score <= -6698.4999999999991 then
                begin
                    Result := -0.014988095559729825;
                end
                else
                begin
                    Result := 0.0015404064773616776;
                end;
            end;
        end;
    end
    else
    begin
        if features.char_lm_score <= -4231.9999999999991 then
        begin
            Result := 0.005153506062823456;
        end
        else
        begin
            Result := 0.019167745706901593;
        end;
    end;
end;

function long_ranker_tree_38(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4806.4999999999991 then
    begin
        if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
        begin
            Result := -0.034015342464532576;
        end
        else
        begin
            if features.score_per_segment <= 12895.500000000002 then
            begin
                if features.lexical_weight_mean <= 813.50000000000011 then
                begin
                    Result := -0.023543339470420505;
                end
                else
                begin
                    Result := 0.0081714618022750169;
                end;
            end
            else
            begin
                Result := -0.0022656551824352562;
            end;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3769.9999999999995 then
        begin
            if features.lexical_weight_mean <= 877.50000000000011 then
            begin
                Result := 0.0043301472866207162;
            end
            else
            begin
                Result := 0.028131466961836778;
            end;
        end
        else
        begin
            Result := 0.023163107879384751;
        end;
    end;
end;

function long_ranker_tree_39(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4231.9999999999991 then
    begin
        if features.original_rank <= 5.5000000000000009 then
        begin
            if features.char_lm_suffix_score <= -6722.4999999999991 then
            begin
                Result := -0.016724879906893659;
            end
            else
            begin
                if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
                begin
                    Result := -0.031885655545345983;
                end
                else
                begin
                    if features.lexical_top_ratio <= 839.50000000000011 then
                    begin
                        Result := -0.012253940671788519;
                    end
                    else
                    begin
                        if features.single_segments <= 4.5000000000000009 then
                        begin
                            Result := 0.0077843186364325283;
                        end
                        else
                        begin
                            Result := -0.020369715212173106;
                        end;
                    end;
                end;
            end;
        end
        else
        begin
            Result := -0.029144295011896276;
        end;
    end
    else
    begin
        Result := 0.017095441849949031;
    end;
end;

function long_ranker_tree_40(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4753.4999999999991 then
    begin
        if features.score_per_segment <= 15586.000000000002 then
        begin
            if features.single_segments <= 2.5000000000000004 then
            begin
                if features.char_lm_per_unit <= -448.49999999999994 then
                begin
                    Result := -0.015844527335983613;
                end
                else
                begin
                    Result := 0.01634385336987175;
                end;
            end
            else
            begin
                Result := -0.024987340560216963;
            end;
        end
        else
        begin
            Result := -0.0018412567403389322;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3314.9999999999995 then
        begin
            if features.word_lm_per_boundary <= 151.50000000000003 then
            begin
                Result := 0.0053891268867530462;
            end
            else
            begin
                Result := 0.028009825527934427;
            end;
        end
        else
        begin
            Result := 0.030946381349508965;
        end;
    end;
end;

function long_ranker_tree_41(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4534.4999999999991 then
    begin
        if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
        begin
            Result := -0.032983112987353708;
        end
        else
        begin
            if features.lexical_margin_sum <= -333.99999999999994 then
            begin
                Result := -0.022338296089223043;
            end
            else
            begin
                if features.char_lm_suffix_score <= -6698.4999999999991 then
                begin
                    Result := -0.01325698471690772;
                end
                else
                begin
                    Result := 0.0036054919494532892;
                end;
            end;
        end;
    end
    else
    begin
        if features.lexical_weight_mean <= 877.50000000000011 then
        begin
            if features.original_rank <= 6.5000000000000009 then
            begin
                Result := 0.012262603555402448;
            end
            else
            begin
                Result := -0.024326616577222529;
            end;
        end
        else
        begin
            Result := 0.032684907961853471;
        end;
    end;
end;

function long_ranker_tree_42(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_suffix_score <= -6252.4999999999991 then
    begin
        if features.single_segments <= 2.5000000000000004 then
        begin
            Result := -0.0068174048295725374;
        end
        else
        begin
            Result := -0.025042564653249971;
        end;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4791.4999999999991 then
        begin
            if features.single_segments <= 4.5000000000000009 then
            begin
                if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
                begin
                    Result := -0.021794627731640603;
                end
                else
                begin
                    if features.word_lm_bonus <= 534.50000000000011 then
                    begin
                        Result := 0.0023058028190845736;
                    end
                    else
                    begin
                        Result := 0.015085233155058816;
                    end;
                end;
            end
            else
            begin
                Result := -0.017938245815172137;
            end;
        end
        else
        begin
            Result := 0.021420678014682743;
        end;
    end;
end;

function long_ranker_tree_43(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4773.4999999999991 then
    begin
        if features.base_score <= 93585.500000000015 then
        begin
            if features.char_lm_suffix_score <= -7488.4999999999991 then
            begin
                Result := -0.040886786657481876;
            end
            else
            begin
                Result := -0.015487170578585528;
            end;
        end
        else
        begin
            Result := -0.00424407141951444;
        end;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4505.4999999999991 then
        begin
            if features.lexical_rank_max <= 2.5000000000000004 then
            begin
                if features.single_segments <= 4.5000000000000009 then
                begin
                    Result := 0.011773811350871246;
                end
                else
                begin
                    Result := -0.017580466252105978;
                end;
            end
            else
            begin
                Result := -0.01086187053999081;
            end;
        end
        else
        begin
            Result := 0.026329731576879973;
        end;
    end;
end;

function long_ranker_tree_44(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4231.9999999999991 then
    begin
        if features.original_rank <= 5.5000000000000009 then
        begin
            if features.char_lm_score <= -5327.4999999999991 then
            begin
                if features.score_per_segment <= 16846.500000000004 then
                begin
                    if features.char_lm_score <= -7030.9999999999991 then
                    begin
                        Result := -0.049265941091293203;
                    end
                    else
                    begin
                        Result := -0.014804802143284369;
                    end;
                end
                else
                begin
                    Result := -0.003376806068826641;
                end;
            end
            else
            begin
                if features.lexical_top_ratio <= 809.00000000000011 then
                begin
                    Result := -0.017552538035999429;
                end
                else
                begin
                    Result := 0.0048072313731401979;
                end;
            end;
        end
        else
        begin
            Result := -0.02797551012033514;
        end;
    end
    else
    begin
        Result := 0.017457128092702431;
    end;
end;

function long_ranker_tree_45(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4629.4999999999991 then
    begin
        if features.score_per_segment <= 17401.000000000004 then
        begin
            if features.char_lm_suffix_score <= -7545.4999999999991 then
            begin
                Result := -0.045116439642038528;
            end
            else
            begin
                if features.original_rank <= 6.5000000000000009 then
                begin
                    Result := -0.0094125275575698015;
                end
                else
                begin
                    Result := -0.03149914147322861;
                end;
            end;
        end
        else
        begin
            if features.lexical_top_ratio <= 839.50000000000011 then
            begin
                Result := -0.015543679097091806;
            end
            else
            begin
                Result := 0.0060115814533028321;
            end;
        end;
    end
    else
    begin
        if features.original_rank <= 1.5000000000000002 then
        begin
            Result := 0.023323968703691071;
        end
        else
        begin
            Result := 0.0075661417957232167;
        end;
    end;
end;

function long_ranker_tree_46(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_suffix_score <= -6291.4999999999991 then
    begin
        if features.single_segments <= 2.5000000000000004 then
        begin
            Result := -0.0084976393107351559;
        end
        else
        begin
            Result := -0.025496982652814248;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3769.9999999999995 then
        begin
            if features.original_rank <= 4.5000000000000009 then
            begin
                if features.lexical_rank_max <= 2.5000000000000004 then
                begin
                    if features.word_lm_bonus <= 534.50000000000011 then
                    begin
                        Result := 0.0047707738603350305;
                    end
                    else
                    begin
                        Result := 0.018355145949133775;
                    end;
                end
                else
                begin
                    Result := -0.014448609353936093;
                end;
            end
            else
            begin
                Result := -0.014031219483746922;
            end;
        end
        else
        begin
            Result := 0.022734783568978054;
        end;
    end;
end;

function long_ranker_tree_47(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_suffix_score <= -6291.4999999999991 then
    begin
        if features.lexical_margin_sum <= -95.499999999999986 then
        begin
            if features.lexical_weight_min <= 474.50000000000006 then
            begin
                Result := -0.017857275585280167;
            end
            else
            begin
                Result := -0.048687133504980294;
            end;
        end
        else
        begin
            Result := -0.00902898590677975;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3620.4999999999995 then
        begin
            if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
            begin
                Result := -0.027896073951902918;
            end
            else
            begin
                if features.lexical_margin_min <= -368.49999999999994 then
                begin
                    Result := -0.0083669343595001531;
                end
                else
                begin
                    Result := 0.0064009007137964735;
                end;
            end;
        end
        else
        begin
            Result := 0.023528101492605341;
        end;
    end;
end;

function long_ranker_tree_48(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4806.4999999999991 then
    begin
        if features.score_per_segment <= 12895.500000000002 then
        begin
            Result := -0.020326069069327539;
        end
        else
        begin
            if features.first_stage_score <= 208979.50000000003 then
            begin
                Result := -0.0054319071588688969;
            end
            else
            begin
                Result := 0.014732421507545225;
            end;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3769.9999999999995 then
        begin
            if features.lexical_margin_sum <= -24.499999999999996 then
            begin
                Result := -0.0035123678083093628;
            end
            else
            begin
                if features.last_segment_weight <= 310.50000000000006 then
                begin
                    Result := -0.021020336795716434;
                end
                else
                begin
                    Result := 0.01120957662748886;
                end;
            end;
        end
        else
        begin
            Result := 0.022571657812268227;
        end;
    end;
end;

function long_ranker_tree_49(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4231.9999999999991 then
    begin
        if features.char_lm_score <= -5626.4999999999991 then
        begin
            if features.score_per_segment <= 21078.500000000004 then
            begin
                Result := -0.019774898603613124;
            end
            else
            begin
                Result := 0.0082145072680082643;
            end;
        end
        else
        begin
            if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
            begin
                Result := -0.034305453157048235;
            end
            else
            begin
                if features.lexical_margin_sum <= -333.99999999999994 then
                begin
                    Result := -0.013904486182339141;
                end
                else
                begin
                    if features.lexical_margin_min <= -222.49999999999997 then
                    begin
                        Result := 0.024384408292227214;
                    end
                    else
                    begin
                        Result := 0.0015238458601620965;
                    end;
                end;
            end;
        end;
    end
    else
    begin
        Result := 0.016249054393554646;
    end;
end;

function long_ranker_tree_50(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_suffix_score <= -6291.4999999999991 then
    begin
        if features.lexical_weight_sum <= 2584.5000000000005 then
        begin
            Result := 0.022671698561546376;
        end
        else
        begin
            if features.char_lm_score <= -6473.4999999999991 then
            begin
                Result := -0.027942747394949039;
            end
            else
            begin
                Result := -0.011147902961432352;
            end;
        end;
    end
    else
    begin
        if features.original_rank <= 2.5000000000000004 then
        begin
            if features.char_lm_suffix_score <= -4505.4999999999991 then
            begin
                Result := 0.010446244986061896;
            end
            else
            begin
                Result := 0.03222293991520616;
            end;
        end
        else
        begin
            if features.word_lm_per_boundary <= 117.50000000000001 then
            begin
                Result := -0.0053088419857963004;
            end
            else
            begin
                Result := 0.022410177518066125;
            end;
        end;
    end;
end;

function long_ranker_tree_51(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4806.4999999999991 then
    begin
        if features.char_lm_score <= -6473.4999999999991 then
        begin
            if features.lexical_weight_mean <= 804.50000000000011 then
            begin
                if features.lexical_weight_mean <= 541.50000000000011 then
                begin
                    Result := 0.013696885182680684;
                end
                else
                begin
                    Result := -0.036698008399438188;
                end;
            end
            else
            begin
                Result := 0.0087105452370498902;
            end;
        end
        else
        begin
            if features.original_rank <= 4.5000000000000009 then
            begin
                Result := -0.0025148151879452805;
            end
            else
            begin
                Result := -0.020193405117642973;
            end;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3314.9999999999995 then
        begin
            Result := 0.0076545463675557384;
        end
        else
        begin
            Result := 0.02926022508855575;
        end;
    end;
end;

function long_ranker_tree_52(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4513.4999999999991 then
    begin
        if features.original_rank <= 5.5000000000000009 then
        begin
            if features.char_lm_score <= -6302.4999999999991 then
            begin
                Result := -0.017246141560682032;
            end
            else
            begin
                if features.lexical_margin_sum <= -368.49999999999994 then
                begin
                    if features.last_segment_weight <= 439.50000000000006 then
                    begin
                        Result := 0.014124682169209823;
                    end
                    else
                    begin
                        Result := -0.027512943877659506;
                    end;
                end
                else
                begin
                    Result := 0.00085662871655468691;
                end;
            end;
        end
        else
        begin
            Result := -0.025088364360714297;
        end;
    end
    else
    begin
        if features.char_lm_score <= -3314.9999999999995 then
        begin
            Result := 0.0095437007845509438;
        end
        else
        begin
            Result := 0.030233772545116812;
        end;
    end;
end;

function long_ranker_tree_53(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4773.4999999999991 then
    begin
        if features.score_per_segment <= 16648.500000000004 then
        begin
            if features.char_lm_score <= -6785.4999999999991 then
            begin
                Result := -0.046611798560821184;
            end
            else
            begin
                if features.single_segments <= 2.5000000000000004 then
                begin
                    Result := -0.0024358064911905175;
                end
                else
                begin
                    if features.lexical_weight_per_unit <= 382.50000000000006 then
                    begin
                        Result := 0.0053422114328244251;
                    end
                    else
                    begin
                        Result := -0.024736037353840144;
                    end;
                end;
            end;
        end
        else
        begin
            Result := -0.00082819419386646756;
        end;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4505.4999999999991 then
        begin
            Result := 0.0067809218309065663;
        end
        else
        begin
            Result := 0.025401348476111304;
        end;
    end;
end;

function long_ranker_tree_54(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4231.9999999999991 then
    begin
        if features.char_lm_suffix_score <= -6722.4999999999991 then
        begin
            Result := -0.017266547501821487;
        end
        else
        begin
            if Ord(features.baseline_lineage) <= 1.0000000180025095E-35 then
            begin
                Result := -0.027811503595457889;
            end
            else
            begin
                if features.single_segments <= 4.5000000000000009 then
                begin
                    if features.lexical_top_ratio <= 839.50000000000011 then
                    begin
                        Result := -0.0099887957048330946;
                    end
                    else
                    begin
                        Result := 0.0050660470217692797;
                    end;
                end
                else
                begin
                    Result := -0.017790808728671684;
                end;
            end;
        end;
    end
    else
    begin
        if features.lexical_weight_per_unit <= 379.50000000000006 then
        begin
            Result := 0.029821946013991383;
        end
        else
        begin
            Result := 0.011948490816088396;
        end;
    end;
end;

function long_ranker_tree_55(
    const features: TncLongSecondStageFeatures): Double;
begin
    if features.char_lm_score <= -4534.4999999999991 then
    begin
        if features.char_lm_suffix_score <= -6722.4999999999991 then
        begin
            if features.first_stage_score <= 208979.50000000003 then
            begin
                Result := -0.019838001146598613;
            end
            else
            begin
                Result := 0.024293302532718136;
            end;
        end
        else
        begin
            if features.lexical_margin_sum <= -368.49999999999994 then
            begin
                if features.lexical_weight_max <= 999.50000000000011 then
                begin
                    Result := 0.0047831269530356022;
                end
                else
                begin
                    Result := -0.028905778967800579;
                end;
            end
            else
            begin
                Result := -0.00048029973684872662;
            end;
        end;
    end
    else
    begin
        if features.char_lm_suffix_score <= -4505.4999999999991 then
        begin
            Result := 0.0080626612571274067;
        end
        else
        begin
            Result := 0.02372009561472644;
        end;
    end;
end;
function long_second_stage_ranker_score(
    const features: TncLongSecondStageFeatures): Int64;
var
    score: Double;
begin
    score := 0.0;
    score := score + long_ranker_tree_0(features);
    score := score + long_ranker_tree_1(features);
    score := score + long_ranker_tree_2(features);
    score := score + long_ranker_tree_3(features);
    score := score + long_ranker_tree_4(features);
    score := score + long_ranker_tree_5(features);
    score := score + long_ranker_tree_6(features);
    score := score + long_ranker_tree_7(features);
    score := score + long_ranker_tree_8(features);
    score := score + long_ranker_tree_9(features);
    score := score + long_ranker_tree_10(features);
    score := score + long_ranker_tree_11(features);
    score := score + long_ranker_tree_12(features);
    score := score + long_ranker_tree_13(features);
    score := score + long_ranker_tree_14(features);
    score := score + long_ranker_tree_15(features);
    score := score + long_ranker_tree_16(features);
    score := score + long_ranker_tree_17(features);
    score := score + long_ranker_tree_18(features);
    score := score + long_ranker_tree_19(features);
    score := score + long_ranker_tree_20(features);
    score := score + long_ranker_tree_21(features);
    score := score + long_ranker_tree_22(features);
    score := score + long_ranker_tree_23(features);
    score := score + long_ranker_tree_24(features);
    score := score + long_ranker_tree_25(features);
    score := score + long_ranker_tree_26(features);
    score := score + long_ranker_tree_27(features);
    score := score + long_ranker_tree_28(features);
    score := score + long_ranker_tree_29(features);
    score := score + long_ranker_tree_30(features);
    score := score + long_ranker_tree_31(features);
    score := score + long_ranker_tree_32(features);
    score := score + long_ranker_tree_33(features);
    score := score + long_ranker_tree_34(features);
    score := score + long_ranker_tree_35(features);
    score := score + long_ranker_tree_36(features);
    score := score + long_ranker_tree_37(features);
    score := score + long_ranker_tree_38(features);
    score := score + long_ranker_tree_39(features);
    score := score + long_ranker_tree_40(features);
    score := score + long_ranker_tree_41(features);
    score := score + long_ranker_tree_42(features);
    score := score + long_ranker_tree_43(features);
    score := score + long_ranker_tree_44(features);
    score := score + long_ranker_tree_45(features);
    score := score + long_ranker_tree_46(features);
    score := score + long_ranker_tree_47(features);
    score := score + long_ranker_tree_48(features);
    score := score + long_ranker_tree_49(features);
    score := score + long_ranker_tree_50(features);
    score := score + long_ranker_tree_51(features);
    score := score + long_ranker_tree_52(features);
    score := score + long_ranker_tree_53(features);
    score := score + long_ranker_tree_54(features);
    score := score + long_ranker_tree_55(features);
    Result := Trunc(score * c_long_second_stage_ranker_score_scale);
end;

function long_second_stage_ranker_self_test: Boolean;
var
    features: TncLongSecondStageFeatures;
begin
    FillChar(features, SizeOf(features), 0);
    if long_second_stage_ranker_score(features) <>
        c_long_second_stage_ranker_reference_score then
    begin
        Exit(False);
    end;

    features.first_stage_score := -1000000;
    features.base_score := -1000000;
    features.char_lm_score := -1000000;
    features.char_lm_suffix_score := -1000000;
    features.char_lm_context_score := -1000000;
    features.char_lm_context_gain := -1000000;
    features.char_lm_per_unit := -1000000;
    features.word_lm_bonus := -1000000;
    features.word_lm_per_boundary := -1000000;
    features.lexical_weight_sum := -1000000;
    features.lexical_weight_min := -1000000;
    features.lexical_weight_max := -1000000;
    features.lexical_weight_mean := -1000000;
    features.lexical_weight_per_unit := -1000000;
    features.lexical_known_ratio := -1000000;
    features.lexical_top_ratio := -1000000;
    features.lexical_rank_sum := -1000000;
    features.lexical_rank_max := -1000000;
    features.lexical_margin_sum := -1000000;
    features.lexical_margin_min := -1000000;
    features.first_segment_weight := -1000000;
    features.last_segment_weight := -1000000;
    features.segments := -1000000;
    features.single_segments := -1000000;
    features.multi_segments := -1000000;
    features.max_segment_units := -1000000;
    features.min_segment_units := -1000000;
    features.segment_units_square_sum := -1000000;
    features.first_segment_units := -1000000;
    features.last_segment_units := -1000000;
    features.anchor_units := -1000000;
    features.has_anchor := False;
    features.baseline_lineage := False;
    features.original_rank := -1000000;
    features.input_syllable_count := -1000000;
    features.has_left_context := False;
    features.query_path_bonus := -1000000;
    features.query_path_penalty := -1000000;
    features.score_per_segment := -1000000;
    if long_second_stage_ranker_score(features) <>
        c_long_second_stage_ranker_reference_score_low then
    begin
        Exit(False);
    end;

    features.first_stage_score := 1000000;
    features.base_score := 1000000;
    features.char_lm_score := 1000000;
    features.char_lm_suffix_score := 1000000;
    features.char_lm_context_score := 1000000;
    features.char_lm_context_gain := 1000000;
    features.char_lm_per_unit := 1000000;
    features.word_lm_bonus := 1000000;
    features.word_lm_per_boundary := 1000000;
    features.lexical_weight_sum := 1000000;
    features.lexical_weight_min := 1000000;
    features.lexical_weight_max := 1000000;
    features.lexical_weight_mean := 1000000;
    features.lexical_weight_per_unit := 1000000;
    features.lexical_known_ratio := 1000000;
    features.lexical_top_ratio := 1000000;
    features.lexical_rank_sum := 1000000;
    features.lexical_rank_max := 1000000;
    features.lexical_margin_sum := 1000000;
    features.lexical_margin_min := 1000000;
    features.first_segment_weight := 1000000;
    features.last_segment_weight := 1000000;
    features.segments := 1000000;
    features.single_segments := 1000000;
    features.multi_segments := 1000000;
    features.max_segment_units := 1000000;
    features.min_segment_units := 1000000;
    features.segment_units_square_sum := 1000000;
    features.first_segment_units := 1000000;
    features.last_segment_units := 1000000;
    features.anchor_units := 1000000;
    features.has_anchor := True;
    features.baseline_lineage := True;
    features.original_rank := 1000000;
    features.input_syllable_count := 1000000;
    features.has_left_context := True;
    features.query_path_bonus := 1000000;
    features.query_path_penalty := 1000000;
    features.score_per_segment := 1000000;
    if long_second_stage_ranker_score(features) <>
        c_long_second_stage_ranker_reference_score_high then
    begin
        Exit(False);
    end;

    features.first_stage_score := 137;
    features.base_score := -274;
    features.char_lm_score := 411;
    features.char_lm_suffix_score := -548;
    features.char_lm_context_score := 685;
    features.char_lm_context_gain := -822;
    features.char_lm_per_unit := 959;
    features.word_lm_bonus := -1096;
    features.word_lm_per_boundary := 1233;
    features.lexical_weight_sum := -1370;
    features.lexical_weight_min := 1507;
    features.lexical_weight_max := -1644;
    features.lexical_weight_mean := 1781;
    features.lexical_weight_per_unit := -1918;
    features.lexical_known_ratio := 2055;
    features.lexical_top_ratio := -2192;
    features.lexical_rank_sum := 2329;
    features.lexical_rank_max := -2466;
    features.lexical_margin_sum := 2603;
    features.lexical_margin_min := -2740;
    features.first_segment_weight := 2877;
    features.last_segment_weight := -3014;
    features.segments := 3151;
    features.single_segments := -3288;
    features.multi_segments := 3425;
    features.max_segment_units := -3562;
    features.min_segment_units := 3699;
    features.segment_units_square_sum := -3836;
    features.first_segment_units := 3973;
    features.last_segment_units := -4110;
    features.anchor_units := 4247;
    features.has_anchor := True;
    features.baseline_lineage := False;
    features.original_rank := -4658;
    features.input_syllable_count := 4795;
    features.has_left_context := True;
    features.query_path_bonus := 5069;
    features.query_path_penalty := -5206;
    features.score_per_segment := 5343;
    Result := long_second_stage_ranker_score(features) =
        c_long_second_stage_ranker_reference_score_mixed;
end;

end.
