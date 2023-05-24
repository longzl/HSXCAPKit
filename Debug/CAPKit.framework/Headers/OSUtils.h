@class CAPAppSandbox;
@class PNum;

@interface OSUtils : NSObject {
    
}

+ (NSString *) getLocalePath: (NSString *) filePath
               withContainer: (CAPContainer *) container;

+ (NSString *) getLocalePath: (NSString *) filePath
               withContainer: (CAPContainer *) container
                   withAppId: (NSString *) appId
                    withPath: (NSString *) path;
+ (NSString *) uuid;

+ (NSString *) md5String: (NSString *) input;

+ (NSString *) fileMD5:(NSString*)path;

+ (UIColor *) getColorFromString: (NSString *) colorString withDefaultColor: (UIColor *) color DEPRECATED_ATTRIBUTE;

+ (UIColor *) getColorFromObject: (NSObject *) colorObject withDefaultColor: (UIColor *) color;

+ (UIColor *) getColor: (NSObject *) colorObject withAlpha: (float) alpha withDefaultColor: (UIColor *) color;

+ (float) convertNumberFromObject: (PNum *) obj withParent: (float) parent;
+ (float) convertNumberFromObject: (PNum *) obj withParent: (float) parent withDefault: (float) val;

+ (BOOL) is_EmailSchema:(NSString *)email;

+ (NSInteger) compareVersion: (NSString *) version1 withVersion: (NSString *) version2;

+ (BOOL) unzip: (NSString *) sourcePath to: (NSString *) destPath;

+ (NSString *) getHash: (NSString *) url withContainer: (CAPContainer *) container;

+ (void) execute: (NSObject *) script withSandbox: (CAPPageSandbox *) sandbox DEPRECATED_ATTRIBUTE;

+ (void) executeDirect: (NSObject *) script withSandbox: (CAPPageSandbox *) sandbox;

+ (void) executeDirect: (NSObject *) script withSandbox: (CAPPageSandbox *) sandbox withObject: (NSObject *) obj;

+ (void) executeDirect: (NSObject *) script withSandbox: (CAPPageSandbox *) sandbox withObject: (NSObject *) obj1 withObject: (NSObject *) obj2;

+ (NSObject *) getObject: (NSObject *) delegate withObject: (NSObject *) obj1 withObject: (NSObject *) obj2 withObject: (NSObject *) obj3 withObject: (NSObject *) obj4;

+ (id) getObject: (NSObject *) delegate withObject: (NSObject *) obj1 withObject: (NSObject *) obj2 withObject: (NSObject *) obj3;

+ (NSInteger) getInteger: (NSObject *) delegate withObject: (NSObject *) obj1 withObject: (NSObject *) obj2 withObject: (NSObject *) obj3;
+ (double) getDouble: (NSObject *) delegate withObject: (NSObject *) obj1 withObject: (NSObject *) obj2 withObject: (NSObject *) obj3;
+ (BOOL) getBOOL: (NSObject *) delegate withObject: (NSObject *) obj1 withObject: (NSObject *) obj2 withObject: (NSObject *) obj3;

+ (NSArray *) getArray: (NSObject *) delegate withObject: (NSObject *) obj1 withObject: (NSObject *) obj2 withObject: (NSObject *) obj3;

+ (NSDictionary *) getDictionary: (NSObject *) delegate withObject: (NSObject *) obj1 withObject: (NSObject *) obj2 withObject: (NSObject *) obj3;

+ (void) runBlockOnMain: (dispatch_block_t) blk;

+ (void) runSyncBlockOnMain: (dispatch_block_t) blk;

typedef id (^block_with_returnvalue)(void);

+ (id) runBlockOnMainWithReturnValue: (block_with_returnvalue) b;

+ (void) runBlockOnBackground: (dispatch_block_t) blk;

+ (CAPAppSandbox *) getSandboxFromState: (lua_State *) L;

+ (CAPContainer *) getContainerFromState: (lua_State *) L;

+ (void) unRef: (NSObject *) ref;

+ (UIImage *) imageFromDataString: (NSString *) srcString;

+ (UIInterfaceOrientationMask) buildDirection: (NSString *) direction;

@end
