//
//  WebViewWidget.h
//  EOSClient2
//
//  Created by Chang Sam on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CAPKit/CAPKit.h>
#import "IWebViewWidget.h"
#import "CAPWebViewM.h"
#import <WebKit/WebKit.h>

@interface CAPWebViewWidget : CAPAbstractUIWidget <UIWebViewDelegate, IWebViewWidget,
    WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>{
    UIWebView *uiwebview;

    WKWebView *wkwebview;

    UIView *mainView;
    
    UIView *coverView;
    UILabel *coverLabel;
    
    UIButton *retryButton;
    
    BOOL firstLoad;
    
    int progressCount;
    
    UIActivityIndicatorView *indicatorView;
    UIView *busyView;
    UIImageView *indicatorBackgroundView;
    
    NSMutableDictionary *schemeHandlerMap;

    BOOL usingJit;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, readonly) CAPWebViewM *model;
@property (nonatomic, readonly) CAPWebViewM *stableModel;
#pragma clang diagnostic pop

@property (nonatomic, strong) NSString *firstSrc;
@property (nonatomic, strong) NSString *lastFileParent;
@property (nonatomic, strong) NSString *lastURLParent;
@property (nonatomic, strong) NSURL *lastURL;

- (void) execute: (NSString *) js;
- (void) loadPage: (NSString *) urlString;

- (void) restart;

@end
