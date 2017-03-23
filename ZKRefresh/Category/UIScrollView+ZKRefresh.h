//
//  UIScrollView+ZKRefresh.h
//  ZKRefresh
//
//  Created by doug on 11/13/16.
//  Copyright © 2016 doug. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZKRefreshProtocol;

@interface UIScrollView (ZKRefresh)

@property (strong, nonatomic) __kindof UIView<ZKRefreshProtocol>* zk_header;
@property (strong, nonatomic) __kindof UIView<ZKRefreshProtocol>* zk_footer;
@end
