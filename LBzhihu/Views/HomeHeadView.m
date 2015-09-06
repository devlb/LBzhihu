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
    CGFloat titleLabelW = 80;
    
    self.leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(edge, edge, imageW, imageW)];
    [self.leftBtn setImage:[UIImage imageNamed:@"icon.bundle/Home_Icon.png"] forState:(UIControlStateNormal)];

    self.titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.center.x - titleLabelW / 2, edge, titleLabelW, imageW)];
    self.titleBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.titleBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
       [self.titleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    self.titleBtn.contentEdgeInsets = UIEdgeInsetsZero;
    
    [self addSubview:self.leftBtn];
    [self addSubview:self.titleBtn];
}

@end
