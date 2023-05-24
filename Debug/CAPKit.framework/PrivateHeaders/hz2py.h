//
//  hz2py.h
//  EOSFramework
//
//  Created by Sam on 6/4/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#ifndef EOSLib2_hz2py_h
#define EOSLib2_hz2py_h

int is_utf8_string(char *utf);
void utf8_to_pinyin(
                    const char *in,
                    char *out,
                    int first_letter_only, 
                    int polyphone_support,
                    int add_blank,
                    int convert_double_char,
                    char *overage_buff
                    );
#endif
