//
//  WebViewWidget.m
//  EOSClient2
//
//  Created by Chang Sam on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPWebViewWidget.h"
#import "CAPWebViewM.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <QuartzCore/QuartzCore.h>

@implementation CAPWebViewWidget

+(void)load{
    [WidgetMap bind: @"webview" withModelClassName: NSStringFromClass([CAPWebViewM class]) withWidgetClassName: NSStringFromClass([CAPWebViewWidget class])];
}

- (void) setCoverMessage: (NSString *) message withType: (int) coverType{
    if ([message isKindOfClass: [NSString class]] && [message length] > 0) {
        coverView.alpha = 1;
    }
    coverLabel.text = message;
}

- (void) hideCoverMessage{
    coverView.alpha = 0;
}

- (void) loadPage: (nonnull NSString *) urlString{
    if (self.firstSrc == nil) {
        self.firstSrc = urlString;
    }
    
    progressCount = 0;
    retryButton.alpha = 0;
    [self setCoverMessage: @"" withType: 0];
    
    NSString *secureCode = [[self.pageSandbox getGlobalSandbox] getSecureCode];
    if (![secureCode isKindOfClass: [NSString class]]) {
        secureCode = @"";
    }
    urlString = [urlString stringByReplacingOccurrencesOfString: @"${SECURE_CODE}" withString: secureCode];
    
    NSURL *url = nil;

    if (![urlString hasPrefix: @"app://"]
        && ![urlString hasPrefix: @"data://"]
        && [urlString rangeOfString: @":"].length > 0) {
        self.lastFileParent = nil;
        if ([urlString characterAtIndex: [urlString length] - 1] == '/') {
            self.lastURLParent = urlString;
        }else {
            self.lastURLParent = [urlString stringByDeletingLastPathComponent];
        }
        url = [NSURL URLWithString: urlString];
    }else{
        if ([urlString length] > 0 && [[NSFileManager defaultManager] fileExistsAtPath: urlString]) {
            self.lastFileParent = [urlString stringByDeletingLastPathComponent];
            self.lastURLParent = nil;
            url = [NSURL fileURLWithPath: urlString];
        }else{
            NSURL *htmlPath = [[self.pageSandbox getAppSandbox] resolveFile: urlString];
            if ([htmlPath isFileURL] && [[NSFileManager defaultManager] fileExistsAtPath: [htmlPath path]]) {
                self.lastFileParent = [[htmlPath path] stringByDeletingLastPathComponent];
                self.lastURLParent = nil;
                url = [NSURL fileURLWithPath: [htmlPath path]];
            }else{
                NSString *htmlPathString = [[self.pageSandbox getAppSandbox] getDataFile: urlString];
                if ([htmlPathString isKindOfClass: [NSString class]] && [[NSFileManager defaultManager] fileExistsAtPath: htmlPathString]) {
                    self.lastFileParent = [htmlPathString stringByDeletingLastPathComponent];
                    self.lastURLParent = nil;
                    url = [NSURL fileURLWithPath: htmlPathString];
                }else{
                    if (self.lastFileParent != nil) {
                        htmlPathString = [self.lastFileParent stringByAppendingPathComponent: urlString];
                        if ([[NSFileManager defaultManager] fileExistsAtPath: htmlPathString]) {
                            url = [NSURL fileURLWithPath: htmlPathString];
                        }
                    }else if(self.lastURLParent != nil){
                        url = [NSURL URLWithString: [self.lastURLParent stringByAppendingPathComponent: urlString]];
                    }
                }
            }
        }
    }
    
    if (url) {
        self.lastURL = url;
        if (usingJit) {
            [wkwebview loadRequest: [NSURLRequest requestWithURL: url]];
        } else {
            [uiwebview loadRequest: [NSURLRequest requestWithURL: url]];
        }
    }else {
        busyView.alpha = 0;
        retryButton.alpha = 1;
        [self setCoverMessage: @"无效地址" withType: 0];
    }
}

