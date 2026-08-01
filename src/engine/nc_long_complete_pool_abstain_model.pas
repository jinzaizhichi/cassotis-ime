unit nc_long_complete_pool_abstain_model;

interface

uses
    nc_long_final_abstain_model;

const
    c_long_complete_pool_abstain_feature_count: Integer = 49;
    c_long_complete_pool_abstain_tree_count: Integer = 60;
    c_long_complete_pool_abstain_score_scale: Double = 100000000.0;
    c_long_complete_pool_abstain_reference_score: Int64 = -65652733;
    c_long_complete_pool_abstain_reference_score_low: Int64 = -69970760;
    c_long_complete_pool_abstain_reference_score_high: Int64 = 34610868;
    c_long_complete_pool_abstain_reference_score_mixed: Int64 = -69970760;

function long_complete_pool_abstain_score(
    const features: TncLongFinalAbstainFeatures): Int64;
function long_complete_pool_abstain_self_test: Boolean;

implementation

{ Unified long-sentence ranker confidence gate. The generated unit has no LightGBM runtime dependency.
  Training report SHA-256: 3EE53E4E1BD3F6AFACC12E1434ADE61668B4A962BB772572FB1D1A266E732C64
  LightGBM model SHA-256: 624F015868935717CB08C2CC2C3E99AA390EFD3BBFC6B8924D9F9DCEC722F0B2 }

