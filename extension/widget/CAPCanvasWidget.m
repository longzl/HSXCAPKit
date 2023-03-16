//
//  CanvasWidget.m
//  EOSFramework
//
//  Created by Sam on 5/9/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CAPCanvasWidget.h"
#import "CAPCanvasM.h"
#import "CanvasDisplayView.h"

#define BITMAP_CONTEXT_LOCK() [bitmapLock lock]
#define BITMAP_CONTEXT_UNLOCK() [bitmapLock unlock]

@implementation CAPCanvasWidget

+(void)load{
    [WidgetMap bind: @"canvas" withModelClassName: NSStringFromClass([CAPCanvasM class]) withWidgetClassName: NSStringFromClass([CAPCanvasWidget class])];
}

-(id)initWithModel:(CAPCanvasM *)m withPageSandbox:(CAPPageSandbox *)sandbox{
    self = [super initWithModel: m withPageSandbox: sandbox];
    
    if (self) {
        view = [[CanvasDisplayView alloc] initWithFrame: CGRectZero];
        bitmapLock = [[NSRecursiveLock alloc] init];
    }
    
    return self;
}

-(void)setViewFrame:(CGRect)rect{
    [super setViewFrame: rect];
    
    BITMAP_CONTEXT_LOCK();
    
    if (bitmapContext != nil) {
        view->bitmapContext = nil;
        
        CGContextRelease(bitmapContext);
        bitmapContext = nil;
    }
    
    int size = rect.size.width * rect.size.height * 4;
    if (size > 0) {
        bitmapBuff = realloc(bitmapBuff, size);
        memset(bitmapBuff, 0, size);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        bitmapContext = CGBitmapContextCreate(bitmapBuff, rect.size.width, rect.size.height, 8, rect.size.width * 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedFirst);
        CGColorSpaceRelease(colorSpace);
        
        view->bitmapContext = bitmapContext;
        view->bitmapLock = bitmapLock;
    }
    
    BITMAP_CONTEXT_UNLOCK();

}

#pragma mark Lua Proxy Begin

#define UNKNOWN_PARAMETER(name,value) NSLog(@"%@ Unknown parameter '%@': %@", NSStringFromSelector(_cmd), name, value);

- (void) setFillStyle: (NSObject *) colorObject{
    UIColor *color = [OSUtils getColor: colorObject withAlpha: NAN withDefaultColor: [UIColor redColor]];
    BITMAP_CONTEXT_LOCK();
    CGContextSetFillColorWithColor(bitmapContext, [color CGColor]);
    BITMAP_CONTEXT_UNLOCK();
}

- (void) setStrokeStyle: (NSObject *) colorObject{
    UIColor *color = [OSUtils getColor: colorObject withAlpha: NAN withDefaultColor: [UIColor redColor]];
    BITMAP_CONTEXT_LOCK();
    CGContextSetStrokeColorWithColor(bitmapContext, [color CGColor]);
    BITMAP_CONTEXT_UNLOCK();
}

- (void) setLineWidth: (id) widthObject{
    if ([widthObject respondsToSelector: @selector(intValue)]) {
        int width = [widthObject intValue];
        if (width > 0) {
            BITMAP_CONTEXT_LOCK();
            CGContextSetLineWidth(bitmapContext, width);
            BITMAP_CONTEXT_UNLOCK();
        }
    }else {
        UNKNOWN_PARAMETER(@"widthObject", widthObject);
    }
}

- (void) setGlobalAlpha: (id) alphaObject{
    if ([alphaObject respondsToSelector: @selector(floatValue)]) {
        float alpha = [alphaObject floatValue];
        if (!isnan(alpha)) {
            BITMAP_CONTEXT_LOCK();
            CGContextSetAlpha(bitmapContext, alpha);
            BITMAP_CONTEXT_UNLOCK();
        }
    }
}

