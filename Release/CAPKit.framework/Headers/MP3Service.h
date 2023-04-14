#import <CAPKit/CAPKit.h>
#import "AQRecorder.h"
#import <AudioToolbox/AudioSession.h>
#import <AVFoundation/AVFoundation.h>

@interface MP3Service : NSObject <IService, LuaTableCompatible, AVAudioPlayerDelegate, AVAudioRecorderDelegate> {
    lua_State *L;

    AQRecorder *recorder;

    NSString *lastRecordPath;

    Float64 samplerate;

    LuaFunction *onplayercomplete;

    NSString *previewCategory;
}

@property (nonatomic) AVAudioPlayer *player;

@end
