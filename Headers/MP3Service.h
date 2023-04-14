#import <CAPKit/CAPKit.h>
#import "AQRecorder.h"
#import <AudioToolbox/AudioSession.h>
#import <AVFoundation/AVFoundation.h>

@interface MP3Service : NSObject <IService, LuaTableCompatible, AVAudioPlayerDelegate, AVAudioRecorderDelegate> {
    lua_State *L;

    AQRecorder *recorder;

    AVAudioPlayer *player;

    NSString *lastRecordPath;

    Float64 samplerate;

    LuaFunction *onplayercomplete;

    NSString *previewCategory;
}

@end
