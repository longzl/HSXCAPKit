@interface CAPPageSandbox : DefaultSandbox <PageSandboxInterface>{
    NSMutableArray *editingFocusStack;
}

@property (nonatomic, weak) CAPPanelView<PagePanel> *panelView;

@property (nonatomic, weak) CAPAppSandbox *appSandbox;

@property (nonatomic, weak) id<PageSandboxDelegate> delegate;

@property (nonatomic, readonly) int envRef;
@property (nonatomic, readonly) LuaState *state;

@property (nonatomic, strong) CAPPageM *model;
@property (nonatomic, readonly) id<PageLifecycle> lifecycle;
@property (nonatomic, readonly) NSString *pageId;

@property (nonatomic, readonly) NSMapTable *weakFunctions;
@property (atomic, assign) NSInteger widgetCount;

- (id) initWithAppSandbox: (CAPAppSandbox *) sandbox withPageId: (NSString *) pid;

- (void) runLuaBuffer: (NSString *) buffer;

- (NSURL *) resolveFile: (NSString *) path;

- (NSString *) getDataFile: (NSString *) path;

- (NSString *) getDefaultFontName;

- (CAPAppSandbox *) getAppSandbox;

- (GlobalSandbox *) getGlobalSandbox;

- (void) loadScripts: (CAPPageM *) pagem;
- (void) pushGlobalKey:(id)key value:(id)value;

- (void) pushEditingFocus: (CAPAbstractUIWidget *) view;
- (void) removeEditingFocus: (CAPAbstractUIWidget *) view;
- (CAPAbstractUIWidget *) lastEditingFocus;

@end
