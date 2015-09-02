//
//  TopView.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "TopView.h"


@implementation TopView
- (instancetype)initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)addUIWithFrame:(CGRect)frame{
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.frame = CGRectMake( 100, 440, 120, 20);
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    pageControl.tag = 100;
    [self addSubview:pageControl];
    
}

@end
