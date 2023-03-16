#import "ILBCService.h"

extern OSStatus DoConvertFile(CFURLRef sourceURL, CFURLRef destinationURL, OSType outputFormat, Float64 outputSampleRate);

@implementation ILBCService

- (BOOL) singleton{
    return YES;
}

- (void) setCurrentState: (lua_State *) value{
    L = value;
}

-(void)dealloc{
    delete recorder;
}

-(void)onLoad{
    recorder = new AQRecorder();

    [[AVAudioSession sharedInstance] setActive: YES error: nil];

    if ([[AVAudioSession sharedInstance] respondsToSelector: @selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {

        }];
    }

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(onInterruption:)
                                                 name: AVAudioSessionInterruptionNotification
                                               object: nil];
}

- (void) onInterruption: (NSNotification *) notification{
    NSNumber *type = [notification.userInfo valueForKey: AVAudioSessionInterruptionTypeKey];
    switch ([type intValue]) {
        case AVAudioSessionInterruptionTypeBegan:
            if (recorder->IsRunning()) {
                recorder->StopRecord();
            }
            break;
        case AVAudioSessionInterruptionTypeEnded:
            if (player) {
                [player play];
            }
            break;
        default:
            break;
    }
}

+(void)load{
    [[ESRegistry getInstance] registerService: @"ILBCService" withName: @"ilbc"];
}

- (void) startRecord: (NSString *) path {
    if (recorder->IsRunning()) {
        recorder->StopRecord();
    }

    lastRecordPath = path;

    CAPAppSandbox *sandbox = [OSUtils getSandboxFromState: L];
    previewCategory = [AVAudioSession sharedInstance].category;

    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];

    recorder->StartRecord((__bridge CFStringRef)[[sandbox resolveFile: [path stringByAppendingPathExtension: @"caf"]] absoluteString]);
}

- (void) stopRecord{
    if (recorder->IsRunning()) {
        recorder->StopRecord();
    }

    if (previewCategory) {
        [[AVAudioSession sharedInstance] setCategory: previewCategory error: nil];
    }

    if (!lastRecordPath) {
        return;
    }

    CAPAppSandbox *sandbox = [OSUtils getSandboxFromState: L];

    NSURL *cafURL = [sandbox resolveFile: [lastRecordPath stringByAppendingPathExtension: @"caf"]];

    DoConvertFile((__bridge CFURLRef)cafURL,
                  (__bridge CFURLRef)[sandbox resolveFile: lastRecordPath], kAudioFormatiLBC, 8000.0);

    [[NSFileManager defaultManager] removeItemAtURL: cafURL error: nil];

    lastRecordPath = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag{
    player = nil;
}

- (void) play: (NSString *) path{
    CAPAppSandbox *sandbox = [OSUtils getSandboxFromState: L];

    player = [[AVAudioPlayer alloc] initWithContentsOfURL: [sandbox resolveFile: path] error: nil];
    player.delegate = self;
    [player play];
}

@end
