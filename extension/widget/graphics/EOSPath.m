//
//  EOSPath.m
//  EOSFramework
//
//  Created by Sam on 6/6/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "EOSPath.h"

@implementation EOSPath

- (id)init
{
    self = [super init];
    if (self) {
        _path = CGPathCreateMutable();
    }
    return self;
}

-(void)dealloc{
    CGPathRelease(_path);
}

@end
