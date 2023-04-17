//
//  DownloadInfo.h
//  EOSFramework
//
//  Created by Sam Chang on 1/11/13.
//
//

#import <CAPKit/CAPKit.h>
#import "ASIHTTPRequest.h"
#import "FMDatabase.h"

typedef enum{
    DownloadStatusUnknown,
    DownloadStatusStop,
    DownloadStatusPause,
    DownloadStatusRunning,
    DownloadStatusComplete,
    DownloadStatusNotFound
} DownloadStatus;

@interface DownloadInfo : AbstractLuaTableCompatible <ASIHTTPRequestDelegate>{
    NSMutableArray *progressWatchers;
    NSMutableArray *statusWatchers;
    
    @public
    int progress;
    
    FMDatabase *downloaddb;
}

@property (nonatomic, strong) NSString *infoid;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, assign) DownloadStatus status;
@property (nonatomic, strong) ASIHTTPRequest *http;

- (void) stop;
- (void) pause;
- (void) resume;

@end
