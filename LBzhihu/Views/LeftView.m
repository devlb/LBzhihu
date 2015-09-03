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
    CGFloat imgW = 30;
    CGFloat labelW = 90;

    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), LEFTHEADVIEWH)];
    self.headView.backgroundColor = HOMEHEADBACKGROUNDCOLOR;
    
    self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(edge, edge, imgW, imgW)];
    self.headImgView.layer.masksToBounds =YES;
    self.headImgView.layer.cornerRadius =imgW / 2.0;
    
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 *edge + CGRectGetWidth(self.headImgView.frame), edge, labelW, imgW)];
    self.userNameLabel.adjustsFontSizeToFitWidth = YES;
    [self.userNameLabel setTextColor:[UIColor whiteColor]];
    
    self.favoriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(edge , edge + CGRectGetMaxY(self.headImgView.frame), labelW, imgW)];
    [self.favoriteBtn setTitle:@"我的收藏" forState:(UIControlStateNormal)];
    [self.favoriteBtn setTintColor:[UIColor whiteColor]];
    
    self.downBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - edge - labelW, edge + CGRectGetMaxY(self.headImgView.frame), labelW, imgW)];
    [self.downBtn setTitle:@"离线下载" forState:(UIControlStateNormal)];
    [self.downBtn setTintColor:[UIColor whiteColor]];

    [self.headView addSubview:self.headImgView];
    [self.headView addSubview:self.favoriteBtn];
    [self.headView addSubview:self.userNameLabel];
    [self.headView addSubview:self.favoriteBtn];
    [self.headView addSubview:self.downBtn];
 
    self.homeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), LEFTHOMEVIEWH)];
    self.homeView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    self.homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(edge, 0, labelW, LEFTHOMEVIEWH)];
    self.homeBtn.backgroundColor = [UIColor clearColor];
    [self.homeBtn setTitle:@"首页" forState:(UIControlStateNormal)];
    [self.homeBtn setTitleColor:HOMEHEADBACKGROUNDCOLOR forState:(UIControlStateNormal)];
    [self.homeView addSubview:self.homeBtn];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - CGRectGetMaxY(self.headView.frame)) style:(UITableViewStylePlain - CGRectGetHeight(self.homeView.frame))];
    self.tableView.accessibilityNavigationStyle = UITableViewCellAccessoryDisclosureIndicator;
    self.tableView.tableHeaderView = self.homeView;
    self.tableView.tableFooterView = [UIView new];
    
    [self addSubview:self.headView];
    [self addSubview:self.tableView];
}

@end
