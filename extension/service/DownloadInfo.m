//
//  DownloadInfo.m
//  EOSFramework
//
//  Created by Sam Chang on 1/11/13.
//
//

#import "DownloadInfo.h"
#import "IDownloadInfo.h"

@implementation DownloadInfo

- (id)init
{
    self = [super init];
    if (self) {
        progressWatchers = [[NSMutableArray alloc] init];
        statusWatchers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) cancel{
    if ([_http isExecuting]) {
        [_http cancel];
        
        self.http = nil;
    }
}

- (void) stop{
    [self updateStatus: DownloadStatusStop];
    
    [self cancel];
}

- (void) pause{
    [self updateStatus: DownloadStatusPause];
    [self cancel];
}

- (void) resume{
    [self cancel];
    
    _http = [ASIHTTPRequest requestWithURL: [NSURL URLWithString: _urlString]];
    
    [_http setDelegate: self];
    [_http setTemporaryFileDownloadPath: [[CAPCenter shared].lastContainer.option.cacheRoot stringByAppendingPathComponent: _infoid]];
    [_http setAllowResumeForFileDownloads: YES];
    [_http setDownloadDestinationPath: [[CAPCenter shared].lastContainer.option.cacheRoot stringByAppendingPathComponent: _path]];
    [_http setTimeOutSeconds: 30];
    [_http setPersistentConnectionTimeoutSeconds: 30];
    
    __unsafe_unretained DownloadInfo *weakSelf = self;
    __unsafe_unretained ASIHTTPRequest *http = _http;

    [_http setHeadersReceivedBlock:^(NSDictionary *responseHeaders) {
        if (weakSelf.http.responseStatusCode == 302) {
            [weakSelf setUrl: [http.url absoluteString]];
        }
        NSLog(@"RequestHeaders=%@", http.requestHeaders);
        NSLog(@"didReceiveResponseHeaders=%@ %@ %@", http.responseStatusMessage, http.url, http.responseHeaders);
        if (http.responseStatusCode >= 400 && weakSelf.status == DownloadStatusRunning) {
            [weakSelf updateStatus: DownloadStatusPause];
            [weakSelf cancel];
        }
    }];
    
    [_http setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        if (http.responseStatusCode < 300 && http.responseStatusCode >= 200) {
            unsigned long long downloaded = [http totalBytesRead] + [http partialDownloadSize];
//            NSLog(@"%lld/%lld", downloaded, total);
            [weakSelf updateProgress: (int)(downloaded * 1000 / total)];
        }
    }];
    
    [_http setCompletionBlock:^{
        if (http.responseStatusCode < 300 && http.responseStatusCode >= 200 && http.error == nil) {
            [weakSelf updateProgress: 1000]; // 1000 will update status with complete
            [weakSelf updateStatus: DownloadStatusComplete];
        }else if (http.responseStatusCode >= 400 || http.error != nil){
            if (weakSelf.status == DownloadStatusRunning) {
                [weakSelf updateStatus: DownloadStatusNotFound];
            }
        }
        
//        NSLog(@"Complete responseStatusCode=%d, error=%@", http.responseStatusCode, http.error);
    }];
    
    [_http setFailedBlock:^{
        if (http.error) {
            NSLog(@"%@", http.error);
        }
        if (weakSelf.status == DownloadStatusRunning) {
            [weakSelf updateStatus: DownloadStatusPause];
        }
        [http clearDelegatesAndCancel];
    }];
    
    [_http startAsynchronous];
    
    [self updateStatus: DownloadStatusRunning];
}

- (void) updateStatus: (DownloadStatus) st{
    _status = st;
    @synchronized(downloaddb){
        [downloaddb executeUpdate: @"update download set status=? where id=?", [NSNumber numberWithInt: _status], _infoid, nil];
    }
    
    @synchronized(statusWatchers){
        NSArray *watchers = [NSArray arrayWithArray: statusWatchers];
        
        for (LuaFunction *watcher in watchers) {
            if ([watcher isValid]) {
                [watcher executeWithoutReturnValue: self, [NSNumber numberWithInt: _status], nil];
            }else{
                [statusWatchers removeObject: watcher];
            }
        }
    }
}

- (void) updateProgress: (int) value {
    if (progress != value) {
        progress = value;
        @synchronized(downloaddb){
            [downloaddb executeUpdate: @"update download set progress=? where id=?", [NSNumber numberWithInt: progress], _infoid, nil];
        }
        
        @synchronized(progressWatchers){
            NSArray *watchers = [NSArray arrayWithArray: progressWatchers];
            
            for (LuaFunction *watcher in watchers) {
                if ([watcher isValid]) {
                    [watcher executeWithoutReturnValue: self, [NSNumber numberWithInt: progress], nil];
                }else{
                    [progressWatchers removeObject: watcher];
                }
            }
        }
    }
}

- (NSString *) getId{
    return _infoid;
}

- (NSString *) getPath{
    return _path;
}

- (NSString *) getAbsolutePath{
    return [[CAPCenter shared].lastContainer.option.cacheRoot stringByAppendingPathComponent: _path];
}

- (void) setUrl: (NSString *) value{
    if (value) {
        self.urlString = value;
        
        @synchronized(downloaddb){
            [downloaddb executeUpdate: @"update download set urlString=? where id=?", value, self.infoid, nil];
        }
    }
}

- (NSString *) getUrl{
    return self.urlString;
}

- (DownloadStatus) getStatus{
    return _status;
}

- (int) getProgress{
    return progress;
}

- (LuaFunctionWatcher *) addProgressWatcher: (LuaFunction *) func{
    if (![func isKindOfClass: [LuaFunction class]]) {
        return nil;
    }
    
    @synchronized(progressWatchers){
        [progressWatchers addObject: func];
    }
    
    return [[LuaFunctionWatcher alloc] initWithLuaFunction: func];
}

- (LuaFunctionWatcher *) addStatusWatcher: (LuaFunction *) func{
    if (![func isKindOfClass: [LuaFunction class]]) {
        return nil;
    }
    
    @synchronized(statusWatchers){
        [statusWatchers addObject: func];
    }
    
    return [[LuaFunctionWatcher alloc] initWithLuaFunction: func];
}

- (void) __gc{
}

- (void)dealloc
{
    [self cancel];
}

@end
