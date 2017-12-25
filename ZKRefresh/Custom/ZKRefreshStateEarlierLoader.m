//
//  ZKRefreshStateEarlierLoader.m
//  ZKRefresh
//
//  Created by doug on 3/20/17.
//  Copyright © 2017 doug. All rights reserved.
//

#import "UIScrollView+ZKRefreshPrivate.h"
#import "UIView+ZKRefreshPrivate.h"
#import "ZKRefreshBase_private.h"
#import "ZKRefreshStateEarlierLoader.h"

static const CGFloat ZKRefreshStateEarlierLoaderHeight = 44.0;

@interface ZKRefreshStateEarlierLoader ()

@property (nonatomic, weak)   UIActivityIndicatorView *     loadingView;
@end

@implementation ZKRefreshStateEarlierLoader

#pragma mark - Properties Lazy-loading
- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}

#pragma makr - Override
- (void)prepare
{
    [super prepare];
    
    // view's height
    self.zk_height = ZKRefreshStateEarlierLoaderHeight;
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Cricle
    CGFloat arrowCenterX = CGRectGetWidth(self.frame) * 0.5;
    CGFloat arrowCenterY = CGRectGetHeight(self.frame) * 0.5;
    self.loadingView.center = CGPointMake(arrowCenterX, arrowCenterY);
}

- (void)setState:(ZKRefreshState)state
{
    if (state == self.state) return;
    [super setState:state];
    
    if (state == ZKRefreshStateNoMoreData || state == ZKRefreshStateIdle) {
        [self.loadingView stopAnimating];
    } else if (state == ZKRefreshStateRefreshing) {
        [self.loadingView startAnimating];
    }
}

@end
