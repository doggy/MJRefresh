//
//  ZKRefreshBase_private.h
//  ZKRefresh
//
//  Created by doug on 3/20/17.
//  Copyright © 2017 doug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKRefreshBase.h"

// Private property inherit from super class
@interface ZKRefreshBase ()
@property (nonatomic, weak) __kindof UIScrollView *scrollView;

// refreshing callback
@property (nonatomic, strong) ZKRefreshBaseRefreshingBlock refreshingBlock;

@end
