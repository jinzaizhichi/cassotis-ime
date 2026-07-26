unit nc_long_final_abstain_model;

interface

type
    TncLongFinalAbstainFeatures = record
        candidate_count: Integer;
        complete_count: Integer;
        chain_count: Integer;
        input_syllable_count: Integer;
        has_left_context: Boolean;
        ranker_top_score: Int64;
        ranker_second_score: Int64;
        ranker_third_score: Int64;
        ranker_top_margin: Int64;
        ranker_second_margin: Int64;
        ranker_score_range: Int64;
        ranker_top_legacy_rank: Integer;
        ranker_top_chain_rank: Integer;
        ranker_top_complete: Boolean;
        ranker_top_user: Boolean;
        ranker_top_dictionary: Boolean;
        ranker_top_chain: Boolean;
        legacy_top_ranker_score: Int64;
        ranker_top_over_legacy_margin: Int64;
        ranker_disagrees: Boolean;
        legacy_top_complete: Boolean;
        legacy_top_user: Boolean;
        legacy_top_dictionary: Boolean;
        legacy_top_chain: Boolean;
        legacy_top_chain_rank: Integer;
        ranker_top_char_lm_score: Integer;
        legacy_top_char_lm_score: Integer;
        ranker_top_char_lm_gain: Integer;
        ranker_top_path_confidence: Integer;
        legacy_top_path_confidence: Integer;
        ranker_top_path_confidence_gain: Integer;
        ranker_top_query_choice_bonus: Integer;
        legacy_top_query_choice_bonus: Integer;
    end;

const
    c_long_final_abstain_feature_count: Integer = 33;
    c_long_final_abstain_tree_count: Integer = 60;
    c_long_final_abstain_score_scale: Double = 100000000.0;
    c_long_final_abstain_reference_score: Int64 = 1334496;
    c_long_final_abstain_reference_score_low: Int64 = 48764479;
    c_long_final_abstain_reference_score_high: Int64 = -96548025;
    c_long_final_abstain_reference_score_mixed: Int64 = -1169938;

function long_final_abstain_score(
    const features: TncLongFinalAbstainFeatures): Int64;
function long_final_abstain_self_test: Boolean;

implementation

{ Learned LightGBM final-ranker fallback policy. The generated unit has no LightGBM runtime dependency.
  Training report SHA-256: 7C4E05C8840E391C5F0FFD3BBD9A3A97FB7857FB500D93B5E505169923DF0639
  LightGBM model SHA-256: A6CDD0079E3667569C8065F91F2C06705CBA67F1E656AC8F32DD5B920F6BD02F }

