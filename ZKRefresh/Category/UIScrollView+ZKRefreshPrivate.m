//
//  UIScrollView+ZKRefreshPrivate.m
//  ZKRefresh
//
//  Created by doug on 11/13/16.
//  Copyright © 2016 doug. All rights reserved.
//

#import <objc/runtime.h>
#import "UIScrollView+ZKRefreshPrivate.h"

@implementation UIScrollView (ZKRefreshPrivate)

- (void)setZk_insetTop:(CGFloat)insetTop
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = insetTop;
    self.contentInset = inset;
}

- (CGFloat)zk_insetTop
{
    return self.contentInset.top;
}

- (void)setZk_insetBottom:(CGFloat)insetBottom
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = insetBottom;
    self.contentInset = inset;
}

- (CGFloat)zk_insetBottom
{
    return self.contentInset.bottom;
}

- (void)setZk_offsetY:(CGFloat)offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = offsetY;
    self.contentOffset = offset;
}

- (CGFloat)zk_offsetY
{
    return self.contentOffset.y;
}

- (void)setZk_contentHeight:(CGFloat)contentHeight
{
    CGSize size = self.contentSize;
    size.height = contentHeight;
    self.contentSize = size;
}

- (CGFloat)zk_contentHeight
{
    return self.contentSize.height;
}

@end
