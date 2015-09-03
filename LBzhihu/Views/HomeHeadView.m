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
    CGFloat titleLabelW = 120;
    CGFloat rightBtnW = 60;
    
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(edge, edge, imageW, imageW)];
    self.leftImageView.image = [UIImage imageNamed:@"更多.png"];
    
    self.titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImageView.frame) + edge, edge, titleLabelW, imageW)];
    self.titleBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.titleBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
       [self.titleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    self.titleBtn.contentEdgeInsets = UIEdgeInsetsZero;
    
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - edge - rightBtnW , edge, rightBtnW, imageW)];
    self.rightBtn.backgroundColor = [UIColor clearColor];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    [self addSubview:self.leftImageView];
    [self addSubview:self.titleBtn];
    [self addSubview:self.rightBtn];
}

@end
