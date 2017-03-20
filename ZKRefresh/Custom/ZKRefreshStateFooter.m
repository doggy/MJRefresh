//
//  ZKRefreshStateFooter.m
//  ZKRefresh
//
//  Created by doggy on 11/13/16.
//  Copyright © 2016 doggy. All rights reserved.
//

#import "ZKRefreshBase_private.h"
#import "ZKRefreshStateFooter.h"

@interface ZKRefreshStateFooter()

@property (weak, nonatomic, readwrite) UILabel *stateLabel;

@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation ZKRefreshStateFooter

#pragma mark - Properties Lazy-loading
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        UILabel *label = UILabel.new;
        label.font = [UIFont boldSystemFontOfSize:14];
#define TextColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
        label.textColor = TextColor(90, 90, 90);
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_stateLabel = label];
    }
    return _stateLabel;
}

#pragma mark - Override
- (void)prepare
{
    [super prepare];
    
    // Title Label alignment
    self.labelLeftInset = 25;
    
    // Default title strings
#define kFooterIdleText @"点击或上拉加载更多"
#define kFooterRefreshingText @"正在加载更多的数据..."
#define kFooterNoMoreDataText @"已经全部加载完毕"
    [self setTitle:kFooterIdleText          forState:ZKRefreshStateIdle];
    [self setTitle:kFooterRefreshingText    forState:ZKRefreshStateRefreshing];
    [self setTitle:kFooterNoMoreDataText    forState:ZKRefreshStateNoMoreData];
    
    // 监听label
    self.stateLabel.userInteractionEnabled = YES;
    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Autolayout detector
    if (self.stateLabel.constraints.count) return;
    
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(ZKRefreshState)state
{
    if (state == self.state) return;
    [super setState:state];
    
    NSString* stateString = self.stateTitles[@(state)];
    if (! stateString) {
        // Keep current displaying title on screen
        stateString = self.stateLabel.text;
    }
    
    if (self.isRefreshingTitleHidden) {
        if (   ZKRefreshStateRefreshing == state
            && ZKRefreshStateWillIdle == state ) {
            stateString = nil;
        }
    }
    
    self.stateLabel.text = stateString;
}

#pragma mark - Private
- (void)stateLabelClick
{
    if (self.state == ZKRefreshStateIdle) {
        [self beginRefreshing];
    }
}

#pragma mark - Public
- (void)setTitle:(NSString *)title forState:(ZKRefreshState)state
{
    if (title) {
        self.stateTitles[@(state)] = title;
    } else {
        [self.stateTitles removeObjectForKey:@(state)];
    }
}

@end
