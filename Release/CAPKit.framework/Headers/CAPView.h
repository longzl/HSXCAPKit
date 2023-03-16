@interface CAPView : UIView{
#ifdef DEBUG_EOS_DRAWRECT
    UIColor *debugColor;
#endif
}

@property (nonatomic, weak) CAPAbstractUIWidget *widget;

@end
