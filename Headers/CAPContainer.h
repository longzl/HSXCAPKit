//
//  CAPContainer.h
//  CAPKit
//
//  Created by Sam Chang on 26/09/2016.
//  Copyright © 2016 CAP. All rights reserved.
//
#import <CAPKit/GlobalSandboxDelegate.h>
#import <CAPKit/StorageHelper.h>

@class GlobalSandbox;

@interface CAPContainer : NSObject <GlobalSandboxDelegate> {
    UIView *busyView;
    UIView *busyBodyView;
    UIProgressView *progressView;
    UIActivityIndicatorView *indicatorView;
    NSInteger busyCount;

    NSMutableArray *modalStack;
}

@property (nonatomic, weak, readonly) CAPRenderView *renderView;
@property (nonatomic, strong, readonly) GlobalSandbox *globalSandbox;
@property (nonatomic, strong, readonly) StorageHelper *storageHelper;

@property (nonatomic, strong, readonly) CAPContainerOption *option;

- (instancetype)initWithView: (CAPRenderView *) view
                  withOption: (CAPContainerOption *) option;

- (BOOL) switchApp: (AppContext *) context;
- (BOOL) switchPage: (AppContext *) context;
- (BOOL) pushApp: (AppContext *) context;
- (BOOL) popPage: (AppContext *) context;
- (BOOL) popApp: (AppContext *) context;
- (BOOL) popAndPushApp: (AppContext *) context;

- (void) presentModal: (AppContext *) context;
- (void) dismissModal;

- (void) setProgress: (float) progress;

- (void) reloadPage: (AppContext *) context;

-(NSString *)bootAppId;

- (void) startBusy: (NSString *) ycenter withTitle: (NSString *) title;
- (void) stopBusy;

- (void) initBusyView;
- (BOOL) prepareEnv: (NSString *) currentAppVersion withOutSafeMode: (BOOL) withOutSafeMode;

- (NSString *) appBundleName;
- (NSString *) hydraBundleName;

- (NSString *) preferredLanguage;

- (void) shutdown;

@end
