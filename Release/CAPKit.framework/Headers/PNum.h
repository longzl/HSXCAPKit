@interface PNum : NSObject <NSCopying>{
    float value;
    BOOL percentage;
    BOOL usingAuto;
}

@property (nonatomic, readonly) float value;
@property (nonatomic, readonly) BOOL percentage;
@property (nonatomic, readonly) BOOL usingAuto;

+ (PNum *) pnumWithObject: (NSObject *) obj;
+ (PNum *) pnumWithValue: (float) v withPercentage: (BOOL) p;

+ (PNum *) zero;

- (float) pixelValue: (float) parent;
- (float) pixelValue: (float) parent withDefault: (float) v;

- (NSObject *) getObject;

@end
