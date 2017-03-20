//
//  UIView+ZKRefreshPrivate.m
//  ZKRefresh
//
//  Created by doggy on 11/13/16.
//  Copyright © 2016 doggy. All rights reserved.
//

#import "UIView+ZKRefreshPrivate.h"

@implementation UIView (ZKRefreshPrivate)
- (void)setZk_x:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)zk_x
{
    return self.frame.origin.x;
}

- (void)setZk_y:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)zk_y
{
    return self.frame.origin.y;
}

- (void)setZk_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)zk_width
{
    return self.frame.size.width;
}

- (void)setZk_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)zk_height
{
    return self.frame.size.height;
}

@end
