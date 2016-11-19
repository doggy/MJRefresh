//
//  ZKRefreshStateFooter.h
//  ZKRefresh
//
//  Created by doggy on 11/13/16.
//  Copyright © 2016 doggy. All rights reserved.
//

#import "ZKRefreshBaseFooter.h"

@interface ZKRefreshStateFooter : ZKRefreshBaseFooter

// Title Label
@property (weak, nonatomic, readonly) UILabel *stateLabel;
// Title Label alignment
@property (assign, nonatomic) CGFloat labelLeftInset;

// Stated title string
- (void)setTitle:(NSString *)title forState:(ZKRefreshState)state;

// Hide titleLabel when refreshing
@property (assign, nonatomic, getter=isRefreshingTitleHidden) BOOL refreshingTitleHidden;
@end
