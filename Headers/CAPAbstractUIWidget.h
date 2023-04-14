#import <QuartzCore/QuartzCore.h>

#define APPLY_DIRTY_MODEL_PROP(key, dest) \
if (self.stableModel.key != self.model.key) {\
self.stableModel.key = self.model.key;\
dest = self.model.key;\
}\

#define APPLY_DIRTY_MODEL_PROP_DO(key, dest) \
if (self.stableModel.key != self.model.key && ![self.stableModel.key isEqual: self.model.key]) {\
self.stableModel.key = self.model.key;\
dest;\
}\

//NSLog(@"%s %@ => %@", #key, self.stableModel.key, self.model.key);\

#define APPLY_DIRTY_MODEL_PROP_EQ_DO(key, dest) \
if (self.stableModel.key != self.model.key) {\
self.stableModel.key = self.model.key;\
dest;\
}\

#define APPLY_DIRTY_MODEL_PROP_FLOAT_DO(key, dest) \
if (!(isnan(self.stableModel.key) && isnan(self.model.key)) && self.stableModel.key != self.model.key) {\
self.stableModel.key = self.model.key;\
dest;\
}\

@class CAPViewWidget;

/**This class is the base class of all Widget*/
@interface CAPAbstractUIWidget : AbstractLuaTableCompatible <IAbstractUIWidget, ILuaReference>{
    UIWidgetM *attributeModel;

    NSDictionary *styleDic;
    
    UIImageView *backgroundImageView;
    CAGradientLayer *backgroundGradientLayer;
    
    CGSize lastParentContentSize;
    
    volatile BOOL layoutSuspended;
    volatile BOOL layoutDirty;

    UIViewAnimationOptions animationOptions;
    
    BOOL created;
    
    int ref;
    lua_State *refState;
    
    CGRect selfRect;
    BOOL selfRectDirty;
    
    BOOL resetBeforeDataProvider;
    
    @public
    CGRect currentRect;
}

/**The Model with this `Widget`*/
@property (nonatomic, strong, readonly) UIWidgetM *model; //dirtyModel
@property (nonatomic, strong, readonly) UIWidgetM *stableModel;
@property (nonatomic, weak, readonly) CAPPageSandbox *pageSandbox;

@property (nonatomic, weak) CAPViewWidget *parent;
@property (nonatomic, readonly, getter = getBackgroundColor) UIColor *backgroundColor;

@property (nonatomic, assign) BOOL clipsToBounds;

/**initialize this class with UIWidgetM Model
 
 @param m the model of this `Widget`
 @return self
 */
- (id) initWithModel: (UIWidgetM *) m withPageSandbox: (CAPPageSandbox *) sandbox NS_REQUIRES_SUPER;

/**get the UIView along with this `Widget`
 
 @return UIView to return
 */
- (UIView *) innerView;

- (void) removeFromSuperview;

- (NSUInteger) createView;

/**invoked when this widget is fully created.*/
- (void) onCreated;

- (void) onCreateView;

/**invoked when this widget is going to destory*/
- (void) onDestroy NS_REQUIRES_SUPER;

/**invoked when this widget is removed from ui*/
- (void) onRemoved NS_REQUIRES_SUPER;

/**invoked when this widget is move to front of this screen*/
- (void) onFronted;

/**invoked when this widget is move to backend of this screen*/
- (void) onBackend;

/** Tell parent what's the exactly rect of the widget, parent size should not include it's padding */
- (CGRect) measureRect: (CGSize) parentContentSize;
- (CGRect) measureRect: (CGSize) parentContentSize withAbsolute: (BOOL) absolute;

- (CGRect) measureSelfRect: (CGSize) parentContentSize;
- (CGRect) measureSelfRect: (CGSize) parentContentSize withAbsolute: (BOOL) absolute;

- (CGSize) sizeUnionMargin: (CGSize) parentContentSize;

- (void) reloadRect;
- (void) setViewFrame: (CGRect) rect NS_REQUIRES_SUPER;
- (CGRect) getActualCurrentRect;

- (void) setDataProvider: (id) object NS_REQUIRES_SUPER;
- (void) setData: (NSObject *) data;

- (void) applyBackground: (UIView *) view;

- (UIColor *) getDefaultBackgroundColor;

- (UIView *) getDefaultBackground;

- (void) updateBackgroundFrame;

- (void) onResumeLayout;
- (void) onReload;

- (void) doResetBeforeDataProvider;

- (void) onHiddenChanged;

- (BOOL) isVisible;

@end
