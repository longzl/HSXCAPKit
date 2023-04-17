//
//  MyVideoModel.h
//  BookShelf
//
//  Created by Sam Chang on 1/26/14.
//  Copyright (c) 2014 Jian-Guo Hu. All rights reserved.
//

#import <CAPKit/CAPKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface CAPVideoM : UIWidgetM

@property (nonatomic, assign) MPMovieScalingMode scalingMode;
@property (nonatomic, assign) MPMovieControlStyle controlStyle;
@property (nonatomic, assign) MPMovieRepeatMode repeatMode;
@property (nonatomic, assign) MPMovieSourceType sourceType;
@property (nonatomic, assign) BOOL allowsAirPlay;
@property (nonatomic, assign) BOOL backgroundPlaybackEnabled;
@property (nonatomic, assign) BOOL useAVPlayer;
@property (nonatomic, strong) NSString *src;

@property (nonatomic, assign) NSTimeInterval initialPlaybackTime;
@property (nonatomic, assign) NSTimeInterval endPlaybackTime;

@property (nonatomic, strong) LuaFunction *onloadstate;
@property (nonatomic, strong) LuaFunction *onplaybackstate;
@property (nonatomic, strong) LuaFunction *onpreparedtoplay;
@property (nonatomic, strong) LuaFunction *onplaybackfinish;

- (void) parseScalingMode: (NSString *) scalingMode;
- (void) parseControlStyle: (NSString *) controlStyle;
- (void) parseRepeatMode: (NSString *) repeatMode;
- (void) parseSourceType: (NSString *) sourceType;

- (NSString *) scalingModeName;
- (NSString *) controlStyleName;
- (NSString *) repeatModeName;
- (NSString *) sourceTypeName;

@end
