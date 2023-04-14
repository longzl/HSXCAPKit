//
//  WebViewM.h
//  EOSClient2
//
//  Created by Song on 10/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CAPKit/CAPKit.h>

@interface CAPWebViewM : UIWidgetM

@property (nonatomic, strong) NSString *src;
@property (nonatomic, assign) BOOL zoomable;
@property (nonatomic, assign) BOOL opaque;
@property (nonatomic, assign) BOOL jit;

@property (nonatomic, strong) LuaFunction *didStartLoad;
@property (nonatomic, strong) LuaFunction *didStopLoad;

@property (nonatomic, assign) BOOL busyhidden;

@end
