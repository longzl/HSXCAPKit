//
//  VideoWidget.h
//  BookShelf
//
//  Created by Sam Chang on 1/26/14.
//  Copyright (c) 2014 Jian-Guo Hu. All rights reserved.
//

#import <CAPKit/CAPKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "CAPVideoM.h"
#import "IVideoWidget.h"

@interface CAPVideoWidget : CAPAbstractUIWidget <IVideoWidget>

@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerItem *playerItem;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
@property (nonatomic, strong) UIView *view;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, readonly) CAPVideoM *model;
@property (nonatomic, readonly) CAPVideoM *stableModel;
#pragma clang diagnostic pop

@end
