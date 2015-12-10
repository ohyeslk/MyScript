// Copyright MyScript

#import "LanguageManager.h"

static NSString *LANGUAGES[] = {
    // superimposed languages
    @"en_US",
    @"cs_CZ",
    @"de_DE",
    @"en_GB",
    @"es_ES",
    @"es_MX",
    @"fr_CA",
    @"fr_FR",
    @"it_IT",
    @"ja_JP",
    @"ko_KR",
    @"nl_NL",
    @"no_NO",
    @"pl_PL",
    @"pt_BR",
    @"pt_PT",
    @"ru_RU",
    @"sv_SE",
    @"zh_CN",
    @"zh_HK",
    @"zh_TW",
    // isolated languages
    @"af_ZA",
    @"ar",
    @"az_AZ",
    @"be_BY",
    @"bg_BG",
    @"ca_ES",
    @"da_DK",
    @"de_AT",
    @"el_GR",
    @"en_CA",
    @"et_EE",
    @"eu_ES",
    @"fa_IR",
    @"fi_FI",
    @"ga_IE",
    @"gl_ES",
    @"he_IL",
    @"hi_IN",
    @"hr_HR",
    @"hu_HU",
    @"hy_AM",
    @"id_ID",
    @"is_IS",
    @"ka_GE",
    @"kk_KZ",
    @"lt_LT",
    @"lv_LV",
    @"mk_MK",
    @"mn_MN",
    @"ms_MY",
    @"nl_BE",
    @"ro_RO",
    @"sk_SK",
    @"sl_SI",
    @"sq_AL",
    @"sr_Cyrl_RS",
    @"sr_Latn_RS",
    @"th_TH",
    @"tr_TR",
    @"tt_RU",
    @"uk_UA",
    @"ur_PK",
    @"vi_VN",
    // end of array
    nil
};

@implementation LanguageManager

+ (NSArray *)availableLanguages {
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSString *bundlePath = [mainBundle pathForResource:@"AtkScw" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];

    NSMutableArray *languages = [NSMutableArray array];
    
    for (int i=0; LANGUAGES[i] != nil; i++) {
        if ([bundle pathForResource:LANGUAGES[i] ofType:nil] != nil) {
            [languages addObject:LANGUAGES[i]];
        }
    }
    
    return languages;
}

