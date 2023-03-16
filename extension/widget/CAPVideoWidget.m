//
//  VideoWidget.m
//  BookShelf
//
//  Created by Sam Chang on 1/26/14.
//  Copyright (c) 2014 Jian-Guo Hu. All rights reserved.
//

#import "CAPVideoWidget.h"
#import "MPMoviePlayerController+BackgroundPlayback.h"

CGFloat kMovieViewOffsetX = 20.0;
CGFloat kMovieViewOffsetY = 20.0;

//typedef enum {
//    MovieLoadStateUnknown,
//    MovieLoadStatePlayable,
//    MovieLoadStatePlaythroughOK,
//    MovieLoadStateStalled
//} MovieLoadState;
//typedef enum {
//    MoviePlaybackStateStopped,
//    MoviePlaybackStatePlaying,
//    MoviePlaybackStatePaused,
//    MoviePlaybackStateInterrupted,
//    MoviePlaybackStateSeekingForward,
//    MoviePlaybackStateSeekingBackward
//} MoviePlaybackState;
//typedef enum {
//    MovieFinishReasonPlaybackEnded,
//    MovieFinishReasonPlaybackError,
//    MovieFinishReasonUserExited
//} FinishReason;

@interface CAPVideoWidget ()

@property (nonatomic, assign) BOOL idleTimerDisabled;

@end

@implementation CAPVideoWidget

static int idleTimerDisabledCount;

+(void)initialize{
    idleTimerDisabledCount = 0;
}

+(void)load {
    [WidgetMap bind: @"video" withModelClassName: NSStringFromClass([CAPVideoM class]) withWidgetClassName: NSStringFromClass([CAPVideoWidget class])];
}

- (void) stopIdleTimer {
    if (!_idleTimerDisabled) {
        _idleTimerDisabled = YES;

        idleTimerDisabledCount++;
        if (idleTimerDisabledCount > 0) {
            [UIApplication sharedApplication].idleTimerDisabled = YES;
//            NSLog(@"idleTimerDisabled = YES");
        }
    }
}

- (void) startIdleTimer {
    if (_idleTimerDisabled) {
        _idleTimerDisabled = NO;

        idleTimerDisabledCount--;
        if (idleTimerDisabledCount <= 0) {
            [UIApplication sharedApplication].idleTimerDisabled = NO;
//            NSLog(@"idleTimerDisabled = NO");
        }
    }
}

-(UIView *)innerView{
    return _view;
}

-(void)onCreateView{
    _view = [[UIView alloc] initWithFrame: [self getActualCurrentRect]];
    [self reloadSrc];
    if (!self.model.useAVPlayer) {
        self.moviePlayerController.backgroundPlaybackEnabled = self.model.backgroundPlaybackEnabled;
    }
}

-(void)setViewFrame:(CGRect)rect{
    [super setViewFrame: rect];
    if (self.model.useAVPlayer) {
        self.playerLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    } else {
        self.moviePlayerController.view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    }
}

- (void) onBackend {
    [super onBackend];
    if (self.model.useAVPlayer) {
    } else {
        [self removeMovieNotificationHandlers];
    }
}

- (void) onDestroy {
    [super onDestroy];
    if (self.model.useAVPlayer) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        self.playerItem = nil;
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max) {
            [self.player removeObserver: self forKeyPath: @"timeControlStatus"];
        } else {
            [self.player removeObserver: self forKeyPath: @"rate"];
        }
        
        [self.player pause];
        self.player = nil;
    } else {
        [self removeMovieNotificationHandlers];
        self.moviePlayerController = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver: self];

    [self startIdleTimer];
}

- (void) setSrc: (NSString *) src{
    self.model.src = src;
    
    [self reload];
}

- (NSString *) getSrc{
    return self.model.src;
}

- (void) setCurrentPlaybackTime: (NSTimeInterval) value {
    [OSUtils runBlockOnMain:^{
        if (self.model.useAVPlayer) {
            [self.player seekToTime:CMTimeMakeWithSeconds(value, self.playerItem.currentTime.timescale)];
        } else {
            self.moviePlayerController.currentPlaybackTime = value;
        }
    }];
}

