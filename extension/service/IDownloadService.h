//
//  IDownloadService.h
//  EOSFramework
//
//  Created by Sam Chang on 1/11/13.
//
//

#import <CAPKit/CAPKit.h>
#import "DownloadInfo.h"

@protocol IDownloadService <NSObject>

- (DownloadInfo *) add: (NSString *) urlString;
- (DownloadInfo *) add: (NSString *) urlString : (NSString *) cachekey;
- (DownloadInfo *) query: (NSString *) infoid;
- (BOOL) _LUA_delete: (NSString *) infoid;

- (DownloadInfo *) pause: (NSString *) infoid;
- (DownloadInfo *) resume: (NSString *) infoid;
- (DownloadInfo *) stop: (NSString *) infoid;

- (void) pauseAll;
- (void) resumeAll;
- (void) stopAll;

@end
