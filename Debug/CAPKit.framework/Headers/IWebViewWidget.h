//
//  IWebViewWidget.h
//  EOSFramework
//
//  Created by Sam Chang on 3/21/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IWebViewWidget <NSObject>

- (void) _LUA_execute: (NSString *) js;

- (void) loadURL: (NSString *) urlString;

- (void) loadHTML: (NSString *) htmlString : (NSString *) baseURLString;

- (void) showMessage:(NSDictionary *)aDic;

- (void) setSchemeHandler: (NSString *) schema :(LuaFunction *) func;

@end