function long_complete_pool_abstain_tree_0(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 101835622.50000001 then
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := 0.38683867547061407;
        end
        else
        begin
            Result := 0.41799985720946969;
        end;
    end
    else
    begin
        Result := 0.4652667139599298;
    end;
end;

function long_complete_pool_abstain_tree_1(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 101835622.50000001 then
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := -0.036881826275182876;
        end
        else
        begin
            Result := -0.0076918160423754657;
        end;
    end
    else
    begin
        Result := 0.039209497505091007;
    end;
end;

function long_complete_pool_abstain_tree_2(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_over_legacy_margin <= 91911487.500000015 then
    begin
        Result := -0.023825646774745707;
    end
    else
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := 0.00029995892635609981;
        end
        else
        begin
            Result := 0.034178156098598041;
        end;
    end;
end;

function long_complete_pool_abstain_tree_3(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 107028692.50000001 then
    begin
        if features.ranker_top_margin <= 28569117.000000004 then
        begin
            Result := -0.034703364553791624;
        end
        else
        begin
            Result := -0.0074044102662188943;
        end;
    end
    else
    begin
        Result := 0.038984846203046382;
    end;
end;

function long_complete_pool_abstain_tree_4(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_over_legacy_margin <= 91911487.500000015 then
    begin
        Result := -0.021927453962108122;
    end
    else
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := -0.00076891444400487105;
        end
        else
        begin
            Result := 0.033618796603687384;
        end;
    end;
end;

function long_complete_pool_abstain_tree_5(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 66408992.500000007 then
    begin
        Result := -0.024943649574306698;
    end
    else
    begin
        if features.ranker_top_margin <= 133820812.50000001 then
        begin
            Result := 0.0087976492051046826;
        end
        else
        begin
            Result := 0.044789962006140049;
        end;
    end;
end;

function long_complete_pool_abstain_tree_6(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 133820812.50000001 then
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := -0.029170026683101608;
        end
        else
        begin
            Result := -0.0010339228028789056;
        end;
    end
    else
    begin
        Result := 0.04352526326381579;
    end;
end;

function long_complete_pool_abstain_tree_7(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 66408992.500000007 then
    begin
        Result := -0.022534362858572892;
    end
    else
    begin
        if features.ranker_top_margin <= 133820812.50000001 then
        begin
            Result := 0.0083273251953634424;
        end
        else
        begin
            Result := 0.041094786166658369;
        end;
    end;
end;

function long_complete_pool_abstain_tree_8(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 91827075.500000015 then
    begin
        if features.ranker_top_pair_evidence <= 2617.5000000000005 then
        begin
            Result := -0.022383680860635233;
        end
        else
        begin
            Result := 0.0080785418206567247;
        end;
    end
    else
    begin
        Result := 0.03076455797620798;
    end;
end;

function long_complete_pool_abstain_tree_9(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 64987195.500000007 then
    begin
        Result := -0.021259969360108526;
    end
    else
    begin
        if features.ranker_top_margin <= 133820812.50000001 then
        begin
            Result := 0.0079387889992205314;
        end
        else
        begin
            Result := 0.040587474415734688;
        end;
    end;
end;

function long_complete_pool_abstain_tree_10(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_over_legacy_margin <= 101535359.50000001 then
    begin
        Result := -0.016714867400658445;
    end
    else
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := -0.0028975004198719999;
        end
        else
        begin
            Result := 0.031014197828959353;
        end;
    end;
end;

function long_complete_pool_abstain_tree_11(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 104989663.00000001 then
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := -0.026690911751625163;
        end
        else
        begin
            Result := -0.0026195689952226466;
        end;
    end
    else
    begin
        Result := 0.030915580396378303;
    end;
end;

function long_complete_pool_abstain_tree_12(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 66408992.500000007 then
    begin
        Result := -0.018393632498459128;
    end
    else
    begin
        if features.ranker_top_margin <= 133820812.50000001 then
        begin
            Result := 0.0076787052300924591;
        end
        else
        begin
            Result := 0.037845376119103456;
        end;
    end;
end;

function long_complete_pool_abstain_tree_13(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 64987195.500000007 then
    begin
        Result := -0.018342520809871227;
    end
    else
    begin
        if features.ranker_top_margin <= 133820812.50000001 then
        begin
            Result := 0.008869627217493313;
        end
        else
        begin
            Result := 0.037690713625814692;
        end;
    end;
end;

function long_complete_pool_abstain_tree_14(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 133820812.50000001 then
    begin
        if features.ranker_top_char_lm_gain <= 456.50000000000006 then
        begin
            Result := -0.023229045233058149;
        end
        else
        begin
            Result := 0.00091127991970167471;
        end;
    end
    else
    begin
        Result := 0.035650819879555831;
    end;
end;

function long_complete_pool_abstain_tree_15(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 66408992.500000007 then
    begin
        Result := -0.017194446641309175;
    end
    else
    begin
        if features.ranker_top_margin <= 176635662.00000003 then
        begin
            Result := 0.0096491236499591081;
        end
        else
        begin
            Result := 0.040032953024066009;
        end;
    end;
end;

function long_complete_pool_abstain_tree_16(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 107028692.50000001 then
    begin
        if features.ranker_top_pair_evidence <= 2617.5000000000005 then
        begin
            Result := -0.017047398422922667;
        end
        else
        begin
            Result := 0.011539336902334973;
        end;
    end
    else
    begin
        Result := 0.028461068528105652;
    end;
end;

function long_complete_pool_abstain_tree_17(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 133820812.50000001 then
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := -0.021653803722958588;
        end
        else
        begin
            Result := 0.0031372245661597199;
        end;
    end
    else
    begin
        Result := 0.033477794991897715;
    end;
end;

function long_complete_pool_abstain_tree_18(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_gain <= 536.50000000000011 then
    begin
        Result := -0.017382151548569168;
    end
    else
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := -0.0071365968450468834;
        end
        else
        begin
            Result := 0.022235491380288921;
        end;
    end;
end;

function long_complete_pool_abstain_tree_19(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_gain <= 456.50000000000006 then
    begin
        Result := -0.018143084771159116;
    end
    else
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := -0.0096910777024692158;
        end
        else
        begin
            Result := 0.020536493475734358;
        end;
    end;
end;

function long_complete_pool_abstain_tree_20(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 133820812.50000001 then
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := -0.020744358644926412;
        end
        else
        begin
            Result := 0.0013953479520426532;
        end;
    end
    else
    begin
        Result := 0.032122582988305733;
    end;
end;

function long_complete_pool_abstain_tree_21(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 133820812.50000001 then
    begin
        if features.ranker_top_char_lm_gain <= 132.50000000000003 then
        begin
            Result := -0.029250318790058207;
        end
        else
        begin
            Result := -0.0019989161074064395;
        end;
    end
    else
    begin
        Result := 0.031881604859322267;
    end;
end;

function long_complete_pool_abstain_tree_22(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 133820812.50000001 then
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := -0.018580300083932879;
        end
        else
        begin
            Result := 0.0021901631452926479;
        end;
    end
    else
    begin
        Result := 0.029654956146467772;
    end;
end;

function long_complete_pool_abstain_tree_23(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 66408992.500000007 then
    begin
        Result := -0.013564803481397318;
    end
    else
    begin
        if features.ranker_top_margin <= 196720316.00000003 then
        begin
            Result := 0.0094352598102309618;
        end
        else
        begin
            Result := 0.039984754909615471;
        end;
    end;
end;

function long_complete_pool_abstain_tree_24(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 64987195.500000007 then
    begin
        Result := -0.013085071292450585;
    end
    else
    begin
        if features.ranker_top_margin <= 176635662.00000003 then
        begin
            Result := 0.0086994182063784772;
        end
        else
        begin
            Result := 0.035583977514109959;
        end;
    end;
end;

function long_complete_pool_abstain_tree_25(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 66408992.500000007 then
    begin
        Result := -0.013005609334532701;
    end
    else
    begin
        if features.ranker_top_score <= 347790578.50000006 then
        begin
            Result := 0.0073851993362388357;
        end
        else
        begin
            Result := 0.033573345692923751;
        end;
    end;
end;

function long_complete_pool_abstain_tree_26(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 66408992.500000007 then
    begin
        if features.ranker_top_char_lm_gain <= 117.50000000000001 then
        begin
            Result := -0.032187218269447364;
        end
        else
        begin
            Result := -0.0062432533684969394;
        end;
    end
    else
    begin
        Result := 0.015828370589619466;
    end;
end;

function long_complete_pool_abstain_tree_27(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 133820812.50000001 then
    begin
        if features.ranker_top_pair_evidence <= 2653.5000000000005 then
        begin
            Result := -0.011817418804848646;
        end
        else
        begin
            Result := 0.013036072952047673;
        end;
    end
    else
    begin
        Result := 0.027395734799008649;
    end;
end;

function long_complete_pool_abstain_tree_28(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_char_lm_gain <= 536.50000000000011 then
    begin
        Result := -0.01260872071927766;
    end
    else
    begin
        if features.ranker_top_score <= 355096991.50000006 then
        begin
            Result := 0.0040077447760274165;
        end
        else
        begin
            Result := 0.029647374728530261;
        end;
    end;
end;

function long_complete_pool_abstain_tree_29(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 133820812.50000001 then
    begin
        if features.ranker_top_pair_evidence <= 2839.5000000000005 then
        begin
            Result := -0.010077598673693256;
        end
        else
        begin
            Result := 0.015037589184810424;
        end;
    end
    else
    begin
        Result := 0.027002399504296292;
    end;
end;

function long_complete_pool_abstain_tree_30(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 133820812.50000001 then
    begin
        if features.ranker_top_pair_evidence <= 1090.5000000000002 then
        begin
            Result := -0.015665484887404622;
        end
        else
        begin
            Result := 0.003348140627220495;
        end;
    end
    else
    begin
        Result := 0.026357521672269228;
    end;
end;

function long_complete_pool_abstain_tree_31(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 63659598.000000007 then
    begin
        Result := -0.010243078290772511;
    end
    else
    begin
        if features.ranker_top_margin <= 196720316.00000003 then
        begin
            Result := 0.0072720162690806832;
        end
        else
        begin
            Result := 0.035788726370022804;
        end;
    end;
end;

function long_complete_pool_abstain_tree_32(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 44291133.500000007 then
    begin
        Result := -0.013650726569549427;
    end
    else
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := -0.0054699434521887792;
        end
        else
        begin
            Result := 0.017889749496899445;
        end;
    end;
end;

function long_complete_pool_abstain_tree_33(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 133820812.50000001 then
    begin
        if features.ranker_top_pool_rank <= 4.5000000000000009 then
        begin
            Result := -0.010571669100745772;
        end
        else
        begin
            Result := 0.01219791689885691;
        end;
    end
    else
    begin
        Result := 0.024635471157518372;
    end;
end;

function long_complete_pool_abstain_tree_34(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 42131572.000000007 then
    begin
        Result := -0.012275965761247259;
    end
    else
    begin
        if features.ranker_top_word_lm_bonus <= 458.50000000000006 then
        begin
            Result := 0.0023414195034079962;
        end
        else
        begin
            Result := 0.02490337397622417;
        end;
    end;
end;

function long_complete_pool_abstain_tree_35(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 133820812.50000001 then
    begin
        if features.ranker_top_char_lm_gain <= 117.50000000000001 then
        begin
            Result := -0.025674347403409268;
        end
        else
        begin
            Result := -0.00054318129199102956;
        end;
    end
    else
    begin
        Result := 0.025122853257234668;
    end;
end;

function long_complete_pool_abstain_tree_36(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
    begin
        Result := -0.013327288163803899;
    end
    else
    begin
        if features.ranker_top_char_lm_gain <= 160.50000000000003 then
        begin
            Result := -0.019054896479289749;
        end
        else
        begin
            Result := 0.013553297103337613;
        end;
    end;
end;

function long_complete_pool_abstain_tree_37(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
    begin
        Result := -0.013235543912565919;
    end
    else
    begin
        if features.ranker_top_char_lm_gain <= 160.50000000000003 then
        begin
            Result := -0.01784737026592239;
        end
        else
        begin
            Result := 0.013283622615012791;
        end;
    end;
end;

function long_complete_pool_abstain_tree_38(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 32443309.000000004 then
    begin
        Result := -0.015442772943824148;
    end
    else
    begin
        if features.ranker_top_word_lm_bonus <= 391.00000000000006 then
        begin
            Result := 0.00078668487151261376;
        end
        else
        begin
            Result := 0.020375226495590811;
        end;
    end;
end;

function long_complete_pool_abstain_tree_39(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_pair_evidence <= 1060.5000000000002 then
    begin
        Result := -0.011630514778814376;
    end
    else
    begin
        if features.ranker_top_char_lm_gain <= 50.500000000000007 then
        begin
            Result := -0.017275341377726645;
        end
        else
        begin
            Result := 0.013349158661466234;
        end;
    end;
end;

function long_complete_pool_abstain_tree_40(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 176635662.00000003 then
    begin
        if features.ranker_top_char_lm_gain <= -225.49999999999997 then
        begin
            Result := -0.045301549716434943;
        end
        else
        begin
            Result := -0.002121273259935007;
        end;
    end
    else
    begin
        Result := 0.029044775051449506;
    end;
end;

function long_complete_pool_abstain_tree_41(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 32443309.000000004 then
    begin
        Result := -0.014118308002219937;
    end
    else
    begin
        if features.ranker_top_margin <= 176635662.00000003 then
        begin
            Result := 0.0031541867849426974;
        end
        else
        begin
            Result := 0.029636547289279447;
        end;
    end;
end;

function long_complete_pool_abstain_tree_42(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_word_lm_gain <= 52.500000000000007 then
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := -0.015154076920771633;
        end
        else
        begin
            Result := 0.001500816562440955;
        end;
    end
    else
    begin
        Result := 0.012228558786443267;
    end;
end;

function long_complete_pool_abstain_tree_43(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 176635662.00000003 then
    begin
        if features.ranker_top_char_lm_gain <= 117.50000000000001 then
        begin
            Result := -0.020966313969366542;
        end
        else
        begin
            Result := 6.061053348116999E-05;
        end;
    end
    else
    begin
        Result := 0.028006782715179167;
    end;
end;

function long_complete_pool_abstain_tree_44(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 196720316.00000003 then
    begin
        if features.ranker_top_pool_rank <= 4.5000000000000009 then
        begin
            Result := -0.0072307534576738462;
        end
        else
        begin
            Result := 0.013065857452748353;
        end;
    end
    else
    begin
        Result := 0.03342761149291551;
    end;
end;

function long_complete_pool_abstain_tree_45(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 176635662.00000003 then
    begin
        if features.ranker_top_char_lm_gain <= 117.50000000000001 then
        begin
            Result := -0.021536791428783123;
        end
        else
        begin
            Result := -0.00027908809862772039;
        end;
    end
    else
    begin
        Result := 0.027456732995535395;
    end;
end;

function long_complete_pool_abstain_tree_46(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 196720316.00000003 then
    begin
        if features.ranker_top_pool_rank <= 5.5000000000000009 then
        begin
            Result := -0.0064622639553227256;
        end
        else
        begin
            Result := 0.015523655963483528;
        end;
    end
    else
    begin
        Result := 0.030516545623420356;
    end;
end;

function long_complete_pool_abstain_tree_47(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_word_lm_bonus <= 458.50000000000006 then
    begin
        if features.ranker_top_char_lm_gain <= 117.50000000000001 then
        begin
            Result := -0.029073581989200466;
        end
        else
        begin
            Result := -0.0021190576287349254;
        end;
    end
    else
    begin
        Result := 0.014604742851920038;
    end;
end;

function long_complete_pool_abstain_tree_48(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 42131572.000000007 then
    begin
        Result := -0.010692095061330176;
    end
    else
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := -0.0037400271761002992;
        end
        else
        begin
            Result := 0.014257494418614108;
        end;
    end;
end;

function long_complete_pool_abstain_tree_49(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
    begin
        Result := -0.010738023214977681;
    end
    else
    begin
        if features.ranker_top_char_lm_gain <= -225.49999999999997 then
        begin
            Result := -0.049425156881971875;
        end
        else
        begin
            Result := 0.0097131726514116824;
        end;
    end;
end;

function long_complete_pool_abstain_tree_50(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_pair_evidence <= 1035.0000000000002 then
    begin
        Result := -0.010481500420579085;
    end
    else
    begin
        if features.ranker_top_margin <= 180857442.00000003 then
        begin
            Result := 0.0043069207174758267;
        end
        else
        begin
            Result := 0.032082888964017432;
        end;
    end;
end;

function long_complete_pool_abstain_tree_51(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 109827178.00000001 then
    begin
        if features.ranker_top_pool_rank <= 4.5000000000000009 then
        begin
            Result := -0.0089533122053636598;
        end
        else
        begin
            Result := 0.0099629201158360804;
        end;
    end
    else
    begin
        Result := 0.01632329578858811;
    end;
end;

function long_complete_pool_abstain_tree_52(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_word_lm_gain <= 52.500000000000007 then
    begin
        if features.ranker_top_char_lm_gain <= 117.50000000000001 then
        begin
            Result := -0.031152376516804119;
        end
        else
        begin
            Result := -0.0015921672181793691;
        end;
    end
    else
    begin
        Result := 0.011648752172416144;
    end;
end;

function long_complete_pool_abstain_tree_53(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_pair_evidence <= 1090.5000000000002 then
    begin
        if features.ranker_top_char_lm_gain <= 117.50000000000001 then
        begin
            Result := -0.029431641139838708;
        end
        else
        begin
            Result := -0.0049226603878215289;
        end;
    end
    else
    begin
        Result := 0.0094234784356443963;
    end;
end;

function long_complete_pool_abstain_tree_54(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_word_lm_bonus <= 458.50000000000006 then
    begin
        if features.ranker_top_margin <= 28569117.000000004 then
        begin
            Result := -0.016571232663471769;
        end
        else
        begin
            Result := 0.00047315827813990976;
        end;
    end
    else
    begin
        Result := 0.012222342710589163;
    end;
end;

function long_complete_pool_abstain_tree_55(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 42131572.000000007 then
    begin
        Result := -0.0097063273999512673;
    end
    else
    begin
        if features.ranker_top_margin <= 196720316.00000003 then
        begin
            Result := 0.0040101243036525878;
        end
        else
        begin
            Result := 0.027762096866200542;
        end;
    end;
end;

function long_complete_pool_abstain_tree_56(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 196720316.00000003 then
    begin
        if features.ranker_top_pool_source_kind <= 2.0000000000000004 then
        begin
            Result := -0.0091198550108494061;
        end
        else
        begin
            Result := 0.0044175228515991203;
        end;
    end
    else
    begin
        Result := 0.027806571202549688;
    end;
end;

function long_complete_pool_abstain_tree_57(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_margin <= 196720316.00000003 then
    begin
        if features.ranker_top_pair_evidence <= 1090.5000000000002 then
        begin
            Result := -0.0092645509063182269;
        end
        else
        begin
            Result := 0.0040306606884711951;
        end;
    end
    else
    begin
        Result := 0.028171015953057089;
    end;
end;

function long_complete_pool_abstain_tree_58(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_pair_evidence <= 1090.5000000000002 then
    begin
        Result := -0.0076722401096418315;
    end
    else
    begin
        if features.ranker_top_margin <= 180857442.00000003 then
        begin
            Result := 0.0041011965299923596;
        end
        else
        begin
            Result := 0.03034971033134223;
        end;
    end;
end;

function long_complete_pool_abstain_tree_59(
    const features: TncLongFinalAbstainFeatures): Double;
begin
    if features.ranker_top_word_lm_bonus <= 505.50000000000006 then
    begin
        if features.ranker_top_char_lm_gain <= 117.50000000000001 then
        begin
            Result := -0.023858834648141727;
        end
        else
        begin
            Result := -0.00095061167843369298;
        end;
    end
    else
    begin
        Result := 0.013116705175890225;
    end;
end;
function long_complete_pool_abstain_score(
    const features: TncLongFinalAbstainFeatures): Int64;
var
    score: Double;
begin
    score := 0.0;
    score := score + long_complete_pool_abstain_tree_0(features);
    score := score + long_complete_pool_abstain_tree_1(features);
    score := score + long_complete_pool_abstain_tree_2(features);
    score := score + long_complete_pool_abstain_tree_3(features);
    score := score + long_complete_pool_abstain_tree_4(features);
    score := score + long_complete_pool_abstain_tree_5(features);
    score := score + long_complete_pool_abstain_tree_6(features);
    score := score + long_complete_pool_abstain_tree_7(features);
    score := score + long_complete_pool_abstain_tree_8(features);
    score := score + long_complete_pool_abstain_tree_9(features);
    score := score + long_complete_pool_abstain_tree_10(features);
    score := score + long_complete_pool_abstain_tree_11(features);
    score := score + long_complete_pool_abstain_tree_12(features);
    score := score + long_complete_pool_abstain_tree_13(features);
    score := score + long_complete_pool_abstain_tree_14(features);
    score := score + long_complete_pool_abstain_tree_15(features);
    score := score + long_complete_pool_abstain_tree_16(features);
    score := score + long_complete_pool_abstain_tree_17(features);
    score := score + long_complete_pool_abstain_tree_18(features);
    score := score + long_complete_pool_abstain_tree_19(features);
    score := score + long_complete_pool_abstain_tree_20(features);
    score := score + long_complete_pool_abstain_tree_21(features);
    score := score + long_complete_pool_abstain_tree_22(features);
    score := score + long_complete_pool_abstain_tree_23(features);
    score := score + long_complete_pool_abstain_tree_24(features);
    score := score + long_complete_pool_abstain_tree_25(features);
    score := score + long_complete_pool_abstain_tree_26(features);
    score := score + long_complete_pool_abstain_tree_27(features);
    score := score + long_complete_pool_abstain_tree_28(features);
    score := score + long_complete_pool_abstain_tree_29(features);
    score := score + long_complete_pool_abstain_tree_30(features);
    score := score + long_complete_pool_abstain_tree_31(features);
    score := score + long_complete_pool_abstain_tree_32(features);
    score := score + long_complete_pool_abstain_tree_33(features);
    score := score + long_complete_pool_abstain_tree_34(features);
    score := score + long_complete_pool_abstain_tree_35(features);
    score := score + long_complete_pool_abstain_tree_36(features);
    score := score + long_complete_pool_abstain_tree_37(features);
    score := score + long_complete_pool_abstain_tree_38(features);
    score := score + long_complete_pool_abstain_tree_39(features);
    score := score + long_complete_pool_abstain_tree_40(features);
    score := score + long_complete_pool_abstain_tree_41(features);
    score := score + long_complete_pool_abstain_tree_42(features);
    score := score + long_complete_pool_abstain_tree_43(features);
    score := score + long_complete_pool_abstain_tree_44(features);
    score := score + long_complete_pool_abstain_tree_45(features);
    score := score + long_complete_pool_abstain_tree_46(features);
    score := score + long_complete_pool_abstain_tree_47(features);
    score := score + long_complete_pool_abstain_tree_48(features);
    score := score + long_complete_pool_abstain_tree_49(features);
    score := score + long_complete_pool_abstain_tree_50(features);
    score := score + long_complete_pool_abstain_tree_51(features);
    score := score + long_complete_pool_abstain_tree_52(features);
    score := score + long_complete_pool_abstain_tree_53(features);
    score := score + long_complete_pool_abstain_tree_54(features);
    score := score + long_complete_pool_abstain_tree_55(features);
    score := score + long_complete_pool_abstain_tree_56(features);
    score := score + long_complete_pool_abstain_tree_57(features);
    score := score + long_complete_pool_abstain_tree_58(features);
    score := score + long_complete_pool_abstain_tree_59(features);
    Result := Trunc(score * c_long_complete_pool_abstain_score_scale);
end;

function long_complete_pool_abstain_self_test: Boolean;
var
    features: TncLongFinalAbstainFeatures;
begin
    FillChar(features, SizeOf(features), 0);
    if long_complete_pool_abstain_score(features) <>
        c_long_complete_pool_abstain_reference_score then
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
    features.ranker_top_pool_source_kind := -1000000;
    features.legacy_top_pool_source_kind := -1000000;
    features.ranker_top_pool_rank := -1000000;
    features.legacy_top_pool_rank := -1000000;
    features.ranker_top_pair_evidence := -1000000;
    features.legacy_top_pair_evidence := -1000000;
    features.ranker_top_word_lm_bonus := -1000000;
    features.legacy_top_word_lm_bonus := -1000000;
    features.ranker_top_word_lm_gain := -1000000;
    features.ranker_top_consensus_support := -1000000;
    features.legacy_top_consensus_support := -1000000;
    features.ranker_top_consensus_gain := -1000000;
    features.ranker_top_proper_name_confidence := -1000000;
    features.legacy_top_proper_name_confidence := -1000000;
    features.ranker_top_local_pairwise_score := -1000000;
    features.legacy_top_local_pairwise_score := -1000000;
    if long_complete_pool_abstain_score(features) <>
        c_long_complete_pool_abstain_reference_score_low then
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
    features.ranker_top_pool_source_kind := 1000000;
    features.legacy_top_pool_source_kind := 1000000;
    features.ranker_top_pool_rank := 1000000;
    features.legacy_top_pool_rank := 1000000;
    features.ranker_top_pair_evidence := 1000000;
    features.legacy_top_pair_evidence := 1000000;
    features.ranker_top_word_lm_bonus := 1000000;
    features.legacy_top_word_lm_bonus := 1000000;
    features.ranker_top_word_lm_gain := 1000000;
    features.ranker_top_consensus_support := 1000000;
    features.legacy_top_consensus_support := 1000000;
    features.ranker_top_consensus_gain := 1000000;
    features.ranker_top_proper_name_confidence := 1000000;
    features.legacy_top_proper_name_confidence := 1000000;
    features.ranker_top_local_pairwise_score := 1000000;
    features.legacy_top_local_pairwise_score := 1000000;
    if long_complete_pool_abstain_score(features) <>
        c_long_complete_pool_abstain_reference_score_high then
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
    features.ranker_top_pool_source_kind := -4658;
    features.legacy_top_pool_source_kind := 4795;
    features.ranker_top_pool_rank := -4932;
    features.legacy_top_pool_rank := 5069;
    features.ranker_top_pair_evidence := -5206;
    features.legacy_top_pair_evidence := 5343;
    features.ranker_top_word_lm_bonus := -5480;
    features.legacy_top_word_lm_bonus := 5617;
    features.ranker_top_word_lm_gain := -5754;
    features.ranker_top_consensus_support := 5891;
    features.legacy_top_consensus_support := -6028;
    features.ranker_top_consensus_gain := 6165;
    features.ranker_top_proper_name_confidence := -6302;
    features.legacy_top_proper_name_confidence := 6439;
    features.ranker_top_local_pairwise_score := -6576;
    features.legacy_top_local_pairwise_score := 6713;
    Result := long_complete_pool_abstain_score(features) =
        c_long_complete_pool_abstain_reference_score_mixed;
end;

end.
