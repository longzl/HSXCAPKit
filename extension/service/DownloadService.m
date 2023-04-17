//
//  DownloadService.m
//  EOSFramework
//
//  Created by Sam Chang on 1/11/13.
//
//

#import "DownloadService.h"
#import "IDownloadService.h"
#import "FMDatabaseAdditions.h"
#import "ASIHTTPRequest.h"

@implementation DownloadService

+(void)load{
    [[ESRegistry getInstance] registerService: @"DownloadService" withName: @"download"];
}

-(BOOL)singleton{
    return YES;
}

- (id)init
{
    self = [super init];
    if (self) {
        downloadInfos = [[NSMutableDictionary alloc] initWithCapacity: 2];
        
        [[NSFileManager defaultManager] createDirectoryAtPath: [[CAPCenter shared].lastContainer.option.cacheRoot stringByAppendingPathComponent: @"download"]
                                  withIntermediateDirectories: YES
                                                   attributes: nil
                                                        error: nil];
        
        downloaddb = [[FMDatabase alloc] initWithPath:
                [[CAPCenter shared].lastContainer.option.documentRoot
                 stringByAppendingPathComponent: @"download.sqlite"]];

        if (![downloaddb open]) {
            downloaddb = nil;
        }
        [downloaddb setShouldCacheStatements:YES];
        
        if (![downloaddb tableExists: @"download"]) {
            [downloaddb executeUpdate: @"create table download (id text, urlString text, cachekey text, path text, status number, progress integer, autostart integer)"];
            if ([downloaddb hadError]) {
                NSLog(@"Error %d: %@", [downloaddb lastErrorCode], [downloaddb lastErrorMessage]);
            }
        }else{
            [downloaddb executeUpdate: @"update download set status=? where autostart=0 and status=?", [NSNumber numberWithInt: DownloadStatusPause], [NSNumber numberWithInt: DownloadStatusRunning], nil];
            FMResultSet *rs = [downloaddb executeQuery: @"select id,path,urlString,status,progress from download", nil];
            while ([rs next]) {
                NSString *infoid = [rs stringForColumnIndex: 0];
                
                DownloadInfo *info = [[DownloadInfo alloc] init];
                info.infoid = [rs stringForColumnIndex: 0];
                info.path = [rs stringForColumnIndex: 1];
                info.urlString = [rs stringForColumnIndex: 2];
                info.status = [rs intForColumnIndex: 3];
                info->progress = [rs intForColumnIndex: 4];
                
                info->downloaddb = downloaddb;
                
                [downloadInfos setValue: info forKey: infoid];
                
                if (info.status == DownloadStatusRunning) {
                    [info resume];
                }
            }
            [rs close];
        }
    }
    return self;
}

- (DownloadInfo *) add: (NSString *) urlString : (NSString *) cachekey : (BOOL) autostart{
    if (!cachekey) {
        cachekey = urlString;
    }
    
    DownloadInfo *info = nil;
    
    @synchronized(downloaddb){
        FMResultSet *rs = [downloaddb executeQuery: @"select id,path,urlString,status from download where cachekey=?" withArgumentsInArray: [NSArray arrayWithObject: cachekey]];
        if ([rs next]) {
            NSString *infoid = [rs stringForColumnIndex: 0];
            info = [downloadInfos valueForKey: infoid];
            
            if (!info) {
                info = [[DownloadInfo alloc] init];
                info.infoid = [rs stringForColumnIndex: 0];
                info.path = [rs stringForColumnIndex: 1];
                info.status = [rs intForColumnIndex: 3];
                info->downloaddb = downloaddb;
                
                [downloadInfos setValue: info forKey: infoid];
            }

            info.urlString = urlString;
        }
        [rs close];
    }
    if (!info) {
        info = [[DownloadInfo alloc] init];
        info.infoid = [OSUtils uuid];
        info.urlString = urlString;
        info.path = [NSString stringWithFormat: @"download/%@", [OSUtils md5String: cachekey]];
        info.status = DownloadStatusUnknown;
        info->downloaddb = downloaddb;
        
        [downloadInfos setValue: info forKey: info.infoid];
        @synchronized(downloaddb){
            [downloaddb executeUpdate: @"insert into download (id,path,status,urlString,cachekey,autostart) values(?,?,?,?,?,?)", info.infoid, info.path, [NSNumber numberWithInt: info.status], info.urlString, cachekey, [NSNumber numberWithBool: autostart], nil];
        }
    }else{
        @synchronized(downloaddb){
            [downloaddb executeUpdate: @"update download set urlString=?,autostart=? where id=?", urlString, [NSNumber numberWithBool: autostart], info.infoid, nil];
        }
    }
    
//    //do nothing on completed task and running task
//    if (info.status != DownloadStatusRunning && info.status != DownloadStatusComplete) {
//        [info resume];
//    }
    
    //TODO: task
    
    return info;
}

