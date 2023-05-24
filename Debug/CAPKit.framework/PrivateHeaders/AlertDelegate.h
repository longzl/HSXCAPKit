//
//  AlertDelegate.h
//  EOSFramework
//
//  Created by Sam on 7/10/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>
#import "LuaFunction.h"
#import "LuaState.h"

#define CONFIRM_OK      1
#define CONFIRM_CANCEL  0

@interface AlertDelegate : NSObject <UIAlertViewDelegate>{
    @public
    lua_State *mainthread;
    int coref;
    int ref;
}

@property (nonatomic, strong) LuaFunction *onOK;
@property (nonatomic, strong) LuaFunction *onCancel;

@end
