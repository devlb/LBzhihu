//
//  TopView.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "TopView.h"
#import "UIImageView+WebCache.h"

@implementation TopView
{
    NSTimer *timer;
    UIPageControl *pageControl;
    int imgCount;
    int page;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame]) {
        self.pagingEnabled = YES;
        page = 0;
        pageControl = self.pageControl;
       // [self addUIWithFrame:frame];
    }
    return self;
}

- (void)setImgs:(NSArray *)imgs{
    imgCount = imgs.count;
    pageControl.numberOfPages = imgCount;
    
    CGFloat imgW =  CGRectGetWidth(self.frame);
    self.contentSize = CGSizeMake(imgCount * imgW, CGRectGetHeight(self.frame));
    int i = 0;
    for (NSString *imgUrlString in imgs) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * imgW, 0, imgW, CGRectGetHeight(self.frame))];
        [imageView  sd_setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"知乎.png"]];
        [self addSubview:imageView];
        i++;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

- (void)nextImage{
    page = (page == imgCount - 1) ? 0 : ++page;
    CGFloat x = page * self.frame.size.width;
    self.contentOffset = CGPointMake(x, 0);
}

@end
