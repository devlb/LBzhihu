//
//  LeftView.h
//  LBzhihu
//
//  Created by lb on 15/9/3.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PubilcMember.m"
#import "NetworkTool.h"

@interface LeftView : UIView

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *headImgView;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UIButton *favoriteBtn;
@property (nonatomic,strong) UIButton *downBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *homeView;
@property (nonatomic,strong) UIButton *homeBtn;

- (instancetype)initWithFrame:(CGRect)frame;

@end
