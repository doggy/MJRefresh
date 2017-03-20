//
//  ZKRefreshBaseEarlierLoader.m
//  ZKRefresh
//
//  Created by doug on 3/20/17.
//  Copyright © 2017 doug. All rights reserved.
//

#import "UIScrollView+ZKRefreshPrivate.h"
#import "UIView+ZKRefreshPrivate.h"
#import "ZKRefreshBase_private.h"
#import "ZKRefreshBaseEarlierLoader.h"

static const CGFloat MJRefreshHeaderHeight = 44.0;

@interface ZKRefreshBaseEarlierLoader ()

@end

@implementation ZKRefreshBaseEarlierLoader

#pragma mark - NS_DESIGNATED_INITIALIZER
+ (instancetype)headerWithRefreshingBlock:(ZKRefreshBaseRefreshingBlock)refreshingBlock
{
    ZKRefreshBaseEarlierLoader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}

#pragma mark - Override
- (void)prepare
{
    [super prepare];
    
    // This header view's height
    self.zk_height = MJRefreshHeaderHeight;
    
    // Default values
    self.triggerAutomaticallyRefreshPercent = .0f;
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
        // Extend contentInsetTop for adding this header
        if (self.hidden == NO) {
            self.scrollView.zk_insetTop += self.zk_height;
            
            // re-alignment contentView's position
            CGPoint contentOffset = self.scrollView.contentOffset;
            contentOffset.y -= self.zk_height;
            [self.scrollView setContentOffset:contentOffset animated:NO];
        }
        
        [self addObservers];
    } else {
        // Shrink contentInsetTop for removing this header
        if (self.hidden == NO) {
            self.scrollView.zk_insetTop -= self.zk_height;
        }
    }
}

#pragma mark - KVO Observer
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:ZKRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:ZKRefreshKeyPathContentSize options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:ZKRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:ZKRefreshKeyPathContentSize];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.userInteractionEnabled) return;
    
    // KVO `contentSize` handler
    if ([keyPath isEqualToString:ZKRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    if (self.hidden || self.ignoreRefresh) return;
    
    // KVO `contentOffset` handler
    if ([keyPath isEqualToString:ZKRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    if (self.automaticallyHidden) {
        self.hidden = (0 == self.zk_totalDataCount);
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    if (ZKRefreshStateIdle == self.state) {
        CGFloat triggerDistanceToContentTop = - (  self.scrollView.zk_insetTop
                                                 - self.zk_height
                                                 + self.triggerAutomaticallyRefreshPercent * self.scrollView.zk_height);
        CGFloat triggerOffsetY = self.scrollView.zk_offsetY;
        
        NSLog(@"doug 2 %f" , triggerOffsetY);
        
        if (triggerOffsetY < triggerDistanceToContentTop) {
            // Just a performance improvement
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (old.y <= new.y) return;
            
            NSLog(@"doug beginRefreshing");
            
            // Rolling out !!
            [self beginRefreshing];
        }
    }
}

#pragma mark - state handler

- (void)setState:(ZKRefreshState)state
{
    // Skip if same state
    if (state == self.state) return;
    [super setState:state];
    
    if (state == ZKRefreshStateRefreshing) {
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
    }
}

- (void)setHidden:(BOOL)hidden
{
    // Skip if same value
    if (hidden == self.hidden) return;
    [super setHidden:hidden];
    
    if (hidden) {
        self.state = ZKRefreshStateIdle;
        
        // Hide header: Shrink contentInsetTop
        self.scrollView.zk_insetTop -= self.zk_height;
    } else {
        // Show header: Extend contentInsetTop
        self.scrollView.zk_insetTop += self.zk_height;
    }
}

#pragma mark - Private

- (NSInteger)zk_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self.scrollView isKindOfClass:UITableView.class]) {
        __kindof UITableView *tableView = (__kindof UITableView *)self.scrollView;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self.scrollView isKindOfClass:UICollectionView.class]) {
        __kindof UICollectionView *collectionView = (__kindof UICollectionView *)self.scrollView;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

#pragma mark - Public
- (void)endRefreshingWithNoMoreData
{
    self.state = ZKRefreshStateNoMoreData;
}

- (void)resetNoMoreData
{
    self.state = ZKRefreshStateIdle;
}

- (void)endRefreshingWithHeightIncrease:(CGFloat)heightIncrease
{
    CGPoint offset = self.scrollView.contentOffset;
    offset.y += heightIncrease;
    [self.scrollView setContentOffset:offset animated:NO];
    
    self.state = ZKRefreshStateIdle;
}

@end
