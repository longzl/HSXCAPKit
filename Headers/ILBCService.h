#import <CAPKit/CAPKit.h>
#import "AQRecorder.h"
#import <AudioToolbox/AudioSession.h>
#import <AVFoundation/AVFoundation.h>

@interface ILBCService : NSObject <IService, LuaTableCompatible, AVAudioPlayerDelegate> {
    lua_State *L;
    AQRecorder *recorder;

    AVAudioPlayer *player;

    NSString *lastRecordPath;

    LuaFunction *onplayercomplete;

    NSString *previewCategory;
}

@end