- (void) loadHTML: (NSString *) htmlString : (NSString *) baseURLString{
    if (![htmlString isKindOfClass: [NSString class]]) {
        return;
    }
    [OSUtils runBlockOnMain:^{
        if ([baseURLString isKindOfClass: [NSString class]]) {
            if ([baseURLString hasPrefix: @"http"]) {
                if (usingJit) {
                    [wkwebview loadHTMLString: htmlString baseURL: [NSURL URLWithString: baseURLString]];
                } else {
                    [uiwebview loadHTMLString: htmlString baseURL: [NSURL URLWithString: baseURLString]];
                }
            }else{
                if (usingJit) {
                    [wkwebview loadHTMLString: htmlString baseURL: [self.pageSandbox resolveFile: baseURLString]];
                } else {
                    [uiwebview loadHTMLString: htmlString baseURL: [self.pageSandbox resolveFile: baseURLString]];
                }
            }
        }else{
            if (usingJit) {
                [wkwebview loadHTMLString: htmlString baseURL: nil];
            } else {
                [uiwebview loadHTMLString: htmlString baseURL: nil];
            }
        }
    }];
}

-(id)initWithModel:(CAPWebViewM *)m withPageSandbox: (CAPPageSandbox *) sandbox{
    self = [super initWithModel: m withPageSandbox: sandbox];
    if (self) {
        schemeHandlerMap = [NSMutableDictionary dictionary];

        usingJit = NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 && m.jit;
    }
    return self;
}

-(void)onDestroy{
    [super onDestroy];
    
    [wkwebview.configuration.userContentController removeScriptMessageHandlerForName: @"myApp"];
    uiwebview.delegate = nil;
    wkwebview.navigationDelegate = nil;
}

-(void) onCreateView{
    self.firstSrc = self.model.src;
    
    firstLoad = YES;
    
    mainView = [[UIView alloc] initWithFrame: [self getActualCurrentRect]];
    mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    if (usingJit) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        [configuration.userContentController addScriptMessageHandler:self name:@"myApp"];

        wkwebview = [[WKWebView alloc] initWithFrame: mainView.bounds
                                       configuration: configuration];

        wkwebview.navigationDelegate = self;

        [mainView addSubview: wkwebview];

        if (self.model.hasTouchDisabled) {
            wkwebview.userInteractionEnabled = !self.model.touchDisabled;
        }
    } else {
        uiwebview = [[UIWebView alloc] initWithFrame: mainView.bounds];
        uiwebview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        uiwebview.delegate = self;
        uiwebview.backgroundColor = [UIColor clearColor];
        uiwebview.opaque = self.model.opaque;
        uiwebview.allowsInlineMediaPlayback = YES;

        uiwebview.scalesPageToFit = self.model.zoomable;

        if (self.model.hasTouchDisabled) {
            uiwebview.userInteractionEnabled = !self.model.touchDisabled;
        }
        [mainView addSubview: uiwebview];
    }


    coverView = [[UIView alloc] initWithFrame: mainView.bounds];
    coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    coverView.backgroundColor = [UIColor clearColor];
    coverView.alpha = 0;
    [mainView addSubview: coverView];
    
    coverLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, mainView.bounds.size.width, 100)];
    coverLabel.numberOfLines = 0;
    [coverView addSubview: coverLabel];
    
    retryButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    retryButton.frame = CGRectMake(0, 110, mainView.bounds.size.width, 44);
    
    [retryButton setTitle: @"重试" forState: UIControlStateNormal];
    [coverView addSubview: retryButton];
    retryButton.alpha = 0;
    
    //[retryButton addTarget: self action: @selector(onRetry) forControlEvents: UIControlEventTouchUpInside];
    
    if (!self.model.busyhidden) {
        busyView = [[UIView alloc] initWithFrame: mainView.bounds];
        busyView.alpha = 0;
        busyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UIImageView *bgView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"webviewbg.png"]];
        bgView.frame = mainView.bounds;
        bgView.tag = 100;
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [busyView addSubview: bgView];
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView startAnimating];
        indicatorBackgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"busy_background.png"]];
        [busyView addSubview: indicatorBackgroundView];
        [busyView addSubview: indicatorView];
        
        indicatorBackgroundView.center = busyView.center;
        indicatorView.center = busyView.center;
        
        [mainView addSubview: busyView];
    }
}

