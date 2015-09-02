//
//  HomeHeadView.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "HomeHeadView.h"

@implementation HomeHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame]) {
        [self addUIWithFrame:frame];
    }
    return self;
}

- (void)addUIWithFrame:(CGRect)frame{
    self.backgroundColor = HOMEHEADBACKGROUNDCOLOR;
    
    CGFloat edge = 8;
    CGFloat imageW = CGRectGetHeight(frame) - 2 * edge;
    CGFloat titleLabelW = 100;
    CGFloat rightBtnW = 60;
    
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(edge, edge, imageW, imageW)];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.leftImageView.frame) + edge, edge, titleLabelW, imageW)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - edge - rightBtnW , edge, rightBtnW, imageW)];
    self.rightBtn.backgroundColor = [UIColor clearColor];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    [self addSubview:self.leftImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightBtn];
}

@end