function long_final_abstain_tree_0(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 96084069.500000015 then
    begin
        if features.input_syllable_count <= 11.500000000000002 then
        begin
            Result := 1.2066254623870234;
        end
        else
        begin
            Result := 1.1143321073790546;
        end;
    end
    else
    begin
        Result := 1.2274928291209095;
    end;
end;

function long_final_abstain_tree_1(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 108097173.50000001 then
    begin
        if features.ranker_second_score <= 77150933.000000015 then
        begin
            Result := -0.013931427600589961;
        end
        else
        begin
            Result := -0.11084848641226072;
        end;
    end
    else
    begin
        Result := 0.023867604967158149;
    end;
end;

function long_final_abstain_tree_2(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 96084069.500000015 then
    begin
        if features.ranker_third_score <= -374271341.99999994 then
        begin
            Result := 0.0008593350009152977;
        end
        else
        begin
            Result := -0.080025685134711061;
        end;
    end
    else
    begin
        Result := 0.011109317404844384;
    end;
end;

function long_final_abstain_tree_3(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 96084069.500000015 then
    begin
        if features.ranker_third_score <= -374271341.99999994 then
        begin
            Result := 0.0073552987766399751;
        end
        else
        begin
            Result := -0.080855164740469013;
        end;
    end
    else
    begin
        Result := 0.018385316260444186;
    end;
end;

function long_final_abstain_tree_4(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 96084069.500000015 then
    begin
        if features.ranker_third_score <= -374271341.99999994 then
        begin
            Result := 0.014329083582577548;
        end
        else
        begin
            Result := -0.062014502743893828;
        end;
    end
    else
    begin
        Result := 0.019275749799384571;
    end;
end;

function long_final_abstain_tree_5(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.input_syllable_count <= 15.500000000000002 then
    begin
        if features.ranker_top_score <= 108097173.50000001 then
        begin
            Result := -0.0092092297160967767;
        end
        else
        begin
            Result := 0.022377162775551542;
        end;
    end
    else
    begin
        Result := -0.07976019382168395;
    end;
end;

function long_final_abstain_tree_6(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_second_score <= 34345818.000000007 then
    begin
        if features.ranker_third_score <= -374271341.99999994 then
        begin
            Result := 0.016101346415374758;
        end
        else
        begin
            Result := -0.13203977021560606;
        end;
    end
    else
    begin
        Result := 0.0075330393899076331;
    end;
end;

function long_final_abstain_tree_7(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 108097173.50000001 then
    begin
        if features.ranker_second_score <= 77150933.000000015 then
        begin
            Result := -0.0090142469142726039;
        end
        else
        begin
            Result := -0.099653995639783791;
        end;
    end
    else
    begin
        Result := 0.016801437848898242;
    end;
end;

function long_final_abstain_tree_8(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 96084069.500000015 then
    begin
        if features.ranker_third_score <= -374271341.99999994 then
        begin
            Result := 0.011673505939501788;
        end
        else
        begin
            Result := -0.063012579054774351;
        end;
    end
    else
    begin
        Result := 0.013824725735309931;
    end;
end;

function long_final_abstain_tree_9(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.input_syllable_count <= 15.500000000000002 then
    begin
        if features.ranker_top_char_lm_score <= -4770.4999999999991 then
        begin
            Result := 0.015635017949021883;
        end
        else
        begin
            Result := -0.031924563036713087;
        end;
    end
    else
    begin
        Result := -0.046392501951700325;
    end;
end;

function long_final_abstain_tree_10(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 108097173.50000001 then
    begin
        Result := -0.02208096094308671;
    end
    else
    begin
        if features.ranker_top_char_lm_score <= -6649.9999999999991 then
        begin
            Result := 0.044082165240210504;
        end
        else
        begin
            Result := -0.0083543032693755275;
        end;
    end;
end;

function long_final_abstain_tree_11(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.input_syllable_count <= 15.500000000000002 then
    begin
        if features.ranker_top_char_lm_score <= -4729.9999999999991 then
        begin
            Result := 0.0097714164568988102;
        end
        else
        begin
            Result := -0.036125209352563123;
        end;
    end
    else
    begin
        Result := -0.056636385134367667;
    end;
end;

function long_final_abstain_tree_12(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.input_syllable_count <= 15.500000000000002 then
    begin
        if features.ranker_second_score <= 81017015.000000015 then
        begin
            Result := -0.0088875058549220606;
        end
        else
        begin
            Result := 0.025752936376011348;
        end;
    end
    else
    begin
        Result := -0.063827430275838509;
    end;
end;

function long_final_abstain_tree_13(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 96084069.500000015 then
    begin
        if features.ranker_third_score <= -374271341.99999994 then
        begin
            Result := 0.0076724127309658451;
        end
        else
        begin
            Result := -0.055485557921358029;
        end;
    end
    else
    begin
        Result := 0.01520530068056385;
    end;
end;

function long_final_abstain_tree_14(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 96084069.500000015 then
    begin
        if features.input_syllable_count <= 14.500000000000002 then
        begin
            Result := -0.0081312164559171739;
        end
        else
        begin
            Result := -0.099697332483030796;
        end;
    end
    else
    begin
        Result := 0.014045803458987108;
    end;
end;

function long_final_abstain_tree_15(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_second_score <= 34345818.000000007 then
    begin
        if features.input_syllable_count <= 11.500000000000002 then
        begin
            Result := 0.0047290588370482098;
        end
        else
        begin
            Result := -0.10284275017135386;
        end;
    end
    else
    begin
        Result := 0.0060669268815008526;
    end;
end;

function long_final_abstain_tree_16(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_score <= -4729.9999999999991 then
    begin
        if features.ranker_top_char_lm_gain <= -604.49999999999989 then
        begin
            Result := -0.027624610836089487;
        end
        else
        begin
            Result := 0.0078056918476153156;
        end;
    end
    else
    begin
        Result := -0.058128630296796172;
    end;
end;

function long_final_abstain_tree_17(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 96084069.500000015 then
    begin
        Result := -0.021505687178224084;
    end
    else
    begin
        if features.ranker_top_margin <= 18254850.000000004 then
        begin
            Result := -0.019030338679331637;
        end
        else
        begin
            Result := 0.0239274273927561;
        end;
    end;
end;

function long_final_abstain_tree_18(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 137227616.50000003 then
    begin
        if features.ranker_second_score <= 98854870.000000015 then
        begin
            Result := 0.00025827834503298696;
        end
        else
        begin
            Result := -0.058275995206635213;
        end;
    end
    else
    begin
        Result := 0.029811757686345398;
    end;
end;

function long_final_abstain_tree_19(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_score <= -4729.9999999999991 then
    begin
        if features.input_syllable_count <= 15.500000000000002 then
        begin
            Result := 0.014115737451492187;
        end
        else
        begin
            Result := -0.026981891526809271;
        end;
    end
    else
    begin
        Result := -0.040535889915180888;
    end;
end;

function long_final_abstain_tree_20(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.input_syllable_count <= 14.500000000000002 then
    begin
        Result := 0.0011499402635581791;
    end
    else
    begin
        if features.ranker_third_score <= -374091102.99999994 then
        begin
            Result := 0.0043839079000195834;
        end
        else
        begin
            Result := -0.080694153105389091;
        end;
    end;
end;

function long_final_abstain_tree_21(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.input_syllable_count <= 16.500000000000004 then
    begin
        if features.ranker_second_score <= 81017015.000000015 then
        begin
            Result := -0.010408006672098678;
        end
        else
        begin
            Result := 0.018334430283990861;
        end;
    end
    else
    begin
        Result := -0.050150642690257791;
    end;
end;

function long_final_abstain_tree_22(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_gain <= -304.99999999999994 then
    begin
        if features.ranker_top_char_lm_gain <= -402.49999999999994 then
        begin
            Result := 0.00092928698859196662;
        end
        else
        begin
            Result := -0.047482590675626823;
        end;
    end
    else
    begin
        Result := 0.018981189175831494;
    end;
end;

function long_final_abstain_tree_23(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.input_syllable_count <= 16.500000000000004 then
    begin
        if features.ranker_top_char_lm_score <= -4729.9999999999991 then
        begin
            Result := 0.01362671986272513;
        end
        else
        begin
            Result := -0.025343470587207949;
        end;
    end
    else
    begin
        Result := -0.033941767798795881;
    end;
end;

function long_final_abstain_tree_24(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 108097173.50000001 then
    begin
        if features.ranker_top_char_lm_score <= -6373.4999999999991 then
        begin
            Result := -0.057240477958881708;
        end
        else
        begin
            Result := 0.0073527192930327116;
        end;
    end
    else
    begin
        Result := 0.018208440462697068;
    end;
end;

function long_final_abstain_tree_25(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 108097173.50000001 then
    begin
        if features.ranker_second_score <= 77150933.000000015 then
        begin
            Result := 5.179835742783587E-06;
        end
        else
        begin
            Result := -0.065743493750948345;
        end;
    end
    else
    begin
        Result := 0.017535764853641483;
    end;
end;

function long_final_abstain_tree_26(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 108097173.50000001 then
    begin
        if features.ranker_third_score <= -374271341.99999994 then
        begin
            Result := 0.022056523493881829;
        end
        else
        begin
            Result := -0.035187392433115229;
        end;
    end
    else
    begin
        Result := 0.016143440746520278;
    end;
end;

function long_final_abstain_tree_27(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.input_syllable_count <= 16.500000000000004 then
    begin
        if features.ranker_top_char_lm_score <= -4729.9999999999991 then
        begin
            Result := 0.0074070134098219468;
        end
        else
        begin
            Result := -0.026001987419517165;
        end;
    end
    else
    begin
        Result := -0.046811122750546802;
    end;
end;

function long_final_abstain_tree_28(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 137227616.50000003 then
    begin
        if features.ranker_top_margin <= 22522965.000000004 then
        begin
            Result := -0.028074682825903627;
        end
        else
        begin
            Result := 0.010393672888989902;
        end;
    end
    else
    begin
        Result := 0.02474966907414514;
    end;
end;

function long_final_abstain_tree_29(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.input_syllable_count <= 15.500000000000002 then
    begin
        if features.ranker_top_char_lm_gain <= -604.49999999999989 then
        begin
            Result := -0.021609599078860037;
        end
        else
        begin
            Result := 0.01032819894529767;
        end;
    end
    else
    begin
        Result := -0.0380762568434658;
    end;
end;

function long_final_abstain_tree_30(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.input_syllable_count <= 16.500000000000004 then
    begin
        if features.ranker_top_char_lm_score <= -4729.9999999999991 then
        begin
            Result := 0.007891622622916112;
        end
        else
        begin
            Result := -0.025406724089487822;
        end;
    end
    else
    begin
        Result := -0.042804064525005521;
    end;
end;

function long_final_abstain_tree_31(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 108097173.50000001 then
    begin
        if features.ranker_second_score <= 61071288.500000007 then
        begin
            Result := -0.0050114637572138141;
        end
        else
        begin
            Result := -0.06569063388814414;
        end;
    end
    else
    begin
        Result := 0.017581621933444362;
    end;
end;

function long_final_abstain_tree_32(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_second_score <= 34345818.000000007 then
    begin
        Result := -0.024651009210287841;
    end
    else
    begin
        if features.ranker_top_margin <= 18254850.000000004 then
        begin
            Result := -0.01021943399416135;
        end
        else
        begin
            Result := 0.022372257691589775;
        end;
    end;
end;

function long_final_abstain_tree_33(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.input_syllable_count <= 16.500000000000004 then
    begin
        if features.input_syllable_count <= 11.500000000000002 then
        begin
            Result := -0.0057968849919631405;
        end
        else
        begin
            Result := 0.01967587600448021;
        end;
    end
    else
    begin
        Result := -0.041697871216527904;
    end;
end;

function long_final_abstain_tree_34(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.input_syllable_count <= 16.500000000000004 then
    begin
        if features.ranker_second_margin <= 339852702.50000006 then
        begin
            Result := 0.018840424707709864;
        end
        else
        begin
            Result := -0.0068676485948231947;
        end;
    end
    else
    begin
        Result := -0.039171602442221426;
    end;
end;

function long_final_abstain_tree_35(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_second_score <= 81017015.000000015 then
    begin
        Result := -0.012126317685925177;
    end
    else
    begin
        if features.ranker_top_score <= 108097173.50000001 then
        begin
            Result := -0.037969328745511934;
        end
        else
        begin
            Result := 0.029692461072479276;
        end;
    end;
end;

function long_final_abstain_tree_36(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.input_syllable_count <= 16.500000000000004 then
    begin
        if features.ranker_top_char_lm_score <= -4729.9999999999991 then
        begin
            Result := 0.0077826592111435566;
        end
        else
        begin
            Result := -0.038384340807282535;
        end;
    end
    else
    begin
        Result := -0.038335594434789295;
    end;
end;

function long_final_abstain_tree_37(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_score <= -6861.4999999999991 then
    begin
        Result := 0.021531390333787141;
    end
    else
    begin
        if features.input_syllable_count <= 15.500000000000002 then
        begin
            Result := -0.00064977875578106962;
        end
        else
        begin
            Result := -0.054119711015943477;
        end;
    end;
end;

function long_final_abstain_tree_38(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_second_score <= 34345818.000000007 then
    begin
        Result := -0.028437057521266951;
    end
    else
    begin
        if features.ranker_top_margin <= 18254850.000000004 then
        begin
            Result := -0.011402940536217909;
        end
        else
        begin
            Result := 0.019664997819139093;
        end;
    end;
end;

function long_final_abstain_tree_39(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_gain <= -604.49999999999989 then
    begin
        if features.ranker_top_score <= 72004342.000000015 then
        begin
            Result := 0.016470374085641427;
        end
        else
        begin
            Result := -0.066698948246961431;
        end;
    end
    else
    begin
        Result := 0.0033015323529092576;
    end;
end;

function long_final_abstain_tree_40(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 22522965.000000004 then
    begin
        if features.ranker_top_margin <= 5431110.0000000009 then
        begin
            Result := 0.011937099223313697;
        end
        else
        begin
            Result := -0.049226980036050742;
        end;
    end
    else
    begin
        Result := 0.013560189993100475;
    end;
end;

function long_final_abstain_tree_41(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_score <= -6649.9999999999991 then
    begin
        if features.ranker_top_score <= 108097173.50000001 then
        begin
            Result := -0.026120026110705893;
        end
        else
        begin
            Result := 0.041446595486552766;
        end;
    end
    else
    begin
        Result := -0.0090339618011176966;
    end;
end;

function long_final_abstain_tree_42(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_gain <= -604.49999999999989 then
    begin
        if features.ranker_top_char_lm_score <= -5549.9999999999991 then
        begin
            Result := -0.053301888955496056;
        end
        else
        begin
            Result := 0.007821553276892353;
        end;
    end
    else
    begin
        Result := 0.0075071056860807495;
    end;
end;

function long_final_abstain_tree_43(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_third_score <= -374271341.99999994 then
    begin
        Result := 0.015701266301818124;
    end
    else
    begin
        if features.input_syllable_count <= 15.500000000000002 then
        begin
            Result := 0.0022803570153567439;
        end
        else
        begin
            Result := -0.076101797135223984;
        end;
    end;
end;

function long_final_abstain_tree_44(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_gain <= -604.49999999999989 then
    begin
        if features.ranker_top_score <= 72004342.000000015 then
        begin
            Result := 0.01014774218605145;
        end
        else
        begin
            Result := -0.057374341262840994;
        end;
    end
    else
    begin
        Result := 0.0084940035091032023;
    end;
end;

function long_final_abstain_tree_45(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_gain <= -568.99999999999989 then
    begin
        Result := -0.021181817509955302;
    end
    else
    begin
        if features.ranker_second_score <= 34345818.000000007 then
        begin
            Result := -0.026329146944231444;
        end
        else
        begin
            Result := 0.01502041373913723;
        end;
    end;
end;

function long_final_abstain_tree_46(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_second_score <= 81017015.000000015 then
    begin
        if features.legacy_top_char_lm_score <= -5286.9999999999991 then
        begin
            Result := 0.0070420538177353512;
        end
        else
        begin
            Result := -0.042562276303782356;
        end;
    end
    else
    begin
        Result := 0.012545551747073938;
    end;
end;

function long_final_abstain_tree_47(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.input_syllable_count <= 14.500000000000002 then
    begin
        Result := 0.0055753828963486501;
    end
    else
    begin
        if features.ranker_second_margin <= 440690692.50000006 then
        begin
            Result := -0.052900739890080609;
        end
        else
        begin
            Result := 0.020437779662530086;
        end;
    end;
end;

function long_final_abstain_tree_48(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 22522965.000000004 then
    begin
        if features.ranker_top_margin <= 5431110.0000000009 then
        begin
            Result := 0.013618400082153537;
        end
        else
        begin
            Result := -0.034806755038311252;
        end;
    end
    else
    begin
        Result := 0.010244222094824671;
    end;
end;

function long_final_abstain_tree_49(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_score <= -4729.9999999999991 then
    begin
        if features.input_syllable_count <= 14.500000000000002 then
        begin
            Result := 0.012715892218419043;
        end
        else
        begin
            Result := -0.015436124224261206;
        end;
    end
    else
    begin
        Result := -0.024739652690349265;
    end;
end;

function long_final_abstain_tree_50(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_score <= -4729.9999999999991 then
    begin
        if features.ranker_third_score <= -374271341.99999994 then
        begin
            Result := 0.02360905879408581;
        end
        else
        begin
            Result := -0.0050087884857630358;
        end;
    end
    else
    begin
        Result := -0.036151485925650741;
    end;
end;

function long_final_abstain_tree_51(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_gain <= -604.49999999999989 then
    begin
        if features.ranker_top_score <= 72004342.000000015 then
        begin
            Result := 0.010312720967157126;
        end
        else
        begin
            Result := -0.05754918159071705;
        end;
    end
    else
    begin
        Result := 0.0056517254228872224;
    end;
end;

function long_final_abstain_tree_52(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_second_score <= 34345818.000000007 then
    begin
        Result := -0.032654596665393526;
    end
    else
    begin
        if features.ranker_top_margin <= 18254850.000000004 then
        begin
            Result := -0.01291801347149882;
        end
        else
        begin
            Result := 0.019304986341071018;
        end;
    end;
end;

function long_final_abstain_tree_53(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_second_score <= 126526156.00000001 then
    begin
        if features.ranker_top_margin <= 22522965.000000004 then
        begin
            Result := -0.020491509524215617;
        end
        else
        begin
            Result := 0.0047532695189364382;
        end;
    end
    else
    begin
        Result := 0.043702615010470014;
    end;
end;

function long_final_abstain_tree_54(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_score <= -5029.9999999999991 then
    begin
        if features.input_syllable_count <= 14.500000000000002 then
        begin
            Result := 0.014983051944974339;
        end
        else
        begin
            Result := -0.02637671084978227;
        end;
    end
    else
    begin
        Result := -0.030313928494892967;
    end;
end;

function long_final_abstain_tree_55(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.input_syllable_count <= 16.500000000000004 then
    begin
        if features.input_syllable_count <= 12.500000000000002 then
        begin
            Result := -0.0058778256196200121;
        end
        else
        begin
            Result := 0.020265899344949566;
        end;
    end
    else
    begin
        Result := -0.031813322970793353;
    end;
end;

function long_final_abstain_tree_56(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_second_score <= 81017015.000000015 then
    begin
        if features.legacy_top_char_lm_score <= -5286.9999999999991 then
        begin
            Result := 0.0061389788216653189;
        end
        else
        begin
            Result := -0.041113201599554429;
        end;
    end
    else
    begin
        Result := 0.013789304134522198;
    end;
end;

function long_final_abstain_tree_57(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_score <= -6649.9999999999991 then
    begin
        Result := 0.024802678821365741;
    end
    else
    begin
        if features.ranker_top_char_lm_score <= -6373.4999999999991 then
        begin
            Result := -0.055029417286192234;
        end
        else
        begin
            Result := 0.0034681465611152112;
        end;
    end;
end;

function long_final_abstain_tree_58(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_second_score <= 81017015.000000015 then
    begin
        if features.legacy_top_char_lm_score <= -5286.9999999999991 then
        begin
            Result := 0.0055772965401517816;
        end
        else
        begin
            Result := -0.051845760146035438;
        end;
    end
    else
    begin
        Result := 0.011134541803838088;
    end;
end;

function long_final_abstain_tree_59(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_score <= 108097173.50000001 then
    begin
        if features.ranker_second_score <= 77150933.000000015 then
        begin
            Result := 0.0027410493498755528;
        end
        else
        begin
            Result := -0.075487311540765475;
        end;
    end
    else
    begin
        Result := 0.012551996560214183;
    end;
end;
function long_final_abstain_score(
    const features: TncLongFinalAbstainFeatures): Int64;
var
    score: Double;
begin
    score := 0.0;
    score := score + long_final_abstain_tree_0(features);
    score := score + long_final_abstain_tree_1(features);
    score := score + long_final_abstain_tree_2(features);
    score := score + long_final_abstain_tree_3(features);
    score := score + long_final_abstain_tree_4(features);
    score := score + long_final_abstain_tree_5(features);
    score := score + long_final_abstain_tree_6(features);
    score := score + long_final_abstain_tree_7(features);
    score := score + long_final_abstain_tree_8(features);
    score := score + long_final_abstain_tree_9(features);
    score := score + long_final_abstain_tree_10(features);
    score := score + long_final_abstain_tree_11(features);
    score := score + long_final_abstain_tree_12(features);
    score := score + long_final_abstain_tree_13(features);
    score := score + long_final_abstain_tree_14(features);
    score := score + long_final_abstain_tree_15(features);
    score := score + long_final_abstain_tree_16(features);
    score := score + long_final_abstain_tree_17(features);
    score := score + long_final_abstain_tree_18(features);
    score := score + long_final_abstain_tree_19(features);
    score := score + long_final_abstain_tree_20(features);
    score := score + long_final_abstain_tree_21(features);
    score := score + long_final_abstain_tree_22(features);
    score := score + long_final_abstain_tree_23(features);
    score := score + long_final_abstain_tree_24(features);
    score := score + long_final_abstain_tree_25(features);
    score := score + long_final_abstain_tree_26(features);
    score := score + long_final_abstain_tree_27(features);
    score := score + long_final_abstain_tree_28(features);
    score := score + long_final_abstain_tree_29(features);
    score := score + long_final_abstain_tree_30(features);
    score := score + long_final_abstain_tree_31(features);
    score := score + long_final_abstain_tree_32(features);
    score := score + long_final_abstain_tree_33(features);
    score := score + long_final_abstain_tree_34(features);
    score := score + long_final_abstain_tree_35(features);
    score := score + long_final_abstain_tree_36(features);
    score := score + long_final_abstain_tree_37(features);
    score := score + long_final_abstain_tree_38(features);
    score := score + long_final_abstain_tree_39(features);
    score := score + long_final_abstain_tree_40(features);
    score := score + long_final_abstain_tree_41(features);
    score := score + long_final_abstain_tree_42(features);
    score := score + long_final_abstain_tree_43(features);
    score := score + long_final_abstain_tree_44(features);
    score := score + long_final_abstain_tree_45(features);
    score := score + long_final_abstain_tree_46(features);
    score := score + long_final_abstain_tree_47(features);
    score := score + long_final_abstain_tree_48(features);
    score := score + long_final_abstain_tree_49(features);
    score := score + long_final_abstain_tree_50(features);
    score := score + long_final_abstain_tree_51(features);
    score := score + long_final_abstain_tree_52(features);
    score := score + long_final_abstain_tree_53(features);
    score := score + long_final_abstain_tree_54(features);
    score := score + long_final_abstain_tree_55(features);
    score := score + long_final_abstain_tree_56(features);
    score := score + long_final_abstain_tree_57(features);
    score := score + long_final_abstain_tree_58(features);
    score := score + long_final_abstain_tree_59(features);
    Result := Trunc(score * c_long_final_abstain_score_scale);
end;

function long_final_abstain_self_test: Boolean;
var
    features: TncLongFinalAbstainFeatures;
begin
    FillChar(features, SizeOf(features), 0);
    if long_final_abstain_score(features) <>
        c_long_final_abstain_reference_score then
    begin
        Exit(False);
    end;

    features.candidate_count := -1000000;
    features.complete_count := -1000000;
    features.chain_count := -1000000;
    features.input_syllable_count := -1000000;
    features.has_left_context := False;
    features.ranker_top_score := -1000000;
    features.ranker_second_score := -1000000;
    features.ranker_third_score := -1000000;
    features.ranker_top_margin := -1000000;
    features.ranker_second_margin := -1000000;
    features.ranker_score_range := -1000000;
    features.ranker_top_legacy_rank := -1000000;
    features.ranker_top_chain_rank := -1000000;
    features.ranker_top_complete := False;
    features.ranker_top_user := False;
    features.ranker_top_dictionary := False;
    features.ranker_top_chain := False;
    features.legacy_top_ranker_score := -1000000;
    features.ranker_top_over_legacy_margin := -1000000;
    features.ranker_disagrees := False;
    features.legacy_top_complete := False;
    features.legacy_top_user := False;
    features.legacy_top_dictionary := False;
    features.legacy_top_chain := False;
    features.legacy_top_chain_rank := -1000000;
    features.ranker_top_char_lm_score := -1000000;
    features.legacy_top_char_lm_score := -1000000;
    features.ranker_top_char_lm_gain := -1000000;
    features.ranker_top_path_confidence := -1000000;
    features.legacy_top_path_confidence := -1000000;
    features.ranker_top_path_confidence_gain := -1000000;
    features.ranker_top_query_choice_bonus := -1000000;
    features.legacy_top_query_choice_bonus := -1000000;
    if long_final_abstain_score(features) <>
        c_long_final_abstain_reference_score_low then
    begin
        Exit(False);
    end;

    features.candidate_count := 1000000;
    features.complete_count := 1000000;
    features.chain_count := 1000000;
    features.input_syllable_count := 1000000;
    features.has_left_context := True;
    features.ranker_top_score := 1000000;
    features.ranker_second_score := 1000000;
    features.ranker_third_score := 1000000;
    features.ranker_top_margin := 1000000;
    features.ranker_second_margin := 1000000;
    features.ranker_score_range := 1000000;
    features.ranker_top_legacy_rank := 1000000;
    features.ranker_top_chain_rank := 1000000;
    features.ranker_top_complete := True;
    features.ranker_top_user := True;
    features.ranker_top_dictionary := True;
    features.ranker_top_chain := True;
    features.legacy_top_ranker_score := 1000000;
    features.ranker_top_over_legacy_margin := 1000000;
    features.ranker_disagrees := True;
    features.legacy_top_complete := True;
    features.legacy_top_user := True;
    features.legacy_top_dictionary := True;
    features.legacy_top_chain := True;
    features.legacy_top_chain_rank := 1000000;
    features.ranker_top_char_lm_score := 1000000;
    features.legacy_top_char_lm_score := 1000000;
    features.ranker_top_char_lm_gain := 1000000;
    features.ranker_top_path_confidence := 1000000;
    features.legacy_top_path_confidence := 1000000;
    features.ranker_top_path_confidence_gain := 1000000;
    features.ranker_top_query_choice_bonus := 1000000;
    features.legacy_top_query_choice_bonus := 1000000;
    if long_final_abstain_score(features) <>
        c_long_final_abstain_reference_score_high then
    begin
        Exit(False);
    end;

    features.candidate_count := 137;
    features.complete_count := -274;
    features.chain_count := 411;
    features.input_syllable_count := -548;
    features.has_left_context := False;
    features.ranker_top_score := -822;
    features.ranker_second_score := 959;
    features.ranker_third_score := -1096;
    features.ranker_top_margin := 1233;
    features.ranker_second_margin := -1370;
    features.ranker_score_range := 1507;
    features.ranker_top_legacy_rank := -1644;
    features.ranker_top_chain_rank := 1781;
    features.ranker_top_complete := True;
    features.ranker_top_user := False;
    features.ranker_top_dictionary := True;
    features.ranker_top_chain := False;
    features.legacy_top_ranker_score := -2466;
    features.ranker_top_over_legacy_margin := 2603;
    features.ranker_disagrees := True;
    features.legacy_top_complete := False;
    features.legacy_top_user := True;
    features.legacy_top_dictionary := False;
    features.legacy_top_chain := True;
    features.legacy_top_chain_rank := 3425;
    features.ranker_top_char_lm_score := -3562;
    features.legacy_top_char_lm_score := 3699;
    features.ranker_top_char_lm_gain := -3836;
    features.ranker_top_path_confidence := 3973;
    features.legacy_top_path_confidence := -4110;
    features.ranker_top_path_confidence_gain := 4247;
    features.ranker_top_query_choice_bonus := -4384;
    features.legacy_top_query_choice_bonus := 4521;
    Result := long_final_abstain_score(features) =
        c_long_final_abstain_reference_score_mixed;
end;

end.
