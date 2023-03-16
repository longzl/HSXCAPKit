#define SET_SELF_FROM_IF(CASE,ATTR) if(CASE){(self.ATTR)=(from.ATTR);}
#define SET_SELF_FROM_IFNIL(ATTR) SET_SELF_FROM_IF(!self.ATTR, ATTR)
#define SET_SELF_FROM_IFNAN(ATTR) SET_SELF_FROM_IF(isnan(self.ATTR), ATTR)

typedef enum{
    AlignTypeNone,
    AlignTypeLeft,
    AlignTypeCenter,
    AlignTypeRight,
    AlignTypeFill,
    AlignTypeTop,
    AlignTypeMiddle,
    AlignTypeBottom
} AlignType;

@class CAPViewM;

/**
 You must override copyWithZone,mergeFromDic,fillDic
 */
@interface UIWidgetM : NSObject <NSCopying>

@property (nonatomic, strong) PNum *width;
@property (nonatomic, strong) PNum *height;

@property (nonatomic, strong) PNum *marginLeft;
@property (nonatomic, strong) PNum *marginRight;
@property (nonatomic, strong) PNum *marginTop;
@property (nonatomic, strong) PNum *marginBottom;
@property (nonatomic, strong) NSString *margin;

@property (nonatomic, strong) PNum *paddingLeft;
@property (nonatomic, strong) PNum *paddingRight;
@property (nonatomic, strong) PNum *paddingTop;
@property (nonatomic, strong) PNum *paddingBottom;
@property (nonatomic, strong) NSString *padding;

@property (nonatomic, assign) AlignType alignX;
@property (nonatomic, assign) AlignType alignY;

@property (nonatomic, strong) NSObject *backgroundColor;
@property (nonatomic, strong) NSObject *backgroundImage;
@property (nonatomic, strong) NSString *backgroundScale;

@property (nonatomic, strong) NSObject *backgroundGradient;

@property (nonatomic, strong) NSString *tip;

@property (nonatomic, weak) CAPViewM *parent;

@property (nonatomic, assign) float backgroundAlpha;
@property (nonatomic, assign) float alpha;
@property (nonatomic, assign) CGAffineTransform transform;

@property (nonatomic, assign) float borderWidth;
@property (nonatomic, assign) float borderAlpha;

@property (nonatomic, assign) float cornerRadius;

@property (nonatomic, strong) NSObject *borderColor;

@property (nonatomic, assign) BOOL touchDisabled;
@property (nonatomic, assign) BOOL hasTouchDisabled;
@property (nonatomic, assign) BOOL hidden;

@property (nonatomic, readonly) NSString *itemId;
@property (nonatomic, readonly) NSString *qName;

//@property (nonatomic, readonly) NSMutableDictionary *itemDic;

@property (nonatomic, readonly) NSString *data;

@property (nonatomic, strong) NSObject *onchange;
@property (nonatomic, strong) NSObject *onerror;
@property (nonatomic, strong) NSObject *onload;

@property (nonatomic, strong) LuaFunction *ontouchup;
@property (nonatomic, strong) LuaFunction *ontouchmove;
@property (nonatomic, strong) LuaFunction *ontouchdown;

- (void) mergeFromDic: (NSDictionary *) dic;
//- (void) mergeFromModel: (UIWidgetM *) from;

- (void) parsePadding: (NSString *) value;
- (void) parseMargin: (NSString *) value;

- (BOOL) parseTransform: (NSArray *) value;
- (NSArray *) buildTransform;

- (void) fillSelfDic: (NSMutableDictionary *) dic;

- (void) fillDic: (NSMutableDictionary *) dic;

@end
