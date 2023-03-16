//
//  EOSScrollView.m
//  EOSFramework
//
//  Created by Sam Chang on 8/21/12.
//
//

#import "EOSScrollView.h"

@implementation EOSScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesBegan");
//    if ([self.widget.model.ontouchdown isKindOfClass: [LuaFunction class]]) {
//        CGPoint point = [[touches anyObject] locationInView: self];
//        [self.widget.model.ontouchdown executeWithoutReturnValue: self.widget, [NSNumber numberWithFloat: point.x], [NSNumber numberWithFloat: point.y], nil];
//    }
//}
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesMoved");
//    if ([self.widget.model.ontouchmove isKindOfClass: [LuaFunction class]]) {
//        CGPoint point = [[touches anyObject] locationInView: self];
//        [self.widget.model.ontouchmove executeWithoutReturnValue: self.widget, [NSNumber numberWithFloat: point.x], [NSNumber numberWithFloat: point.y], nil];
//    }
//}
//
//-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self touchesEnded: touches withEvent: event];
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesEnded");
//    if ([self.widget.model.ontouchup isKindOfClass: [LuaFunction class]]) {
//        CGPoint point = [[touches anyObject] locationInView: self];
//        [self.widget.model.ontouchup executeWithoutReturnValue: self.widget, [NSNumber numberWithFloat: point.x], [NSNumber numberWithFloat: point.y], nil];
//    }
//}

@end
