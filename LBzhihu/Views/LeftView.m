//
//  LeftView.m
//  LBzhihu
//
//  Created by lb on 15/9/3.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "LeftView.h"

@implementation LeftView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addViewWithFrame:frame];
    }
    return self;
}

- (void)addViewWithFrame:(CGRect)frame{
    CGFloat edge = 8;
    CGFloat btnW = 130;
    
    self.homeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), LEFTHOMEVIEWH)];
    self.homeView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    self.homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(edge, 0, btnW, LEFTHOMEVIEWH)];
    self.homeBtn.backgroundColor = [UIColor clearColor];
    [self.homeBtn setTitle:@"首页" forState:(UIControlStateNormal)];
    [self.homeBtn setImage:[UIImage imageNamed:@"icon.bundle/Menu_Icon_Home@2x.png"] forState:(UIControlStateNormal)];
    [self.homeBtn setTitleColor:HOMEHEADBACKGROUNDCOLOR forState:(UIControlStateNormal)];

    [self.homeView addSubview:self.homeBtn];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) style:(UITableViewStylePlain - CGRectGetHeight(self.homeView.frame))];
    self.tableView.accessibilityNavigationStyle = UITableViewCellAccessoryDisclosureIndicator;
    self.tableView.tableHeaderView = self.homeView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = LEFTVIEWBACKGROUNDCOLOR;
    
    [self addSubview:self.tableView];
}

@end
