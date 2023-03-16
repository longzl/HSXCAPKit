//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshScrollView.h"
#import "CAPScrollViewWidget.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshScrollView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshScrollView

- (id)initWithWidget:(CAPScrollViewWidget *) widget {
    CGRect listRect = [widget innerView].bounds;
    CGRect rect = CGRectMake(0, -listRect.size.height, listRect.size.width, listRect.size.height);

    if (self = [super initWithFrame: rect]) {
        self.scrollWidget = widget;

//		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        _contentWidget = (CAPViewWidget *)[WidgetBuilder buildWidget: widget.model.dragDownLayout withPageSandbox: widget.pageSandbox];
        CGRect contentRect = [_contentWidget measureRect: [[widget.pageSandbox getAppSandbox].scale getRefSize: rect.size]];
        _contentWidget->currentRect = contentRect;
        [_contentWidget createView];
        [_contentWidget reloadRect];

        [self addSubview: [_contentWidget innerView]];
		
		[self setState:EGOOPullRefreshNormal];
		
    }
	
    return self;
	
}


#pragma mark -
#pragma mark Setters

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
            [self.scrollWidget.model.onDragDownStateChanged executeWithoutReturnValue: self.scrollWidget, [NSNumber numberWithBool: YES], nil];
			break;
		case EGOOPullRefreshNormal:
            [self.scrollWidget.model.onDragDownStateChanged executeWithoutReturnValue: self.scrollWidget, [NSNumber numberWithBool: NO], nil];
			break;
		case EGOOPullRefreshLoading:
            [self.scrollWidget.model.onDragDownAction executeWithoutReturnValue: self.scrollWidget, [NSNumber numberWithBool: YES], nil];
			break;
        case EGOOPullRefreshIgnore:
            [self.scrollWidget.model.onDragDownAction executeWithoutReturnValue: self.scrollWidget, [NSNumber numberWithBool: NO], nil];
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	if (_state == EGOOPullRefreshLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, [[self.scrollWidget.pageSandbox getAppSandbox].scale getActualLength: self.scrollWidget.model.dragDownMinMovement]);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
	} else if (scrollView.isDragging) {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshScrollViewIsLoading:)]) {
			_loading = [_delegate egoRefreshScrollViewIsLoading:self];
		}
		
		if ((_state == EGOOPullRefreshPulling || _state == EGOOPullRefreshIgnore)
            && scrollView.contentOffset.y > - [[self.scrollWidget.pageSandbox getAppSandbox].scale getActualLength: self.scrollWidget.model.dragDownMinMovement] - 5.0f
            && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal
                   && scrollView.contentOffset.y < - [[self.scrollWidget.pageSandbox getAppSandbox].scale getActualLength: self.scrollWidget.model.dragDownMinMovement] - 5.0f
                   && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshScrollViewIsLoading:)]) {
		_loading = [_delegate egoRefreshScrollViewIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - [[self.scrollWidget.pageSandbox getAppSandbox].scale getActualLength: self.scrollWidget.model.dragDownMinMovement] - 5.0f && !_loading) {
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake([[self.scrollWidget.pageSandbox getAppSandbox].scale getActualLength: self.scrollWidget.model.dragDownMinMovement], 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
    } else {
        [self setState: EGOOPullRefreshIgnore];
    }
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];

}

@end
