//
//  ImageAndTitleView.h
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAndTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;

@end
