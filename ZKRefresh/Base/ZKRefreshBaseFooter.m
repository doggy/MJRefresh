//
//  ZKRefreshBaseFooter.m
//  ZKRefresh
//
//  Created by doggy on 11/13/16.
//  Copyright © 2016 doggy. All rights reserved.
//

#import "ZKRefreshBaseHeader.h"
#import "UIScrollView+ZKRefreshPrivate.h"
#import "UIView+ZKRefreshPrivate.h"
#import "ZKRefreshBaseFooter.h"

const CGFloat MJRefreshFooterHeight = 44.0;

@interface ZKRefreshBaseFooter()

@end

@implementation ZKRefreshBaseFooter

#pragma mark - NS_DESIGNATED_INITIALIZER
+ (instancetype)footerWithRefreshingBlock:(ZKRefreshBaseRefreshingBlock)refreshingBlock
{
    ZKRefreshBaseFooter *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}

#pragma mark - Override
- (void)prepare
{
    [super prepare];
    
    // This header view's height
    self.zk_height = MJRefreshFooterHeight;
    
    // Default values
    self.automaticallyHidden = NO;
    self.triggerAutomaticallyRefreshPercent = .0f;
}

- (void)willMoveToSuperview:(__kindof UIScrollView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self removeObservers];
    
    // Must be added to UIScrollView
    if ([newSuperview isKindOfClass:UIScrollView.class]) {
        // Extend contentInsetBottom for adding this footer
        if (self.hidden == NO) {
            self.scrollView.zk_insetBottom += self.zk_height;
        }
        
        // Put itself to the bottom of contentView
        self.zk_y = self.scrollView.zk_contentHeight;
        
        [self addObservers];
    } else {
        // Shrink contentInsetBottom for removing this footer
        if (self.hidden == NO) {
            self.scrollView.zk_insetBottom -= self.zk_height;
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
    
    if (self.hidden) return;
    
    // KVO `contentOffset` handler
    if ([keyPath isEqualToString:ZKRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    // Put itself to the bottom of contentView
    self.zk_y = self.scrollView.zk_contentHeight;
    
    if (self.automaticallyHidden) {
        self.hidden = (0 == self.zk_totalDataCount);
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    if (ZKRefreshStateIdle == self.state) {
        BOOL beginRefreshing = NO;
        
        // ContentHeight less than one page screen
        if (self.scrollView.zk_insetTop + self.scrollView.zk_contentHeight <= self.scrollView.zk_height) {
            // Don't trigger this footer refresh while zk_header is refreshing already
            beginRefreshing = ! self.scrollView.zk_header.isRefreshing;
        } else {
            CGFloat actualContentHeight = self.scrollView.zk_contentHeight + self.scrollView.zk_insetBottom - self.zk_height;
            CGFloat triggerOffsetY = self.scrollView.zk_offsetY + self.scrollView.zk_height;
            CGFloat triggerDistanceToContentBottom = self.triggerAutomaticallyRefreshPercent * self.scrollView.zk_contentHeight;
            if (actualContentHeight - triggerDistanceToContentBottom <= triggerOffsetY) {
                beginRefreshing = YES;
            }
        }
        if (beginRefreshing) {
            // Just a performance improvement
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            
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
        
        // Hide footer: Shrink contentInsetBottom
        self.scrollView.zk_insetBottom -= self.zk_height;
    } else {
        // Show footer: Extend contentInsetBottom
        self.scrollView.zk_insetBottom += self.zk_height;
        
        // Put itself to the bottom of contentView
        self.zk_y = self.scrollView.zk_contentHeight;
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

@end
