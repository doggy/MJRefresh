//
//  UIScrollView+ZKRefreshPrivate.h
//  ZKRefresh
//
//  Created by doggy on 11/13/16.
//  Copyright © 2016 doggy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ZKRefreshPrivate)
@property (assign, nonatomic) CGFloat zk_insetTop;
@property (assign, nonatomic) CGFloat zk_insetBottom;

@property (assign, nonatomic) CGFloat zk_offsetY;

@property (assign, nonatomic) CGFloat zk_contentHeight;

@end

#define dispatch_main_async_safe(block)\
    if (NSThread.isMainThread) { \
        block(); \
    } else { \
        dispatch_async(dispatch_get_main_queue(), block); \
    }
