//
//  ZKRefreshBaseEarlierLoader.h
//  ZKRefresh
//
//  Created by doug on 3/20/17.
//  Copyright © 2017 doug. All rights reserved.
//

#import "ZKRefreshBase.h"

@interface ZKRefreshBaseEarlierLoader : ZKRefreshBase

// NS_DESIGNATED_INITIALIZER
+ (instancetype)headerWithRefreshingBlock:(ZKRefreshBaseRefreshingBlock)refreshingBlock;

// State: NoMoreData
- (void)endRefreshingWithNoMoreData;
// State: Idle
- (void)resetNoMoreData;

@property (assign, nonatomic) BOOL ignoreRefresh;
- (void)endRefreshingWithHeightIncrease:(CGFloat)heightIncrease;

// A gap value between zk_header and scrollView's content. Default is 0
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;

// Show or hide footer view based on current tableView/collectionView's dataCount. Default is NO
@property (assign, nonatomic, getter=isAutomaticallyHidden) BOOL automaticallyHidden;

// Trigger refreshing before you scrolling to the last item on page.
// Set a percent float value of scrollView's frameHeight.
// Default is Zero which means the refreshing only occur at scrollView's bottom
@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;

// KVO `contentOffset` handler
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
// KVO `contentSize` handler
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
@end
