#import <CAPKit/CAPKit.h>

@interface ScreenScale : NSObject{
    float defaultScale;
    float fontScale;
}

- (id) initWithPath: (NSURL *) filePath;
- (id) initWithDictionary: (NSDictionary *) dic;

- (float) getActualLength: (float) length;
- (CGRect) getActualRect: (CGRect) rect;
- (CGSize) getActualSize: (CGSize) size;

- (float) getDefaultScale;
- (float) getFontScale;

- (float) getFontSize: (float) size;
- (float) getRefFontSize: (float) size;

- (float) getRefLength: (float) length;
- (CGRect) getRefRect: (CGRect) rect;
- (CGSize) getRefSize: (CGSize) size;

@end
