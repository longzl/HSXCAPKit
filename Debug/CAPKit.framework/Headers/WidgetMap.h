@interface WidgetMap : NSObject

+ (void) bind: (NSString *) qname
withModelClassName: (NSString *) mClsName
withWidgetClassName: (NSString *) wClsName;

+ (NSString *) getModelClassName: (NSString *) qname;
+ (NSString *) getWidgetClassName: (NSString *) qname;

+ (NSString *) getWidgetClassNameByModel: (UIWidgetM *) model;

@end