- (void) onRetry{
    if (self.lastURL) {
        if (usingJit) {
            [wkwebview loadRequest: [NSURLRequest requestWithURL: self.lastURL]];
        } else {
            [uiwebview loadRequest: [NSURLRequest requestWithURL: self.lastURL]];
        }
    }
}

-(void)setViewFrame:(CGRect)rect{
    [super setViewFrame: rect];

    if (usingJit) {
        wkwebview.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    } else {
        uiwebview.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    }

    coverView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    coverLabel.frame = CGRectMake(0, 0, rect.size.width, 100);
    
    retryButton.frame = CGRectMake(0, 110, rect.size.width, 44);
    busyView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    [busyView viewWithTag: 100].frame = busyView.frame;
    indicatorBackgroundView.center = busyView.center;
    indicatorView.center = busyView.center;
}

- (void)hiddenAlert:(id)sender {
    UIAlertView *alert = (UIAlertView *)sender;
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)showAlert:(NSDictionary *)aDic {
    NSString *title = @"提示";
    NSString *message = @"";
    long expireTime = 1000;
    if ([[aDic valueForKey:@"title"] length]>0) {
        title = [aDic valueForKey:@"title"];
    }
    if ([[aDic valueForKey:@"message"] length]>0) {
        message = [aDic valueForKey:@"message"];
    }
    if ([aDic valueForKey:@"expireTime"] != nil && [[aDic valueForKey:@"expireTime"] isKindOfClass:[NSNumber class]]) {
        expireTime = [[aDic valueForKey:@"expireTime"] longValue];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
                                                        message: message
                                                       delegate: self
                                              cancelButtonTitle: nil
                                              otherButtonTitles: nil];
    [alertView show];
    [self performSelector:@selector(hiddenAlert:) withObject:alertView afterDelay:expireTime/1000];
}

- (void) showMessage:(NSDictionary *)aDic {
    [self performSelectorOnMainThread: @selector(showAlert:) withObject: aDic waitUntilDone: YES];
}

- (void) restart{
    [self loadPage: _firstSrc];
}

-(void)onFronted{
    [super onFronted];
    
    [indicatorView startAnimating];
}

-(void)onCreated{
    [super onCreated];
    
    if (firstLoad) {
        CAPWebViewM *wm = (CAPWebViewM *) self.model;
        if ([wm.src length] > 0) {
            [self loadPage: wm.src];
        }
        firstLoad = NO;
    }
}

-(UIView *)innerView{
    return mainView;
}

- (void) _LUA_execute: (NSString *) js{
    [self performSelectorOnMainThread: @selector(execute:) withObject: [NSString stringWithFormat: @"try{%@;}catch(err){alert(err);}", js] waitUntilDone: NO];
}

- (void) execute: (NSString *) js{
    if (usingJit) {
        [wkwebview evaluateJavaScript: js
                    completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
                    }];
    } else {
        [uiwebview stringByEvaluatingJavaScriptFromString: js];
    }
}

- (void) loadURL: (NSString *) urlString{
    [OSUtils runBlockOnMain:^{
        [self loadPage: urlString];
    }];
}

- (void) setSrc: (NSString *) urlString{
    if (![urlString isKindOfClass: [NSString class]]) {
        return;
    }
    ((CAPWebViewM *) self.model).src = urlString;
    
    [OSUtils runBlockOnMain:^{
        [self loadPage: urlString];
    }];
}

