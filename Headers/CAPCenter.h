@class CAPContainer;
@class CAPRenderView;
@class Reachability;

#define CAPDidEnterBackgroundNotification @"CAPDidEnterBackgroundNotification"
#define CAPWillEnterForegroundNotification @"CAPWillEnterForegroundNotification"

typedef void (^exceptionBlock)(NSException *);
typedef void (^errorBlock)(NSError *);

@interface CAPCenter : NSObject {
    NSMutableArray *containers;
    Reachability *reachability;
    Class containerClass;
}

@property (nonatomic, assign) BOOL EOS_DEBUG_BOOL;
@property (nonatomic, assign) BOOL EOS_DEBUGGER_BOOL;
@property (nonatomic, assign) BOOL screenAutoRotation;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) UIInterfaceOrientationMask defaultDirection;

@property (nonatomic, assign) BOOL safemode;

@property (nonatomic, assign) BOOL shouldExtractDefault;

@property (nonatomic, strong) NSString *userAgent;

@property (nonatomic, strong) exceptionBlock exceptionHandler;
@property (nonatomic, strong) errorBlock errorHandler;


+ (CAPCenter *) shared;

- (void) applyDefaults: (id) empty DEPRECATED_ATTRIBUTE;

- (void) applyDefaults;

- (void) setContainerClass: (Class) cls;

- (CAPContainer *) createContainer: (CAPRenderView *) view
                        withOption: (CAPContainerOption *) option;

- (NSArray *) listAllContainers;

- (void) removeContainer: (CAPContainer *) container;

- (void) removeAllContainers;

- (CAPContainer *) lastContainer;

- (void) initProxy: (NSURL *) optionalURL;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

@end
