unit nc_types;

interface

const
    c_default_candidate_font_name = 'Microsoft YaHei UI';
    c_min_candidate_font_size = 7;
    c_default_candidate_font_size = 12;
    c_max_candidate_font_size = 18;
    c_candidate_font_layout_reference_size = 10;
    c_candidate_font_size_level_count = 11;
    c_default_candidate_font_size_level = 5;
    // Preserve every legacy 7..13 value while extending the top end by four steps.
    c_candidate_font_size_levels: array[0..c_candidate_font_size_level_count - 1]
        of Integer = (7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18);
    c_default_candidate_page_size = 9;
    c_min_candidate_page_size = 3;
    c_max_candidate_page_size = 9;
    c_default_candidate_color_scheme = 0;
    c_min_candidate_color_scheme = 0;
    c_max_candidate_color_scheme = 5;

type
    TncCandidateSource = (cs_rule, cs_user);
    TncLogLevel = (ll_debug, ll_info, ll_warn, ll_error);

    TncCandidate = record
        text: string;
        comment: string;
        score: Integer;
        source: TncCandidateSource;
        has_dict_weight: Boolean;
        dict_weight: Integer;
    end;

    TncCandidateList = array of TncCandidate;

    TncPairPathEvidence = record
        encoded_path: string;
        query_path_weight: Integer;
        lm_transition_weight: Integer;
    end;

    TncPairPathEvidenceList = array of TncPairPathEvidence;

    TncLogConfig = record
        enabled: Boolean;
        level: TncLogLevel;
        max_size_kb: Integer;
        log_path: string;
    end;

    TncKeyState = record
        shift_down: Boolean;
        ctrl_down: Boolean;
        alt_down: Boolean;
        caps_lock: Boolean;
    end;

    TncInputMode = (im_chinese, im_english);
    TncPinyinInputScheme = (
        pis_full_pinyin,
        pis_microsoft_shuangpin,
        pis_xiaohe_shuangpin,
        pis_ziranma_shuangpin,
        pis_sogou_shuangpin,
        pis_ziguang_shuangpin,
        pis_pinyinjiajia_shuangpin
    );
    TncDictionaryVariant = (dv_simplified, dv_traditional);
    TncCandidatePageKeyScheme = (
        cpks_minus_plus,
        cpks_brackets,
        cpks_comma_period,
        cpks_shift_tab
    );

    TncShortcutAction = (
        sa_input_mode_toggle,
        sa_punctuation_toggle,
        sa_dictionary_variant_toggle,
        sa_full_width_toggle,
        sa_open_settings
    );

    TncShortcut = record
        key_code: Word;
        shift_down: Boolean;
        ctrl_down: Boolean;
        alt_down: Boolean;
    end;

    TncShortcutConfig = record
        signature: Cardinal;
        input_mode_toggle: TncShortcut;
        punctuation_toggle: TncShortcut;
        dictionary_variant_toggle: TncShortcut;
        full_width_toggle: TncShortcut;
        open_settings: TncShortcut;
    end;

    TncEngineConfig = record
        input_mode: TncInputMode;
        pinyin_input_scheme: TncPinyinInputScheme;
        max_candidates: Integer;
        enable_ctrl_space_toggle: Boolean;
        enable_shift_space_full_width_toggle: Boolean;
        enable_ctrl_period_punct_toggle: Boolean;
        full_width_mode: Boolean;
        punctuation_full_width: Boolean;
        enable_segment_candidates: Boolean;
        segment_head_only_multi_syllable: Boolean;
        candidate_font_name: string;
        candidate_font_size: Integer;
        candidate_page_size: Integer;
        candidate_page_key_scheme: TncCandidatePageKeyScheme;
        candidate_color_scheme: Integer;
        debug_mode: Boolean;
        dictionary_variant: TncDictionaryVariant;
        shortcuts: TncShortcutConfig;
    end;

implementation

end.