- (NSString *) getSrc{
    return ((CAPWebViewM *) self.model).src;
}

-(void)onBackend{
    [super onBackend];

    [indicatorView stopAnimating];
    
//    [self execute: @"try{onBackend();}catch(err){}"];
}

-(void)reloadRect{
    if (currentRect.size.height == 0) {
        currentRect.size.height = 10;
    }
    if (currentRect.size.width == 0) {
        currentRect.size.width = 10;
    }
    
    [super reloadRect];
}

- (CAPLuaImage *) _COROUTINE_getContentSnapshot{
    __block CAPLuaImage *wrapper = nil;

    if (usingJit) {
        NSLog(@"TODO: snapshot %@.", @"WKWebview");
    } else {
        dispatch_block_t blk = ^{
            NSInteger width = [[uiwebview stringByEvaluatingJavaScriptFromString: @"document.body.scrollWidth"] integerValue];
            NSInteger minheight = [[uiwebview stringByEvaluatingJavaScriptFromString: @"Math.min(document.body.scrollHeight,document.body.clientHeight)"] integerValue];

            CGRect old = uiwebview.frame;
            CGRect rect = uiwebview.frame;

            rect.size.width = width;
            rect.size.height = minheight;

            uiwebview.frame = rect;

            @autoreleasepool {
                UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
                CGContextRef context = UIGraphicsGetCurrentContext();
                [uiwebview.layer renderInContext: context];
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();

                wrapper = [[CAPLuaImage alloc] initWithImage: image];
            }

            uiwebview.frame = old;
        };

        if (![NSThread isMainThread]) {
            dispatch_sync(dispatch_get_main_queue(), blk);
        }else{
            blk();
        }
    }

    return wrapper;
}

- (void) processLua: (NSString *) dicString{
    NSError *err = nil;
    NSDictionary *dic = [[CJSONDeserializer deserializer] deserializeAsDictionary: [dicString dataUsingEncoding: NSUTF8StringEncoding] error: &err];
    if (err != nil) {
        return;
    }
    NSMutableString *buff = [NSMutableString stringWithCapacity: 10];
    NSString *head = [dic valueForKey: @"head"];
    if ([head length] > 0) {
        [buff appendString: head];
        [buff appendString: @"\n"];
    }
    NSString *func = [dic valueForKey: @"func"];
    if ([func length] == 0) {
        return;
    }
    [buff appendString: func];
    NSObject *arg = [dic valueForKey: @"arg"];
    if ([arg isKindOfClass: [NSString class]]) {
        NSString *sarg = (NSString *) arg;
        if ([sarg length] == 0) {
            [buff appendString: @"()"];
            [self.pageSandbox runLuaBuffer: buff];
        }else{
            static const NSString *argName = @"webview_process_arg";
            lua_State *L = [[self.pageSandbox getAppSandbox].state state];
            
            lua_lock(L);
            lua_rawgeti(L, LUA_REGISTRYINDEX, self.pageSandbox.envRef);
            lua_objc_pushpropertylist(L, argName);
            lua_objc_pushpropertylist(L, sarg);
            lua_settable(L, -3);
            lua_pop(L, 1);
            lua_unlock(L);
            
            [buff appendFormat: @"(%@);%@=nil", argName, argName];
            [self.pageSandbox runLuaBuffer: buff];
        }
    }else if([arg isKindOfClass: [NSNumber class]]){
        [buff appendFormat: @"(%@)", arg];
        [self.pageSandbox runLuaBuffer: buff];
    }else{
        [buff appendString: @"()"];
        [self.pageSandbox runLuaBuffer: buff];
    }
    NSString *sent = [dic valueForKey: @"sent"];
    if([sent isKindOfClass: [NSString class]]){
        [self _LUA_execute: [NSString stringWithFormat: @"%@()", sent]];
    }
}

