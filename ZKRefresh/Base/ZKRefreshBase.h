//
//  ZKRefreshBase.h
//  ZKRefresh
//
//  Created by doggy on 11/13/16.
//  Copyright © 2016 doggy. All rights reserved.
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

@interface ZKRefreshBase : UIView
{
    // initial inset of scrollView
    UIEdgeInsets _scrollViewOriginalInset;
    
    // parent view
    __weak UIScrollView *_scrollView;
}
@property (assign, nonatomic, readonly) UIEdgeInsets scrollViewOriginalInset;
@property (weak, nonatomic, readonly) __kindof UIScrollView *scrollView;

// main status
@property (assign, nonatomic) ZKRefreshState state;

// refreshing callback
typedef void (^ZKRefreshBaseRefreshingBlock)();
@property (strong, nonatomic) ZKRefreshBaseRefreshingBlock refreshingBlock;

#pragma mark Public method
- (void)beginRefreshing;
- (void)endRefreshing;
- (BOOL)isRefreshing;

#pragma mark - overridable
- (void)prepare NS_REQUIRES_SUPER;

@end
