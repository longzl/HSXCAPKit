#import <UIKit/UIKit.h>
#import "CAPViewWidget.h"

@interface WidgetViewController : UIViewController {
    CGRect latestReloadFrame;
}

@property (nonatomic, strong) CAPViewWidget *widget;
@property (nonatomic, assign) BOOL animation;
@property (nonatomic, assign) BOOL presentView;
@property (nonatomic, assign) UIInterfaceOrientationMask direction;

@end