- (void) _LUA_setZoomable: (NSNumber *) value{
    self.model.zoomable = [value boolValue];
    
    [self reload];
}

- (BOOL) _LUA_getZoomable{
    return self.model.zoomable;
}

-(void)onReload{
    [super onReload];

    if (usingJit) {
    } else {
        APPLY_DIRTY_MODEL_PROP(zoomable, uiwebview.scalesPageToFit);
    }
}

- (void) setSchemeHandler: (NSString *) schema :(LuaFunction *) func{
    if ([schema isKindOfClass: [NSString class]] && [func isKindOfClass: [LuaFunction class]]) {
        [schemeHandlerMap setValue: func forKey: schema];
    }
}

- (BOOL) shouldStartLoadWithURL:(NSURL *) url{
    NSString *scheme = [url scheme];
    LuaFunction *schemeHandler = [schemeHandlerMap valueForKey: scheme];
    if (schemeHandler) {
        [schemeHandler executeWithoutReturnValue: self, [url absoluteString], nil];
        return NO;
    }else if ([scheme isEqualToString: @"lua"]) {
        NSString *query = [[url query] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [self processLua: query];
        return NO;
    }else if ([url isFileURL]){
        return YES;
    }else if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]){
        self.lastURL = url;
        return YES;
    }else if([scheme isEqualToString: @"about"]){
        return YES;
    }else if([scheme isEqualToString: @"javascript"]){
        return YES;
    }else{
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }

    return YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return [self shouldStartLoadWithURL: request.URL];
}

- (void) webViewDidStartLoad {
    progressCount++;

    busyView.alpha = 1;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self webViewDidStartLoad];
}

-(void)webViewDidFinishLoad {
    progressCount--;
    if (progressCount <= 0) {
        busyView.alpha = 0;
        [self hideCoverMessage];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self webViewDidFinishLoad];
}

-(void)webViewDidFailLoadWithError:(NSError *)error{
    progressCount--;
    busyView.alpha = 0;
    NSURL *url = [self.pageSandbox resolveFile:@"error/no-connection.html"];
    NSString *path = [url path];
    if ([[NSFileManager defaultManager] fileExistsAtPath: path]) {
        NSString *body = [NSString stringWithContentsOfFile: path encoding: NSUTF8StringEncoding error: nil];
        NSData *data = [[CJSONSerializer serializer] serializeObject: [self.lastURL absoluteString] error: nil];
        NSString *str = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        body = [body stringByReplacingOccurrencesOfString: @"${currentUrl}"
                                               withString: str];
        if (usingJit) {
            [wkwebview loadHTMLString: body baseURL: url];
        } else {
            [uiwebview loadHTMLString: body baseURL: url];
        }
    }else {
        retryButton.alpha = 1;
        [self setCoverMessage: [error description] withType: 0];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (error.code == NSURLErrorCancelled){
        return;
    }
    
    [self webViewDidFailLoadWithError: error];
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self webViewDidStartLoad];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self webViewDidFinishLoad];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self webViewDidFailLoadWithError: error];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)())completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController: alertController
                                                                                 animated: YES
                                                                               completion: nil];

}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController: alertController
                                                                                 animated: YES
                                                                               completion: nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    completionHandler(@"prompt not supported.");
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    BOOL should = [self shouldStartLoadWithURL: navigationAction.request.URL];
    decisionHandler(should ? WKNavigationActionPolicyAllow : WKNavigationActionPolicyCancel);
}

// window.webkit.messageHandlers.myApp.postMessage({"message":"Hello there"});
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    NSDictionary *sentData = (NSDictionary *)message.body;
    NSString *messageString = sentData[@"message"];
    NSLog(@"Message received: %@", messageString);
}


-(void)dealloc{
    [OSUtils runSyncBlockOnMain:^{
        uiwebview = nil;
        wkwebview = nil;
    }];
    [indicatorView stopAnimating];
}

@end
