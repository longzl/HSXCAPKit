//
//  ScreenService.h
//  BookShelf
//
//  Created by Sam Chang on 1/2/14.
//  Copyright (c) 2014 Jian-Guo Hu. All rights reserved.
//

#import <CAPKit/CAPKit.h>

@interface BusyService : AbstractLuaTableCompatible <IService, LuaTableCompatible>{
    lua_State *L;

    UIWindow *window;
    UIViewController *rootViewController;
    
    UIScreen *screen;
    
    CAPAbstractUIWidget *widget;
    BOOL hidden;
}

- (void)refreshScreen: (NSNotification *)notification;
- (void) hide;

@end
