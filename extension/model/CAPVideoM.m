//
//  MyVideoM.m
//  BookShelf
//
//  Created by Sam Chang on 1/26/14.
//  Copyright (c) 2014 Jian-Guo Hu. All rights reserved.
//

#import "CAPVideoM.h"

@implementation CAPVideoM

- (instancetype)init
{
    self = [super init];
    if (self) {
        _backgroundPlaybackEnabled = YES;
        _initialPlaybackTime = NAN;
        _endPlaybackTime = NAN;
    }
    return self;
}

- (NSString *) scalingModeName{
    switch (_scalingMode) {
        case MPMovieScalingModeAspectFit:
            return @"AspectFit";
        case MPMovieScalingModeAspectFill:
            return @"AspectFill";
        case MPMovieScalingModeFill:
            return @"Fill";
        case MPMovieScalingModeNone:
            return @"None";
        default:
            return nil;
    }
}

- (void) parseScalingMode: (NSString *) scalingMode{
    if ([scalingMode isKindOfClass: [NSString class]]) {
        if ([scalingMode isEqualToString: @"AspectFit"]) {
            self.scalingMode = MPMovieScalingModeAspectFit;
        } else if ([scalingMode isEqualToString: @"AspectFill"]) {
            self.scalingMode = MPMovieScalingModeAspectFill;
        } else if ([scalingMode isEqualToString: @"Fill"]) {
            self.scalingMode = MPMovieScalingModeFill;
        } else {
            self.scalingMode = MPMovieScalingModeNone;
        }
    }
}

- (NSString *) controlStyleName{
    switch (_controlStyle) {
        case MPMovieControlStyleEmbedded:
            return @"Embedded";
        case MPMovieControlStyleFullscreen:
            return @"Fullscreen";
        case MPMovieControlStyleNone:
            return @"None";
            
        default:
            return nil;
    }
}

- (void) parseControlStyle: (NSString *) controlStyle{
    if ([controlStyle isKindOfClass: [NSString class]]) {
        if ([controlStyle isEqualToString: @"Embedded"]) {
            self.controlStyle = MPMovieControlStyleEmbedded;
        } else if ([controlStyle isEqualToString: @"Fullscreen"]) {
            self.controlStyle = MPMovieControlStyleFullscreen;
        } else if ([controlStyle isEqualToString: @"Default"]) {
            self.controlStyle = MPMovieControlStyleDefault;
        } else {
            self.controlStyle = MPMovieControlStyleNone;
        }
    }
}

- (NSString *) repeatModeName{
    switch (_repeatMode) {
        case MPMovieRepeatModeOne:
            return @"One";
        case MPMovieRepeatModeNone:
            return @"None";
        default:
            return nil;
    }
}

- (void) parseRepeatMode: (NSString *) repeatMode{
    if ([repeatMode isKindOfClass: [NSString class]]) {
        if ([repeatMode isEqualToString: @"One"]) {
            self.repeatMode = MPMovieRepeatModeOne;
        } else {
            self.repeatMode = MPMovieRepeatModeNone;
        }
    }
}

- (NSString *) sourceTypeName{
    switch (_sourceType) {
        case MPMovieSourceTypeFile:
            return @"File";
        case MPMovieSourceTypeStreaming:
            return @"Streaming";
        case MPMovieSourceTypeUnknown:
            return @"Unknown";
        default:
            return nil;
    }
}

- (void) parseSourceType: (NSString *) sourceType{
    if ([sourceType isKindOfClass: [NSString class]]) {
        if ([sourceType isEqualToString: @"File"]) {
            self.sourceType = MPMovieSourceTypeFile;
        } else if ([sourceType isEqualToString: @"Streaming"]){
            self.sourceType = MPMovieSourceTypeStreaming;
        } else {
            self.sourceType = MPMovieSourceTypeUnknown;
        }
    }
}

-(void)mergeFromDic:(NSDictionary *)dic{
    [super mergeFromDic: dic];
    
    [self parseScalingMode: [dic valueForKey: @"scalingMode"]];
    [self parseControlStyle: [dic valueForKey: @"controlStyle"]];
    [self parseRepeatMode: [dic valueForKey: @"repeatMode"]];
    [self parseSourceType: [dic valueForKey: @"sourceType"]];

    NSString *allowsAirPlay = [dic valueForKey: @"allowsAirPlay"];
    if ([allowsAirPlay respondsToSelector: @selector(boolValue)]) {
        self.allowsAirPlay = [allowsAirPlay boolValue];
    }
    
    NSString *usingAVPlayer = [dic valueForKey: @"useAVPlayer"];
    if ([usingAVPlayer respondsToSelector: @selector(boolValue)]) {
        self.useAVPlayer = [usingAVPlayer boolValue];
    }

    NSString *backgroundPlaybackEnabled = [dic valueForKey: @"backgroundPlaybackEnabled"];
    if ([backgroundPlaybackEnabled respondsToSelector: @selector(boolValue)]) {
        self.backgroundPlaybackEnabled = [backgroundPlaybackEnabled boolValue];
    }

    NSString *initialPlaybackTime = [dic valueForKey: @"initialPlaybackTime"];
    if ([initialPlaybackTime respondsToSelector: @selector(floatValue)]) {
        self.initialPlaybackTime = [initialPlaybackTime floatValue];
    }

    NSString *endPlaybackTime = [dic valueForKey: @"endPlaybackTime"];
    if ([endPlaybackTime respondsToSelector: @selector(floatValue)]) {
        self.endPlaybackTime = [endPlaybackTime floatValue];
    }

    NSString *src = [dic valueForKey: @"src"];
    if ([src isKindOfClass: [NSString class]]) {
        self.src = src;
    }
}

-(id)copyWithZone:(NSZone *)zone{
    CAPVideoM *m = [super copyWithZone: zone];
    m.scalingMode = _scalingMode;
    m.controlStyle = _controlStyle;
    m.repeatMode = _repeatMode;
    m.allowsAirPlay = _allowsAirPlay;
    m.useAVPlayer = _useAVPlayer;
    m.sourceType = _sourceType;
    m.src = _src;
    m.backgroundPlaybackEnabled = _backgroundPlaybackEnabled;
    
    return m;
}

-(void)dealloc{
    [_onloadstate unref];
    [_onplaybackfinish unref];
    [_onplaybackstate unref];
    [_onpreparedtoplay unref];
}

@end