- (void) setLineCap: (NSString *) capString{
    if (![capString isKindOfClass: [NSString class]]) {
        return;
    }
    BITMAP_CONTEXT_LOCK();
    if ([capString isEqualToString: @"butt"]) {
        CGContextSetLineCap(bitmapContext, kCGLineCapButt);
    }else if ([capString isEqualToString: @"round"]) {
        CGContextSetLineCap(bitmapContext, kCGLineCapRound);
    }else if ([capString isEqualToString: @"square"]) {
        CGContextSetLineCap(bitmapContext, kCGLineCapSquare);
    }
    BITMAP_CONTEXT_UNLOCK();
}

- (void) setLineJoin: (NSString *) joinString{
    if (![joinString isKindOfClass: [NSString class]]) {
        return;
    }
    
    BITMAP_CONTEXT_LOCK();
    if ([joinString isEqualToString: @"bevel"]) {
        CGContextSetLineJoin(bitmapContext, kCGLineJoinBevel);
    }else if ([joinString isEqualToString: @"round"]) {
        CGContextSetLineJoin(bitmapContext, kCGLineJoinRound);
    }else if ([joinString isEqualToString: @"miter"]) {
        CGContextSetLineJoin(bitmapContext, kCGLineJoinMiter);
    }
    BITMAP_CONTEXT_UNLOCK();
}

- (void) stroke{
    BITMAP_CONTEXT_LOCK();
    CGRect rect = CGContextGetPathBoundingBox(bitmapContext);
    CGContextStrokePath(bitmapContext);
    BITMAP_CONTEXT_UNLOCK();
    
    [view addNeedsDisplayRect: rect];
}

- (void) arc: (NSNumber *) x :(NSNumber *) y :(NSNumber *) radius :(NSNumber *) startAngle :(NSNumber *) endAngle :(NSNumber *) clockwise{
    BITMAP_CONTEXT_LOCK();
    CGContextAddArc(bitmapContext, [x floatValue], [y floatValue], [radius floatValue], [startAngle floatValue], [endAngle floatValue],  [clockwise intValue]);
    BITMAP_CONTEXT_UNLOCK();
}

- (void) arcTo: (NSNumber *) x1 :(NSNumber *) y1 :(NSNumber *) x2 :(NSNumber *) y2 :(NSNumber *) radius{
    BITMAP_CONTEXT_LOCK();
    CGContextAddArcToPoint(bitmapContext, [x1 floatValue], [y1 floatValue], [x2 floatValue], [y2 floatValue], [radius floatValue]);
    BITMAP_CONTEXT_UNLOCK();
}

- (void) quadraticCurveTo: (NSNumber *) cpx :(NSNumber *) cpy :(NSNumber *) x :(NSNumber *) y{
    BITMAP_CONTEXT_LOCK();
    CGContextAddQuadCurveToPoint(bitmapContext, [cpx floatValue], [cpy floatValue], [x floatValue], [y floatValue]);
    BITMAP_CONTEXT_UNLOCK();
}

- (void) bezierCurveTo: (NSNumber *) cp1x :(NSNumber *) cp1y :(NSNumber *) cp2x :(NSNumber *) cp2y :(NSNumber *) x :(NSNumber *) y{
    BITMAP_CONTEXT_LOCK();
    CGContextAddCurveToPoint(bitmapContext, [cp1x floatValue], [cp1y floatValue], [cp2x floatValue], [cp2y floatValue], [x floatValue], [y floatValue]);
    BITMAP_CONTEXT_UNLOCK();
}

- (void) fill{
    BITMAP_CONTEXT_LOCK();
    CGRect rect = CGContextGetPathBoundingBox(bitmapContext);
    CGContextFillPath(bitmapContext);
    BITMAP_CONTEXT_UNLOCK();
    
    [view addNeedsDisplayRect: rect];
}

-(void)beginPath{
    BITMAP_CONTEXT_LOCK();
    CGContextBeginPath(bitmapContext);
    BITMAP_CONTEXT_UNLOCK();
}

-(void)closePath{
    BITMAP_CONTEXT_LOCK();
    CGContextClosePath(bitmapContext);
    BITMAP_CONTEXT_UNLOCK();
}

