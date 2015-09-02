//
//  ImageAndTitleView.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "ImageAndTitleView.h"

@implementation ImageAndTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame]) {
        [self addUIWithFrame:frame];
    }
    return self;
}

- (void)addUIWithFrame:(CGRect)frame{
    
    CGFloat edge = 8;
    CGFloat LabelHigh = 60;
    
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(edge, CGRectGetHeight(frame) - edge - LabelHigh, CGRectGetWidth(frame) - 2 * edge, LabelHigh)];
    self.titleLabel.textColor = [UIColor whiteColor];
    
    [self.imageView addSubview:self.titleLabel];
    [self addSubview:self.imageView];
    
}

@end
