#import "MP3Service.h"
#import <lame/lame.h>

@implementation MP3Service

+(void)load{
    [[ESRegistry getInstance] registerService: @"MP3Service" withName: @"mp3"];
}

- (BOOL) singleton{
    return YES;
}

- (void) setCurrentState: (lua_State *) value{
    L = value;
}

- (void) setSampleRate: (NSNumber *) rate {
    samplerate = [rate floatValue];
}

-(void)onLoad{
    recorder = new AQRecorder();

    samplerate = 11025.0;

    [[AVAudioSession sharedInstance] setActive: YES error: nil];

    previewCategory = [AVAudioSession sharedInstance].category;

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

- (void) startRecord: (NSString *) path {
    if (recorder->IsRunning()) {
        recorder->StopRecord();
    }

    lastRecordPath = path;

    CAPAppSandbox *sandbox = [OSUtils getSandboxFromState: L];

    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];

    recorder->StartRecord((__bridge CFStringRef)[[sandbox resolveFile: [path stringByAppendingPathExtension: @"caf"]] absoluteString]);
}

- (void) _COROUTINE_stopRecord{
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

    @try {
        double mSampleRate = [AVAudioSession sharedInstance].sampleRate;

        int read, write;

        FILE *pcm = fopen([[cafURL path] cStringUsingEncoding: NSUTF8StringEncoding], "rb");
        fseek(pcm, 4*1024, SEEK_CUR);
        FILE *mp3 = fopen([[[sandbox resolveFile: lastRecordPath] path] cStringUsingEncoding: NSUTF8StringEncoding], "wb");

        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];

        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, mSampleRate);
        lame_set_out_samplerate(lame, samplerate);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);

        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);

            fwrite(mp3_buffer, write, 1, mp3);

        } while (read != 0);

        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        [Bugly reportException: exception];
    }
    @finally
    {
    }

    [[NSFileManager defaultManager] removeItemAtURL: cafURL error: nil];

    lastRecordPath = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag{
    player = nil;
    if (previewCategory) {
        [[AVAudioSession sharedInstance] setCategory: previewCategory error: nil];
    }

    if (onplayercomplete) {
        [onplayercomplete executeWithoutReturnValue: [NSNumber numberWithBool: flag], nil];
        onplayercomplete = nil;
    }
}

- (NSNumber *) getDuration{
    if (player) {
        return [NSNumber numberWithDouble: player.duration];
    }

    return nil;
}

- (NSNumber *) getCurrentTime {
    if (player) {
        return [NSNumber numberWithDouble: player.currentTime];
    }

    return nil;
}

- (void) setCurrentTime: (NSNumber *) time {
    if (player) {
        [OSUtils runBlockOnMain:^{
            player.currentTime = [time doubleValue];
        }];
    }
}

- (void) load: (NSString *) path{
    CAPAppSandbox *sandbox = [OSUtils getSandboxFromState: L];

    player = [[AVAudioPlayer alloc] initWithContentsOfURL: [sandbox resolveFile: path] error: nil];
    player.delegate = self;
}

- (void) play: (LuaFunction *) callback {
    onplayercomplete = callback;

    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];

    [player play];
}

- (void) play {
    [self play: nil];
}

- (void) stop {
    if (player) {
        [player stop];
    }
}

@end
