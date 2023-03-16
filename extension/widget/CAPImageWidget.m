//
//  ImageWidget.m
//  EOSClient2
//
//  Created by Song on 10/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPImageWidget.h"
#import "CAPImageM.h"
#import "NSData+Base64.h"

@interface CAPImageWidget ()

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation CAPImageWidget

+(void)load{
    [WidgetMap bind: @"image" withModelClassName: NSStringFromClass([CAPImageM class]) withWidgetClassName: NSStringFromClass([CAPImageWidget class])];
}

-(id)initWithModel:(UIWidgetM *)m withPageSandbox: (CAPPageSandbox *) sandbox{
    self = [super initWithModel: m withPageSandbox: sandbox];
    if (self) {
    }
    return self;
}

- (void) onCreateView{
    view = [[UIView alloc] initWithFrame: [self getActualCurrentRect]];
    view.autoresizingMask = UIViewAutoresizingNone;
    view.clipsToBounds = YES;
    if (self.model.hasTouchDisabled) {
        view.userInteractionEnabled = !self.model.touchDisabled;
    }else{
        view.userInteractionEnabled = NO;
    }
    imageView = [[YLImageView alloc] initWithFrame: view.bounds];
//    imageView.contentMode = UIViewContentModeCenter;
    [view addSubview: imageView];
    
    if (self.model.src != nil) {
        [self applySrc];
    }
}

