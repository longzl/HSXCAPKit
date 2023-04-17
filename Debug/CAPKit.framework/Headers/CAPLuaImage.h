#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

typedef void (^image_callback)(UIImage *img);

@interface CAPLuaImage : AbstractLuaTableCompatible

@property (nonatomic, readonly) PHAsset *asset;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly, assign) CGSize assetSize;
@property (nonatomic, assign) BOOL aspectRadio;

- (instancetype) initWithAsset: (PHAsset *) asset;
- (instancetype) initWithAsset: (PHAsset *) asset withSize: (CGSize) size;
- (instancetype) initWithImage: (UIImage *) img;
- (instancetype) initWithPath: (NSString *) path;

- (void) getImage: (image_callback) callback;
- (UIImage *) syncGetImage;

@end
