//
//  PagePanel.h
//  EOSClient2
//
//  Created by Chang Sam on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@class CAPPageSandbox;
@class CAPPageM;
@class ManifestM;

@protocol PagePanel

/**invoked when this `Panel` is fully created.*/
- (void) onCreated;

/**invoked when this `Panel` is going to destory*/
- (void) onDestroy;

/**invoked when this `Panel` is move to front of this screen*/
- (void) onFronted;

/**invoked when this `Panel` is move to backend of this screen*/
- (void) onBackend;

- (CAPPageM *) getModel;

- (void) setContext: (AppContext *) context;

- (CAPPageSandbox *) getSandbox;

- (void) reloadSize;

-(id)initWithURL: (NSURL *) url withSandbox: (CAPPageSandbox *) sandbox;

@end
