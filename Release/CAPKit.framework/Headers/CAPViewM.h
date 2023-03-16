typedef enum {
    LayoutTypeNone,
    LayoutTypeAbsolute,
    LayoutTypeFlowX,
    LayoutTypeFlowY
} LayoutType;

typedef enum {
    OverflowTypeNone,
    OverflowTypeVisible,
    OverflowTypeHidden,
    OverflowTypeScroll
}OverflowType;

@interface CAPViewM : UIWidgetM{
}

@property (nonatomic, strong) NSMutableArray *subitems;
@property (nonatomic, assign) LayoutType layout;
@property (nonatomic, assign) OverflowType overflow;

@end
