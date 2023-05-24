#import <MessageUI/MessageUI.h>

#define CONFIRM_OK      1
#define CONFIRM_CANCEL  0

@class CAPPageSandbox, CAPAppSandbox, CAPLuaImage;
@class AdvancedTakePhoto;

@interface LuaHelper : NSObject <UIAlertViewDelegate, UIActionSheetDelegate, LuaTableCompatible, MFMessageComposeViewControllerDelegate> {
    BOOL previewingPhoto;
    BOOL isPreviewDone;
    
    NSDateFormatter *formatter;
    AdvancedTakePhoto *takePhoto;
    
    lua_State *L;
}

@property (nonatomic, weak, readonly) CAPContainer *container;
@property (nonatomic, weak, readonly) CAPAppSandbox *sandbox;

-(id)initWithSandbox: (CAPAppSandbox *) sandbox;

- (NSString *) dump: (NSObject *) object;

- (void) switchApp: (AppContext *) context;
- (void) switchPage: (AppContext *) context;
- (void) pushApp: (AppContext *) context;
- (void) popPage: (AppContext *) context;
- (void) popApp: (AppContext *) context;
- (void) pushController: (AppContext *) context;

- (void) startBusy: (NSString *) ycenter withTitle: (NSString *) title;
- (void) stopBusy;

- (NSString *) urlencode: (NSString *) str;
- (NSString *) urldecode: (NSString *) str;

- (BOOL) removeApp: (NSString *) appId;

- (NSInteger) compareVersion: (NSString *) version1 withVersion: (NSString *) version2; 

- (void) registerPush;

- (BOOL) phonecall: (NSString *) num;

- (BOOL) phonesms: (NSString *) num;

- (NSString *) load: (NSString *) key scope: (NSString *) scope;

- (BOOL) save: (NSString *) key value: (NSObject *) value scope: (NSString *) scope timeout: (NSTimeInterval) sec;

- (BOOL) save: (NSString *) key value: (NSObject *) value scope: (NSString *) scope;

- (NSString *) unzip: (NSString *) urlString toPath: (NSString *) path withOutCache: (BOOL) withOutCache;

- (NSString *) download: (NSString *) urlString toPath: (NSString *) path;

- (NSString *) md5String: (NSString *) input;

- (BOOL) navigateURL: (NSString *) urlString;

- (NSNumber *) isWLAN;

- (void) exit: (int) num;

- (void) advancedTakePhoto:(NSDictionary *)option;

- (void) takePhoto:(NSDictionary *)option;

- (void) setScreenAutoRotation: (int) value;

- (int) getScreenAutoRotation;

@end