-(void)rect:(NSNumber *)x :(NSNumber *)y :(NSNumber *)width :(NSNumber *)height{
    BITMAP_CONTEXT_LOCK();
    CGRect rect = CGRectMake([x floatValue], [y floatValue], [width floatValue], [height floatValue]);
    CGContextAddRect(bitmapContext, rect);
    BITMAP_CONTEXT_UNLOCK();
}

-(void)clip{
    BITMAP_CONTEXT_LOCK();
    CGContextClip(bitmapContext);
    BITMAP_CONTEXT_UNLOCK();
}

-(void)save{
    BITMAP_CONTEXT_LOCK();
    CGContextSaveGState(bitmapContext);
    BITMAP_CONTEXT_UNLOCK();
}

-(void)restore{
    BITMAP_CONTEXT_LOCK();
    CGContextRestoreGState(bitmapContext);
    BITMAP_CONTEXT_UNLOCK();
}

- (void) translate:(NSNumber *)x :(NSNumber *)y{
    BITMAP_CONTEXT_LOCK();
    CGContextTranslateCTM(bitmapContext, [x floatValue], [y floatValue]);
    [bitmapLock unlock];
}

- (void) scale:(NSNumber *)x :(NSNumber *)y{
    BITMAP_CONTEXT_LOCK();
    CGContextScaleCTM(bitmapContext, [x floatValue], [y floatValue]);
    BITMAP_CONTEXT_UNLOCK();
}

- (void) rotate:(NSNumber *) angle{
    BITMAP_CONTEXT_LOCK();
    CGContextRotateCTM(bitmapContext, [angle floatValue]);
    BITMAP_CONTEXT_UNLOCK();
}

-(void)clearRect:(NSNumber *)x :(NSNumber *)y :(NSNumber *)width :(NSNumber *)height{
    CGRect rect = CGRectMake([x floatValue], [y floatValue], [width floatValue], [height floatValue]);
    BITMAP_CONTEXT_LOCK();
    CGContextClearRect(bitmapContext, rect);
    BITMAP_CONTEXT_UNLOCK();
    
    [view addNeedsDisplayRect: rect];
}

- (void) fillRect: (NSNumber *) x :(NSNumber *) y :(NSNumber *) width :(NSNumber *) height{
    CGRect rect = CGRectMake([x floatValue], [y floatValue], [width floatValue], [height floatValue]);
    BITMAP_CONTEXT_LOCK();
    CGContextFillRect(bitmapContext, rect);
    BITMAP_CONTEXT_UNLOCK();
    
    [view addNeedsDisplayRect: rect];
}

-(void)strokeRect:(NSNumber *)x :(NSNumber *)y :(NSNumber *)width :(NSNumber *)height{
    CGRect rect = CGRectMake([x floatValue], [y floatValue], [width floatValue], [height floatValue]);
    BITMAP_CONTEXT_LOCK();
    CGContextStrokeRect(bitmapContext, rect);
    BITMAP_CONTEXT_UNLOCK();
    
    [view addNeedsDisplayRect: rect];
}

- (void) moveTo: (NSNumber *) x : (NSNumber *) y{
    BITMAP_CONTEXT_LOCK();
    CGContextMoveToPoint(bitmapContext, [x floatValue], [y floatValue]);
    BITMAP_CONTEXT_UNLOCK();
}

-(NSNumber *)isPointInPath:(NSNumber *)x :(NSNumber *)y{
    //determined by the non-zero winding number rule
    BITMAP_CONTEXT_LOCK();
    BOOL value = CGContextPathContainsPoint(bitmapContext, CGPointMake([x floatValue], [y floatValue]), kCGPathFill);
    BITMAP_CONTEXT_UNLOCK();
    return [NSNumber numberWithBool: value];
}

- (void) lineTo: (NSNumber *) x : (NSNumber *) y{
    BITMAP_CONTEXT_LOCK();
    CGContextAddLineToPoint(bitmapContext, [x floatValue], [y floatValue]);
    BITMAP_CONTEXT_UNLOCK();
}

-(UIView *)innerView{
    return view;
}

#pragma mark Lua Proxy End

-(void)dealloc{
    free(bitmapBuff);
    
    if (bitmapContext) {
        CGContextRelease(bitmapContext);
    }
}
@end
