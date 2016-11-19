//
//  ZKRefreshBaseHeader.m
//  ZKRefresh
//
//  Created by doggy on 11/13/16.
//  Copyright © 2016 doggy. All rights reserved.
//

#import "UIScrollView+ZKRefreshPrivate.h"
#import "UIView+ZKRefreshPrivate.h"
#import "ZKRefreshBaseHeader.h"

const CGFloat MJRefreshHeaderHeight = 54.0;
const CGFloat MJRefreshFastAnimationDuration = 0.25;
const CGFloat MJRefreshSlowAnimationDuration = 0.4;

@interface ZKRefreshBaseHeader()
@property (assign, nonatomic) CGFloat insetTDelta;

// @ Property inherted from ZKRefreshBase
@property (assign, nonatomic, readwrite) UIEdgeInsets scrollViewOriginalInset;
@end

@implementation ZKRefreshBaseHeader

// @ Property inherted from ZKRefreshBase
@synthesize scrollViewOriginalInset = __scrollViewOriginalInset;
- (void)setScrollViewOriginalInset:(UIEdgeInsets)scrollViewOriginalInset
{
    __scrollViewOriginalInset = scrollViewOriginalInset;
}

#pragma mark - NS_DESIGNATED_INITIALIZER
+ (instancetype)headerWithRefreshingBlock:(ZKRefreshBaseRefreshingBlock)refreshingBlock
{
    ZKRefreshBaseHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}

#pragma mark - Override
- (void)prepare
{
    [super prepare];
    
    // This header view's height
    self.zk_height = MJRefreshHeaderHeight;
}

- (void)beginRefreshing
{
    self.pullingPercent = 1.0;
    [super beginRefreshing];
}

-(void)layoutSubviews
{
    // Put itself to the top of contentView
    self.zk_y = - self.zk_height - self.ignoredScrollViewContentInsetTop;
    
    [super layoutSubviews];
}

- (void)willMoveToSuperview:(__kindof UIScrollView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self removeObservers];
    
    // Must be added to UIScrollView
    if ([newSuperview isKindOfClass:UIScrollView.class]) {
        // Save original contentInset
        self.scrollViewOriginalInset = self.scrollView.contentInset;
        
        [self addObservers];
    }
}

#pragma mark - KVO Observer
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:ZKRefreshKeyPathContentOffset options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:ZKRefreshKeyPathContentOffset];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.userInteractionEnabled) return;
    
    if (self.hidden) return;
    
    // KVO `contentOffset` handler
    if ([keyPath isEqualToString:ZKRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    if (   self.state != ZKRefreshStateRefreshing
        && self.state != ZKRefreshStateWillIdle ) {
        // Mind to updating contentInset
        self.scrollViewOriginalInset = self.scrollView.contentInset;
    }
    
    CGFloat contentOffset = self.scrollView.zk_offsetY;
    // offsetY value to show this zk_header
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // This zk_header is not showing
    if (contentOffset > happenOffsetY) return;
    
    // Refreshing In Progress
    if (self.state == ZKRefreshStateRefreshing) {
        // Shrink contentInsetTop for grouped style UITableView's sectionheader
        CGFloat insetT = MAX(- contentOffset, self.scrollViewOriginalInset.top);
        insetT = MIN(insetT, self.zk_height + self.scrollViewOriginalInset.top);
        self.scrollView.zk_insetTop = insetT;
        // ... and keep the shrunk value
        self.insetTDelta = self.scrollViewOriginalInset.top - insetT;
    } else {
        // Calculate pulling percent, based on this zk_header's height
        CGFloat pullingPercent = (happenOffsetY - contentOffset) / self.zk_height;
        
        // Dragging
        if (self.scrollView.isDragging) {
            // state Idle or Pulling
            CGFloat idleOrPulling = happenOffsetY - self.zk_height;
            
            self.pullingPercent = pullingPercent;
            if (contentOffset < idleOrPulling) {
                if (self.state == ZKRefreshStateIdle) {
                    self.state = ZKRefreshStatePulling;
                }
            } else if (idleOrPulling <= contentOffset) {
                if (self.state == ZKRefreshStatePulling) {
                    self.state = ZKRefreshStateIdle;
                }
            }
        } else {
            // No finger dragging on the scrollView.
            if (self.state == ZKRefreshStatePulling) {
                // Rolling out !!
                [self beginRefreshing];
            } else if (pullingPercent < 1) {
                // Updating percent
                self.pullingPercent = pullingPercent;
            }
        }
    }
}

#pragma mark - State Handler

- (void)setState:(ZKRefreshState)state
{
    // Skip if same state
    if (state == self.state) return;
    ZKRefreshState oldState = self.state;
    [super setState:state];
    
    if (state == ZKRefreshStateRefreshing) {
        // Start Refreshing
        dispatch_main_async_safe( ^{
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                CGFloat top = self.scrollViewOriginalInset.top + self.zk_height;
                // contentInsetTop should be increased in order to keeping this zk_header in scrollView
                self.scrollView.zk_insetTop = top;
                // 设置滚动位置
                [self.scrollView setContentOffset:CGPointMake(0, -top) animated:NO];
            } completion:^(BOOL finished) {
                if (self.refreshingBlock) {
                    self.refreshingBlock();
                }
            }];
        });
    } else if (state == ZKRefreshStateIdle) {
        if (oldState == ZKRefreshStateRefreshing) {
            // Refreshing Stopped
            self.state = ZKRefreshStateWillIdle;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                    // Reset contentInsetTop
                    self.scrollView.zk_insetTop += self.insetTDelta;
                } completion:^(BOOL finished) {
                    self.state = ZKRefreshStateIdle;
                    
                    CGFloat pullingPercent = self.pullingPercent;
                    self.pullingPercent = .0f;
                    self.pullingPercent = pullingPercent;
                }];
            });
        }
    }
}

@end
