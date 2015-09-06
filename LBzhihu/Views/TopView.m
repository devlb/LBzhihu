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
    int imgCount;
    int page;
}

@synthesize pageControl;

- (instancetype)initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame]) {
        self.pagingEnabled = YES;
        self.delegate = self;
        page = 0;
       // [self addUIWithFrame:frame];
    }
    return self;
}

- (void)setStories:(NSArray *)stories{
    imgCount = stories.count;
    pageControl.numberOfPages = imgCount;
   
    CGFloat edge = 8;
    CGFloat imgW =  CGRectGetWidth(self.frame);
    self.contentSize = CGSizeMake(imgCount * imgW, CGRectGetHeight(self.frame));

    for (int i = 0;i < stories.count;i++) {
        StoriesItm *itm = stories[i];
        NSString *imgUrlString = itm.image;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * imgW, 0, imgW, CGRectGetHeight(self.frame))];
        [imageView  sd_setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"Image_Preview@2x.png"]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = TOPVIEWIMGTAG + i;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(edge,TOPVIEWH - 2 * edge - 60, imgW - 2 * edge, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = itm.title;
        titleLabel.font = [UIFont fontWithName:titleLabel.font.fontName size:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        [titleLabel sizeToFit];
        [imageView addSubview:titleLabel];
        [self addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        tap.delegate = self;
        [imageView addGestureRecognizer:tap];
    }
    
    pageControl.currentPage = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

- (void)nextImage{
    page = (page == imgCount - 1) ? 0 : ++page;
    CGFloat x = page * self.frame.size.width;
    self.contentOffset = CGPointMake(x, 0);
    pageControl.currentPage = page;
}

- (void)tapImageView:(UITapGestureRecognizer *)tap{
    [self.tapDelegate tapImageView:(UIImageView *)tap.view];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int p = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    page = p;
    pageControl.currentPage = p;
}

@end
