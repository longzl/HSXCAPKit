//
//  base64.h
//  EOSFramework
//
//  Created by Sam on 6/26/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#ifndef EOSLib2_base64_h
#define EOSLib2_base64_h
#include <sys/types.h>
#include <resolv.h>

int b64_ntop(u_char const *src, size_t srclength, char *target, size_t targsize);
int b64_pton(char const *src, u_char *target, size_t targsize);

#endif
