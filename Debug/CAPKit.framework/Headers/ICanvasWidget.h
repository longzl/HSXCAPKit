//
//  ICanvasWidget.h
//  EOSFramework
//
//  Created by Sam on 5/9/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>

@protocol ICanvasWidget <NSObject>

- (void) fillRect: (NSNumber *) x :(NSNumber *) y :(NSNumber *) width :(NSNumber *) height;

- (void) arc: (NSNumber *) x :(NSNumber *) y :(NSNumber *) radius :(NSNumber *) startAngle :(NSNumber *) endAngle :(NSNumber *) clockwise;

- (void) arcTo: (NSNumber *) x1 :(NSNumber *) y1 :(NSNumber *) x2 :(NSNumber *) y2 :(NSNumber *) radius;

- (void) moveTo: (NSNumber *) x : (NSNumber *) y;

- (void) lineTo: (NSNumber *) x : (NSNumber *) y;

- (void) quadraticCurveTo: (NSNumber *) cpx :(NSNumber *) cpy :(NSNumber *) x :(NSNumber *) y;

- (void) bezierCurveTo: (NSNumber *) cp1x :(NSNumber *) cp1y :(NSNumber *) cp2x :(NSNumber *) cp2y :(NSNumber *) x :(NSNumber *) y;

- (void) fill;

- (void) stroke;

- (void) beginPath;

- (void) closePath;

- (void) rect: (NSNumber *) x :(NSNumber *) y :(NSNumber *) width :(NSNumber *) height;

- (void) clip;

- (void) save;

- (void) restore;

- (void) clearRect: (NSNumber *) x :(NSNumber *) y :(NSNumber *) width :(NSNumber *) height;

- (void) strokeRect: (NSNumber *) x :(NSNumber *) y :(NSNumber *) width :(NSNumber *) height;

- (NSNumber *)isPointInPath:(NSNumber *)x :(NSNumber *)y;

- (void) translate:(NSNumber *)x :(NSNumber *)y;

- (void) scale:(NSNumber *)x :(NSNumber *)y;

- (void) rotate:(NSNumber *) angle;

@end
