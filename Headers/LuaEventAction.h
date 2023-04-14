//
//  LuaEventAction.h
//  EOSFramework
//
//  Created by Sam on 7/4/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "EventAction.h"
#import "LuaState.h"
#import "LuaFunction.h"

@interface LuaEventAction : EventAction{
    LuaFunction *script;
}

- (id) initWithFunction: (LuaFunction *) sc;
@end
