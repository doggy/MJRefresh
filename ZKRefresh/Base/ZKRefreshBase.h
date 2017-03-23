//
//  ZKRefreshBase.h
//  ZKRefresh
//
//  Created by doug on 11/13/16.
//  Copyright © 2016 doug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+ZKRefresh.h"

UIKIT_EXTERN NSString *const ZKRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const ZKRefreshKeyPathContentSize;

typedef NS_ENUM(NSInteger, ZKRefreshState) {
    ZKRefreshStateIdle = 1,     // Nothing happen
    ZKRefreshStatePulling,      // Refreshing after hands release
    ZKRefreshStateRefreshing,   // Refreshing
    ZKRefreshStateWillIdle,
    ZKRefreshStateWillRefresh,  // `beginRefreshing` called but view isn't displaying (internal status)
    ZKRefreshStateNoMoreData,   // Only used in footer
};

typedef void (^ZKRefreshBaseRefreshingBlock)();

@protocol ZKRefreshProtocol <NSObject>

// Footer/Header:
// main status
@property (nonatomic, assign) ZKRefreshState state;
- (void)beginRefreshing;
- (void)endRefreshing;
- (BOOL)isRefreshing;

@optional
// Footer Only:

// State: Idle
- (void)resetNoMoreData;
- (void)endRefreshingWithHeightIncrease:(CGFloat)heightIncrease;
// State: NoMoreData
- (void)endRefreshingWithNoMoreData;
@end

@interface ZKRefreshBase : UIView <ZKRefreshProtocol>

@property (nonatomic, assign) ZKRefreshState state;

@property (assign, nonatomic) BOOL ignoreRefresh;

#pragma mark Public method
- (void)beginRefreshing;
- (void)endRefreshing;
- (BOOL)isRefreshing;

#pragma mark - overridable
- (void)prepare NS_REQUIRES_SUPER;

@end
