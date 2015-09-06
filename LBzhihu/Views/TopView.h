//
//  TopView.h
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAndTitleView.h"
#import "StoriesItm.h"
#import "NetworkTool.h"

@protocol TapImageViewDelegate <NSObject>

- (void)tapImageView:(UIImageView *)imageView;

@end

@interface TopView : UIScrollView<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)  UIPageControl *pageControl;
@property  id <TapImageViewDelegate> tapDelegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setStories:(NSArray *)stories;

@end
