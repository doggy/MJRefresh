//
//  UIScrollView+ZKRefresh.h
//  ZKRefresh
//
//  Created by doggy on 11/13/16.
//  Copyright © 2016 doggy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKRefreshBaseHeader, ZKRefreshBaseFooter;

@interface UIScrollView (ZKRefresh)

@property (strong, nonatomic) __kindof ZKRefreshBaseHeader *zk_header;
@property (strong, nonatomic) __kindof ZKRefreshBaseFooter *zk_footer;
@end
