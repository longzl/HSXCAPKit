//
//  LuaFunctionWatcher.h
//  EOSFramework
//
//  Created by Sam on 13-10-31.
//
//

#import <Foundation/Foundation.h>
#import <CAPKit/LuaFunction.h>

@interface LuaFunctionWatcher : NSObject{
    LuaFunction *func;
}

- (id) initWithLuaFunction: (LuaFunction *) value;

- (void) clear;

@end
