//
//  ZKRefreshBaseHeader.h
//  ZKRefresh
//
//  Created by doug on 11/13/16.
//  Copyright © 2016 doug. All rights reserved.
//

#import "ZKRefreshBase.h"

@interface ZKRefreshBaseHeader : ZKRefreshBase

// NS_DESIGNATED_INITIALIZER
+ (instancetype)headerWithRefreshingBlock:(ZKRefreshBaseRefreshingBlock)refreshingBlock;

// A gap value between zk_header and scrollView's content. Default is 0
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;

// Pulling distance to refreshing. Be updated on dragging
// Idle: 0% ~ 99%
// Refresh: >= 100%
@property (assign, nonatomic) CGFloat pullingPercent;

// KVO `contentOffset` handler
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;

@end
