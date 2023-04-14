//
//  ScreenService.m
//  BookShelf
//
//  Created by Sam Chang on 1/2/14.
//  Copyright (c) 2014 Jian-Guo Hu. All rights reserved.
//

#import "ScreenService.h"

@implementation ScreenService

+(void)load{
    [[ESRegistry getInstance] registerService: @"ScreenService" withName: @"screen"];
}

-(BOOL)singleton{
    return NO;
}

- (void) setCurrentState: (lua_State *) value{
    L = value;
}

-(void)onLoad{
    self.rootViewController = [[RootViewController alloc] init];
    self.rootViewController.view.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScreen:) name: UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScreen:) name: UIScreenDidDisconnectNotification object:nil];
    
    [self refreshScreen: nil];
}

- (void) show: (id) dic{
    if ([dic isKindOfClass: [CAPAbstractUIWidget class]]) {
        self.widget = dic;
    }else if ([dic isKindOfClass: [NSDictionary class]]){
        CAPPanelView<PagePanel> *panelView = [[OSUtils getContainerFromState: L].renderView topPanelView];
        CAPPageSandbox *sandbox = [panelView getSandbox];
        
        if ([sandbox isKindOfClass: [CAPPageSandbox class]]) {
            UIWidgetM *model = [ModelBuilder buildModel: dic];
            self.widget = [WidgetBuilder buildWidget: model withPageSandbox: sandbox];
            
            [OSUtils runBlockOnMain:^{
                [self.widget createView];
            }];
        }
    } else {
        self.widget = nil;
    }
    
    hidden = NO;
    [self refreshScreen: nil];
}

- (void) stopMirror {
    if ([[UIScreen screens] count] > 1) {
        screen = [[UIScreen screens] lastObject];
        
        CGRect frame = screen.bounds;
        
        if (!window) {
            window = [[UIWindow alloc] initWithFrame: frame];
            window.backgroundColor = [UIColor blueColor];
            window.rootViewController = self.rootViewController;
        } else {
            window.frame = screen.bounds;
        }
        
        [window setScreen: screen];
        window.hidden = NO;
        //UIScreen *deviceScreen = [[UIScreen screens] objectAtIndex:0];
        UIView * deviceView = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController].view;
        NSData *tempArchiveView = [NSKeyedArchiver archivedDataWithRootObject:deviceView];
        UIView *viewOfSelf = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchiveView];
        self.rootViewController.view = viewOfSelf;
    }
}

- (void) resumeMirror {
    if (window) {
        window = nil;
        screen = nil;
    }
}

- (void) hide{
    if (window) {
        window = nil;
        self.widget = nil;
        hidden = YES;
    }
}

- (BOOL) ready{
    return [[UIScreen screens] count] > 1;
}

- (NSArray *) getAvailableModes{
    if ([[UIScreen screens] count] > 1) {
        UIScreen *sc = [[UIScreen screens] lastObject];
        NSMutableArray *list = [NSMutableArray arrayWithCapacity: [sc.availableModes count]];
        for (UIScreenMode *mode in sc.availableModes) {
            [list addObject: NSStringFromCGSize(mode.size)];
        }
        
        return list;
    }
    return nil;
}

- (NSString *) getPreferredMode {
    if ([[UIScreen screens] count] > 1) {
        UIScreen *sc = [[UIScreen screens] lastObject];
        return NSStringFromCGSize(sc.preferredMode.size);
    }
    return nil;
}

- (void) setCurrentMode: (NSString *) value{
    if ([value isKindOfClass: [NSString class]]) {
        if ([[UIScreen screens] count] > 1) {
            UIScreen *sc = [[UIScreen screens] lastObject];
            for (UIScreenMode *mode in sc.availableModes) {
                if ([NSStringFromCGSize(mode.size) isEqualToString: value]) {
                    sc.currentMode = mode;
                    break;
                }
            }
        }
    }
}

- (NSString *) getCurrentMode{
    if ([[UIScreen screens] count] > 1) {
        UIScreen *sc = [[UIScreen screens] lastObject];
        return NSStringFromCGSize(sc.currentMode.size);
    }
    return nil;
}

- (void)refreshScreen: (NSNotification *)notification {
    if (!hidden && [[UIScreen screens] count] > 1) {
        screen = [[UIScreen screens] lastObject];
        
        CGRect frame = screen.bounds;
        
        if (!window) {
            window = [[UIWindow alloc] initWithFrame: frame];
            window.backgroundColor = [UIColor blueColor];
            window.rootViewController = self.rootViewController;
        } else {
            window.frame = screen.bounds;
        }
        
        [window setScreen: screen];
        window.hidden = NO;

        if (self.widget) {
            __weak __typeof__(self) weakSelf = self;
            [OSUtils runBlockOnMain:^{
                CGRect rect = [weakSelf.widget measureRect: frame.size];
                weakSelf.widget->currentRect = rect;
                [weakSelf.widget reloadRect];
                
                for (UIView *view in [[weakSelf.rootViewController.view subviews] copy]) {
                    [view removeFromSuperview];
                }
                
                [weakSelf.rootViewController.view addSubview: [weakSelf.widget innerView]];
            }];
        }
    } else {
        screen = nil;
    }
}
@end
