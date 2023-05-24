//
//  DownloadManager.h
//  EOSFramework
//
//  Created by Chang Sam on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>
#import "ASIHTTPRequest.h"

typedef enum{
    TaskStatusUnknown,
    TaskStatusRunning,
    TaskStatusPause,
    TaskStatusStopped,
    TaskStatusFinished
}TaskStatus;

@interface DTask : NSObject <ASIHTTPRequestDelegate>{
    NSString *urlString;
    NSString *storagePath;
    NSString *resourceId;
    TaskStatus status;
    ASIHTTPRequest *request;
}

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *storagePath;
@property (nonatomic, strong) NSString *resourceId;
@property (nonatomic, assign) TaskStatus status;

- (void) stop;
- (void) pause;
- (void) resume;

@end

@interface DownloadManager : NSObject {
    NSMutableDictionary *tasks;
    NSString *downloadCachePath;
}

- (NSString *) addTask: (NSString *) urlString withPath: (NSString *) storagePath;
- (TaskStatus) getTaskStatus: (NSString *) taskId;

- (void) stopAll;
- (void) stop: (NSString *) taskId;
- (void) pause: (NSString *) taskId;
- (void) resume: (NSString *) taskId;
- (void) cancel: (NSString *) taskId;

@end