-(DownloadInfo *)add:(NSString *)urlString : (NSString *) cachekey{
    return [self add: urlString : cachekey : NO];
}

-(DownloadInfo *)add:(NSString *)urlString{
    return [self add: urlString : urlString];
}

- (DownloadInfo *) query: (NSString *) infoid{
    DownloadInfo *info = [downloadInfos valueForKey: infoid];
    if (!info) {
        @synchronized(downloaddb){
            FMResultSet *rs = [downloaddb executeQuery: @"select id,path,urlString,status,progress from download where id=?" withArgumentsInArray: [NSArray arrayWithObject: infoid]];
            if ([rs next]) {
                info = [[DownloadInfo alloc] init];
                info.infoid = [rs stringForColumnIndex: 0];
                info.path = [rs stringForColumnIndex: 1];
                info.urlString = [rs stringForColumnIndex: 2];
                info.status = [rs intForColumnIndex: 3];
                info->progress = [rs intForColumnIndex: 4];
                info->downloaddb = downloaddb;
                
                [downloadInfos setValue: info forKey: infoid];
            }
            [rs close];
        }
    }
    
    return info;
}

- (BOOL) _LUA_delete: (NSString *) infoid{
    DownloadInfo *info = [self query: infoid];
    
    if (!info) {
        return NO;
    }
    
    if (info.status == DownloadStatusRunning) {
        [info stop];
    }
    
    @synchronized(downloaddb){
        [downloaddb executeUpdate: @"delete from download where id=?", info.infoid, nil];
    }
    
    [[NSFileManager defaultManager] removeItemAtPath: [[CAPCenter shared].lastContainer.option.cacheRoot stringByAppendingPathComponent: info.infoid] error: nil];
    [[NSFileManager defaultManager] removeItemAtPath: [[CAPCenter shared].lastContainer.option.cacheRoot stringByAppendingPathComponent: info.path] error: nil];
    
    return YES;
}

- (DownloadInfo *) pause: (NSString *) infoid{
    DownloadInfo *info = [self query: infoid];
    
    if (!info) {
        return nil;
    }
    
    [info pause];
    
    return info;
}

- (void) pauseAll{
    for (DownloadInfo *info in [downloadInfos allValues]) {
        if (info.status == DownloadStatusRunning) {
            [info pause];
        }
    }
}

-(void)resumeAll{
    for (DownloadInfo *info in [downloadInfos allValues]) {
        if (info.status == DownloadStatusRunning) {
            [info resume];
        }
    }
}

-(void)stopAll{
    for (DownloadInfo *info in [downloadInfos allValues]) {
        if (info.status == DownloadStatusRunning) {
            [info stop];
        }
    }
}

- (DownloadInfo *) resume: (NSString *) infoid{
    DownloadInfo *info = [self query: infoid];
    
    if (!info) {
        return nil;
    }
    
    [info resume];
    
    return info;
}

- (DownloadInfo *) stop: (NSString *) infoid{
    DownloadInfo *info = [self query: infoid];
    
    if (!info) {
        return nil;
    }
    
    [info stop];
    
    return info;
}

- (LuaTable *) toLuaTable{
    LuaTable *table = [[LuaTable alloc] init];
    [table.map setValue: [NSNumber numberWithInt: DownloadStatusComplete]
                 forKey: @"StatusComplete"];
    
    [table.map setValue: [NSNumber numberWithInt: DownloadStatusStop]
                 forKey: @"StatusStop"];
    
    [table.map setValue: [NSNumber numberWithInt: DownloadStatusPause]
                 forKey: @"StatusPause"];
    
    [table.map setValue: [NSNumber numberWithInt: DownloadStatusRunning]
                 forKey: @"StatusRunning"];
    
    [table.map setValue: [NSNumber numberWithInt: DownloadStatusUnknown]
                 forKey: @"StatusUnknown"];
    
    [table.map setValue: [NSNumber numberWithInt: DownloadStatusNotFound]
                 forKey: @"StatusNotFound"];
    return table;
}

- (void)dealloc
{
    [downloaddb close];
}

@end