- (NSTimeInterval) getCurrentPlaybackTime{
    if (self.model.useAVPlayer) {
        return CMTimeGetSeconds(self.playerItem.currentTime);
    } else {
        return self.moviePlayerController.currentPlaybackTime;
    }
}

- (NSTimeInterval) getDuration {
    if (self.model.useAVPlayer) {
        return CMTimeGetSeconds(self.playerItem.duration);
    } else {
        return self.moviePlayerController.duration;
    }
}

- (NSTimeInterval) getPlayableDuration {
    if (self.model.useAVPlayer) {
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max) {
            return self.playerItem.preferredForwardBufferDuration;
        } else {
            return 0;
        }
    } else {
        return self.moviePlayerController.playableDuration;
    }
}

- (void) setCurrentPlaybackRate: (float) value {
    [OSUtils runBlockOnMain:^{
        if (self.model.useAVPlayer) {
            self.player.rate = value;
        } else {
            self.moviePlayerController.currentPlaybackRate = value;
        }
    }];
}

- (void) setInitialPlaybackTime: (float) value {
    self.model.initialPlaybackTime = value;
    [OSUtils runBlockOnMain:^{
        if (self.model.useAVPlayer) {
        } else {
            self.moviePlayerController.initialPlaybackTime = value;
        }
    }];
}

- (void) setEndPlaybackTime: (float) value {
    self.model.endPlaybackTime = value;
    [OSUtils runBlockOnMain:^{
        if (self.model.useAVPlayer) {
        } else {
            self.moviePlayerController.endPlaybackTime = value;
        }
    }];
}

- (float) getCurrentPlaybackRate{
    if (self.model.useAVPlayer) {
        return self.player.rate;
    } else {
        return self.moviePlayerController.currentPlaybackRate;
    }
}

- (void) setFullscreen: (NSNumber *) value {
    [OSUtils runBlockOnMain:^{
        if (self.model.useAVPlayer) {
        } else {
            [self.moviePlayerController setFullscreen: [value boolValue] animated: YES];
        }
    }];
}

- (void)seekingForward{
    [OSUtils runBlockOnMain:^{
        if (self.model.useAVPlayer) {
        } else {
            [self.moviePlayerController beginSeekingForward];
        }
    }];
}

- (void)seekingBackward{
    [OSUtils runBlockOnMain:^{
        if (self.model.useAVPlayer) {
        } else {
            [self.moviePlayerController beginSeekingBackward];
        }
    }];
}

- (void)endSeeking{
    [OSUtils runBlockOnMain:^{
        if (self.model.useAVPlayer) {
        } else {
            [self.moviePlayerController endSeeking];
        }
    }];
}

- (void) play{
    [OSUtils runBlockOnMain:^{
        if (self.model.useAVPlayer) {
            [self.player play];
        } else {
            [self.moviePlayerController play];
        }
        
        [self stopIdleTimer];
    }];
}

- (void) pause{
    [OSUtils runBlockOnMain:^{
        if (self.model.useAVPlayer) {
            [self.player pause];
        } else {
            [self.moviePlayerController pause];
        }
        
        [self startIdleTimer];
    }];
}

- (void) stop{
    [OSUtils runBlockOnMain:^{
        if (self.model.useAVPlayer) {
            [self.player pause];
        } else {
            [self.moviePlayerController stop];
        }
        
        [self startIdleTimer];
    }];
}

- (void) setScalingMode: (NSString *) scalingMode{
    [self.model parseScalingMode: scalingMode];
    
    [self reload];
}

- (NSString *) getScalingMode{
    return [self.model scalingModeName];
}

- (void) setControlStyle: (NSString *) controlStyle{
    [self.model parseControlStyle: controlStyle];
    
    [self reload];
}

- (NSString *) getControlStyle{
    return [self.model controlStyleName];
}

- (void) setRepeatMode: (NSString *) repeatMode{
    [self.model parseRepeatMode: repeatMode];
    
    [self reload];
}

- (NSString *) getRepeatMode{
    return [self.model repeatModeName];
}

