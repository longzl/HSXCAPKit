/** Widget Builder
 
 WidgetBuilder is the tools to build [Widget](AbstractUIWidget)
 */
@interface WidgetBuilder : NSObject{
}

/**Build PagePanel from PageM

 @param pageURL The page model to build
 @param sandbox The App `Sandbox` from which we build the page
 @return the page view controller based on the input page
 */
+ (CAPPanelView<PagePanel> *) buildPage: (NSURL *) pageURL withSandbox: (CAPPageSandbox *) sandbox;

/**Build PagePanel from PageId
 
 @param pageId The pageId to build
 @param appsandbox The App `Sandbox` from which we build the page
 @return the page view controller based on the input page
 */
+ (CAPPanelView<PagePanel> *) buildPageId: (NSString *) pageId withAppSandbox: (CAPAppSandbox *) appsandbox;


/**Build single `Widget`
 
 @param widgetm the model of the `Widget`
 @param sandbox the `Sandbox` of this `Widget`
 @return the output `Widget`
 */
+ (CAPAbstractUIWidget *) buildWidget: (UIWidgetM *) widgetm withPageSandbox: (CAPPageSandbox *) sandbox;

@end
