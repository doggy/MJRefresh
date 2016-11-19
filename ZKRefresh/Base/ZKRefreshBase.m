//
//  ZKRefreshBase.m
//  ZKRefresh
//
//  Created by doggy on 11/13/16.
//  Copyright © 2016 doggy. All rights reserved.
//

#import "UIScrollView+ZKRefreshPrivate.h"
#import "UIView+ZKRefreshPrivate.h"
#import "ZKRefreshBase.h"

NSString *const ZKRefreshKeyPathContentOffset = @"contentOffset";
NSString *const ZKRefreshKeyPathContentSize = @"contentSize";


@interface ZKRefreshBase()
@property (weak,   nonatomic, readwrite) __kindof UIScrollView *scrollView;

@end

@implementation ZKRefreshBase

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepare];
        
        // default value
        _state = ZKRefreshStateIdle;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // `beginRefreshing` called but isn't displaying
    // Now changing state to Refreshing
    if (self.state == ZKRefreshStateWillRefresh) {
        self.state = ZKRefreshStateRefreshing;
    }
}

- (void)prepare
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = UIColor.clearColor;
}

- (void)willMoveToSuperview:(__kindof UIScrollView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // superView muse be kind of UIScrollView
    if ([newSuperview isKindOfClass:UIScrollView.class]) {
        // width and left position
        self.zk_width = newSuperview.zk_width;
        self.zk_x = 0;
        
        // hold parentView in weak
        self.scrollView = newSuperview;
        
        // MUST BE: bouncing style
        self.scrollView.alwaysBounceVertical = YES;
    }
}

#pragma mark Public method
- (void)beginRefreshing
{
    if (self.window) {
        // Displaying
        self.state = ZKRefreshStateRefreshing;
    } else {
        // Property scrollViewOriginalInset not set
        // waiting for willMoveToSuperview:
        if (self.state != ZKRefreshStateRefreshing) {
            self.state = ZKRefreshStateWillRefresh;\
            // Display view in next runLoop
            [self setNeedsDisplay];
        }
    }
}

- (void)endRefreshing
{
    self.state = ZKRefreshStateIdle;
}

- (BOOL)isRefreshing
{
    return (   self.state == ZKRefreshStateRefreshing
            || self.state == ZKRefreshStateWillRefresh
            || self.state == ZKRefreshStateWillIdle
            );
}

@end