- (void) setSourceType: (NSString *) sourceType{
    [self.model parseSourceType: sourceType];
    
    [self reload];
}

- (NSString *) getSourceType{
    return [self.model sourceTypeName];
}

- (void) setAllowsAirPlay: (NSNumber *) allowsAirPlay{
    if ([allowsAirPlay respondsToSelector: @selector(boolValue)]) {
        self.model.allowsAirPlay = [allowsAirPlay boolValue];
        
        [self reload];
    }
}

- (BOOL) getAllowsAirPlay{
    return self.model.allowsAirPlay;
}

- (void) setUseAVPlayer: (NSNumber *) useAVPlayer{
    if ([useAVPlayer respondsToSelector: @selector(boolValue)]) {
        self.model.useAVPlayer = [useAVPlayer boolValue];
        
        [self reload];
    }
}

- (BOOL) getUseAVPlayer{
    return self.model.useAVPlayer;
}

- (void) setOnloadstate: (LuaFunction *) func{
    if ([func isKindOfClass: [LuaFunction class]]) {
        self.model.onloadstate = func;
    }
}

- (LuaFunction *) getOnloadstate{
    return self.model.onloadstate;
}

- (void) setOnplaybackfinish: (LuaFunction *) func{
    if ([func isKindOfClass: [LuaFunction class]]) {
        self.model.onplaybackfinish = func;
    }
}

- (LuaFunction *) getOnplaybackfinish{
    return self.model.onplaybackfinish;
}

- (void) setOnplaybackstate: (LuaFunction *) func{
    if ([func isKindOfClass: [LuaFunction class]]) {
        self.model.onplaybackstate = func;
    }
}

- (LuaFunction *) getOnplaybackstate{
    return self.model.onplaybackstate;
}

- (void) setOnpreparedtoplay: (LuaFunction *) func{
    if ([func isKindOfClass: [LuaFunction class]]) {
        self.model.onpreparedtoplay = func;
    }
}

- (LuaFunction *) getOnpreparedtoplay{
    return self.model.onpreparedtoplay;
}

- (void) reloadSrc{
    NSURL *url = [self.pageSandbox resolveFile: self.model.src];
    if (self.model.useAVPlayer) {
        [self createAndConfigurePlayerWithURL: url];
    } else {
        if ([url isFileURL]) {
            [self createAndConfigurePlayerWithURL: url sourceType: MPMovieSourceTypeFile];
        } else {
            MPMovieSourceType movieSourceType = self.model.sourceType;
            if ([[url pathExtension] compare:@"m3u8" options: NSCaseInsensitiveSearch] == NSOrderedSame) {
                movieSourceType = MPMovieSourceTypeStreaming;
            }
            [self createAndConfigurePlayerWithURL: url sourceType: movieSourceType];
        }
    }
}

-(void)onReload{
    [super onReload];
    if (self.model.useAVPlayer) {
    } else {
        APPLY_DIRTY_MODEL_PROP(scalingMode, self.moviePlayerController.scalingMode);
        APPLY_DIRTY_MODEL_PROP(controlStyle, self.moviePlayerController.controlStyle);
        APPLY_DIRTY_MODEL_PROP(repeatMode, self.moviePlayerController.repeatMode);
        APPLY_DIRTY_MODEL_PROP(allowsAirPlay, self.moviePlayerController.allowsAirPlay);
    }
    
    APPLY_DIRTY_MODEL_PROP_DO(src, {
        [self reloadSrc];
    });
}

#pragma mark Create and Play Movie URL

-(void)createAndConfigurePlayerWithURL:(NSURL *)movieURL
{
    if (!self.player && movieURL) {
        // 初始化播放器item
        self.playerItem = [[AVPlayerItem alloc] initWithURL: movieURL];
        self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
        // 初始化播放器的Layer
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.player currentItem]];
        
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        // layer的frame
        self.playerLayer.frame = _view.bounds;
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        // 把Layer加到底部View上
        [_view.layer insertSublayer:self.playerLayer atIndex:0];
        // 监听播放器状态变化
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        // 监听缓存大小
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        // 监听播放器当前状态
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max) {
            [self.player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
        } else {
            [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
        }
        
    }
}

-(void)createAndConfigurePlayerWithURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType
{
    if (!self.moviePlayerController) {
        self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        self.moviePlayerController.controlStyle = self.model.controlStyle;
        self.moviePlayerController.scalingMode = self.model.scalingMode;
        self.moviePlayerController.repeatMode = self.model.repeatMode;
        self.moviePlayerController.allowsAirPlay = self.model.allowsAirPlay;
        if (!isnan(self.model.initialPlaybackTime)) {
            self.moviePlayerController.initialPlaybackTime = self.model.initialPlaybackTime;
        }
        if (!isnan(self.model.endPlaybackTime)) {
            self.moviePlayerController.endPlaybackTime = self.model.endPlaybackTime;
        }

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadStateDidChange:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object: self.moviePlayerController];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object: self.moviePlayerController];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                     name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                   object: self.moviePlayerController];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackStateDidChange:)
                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                   object: self.moviePlayerController];
        
        [self.view addSubview: self.moviePlayerController.view];
        self.moviePlayerController.view.frame = CGRectMake(0, 0, [self getActualCurrentRect].size.width, [self getActualCurrentRect].size.height);
    }
    
    if (self.moviePlayerController) {
        [self.moviePlayerController setContentURL: movieURL];
        [self.moviePlayerController setMovieSourceType: sourceType];
    }
}

#pragma mark Movie Notification Handlers

-(LuaTable *)toLuaTable{
    LuaTable *tb = [super toLuaTable];
    
    [tb.map setValue: [NSNumber numberWithInt: MPMovieLoadStatePlaythroughOK] forKey: @"StatePlaythroughOK"];
    
    [tb.map setValue: [NSNumber numberWithInt: MPMovieLoadStateUnknown] forKey: @"LoadStateUnknown"];
    [tb.map setValue: [NSNumber numberWithInt: MPMovieLoadStatePlayable] forKey: @"LoadStatePlayable"];
    [tb.map setValue: [NSNumber numberWithInt: MPMovieLoadStatePlaythroughOK] forKey: @"LoadStatePlaythroughOK"];
    [tb.map setValue: [NSNumber numberWithInt: MPMovieLoadStateStalled] forKey: @"LoadStateStalled"];
    
    [tb.map setValue: [NSNumber numberWithInt: MPMoviePlaybackStateStopped] forKey: @"PlaybackStateStopped"];
    [tb.map setValue: [NSNumber numberWithInt: MPMoviePlaybackStatePlaying] forKey: @"PlaybackStatePlaying"];
    [tb.map setValue: [NSNumber numberWithInt: MPMoviePlaybackStatePaused] forKey: @"PlaybackStatePaused"];
    [tb.map setValue: [NSNumber numberWithInt: MPMoviePlaybackStateInterrupted] forKey: @"PlaybackStateInterrupted"];
    [tb.map setValue: [NSNumber numberWithInt: MPMoviePlaybackStateSeekingForward] forKey: @"PlaybackStateSeekingForward"];
    [tb.map setValue: [NSNumber numberWithInt: MPMoviePlaybackStateSeekingBackward] forKey: @"PlaybackStateSeekingBackward"];
    
    [tb.map setValue: [NSNumber numberWithInt: MPMovieFinishReasonPlaybackEnded] forKey: @"FinishReasonPlaybackEnded"];
    [tb.map setValue: [NSNumber numberWithInt: MPMovieFinishReasonPlaybackError] forKey: @"FinishReasonPlaybackError"];
    [tb.map setValue: [NSNumber numberWithInt: MPMovieFinishReasonUserExited] forKey: @"FinishReasonUserExited"];
    
    return tb;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    NSNumber *reason = [[notification userInfo] objectForKey: MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if (self.model.onplaybackfinish) {
        [self.model.onplaybackfinish executeWithoutReturnValue: self, reason, [notification userInfo], nil];
    } else {
        NSLog(@"Unhandled Event, %@", notification);
    }

    [self startIdleTimer];
}

- (void)loadStateDidChange:(NSNotification *)notification
{
	MPMoviePlayerController *player = notification.object;
	MPMovieLoadState loadState = player.loadState;
    
    if (self.model.onloadstate) {
        [self.model.onloadstate executeWithoutReturnValue: self, [NSNumber numberWithInt: loadState], nil];
    } else {
        NSLog(@"Unhandled Event, %@", notification);
    }
}

- (void) moviePlayBackStateDidChange:(NSNotification*)notification
{
	MPMoviePlayerController *player = notification.object;
    if (self.model.onplaybackstate) {
        [self.model.onplaybackstate executeWithoutReturnValue: self, [NSNumber numberWithInt: player.playbackState], nil];
    } else {
        NSLog(@"Unhandled Event, %@", notification);
    }

    switch (player.playbackState) {
        case MPMoviePlaybackStateStopped:
        case MPMoviePlaybackStatePaused:
        case MPMoviePlaybackStateInterrupted:
            [self startIdleTimer];
            break;

        default:
            [self stopIdleTimer];
            break;
    }
}

- (void) mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
	MPMoviePlayerController *player = notification.object;
    if (self.model.onpreparedtoplay) {
        [self.model.onpreparedtoplay executeWithoutReturnValue: self, [NSNumber numberWithBool: player.isPreparedToPlay], nil];
    } else {
        NSLog(@"Unhandled Event, %@", notification);
    }
}

