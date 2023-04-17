//
//  IMyVideoWidget.h
//  BookShelf
//
//  Created by Sam Chang on 1/26/14.
//  Copyright (c) 2014 Jian-Guo Hu. All rights reserved.
//

#import <CAPKit/CAPKit.h>

@protocol IVideoWidget <NSObject>

- (void) play;
- (void) pause;
- (void) stop;

@end
