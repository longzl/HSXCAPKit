//
//  ScrollViewWidget.m
//  EOSClient2
//
//  Created by Chang Sam on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPScrollViewWidget.h"
#import "CAPScrollViewM.h"
#import "EOSScrollView.h"

@implementation CAPScrollViewWidget

@synthesize editingFocusView;

+(void)load{
    [WidgetMap bind: @"scrollview" withModelClassName: NSStringFromClass([CAPScrollViewM class]) withWidgetClassName: NSStringFromClass([CAPScrollViewWidget class])];
}

-(id)initWithModel:(CAPScrollViewM *)m withPageSandbox: (CAPPageSandbox *) sandbox{
    m.overflow = OverflowTypeHidden;
    
    self = [super initWithModel: m withView: nil withPageSandbox: sandbox];
    super.clipsToBounds = YES;
    return self;
}

-(void)onCreateView{
    EOSScrollView *v = [[EOSScrollView alloc] initWithFrame: [self getActualCurrentRect]];
    v.delegate = self;
    v.directionalLockEnabled = YES;
    v.decelerationRate = INT16_MAX;
    v.showsHorizontalScrollIndicator = NO;
    v.showsVerticalScrollIndicator = NO;

    if (@available(iOS 11, *)) {
        v.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    view = v;

    [super onCreateView];

    ((EOSScrollView *)[self innerView]).pagingEnabled = self.model.pagingEnabled;

    [self buildRefreshTableView];
}

- (void) buildRefreshTableView{
    if ([self.model.dragDownLayout isKindOfClass: [CAPViewM class]] && self.model.dragDownMinMovement > 0) {
        __weak typeof(self) weakSelf = self;
        __weak typeof(view) weakView = view;
        [OSUtils runBlockOnMain:^{
            if (weakSelf.refreshScrollView) {
                weakSelf.refreshScrollView.delegate = nil;
                [weakSelf.refreshScrollView removeFromSuperview];
                weakSelf.refreshScrollView = nil;
            }

            weakSelf.refreshScrollView = [[EGORefreshScrollView alloc] initWithWidget: weakSelf];
            weakSelf.refreshScrollView.delegate = weakSelf;
            [weakView addSubview: weakSelf.refreshScrollView];

            ((EOSScrollView *) weakView).alwaysBounceVertical = YES;
        }];
    }
}

- (void) setDragDownMinMovement: (NSNumber *) movement{
    self.model.dragDownMinMovement = [movement floatValue];

    [self buildRefreshTableView];
}

- (void) setDragDownLayout: (NSDictionary *) dic{
    self.model.dragDownLayout = [ModelBuilder buildModel: dic];

    [self buildRefreshTableView];
}

- (void) setOnDragDownStateChanged: (LuaFunction *) func {
    if ([func isKindOfClass: [LuaFunction class]]) {
        self.model.onDragDownStateChanged = func;
    }
}

- (void) setOnDragDownAction: (LuaFunction *) func {
    if ([func isKindOfClass: [LuaFunction class]]) {
        self.model.onDragDownAction = func;
    }
}

- (void)closeDragDown{
    __weak typeof(self) weakSelf = self;
    [OSUtils runBlockOnMain:^{
        [weakSelf.refreshScrollView egoRefreshScrollViewDataSourceDidFinishedLoading: (UIScrollView *) [weakSelf innerView]];
    }];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (BOOL)egoRefreshScrollViewIsLoading:(EGORefreshScrollView*)view{
    return dragDowning; // should return if data source model is reloading
}

-(void)onReload{
    [super onReload];
    
    APPLY_DIRTY_MODEL_PROP_EQ_DO(pagingEnabled, {
        ((EOSScrollView *)[self innerView]).pagingEnabled = self.model.pagingEnabled;
    });
}

- (void) setPagingEnabled: (NSNumber *) value {
    self.model.pagingEnabled = [value boolValue];
    
    [self reload];
}


- (BOOL) getPagingEnabled{
    return self.model.pagingEnabled;
}

- (void) setDecelerationEnabled: (NSNumber *) value {
    self.model.decelerationEnabled = [value boolValue];
    
    [self reload];
}


- (BOOL) getDecelerationEnabled{
    return self.model.decelerationEnabled;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshScrollView egoRefreshScrollViewDidScroll: scrollView];

    CGPoint point = scrollView.contentOffset;
    point.x = [[self.pageSandbox getAppSandbox].scale getRefLength: point.x];
    point.y = [[self.pageSandbox getAppSandbox].scale getRefLength: point.y];

    if ([self.model.ontouchmove isKindOfClass: [LuaFunction class]]) {
        [self.model.ontouchmove executeWithoutReturnValue: self, [NSNumber numberWithFloat: point.x], [NSNumber numberWithFloat: point.y], nil];
    }
    if ([self.model.onchange isKindOfClass: [LuaFunction class]]) {
        [(LuaFunction *)self.model.onchange executeWithoutReturnValue: self, [NSNumber numberWithFloat: point.x], [NSNumber numberWithFloat: point.y], nil];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.model.ontouchdown isKindOfClass: [LuaFunction class]]) {
        CGPoint point = scrollView.contentOffset;
        point.x = [[self.pageSandbox getAppSandbox].scale getRefLength: point.x];
        point.y = [[self.pageSandbox getAppSandbox].scale getRefLength: point.y];
        [self.model.ontouchdown executeWithoutReturnValue: self, [NSNumber numberWithFloat: point.x], [NSNumber numberWithFloat: point.y], nil];
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (!self.model.decelerationEnabled) {
        [scrollView setContentOffset:scrollView.contentOffset animated: YES];
    }
}

- (void) dispatchTouchUp:(UIScrollView *)scrollView{
    if ([self.model.ontouchup isKindOfClass: [LuaFunction class]]) {
        CGPoint point = scrollView.contentOffset;
        point.x = [[self.pageSandbox getAppSandbox].scale getRefLength: point.x];
        point.y = [[self.pageSandbox getAppSandbox].scale getRefLength: point.y];
        [self.model.ontouchup executeWithoutReturnValue: self, [NSNumber numberWithFloat: point.x], [NSNumber numberWithFloat: point.y], nil];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (!decelerate) {
        [self dispatchTouchUp: scrollView];
    [_refreshScrollView egoRefreshScrollViewDidEndDragging: scrollView];
//    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [self dispatchTouchUp: scrollView];
}

+ (CGRect) rectWithRotation: (CGRect) rect{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        return CGRectMake(rect.origin.y, rect.origin.x, rect.size.height, rect.size.width);
    }
    return rect;
}

+ (CGSize) sizeWithRotation: (CGSize) size{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        return CGSizeMake(size.height, size.width);
    }
    return size;
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification{
    if (![self isVisible]) {
        return;
    }

    BOOL meet = NO;
    CAPViewWidget *parentWidget = [self.pageSandbox lastEditingFocus].parent;
    while (parentWidget != nil) {
        if (parentWidget == self) {
            meet = YES;
            break;
        }else{
            parentWidget = parentWidget.parent;
        }
    }
    
    if (!meet && !editingFocusView) {
        return;
    }
    
    self.editingFocusView = [self.pageSandbox lastEditingFocus];

    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    keyboardBounds = [CAPScrollViewWidget rectWithRotation: keyboardBounds];
    
    CGRect screenRect = [CAPScrollViewWidget rectWithRotation: [UIApplication sharedApplication].keyWindow.bounds];
    CGRect bounds = [self innerView].bounds;
    CGRect selfOnScreenRect = [CAPScrollViewWidget rectWithRotation: [[self innerView] convertRect: bounds toView: [UIApplication sharedApplication].keyWindow]];
    
    UIEdgeInsets e;
    if (keyboardBounds.origin.y == screenRect.size.height) {
        e = UIEdgeInsetsZero;
    }else{
        e = UIEdgeInsetsMake(0, 0, selfOnScreenRect.origin.y + selfOnScreenRect.size.height - keyboardBounds.origin.y, 0);
    }
    
    [(UIScrollView *)[self innerView] setScrollIndicatorInsets:e];
    [(UIScrollView *)[self innerView] setContentInset:e];
    
    if (editingFocusView) {
        [(UIScrollView *)[self innerView] scrollRectToVisible: [[editingFocusView innerView] convertRect: [editingFocusView innerView].bounds
                                                                                                  toView: [self innerView]]
                                                     animated: YES];
    }
}

-(void)onDestroy{
    self.editingFocusView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super onDestroy];
}

- (void) onFronted{
    [super onFronted];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeFrame:)
                                                 name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void) onBackend{
    [super onBackend];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

-(CGRect)measureRect:(CGSize) parentContentSize{
    __block CGRect totalRect = [super measureSelfRect: parentContentSize];
    
    float paddingLeft = [self.model.paddingLeft pixelValue: parentContentSize.width withDefault: 0];
    float paddingRight = [self.model.paddingRight pixelValue: parentContentSize.width withDefault: 0];
    float paddingTop = [self.model.paddingTop pixelValue: parentContentSize.height withDefault: 0];
    float paddingBottom = [self.model.paddingBottom pixelValue: parentContentSize.height withDefault: 0];
    
    contentRect = CGRectMake(paddingLeft, paddingTop,
                                    totalRect.size.width - paddingLeft - paddingRight,
                                    totalRect.size.height - paddingTop - paddingBottom);
    
    CGRect content = CGRectMake(0, 0, totalRect.size.width, totalRect.size.height);

    NSArray *subitems = self.subitems;
    for (CAPAbstractUIWidget *widget in subitems) {
        CGRect expectedRect = [widget measureRect: contentRect.size];
        if (widget.model.hidden) {
            continue;
        }
        expectedRect = CGRectOffset(expectedRect, contentRect.origin.x, contentRect.origin.y);
        widget->currentRect = expectedRect;
        
        content = CGRectUnion(content, widget->currentRect);
    }
    
    currentContentSize = content.size;
    
    return totalRect;
}

-(void)setViewFrame:(CGRect)rect{
    [super setViewFrame: rect];
    ((UIScrollView *)[self innerView]).contentSize = [[self.pageSandbox getAppSandbox].scale getActualSize: currentContentSize];
}

- (BOOL) scrollX: (float) value{
    value = [[self.pageSandbox getAppSandbox].scale getActualLength: value];

    CGPoint offset = ((UIScrollView *)[self innerView]).contentOffset;
    offset.x = offset.x + value;
    [OSUtils runBlockOnMain:^{
        [UIScrollView beginAnimations: nil context: nil];
        ((UIScrollView *)[self innerView]).contentOffset = offset;
        [UIScrollView commitAnimations];
    }];
    return YES;
}

- (BOOL) scrollY: (float) value{
    value = [[self.pageSandbox getAppSandbox].scale getActualLength: value];

    CGPoint offset = ((UIScrollView *)[self innerView]).contentOffset;
    offset.y = offset.y + value;
    [OSUtils runBlockOnMain:^{
        [UIScrollView beginAnimations: nil context: nil];
        ((UIScrollView *)[self innerView]).contentOffset = offset;
        [UIScrollView commitAnimations];
    }];
    return YES;
}

- (void) setContentOffset: (float) x : (float) y : (NSNumber *) animated{
    x = [[self.pageSandbox getAppSandbox].scale getActualLength: x];
    y = [[self.pageSandbox getAppSandbox].scale getActualLength: y];

    [OSUtils runBlockOnMain:^{
        [((UIScrollView *)[self innerView]) setContentOffset:CGPointMake(x, y) animated: [animated boolValue]];
    }];
}

- (void) setContentOffset: (float) x : (float) y{
    x = [[self.pageSandbox getAppSandbox].scale getActualLength: x];
    y = [[self.pageSandbox getAppSandbox].scale getActualLength: y];

    [OSUtils runBlockOnMain:^{
        ((UIScrollView *)[self innerView]).contentOffset = CGPointMake(x, y);
    }];
}

- (PackedArray *) getContentOffset{
    __block CGPoint contentOffset;
    [OSUtils runSyncBlockOnMain:^{
        contentOffset = ((UIScrollView *)[self innerView]).contentOffset;
    }];

    return [[PackedArray alloc] initWithArray: @[
            [NSNumber numberWithFloat: [[self.pageSandbox getAppSandbox].scale getRefLength:contentOffset.x]],
            [NSNumber numberWithFloat: [[self.pageSandbox getAppSandbox].scale getRefLength:contentOffset.y]]
           ]];
}

- (PackedArray *) getContentSize{
    CGSize size = ((UIScrollView *)[self innerView]).contentSize;
    size = [[self.pageSandbox getAppSandbox].scale getRefSize: size];
    return [[PackedArray alloc] initWithArray: @[[NSNumber numberWithFloat: size.width],
                                                 [NSNumber numberWithFloat: size.height]]];
}

- (void) setContentSize: (float) width : (float) height{
    CGSize size = [[self.pageSandbox getAppSandbox].scale getActualSize: CGSizeMake(width, height)];

    ((UIScrollView *)[self innerView]).contentSize = size;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