#pragma mark Remove Movie Notification Handlers

-(void)removeMovieNotificationHandlers {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object: self.moviePlayerController];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object: self.moviePlayerController];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object: self.moviePlayerController];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object: self.moviePlayerController];
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [self.playerItem loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start); // 开始的点
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration); // 已缓存的时间点
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

// 监听播放器的变化属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        AVPlayerItemStatus loadState = [change[NSKeyValueChangeNewKey] integerValue];
        
        switch (loadState) {
            case AVPlayerItemStatusReadyToPlay:
                if (self.model.onloadstate) {
                    [self.model.onloadstate executeWithoutReturnValue: self, [NSNumber numberWithInt: MPMovieLoadStatePlayable], nil];
                }
                break;
            case AVPlayerItemStatusUnknown:
                if (self.model.onloadstate) {
                    [self.model.onloadstate executeWithoutReturnValue: self, [NSNumber numberWithInt: MPMovieLoadStateUnknown], nil];
                }
                break;
            case AVPlayerItemStatusFailed:
                if (self.model.onloadstate) {
                    [self.model.onloadstate executeWithoutReturnValue: self, [NSNumber numberWithInt: MPMovieLoadStateUnknown], nil];
                }
                break;
                
            default:
                break;
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) // 监听缓存进度的属性
    {
        //        NSTimeInterval timeInterval = [self availableDuration];
        //        CMTime duration = self.playerItem.duration;
        //        CGFloat durationTime = CMTimeGetSeconds(duration);
        //        if (timeInterval >= durationTime-1.0) {
        //
        //        }
        
    } else if ([keyPath isEqualToString: @"timeControlStatus"]) {
        switch (self.player.timeControlStatus) {
            case AVPlayerTimeControlStatusPlaying:
                [self.model.onplaybackstate executeWithoutReturnValue: self, [NSNumber numberWithInt: MPMoviePlaybackStatePlaying], nil];
                break;
            case AVPlayerTimeControlStatusPaused:
                [self.model.onplaybackstate executeWithoutReturnValue: self, [NSNumber numberWithInt: MPMoviePlaybackStatePaused], nil];
                break;
            case AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate:
                [self.model.onplaybackstate executeWithoutReturnValue: self, [NSNumber numberWithInt: MPMoviePlaybackStateInterrupted], nil];
                break;
                
            default:
                
                break;
        }
    } else if ([keyPath isEqualToString: @"rate"]) {
        if (self.player.rate == 0) {
            [self.model.onplaybackstate executeWithoutReturnValue: self, [NSNumber numberWithInt: MPMoviePlaybackStatePaused], nil];
        } else {
            [self.model.onplaybackstate executeWithoutReturnValue: self, [NSNumber numberWithInt: MPMoviePlaybackStatePlaying], nil];
        }
    }
}

@end
