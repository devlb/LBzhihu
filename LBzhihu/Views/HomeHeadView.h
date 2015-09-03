//
//  HomeHeadView.h
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkTool.h"

@interface HomeHeadView : UIView

@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UIButton *rightBtn;

- (instancetype)initWithFrame:(CGRect)frame;

@end
