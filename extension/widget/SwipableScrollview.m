#import "SwipableScrollview.h"

@implementation SwipableScrollview

-(BOOL)touchesShouldCancelInContentView:(UIView *)view{
    NSLog(@"%@", view);
    return NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
}

@end