- (void) updateImageFrame{
    NSString *scale = self.model.scale;
    CGRect rect = [self innerView].frame;
    scale = [scale stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([scale isEqualToString: @"none"]) {
        [imageView sizeToFit];
    }else if ([scale isEqualToString: @"center"]){
        [imageView sizeToFit];
        CGFloat x = (rect.size.width - imageView.image.size.width) / 2;
        CGFloat y = (rect.size.height - imageView.image.size.height) / 2;
        imageView.frame = CGRectMake(x, y, imageView.image.size.width, imageView.image.size.height);
    }else if ([scale isEqualToString: @"fill"] || [scale hasPrefix: @"clip"]) {
        imageView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    }else if (scale == nil || [scale isEqualToString: @"fitWidth"]) {
        float scale = imageView.image.size.width / rect.size.width;
        float height = imageView.image.size.height / scale;
        imageView.frame = CGRectMake(0, 0, rect.size.width, height);
    }else if([scale isEqualToString: @"fitHeight"]){
        float scale = imageView.image.size.height / rect.size.height;
        float width = imageView.image.size.width / scale;
        imageView.frame = CGRectMake(0, 0, width, rect.size.height);
    }
}

- (BOOL) reloadImage: (UIImage *) image{
    BOOL hasSet = NO;
    if ([self.model.scale hasPrefix: @"clip"]) {
        NSString *clip = [self.model.scale substringFromIndex: [@"clip" length]];
        clip = [clip stringByReplacingOccurrencesOfString: @"(" withString: @""];
        clip = [clip stringByReplacingOccurrencesOfString: @")" withString: @""];
        NSArray *items = [clip componentsSeparatedByString: @","];
        
        NSMutableArray *trimedItems = [[NSMutableArray alloc] initWithCapacity: [items count]];
        for (NSString *item in items) {
            [trimedItems addObject: [item stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
        int top = 0,right = 0,bottom = 0,left = 0;
        if ([trimedItems count] >= 2) {
            top = [[trimedItems objectAtIndex: 0] intValue];
            right = [[trimedItems objectAtIndex: 1] intValue];
            if ([trimedItems count] >= 4) {
                bottom = [[trimedItems objectAtIndex: 2] intValue];
                left = [[trimedItems objectAtIndex: 3] intValue];
            }else{
                bottom = top;
                left = right;
            }
            
            UIImage *clippedImage = nil;
            if ([image respondsToSelector: @selector(resizableImageWithCapInsets:resizingMode:)]) {
                clippedImage = [image resizableImageWithCapInsets: UIEdgeInsetsMake(top, left, bottom, right)
                                                     resizingMode: UIImageResizingModeStretch];
            } else{
                clippedImage = [image stretchableImageWithLeftCapWidth: left topCapHeight: top];
            }
            imageView.image = clippedImage;
            hasSet = YES;
        }
    }
    if (!hasSet){
        if (image != nil) {
            imageView.image = image;
            [self updateImageFrame];
        }
    }
    
    return YES;
}

- (void)processImageData:(id)imagePath {
    imageView.image = nil;
    if ([imagePath isKindOfClass: [NSString class]]) {
        UIImage *image = [[ImageCache sharedInstance] get: imagePath];
        [self reloadImage: image];
    }else if ([imagePath isKindOfClass: [UIImage class]]){
        [self reloadImage: (UIImage *)imagePath];
    }
    
    [OSUtils executeDirect: self.model.onload withSandbox: self.pageSandbox withObject: self];
}

- (void) applySrc{
    __weak typeof(self) weakSelf = self;
    if (self.dataTask) {
        [self.dataTask cancel];
        self.dataTask = nil;
    }
    
    if ([self.model.src isKindOfClass: [UIImage class]]) {
        [self reloadImage: self.model.src];
    } else if ([self.model.src isKindOfClass: [CAPLuaImage class]]) {
        CAPLuaImage *luaImage = (CAPLuaImage *) self.model.src;
        [luaImage getImage:^(UIImage *img) {
            [weakSelf reloadImage: img];
        }];
    } else if ([self.model.src isKindOfClass: [NSString class]]){
        if ([self.model.src hasPrefix: @"data:"] && ![self.model.src hasPrefix: @"data://"]) {
            UIImage *image = [OSUtils imageFromDataString: self.model.src];
            [self processImageData: image];
        }else{
            NSURL *imageURL = [self.pageSandbox resolveFile: self.model.src];
            if ([imageURL isFileURL]) {
                [self processImageData:[imageURL path]];
            }else if([imageURL isKindOfClass: [NSURL class]]){
                NSLog(@"%@", imageURL);
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: imageURL
                                                                       cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                                   timeoutInterval: 60];

                NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest: request];
                if (cachedResponse.data) {
                    NSDictionary *allHeaderFields = ((NSHTTPURLResponse *)cachedResponse.response).allHeaderFields;
                    NSString *etag = nil;
                    NSString *cache_control = nil;
                    for (NSString *key in allHeaderFields.allKeys) {
                        NSString *key_lower = [key lowercaseString];
                        if ([key_lower isEqualToString: @"etag"]) {
                            etag = allHeaderFields[key];
                        } else if ([key_lower isEqualToString: @"cache-control"]) {
                            cache_control = allHeaderFields[key];
                        }
                    }

                    if ([cache_control rangeOfString: @"no-cache"].length > 0) {
                        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
                    }

                    [request addValue: etag forHTTPHeaderField: @"If-None-Match"];
                }
                if (cachedResponse.data){
                    [self processImageData: [YLGIFImage imageWithData: cachedResponse.data]];
                } else if ([self.model.placeholder isKindOfClass: [NSString class]]) {
                    NSURL *placeHolderURL = [self.pageSandbox resolveFile: self.model.placeholder];
                    if ([placeHolderURL isFileURL]) {
                        [self processImageData:[placeHolderURL path]];
                    }
                }

                self.dataTask =
                [[NSURLSession sharedSession]
                 dataTaskWithRequest: request
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                     if (!error && data) {
                         if (((NSHTTPURLResponse *) response).statusCode < 300 && ((NSHTTPURLResponse *) response).statusCode >= 200) {
                             [OSUtils runBlockOnMain:^{
                                 [weakSelf processImageData: [YLGIFImage imageWithData: data]];
                             }];
                         }
                     } else {
                         NSDictionary *resp = @{@"responseCode": [NSNumber numberWithLong: ((NSHTTPURLResponse *) response).statusCode]};
                         [OSUtils executeDirect: weakSelf.model.onerror withSandbox: weakSelf.pageSandbox withObject: weakSelf withObject: resp];
                         NSLog(@"image download failed! - %@ - %@", imageURL, error);
                     }

                     weakSelf.dataTask = nil;
                 }];

                [self.dataTask resume];
            } else {
                [OSUtils runBlockOnMain:^{
                    [weakSelf processImageData: nil];
                }];
            }
        }
    }
}

- (void) onReload{
    BOOL needRefreshSrc = NO;
    APPLY_DIRTY_MODEL_PROP_DO(src, {
        needRefreshSrc = YES;
    });
    APPLY_DIRTY_MODEL_PROP_DO(scale, {
        needRefreshSrc = YES;
    });

    if (imageView.image && [imageView.image isKindOfClass: [YLGIFImage class]]) {
        UIImage *image = imageView.image;
        imageView.image = nil;
        imageView.image = image;
    }

    if (needRefreshSrc) {
        [self applySrc];
    }
}

- (void)setData:(NSObject *) data{
    if ([data isKindOfClass: [NSString class]]) {
        self.model.src = (NSString *) data;
    } else if ([data isKindOfClass: [NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *) data;
        if ([dic valueForKey: @"src"]) {
            self.model.src = [dic valueForKey: @"src"];
        }
    }
}

-(UIView *)innerView{
    return view;
}

-(void)setViewFrame:(CGRect)rect{
    [super setViewFrame: rect];
    
    if (imageView.image == nil) {
        return;
    }else{
        [self updateImageFrame];
    }
    
}

- (void) setImage: (UIImage *) img{
    self.model.src = img;
    [self reload];
}

- (UIImage *) getImage{
    return imageView.image;
}

#pragma mark Lua API Begin
- (void) _LUA_setImage: (id) img{
    self.model.src = img;
    [self reload];
}

- (CAPLuaImage *) _LUA_getImage{
    return [[CAPLuaImage alloc] initWithImage: imageView.image];
}

- (void) setSrc: (NSObject *) src{
    self.model.src = src;
    
    [self reload];
}

- (NSObject *)getSrc{
    return self.model.src;
}

- (void) setPlaceHolder: (NSString *) src{
    self.model.placeholder = src;
    
    [self reload];
}

- (NSString *) getPlaceholder{
    return self.model.placeholder;
}

- (void) setScale: (NSString *) scale{
    self.model.scale = scale;
    
    [self reload];
}

- (NSString *) getScale{
    return self.model.scale;
}

#pragma mark Lua API End

@end