+ (NSArray *)resourcesForLanguage:(NSString *)language {
    NSArray *resources;
    
    // superimposed languages
    if ([@"cs_CZ" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"latin/latin-ak-superimposed.lite",
                     @"cs_CZ/cs_CZ-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"de_DE" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"latin/latin-ak-superimposed.lite",
                     @"de_DE/de_DE-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"en_GB" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"latin/latin-ak-superimposed.lite",
                     @"en_GB/en_GB-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"en_US" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"latin/latin-ak-superimposed.lite",
                     @"en_US/en_US-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"es_ES" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"latin/latin-ak-superimposed.lite",
                     @"es_ES/es_ES-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"es_MX" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"latin/latin-ak-superimposed.lite",
                     @"es_MX/es_MX-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"fr_CA" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"latin/latin-ak-superimposed.lite",
                     @"fr_CA/fr_CA-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"fr_FR" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"latin/latin-ak-superimposed.lite",
                     @"fr_FR/fr_FR-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"it_IT" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"latin/latin-ak-superimposed.lite",
                     @"it_IT/it_IT-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"nl_NL" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"latin/latin-ak-superimposed.lite",
                     @"nl_NL/nl_NL-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"no_NO" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"latin/latin-ak-superimposed.lite",
                     @"no_NO/no_NO-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"pl_PL" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"latin/latin-ak-superimposed.lite",
                     @"pl_PL/pl_PL-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"pt_BR" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"latin/latin-ak-superimposed.lite",
                     @"pt_BR/pt_BR-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"pt_PT" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"latin/latin-ak-superimposed.lite",
                     @"pt_PT/pt_PT-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"ru_RU" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"cyrillic/cyrillic-ak-superimposed.lite",
                     @"ru_RU/ru_RU-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"sv_SE" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"latin/latin-ak-superimposed.lite",
                     @"sv_SE/sv_SE-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"zh_CN" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"zh_CN/zh_CN-ak-superimposed.lite",
                     @"zh_CN/zh_CN-lk-text.lite",
                     nil];
    } else if ([@"zh_HK" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"zh_HK/zh_HK-ak-superimposed.lite",
                     @"zh_HK/zh_HK-lk-text.lite",
                     nil];
    } else if ([@"zh_TW" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"zh_TW/zh_TW-ak-superimposed.lite",
                     @"zh_TW/zh_TW-lk-text.lite",
                     nil];
    } else if ([@"ja_JP" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"ja_JP/ja_JP-ak-superimposed.lite",
                     @"ja_JP/ja_JP-lk-text.lite",
                     nil];
    } else if ([@"ko_KR" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"ko_KR/ko_KR-ak-superimposed.lite",
                     @"ko_KR/ko_KR-lk-text.lite",
                     nil];
    }
    
    // isolated languages
    if ([@"af_ZA" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"af_ZA/af_ZA-ak-iso.lite",
                     @"af_ZA/af_ZA-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"ar" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"ar/ar-ak-iso.lite",
                     @"ar/ar-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"az_AZ" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"az_AZ/az_AZ-ak-iso.lite",
                     @"az_AZ/az_AZ-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"be_BY" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"be_BY/be_BY-ak-iso.lite",
                     @"be_BY/be_BY-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"bg_BG" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"bg_BG/bg_BG-ak-iso.lite",
                     @"bg_BG/bg_BG-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"ca_ES" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"ca_ES/ca_ES-ak-iso.lite",
                     @"ca_ES/ca_ES-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"da_DK" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"da_DK/da_DK-ak-iso.lite",
                     @"da_DK/da_DK-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"de_AT" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"de_AT/de_AT-ak-iso.lite",
                     @"de_AT/de_AT-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"el_GR" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"el_GR/el_GR-ak-iso.lite",
                     @"el_GR/el_GR-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"en_CA" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"en_CA/en_CA-ak-iso.lite",
                     @"en_CA/en_CA-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"et_EE" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"et_EE/et_EE-ak-iso.lite",
                     @"et_EE/et_EE-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"eu_ES" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"eu_ES/eu_ES-ak-iso.lite",
                     @"eu_ES/eu_ES-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"fa_IR" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"fa_IR/fa_IR-ak-iso.lite",
                     @"fa_IR/fa_IR-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"fi_FI" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"fi_FI/fi_FI-ak-iso.lite",
                     @"fi_FI/fi_FI-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"ga_IE" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"ga_IE/ga_IE-ak-iso.lite",
                     @"ga_IE/ga_IE-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"gl_ES" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"gl_ES/gl_ES-ak-iso.lite",
                     @"gl_ES/gl_ES-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"he_IL" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"he_IL/he_IL-ak-iso.lite",
                     @"he_IL/he_IL-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"hi_IN" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"hi_IN/hi_IN-ak-cur.lite",
                     @"hi_IN/hi_IN-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"hr_HR" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"hr_HR/hr_HR-ak-iso.lite",
                     @"hr_HR/hr_HR-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"hu_HU" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"hu_HU/hu_HU-ak-iso.lite",
                     @"hu_HU/hu_HU-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"hy_AM" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"hy_AM/hy_AM-ak-iso.lite",
                     @"hy_AM/hy_AM-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"id_ID" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"id_ID/id_ID-ak-iso.lite",
                     @"id_ID/id_ID-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"is_IS" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"is_IS/is_IS-ak-iso.lite",
                     @"is_IS/is_IS-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"ka_GE" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"ka_GE/ka_GE-ak-iso.lite",
                     @"ka_GE/ka_GE-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"kk_KZ" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"kk_KZ/kk_KZ-ak-iso.lite",
                     @"kk_KZ/kk_KZ-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"lt_LT" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"lt_LT/lt_LT-ak-iso.lite",
                     @"lt_LT/lt_LT-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"lv_LV" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"lv_LV/lv_LV-ak-iso.lite",
                     @"lv_LV/lv_LV-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"mk_MK" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"mk_MK/mk_MK-ak-iso.lite",
                     @"mk_MK/mk_MK-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"mn_MN" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"mn_MN/mn_MN-ak-iso.lite",
                     @"mn_MN/mn_MN-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"ms_MY" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"ms_MY/ms_MY-ak-iso.lite",
                     @"ms_MY/ms_MY-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"nl_BE" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"nl_BE/nl_BE-ak-iso.lite",
                     @"nl_BE/nl_BE-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"ro_RO" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"ro_RO/ro_RO-ak-iso.lite",
                     @"ro_RO/ro_RO-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"sk_SK" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"sk_SK/sk_SK-ak-iso.lite",
                     @"sk_SK/sk_SK-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"sl_SI" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"sl_SI/sl_SI-ak-iso.lite",
                     @"sl_SI/sl_SI-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"sq_AL" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"sq_AL/sq_AL-ak-iso.lite",
                     @"sq_AL/sq_AL-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"sr_Cyrl_RS" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"sr_Cyrl_RS/sr_Cyrl_RS-ak-iso.lite",
                     @"sr_Cyrl_RS/sr_Cyrl_RS-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"sr_Latn_RS" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"sr_Latn_RS/sr_Latn_RS-ak-iso.lite",
                     @"sr_Latn_RS/sr_Latn_RS-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"th_TH" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"th_TH/th_TH-ak-iso.lite",
                     @"th_TH/th_TH-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"tr_TR" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"tr_TR/tr_TR-ak-iso.lite",
                     @"tr_TR/tr_TR-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"tt_RU" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"tt_RU/tt_RU-ak-iso.lite",
                     @"tt_RU/tt_RU-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"uk_UA" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"uk_UA/uk_UA-ak-iso.lite",
                     @"uk_UA/uk_UA-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"ur_PK" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"ur_PK/ur_PK-ak-iso.lite",
                     @"ur_PK/ur_PK-lk-text.lite",
                     @"mul/mul-lk-gesture", nil];
    } else if ([@"vi_VN" isEqualToString:language]) {
        resources = [NSArray  arrayWithObjects:
                     @"vi_VN/vi_VN-ak-iso.lite",
                     @"vi_VN/vi_VN-lk-text.lite",
                     @"mul/mul-lk-gesture",
                     nil];
    }
    
    return resources;
}

+ (NSArray *)pathsForResources:(NSArray *)resources {
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSString *bundlePath = [mainBundle pathForResource:@"AtkScw" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    NSMutableArray *paths = [NSMutableArray array];
    for (NSString *resource in resources) {
        [paths addObject:[bundle pathForResource:resource ofType:@"res"]];
    }
    
    return paths;
}

@end
