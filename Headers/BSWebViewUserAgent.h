//
//  BSWebViewUserAgent.h
//  EOSFramework
//
//  Created by Sam on 5/29/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>

@interface BSWebViewUserAgent : NSObject <UIWebViewDelegate> {
	NSString *userAgent;
	UIWebView *webView;
}
@property (nonatomic, strong) NSString *userAgent;
-(NSString*)userAgentString;
@end
