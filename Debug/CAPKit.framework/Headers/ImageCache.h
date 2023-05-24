#import <UIKit/UIKit.h>
#import <CAPKit/LruCache.h>

@interface ImageCache : LruCache

@property (nonatomic, assign) BOOL disabled;

+ (ImageCache *) sharedInstance;

@end
