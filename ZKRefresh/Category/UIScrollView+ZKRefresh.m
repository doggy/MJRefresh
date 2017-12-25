//
//  UIScrollView+ZKRefresh.m
//  ZKRefresh
//
//  Created by doug on 11/13/16.
//  Copyright © 2016 doug. All rights reserved.
//

#import <objc/runtime.h>
#import "ZKRefreshBaseHeader.h"
#import "ZKRefreshBaseFooter.h"
#import "UIScrollView+ZKRefresh.h"

@implementation UIScrollView (ZKRefresh)

#pragma mark - header
static const char ZKRefreshBaseHeaderKey = '\0';
- (void)setZk_header:(__kindof ZKRefreshBaseHeader *)header
{
    if (header != self.zk_header) {
        // Old header removed
        [self.zk_header removeFromSuperview];
        
        // New one inserted
        [self insertSubview:header atIndex:0];
        
        // Hold it with AssociatedObject
        [self willChangeValueForKey:@"zk_header"]; // KVO
        objc_setAssociatedObject(self, &ZKRefreshBaseHeaderKey,
                                 header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"zk_header"]; // KVO
    }
}

- (__kindof ZKRefreshBaseHeader *)zk_header
{
    return objc_getAssociatedObject(self, &ZKRefreshBaseHeaderKey);
}

#pragma mark - footer
static const char ZKRefreshBaseFooterKey = '\0';
- (void)setZk_footer:(__kindof ZKRefreshBaseFooter *)footer
{
    if (footer != self.zk_footer) {
        // Old header removed
        [self.zk_footer removeFromSuperview];
        
        // New one inserted
        [self insertSubview:footer atIndex:0];
        
        // Hold it with AssociatedObject
        [self willChangeValueForKey:@"zk_footer"]; // KVO
        objc_setAssociatedObject(self, &ZKRefreshBaseFooterKey,
                                 footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"zk_footer"]; // KVO
    }
}

- (__kindof ZKRefreshBaseFooter *)zk_footer
{
    return objc_getAssociatedObject(self, &ZKRefreshBaseFooterKey);
}

@end
