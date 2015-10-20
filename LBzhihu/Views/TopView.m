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
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)nextImage{
    page = (page == imgCount - 1) ? 0 : ++page;
    CGFloat x = page * self.frame.size.width;
    self.contentOffset = CGPointMake(x, 0);
    pageControl.currentPage = page;
}

- (void)tapImageView:(UITapGestureRecognizer *)tap{
    __weak typeof(self) weakSelf = self;
    [weakSelf.tapDelegate tapImageView:(UIImageView *)tap.view];
}

#pragma mark UIScrollViewDelegate

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    CGFloat pageWidth = scrollView.frame.size.width;
//    int p = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    page = p;
//    pageControl.currentPage = p;
//}


//实现滚动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //内容偏移x + 一半的scroll的宽
    int offsetX = self.contentOffset.x +(self.frame.size.width *0.5);
    //计算滚动的当前页:偏移x除以scroll的宽
    pageControl.currentPage = offsetX / self.frame.size.width;
    
}

//实现开始拖拽的方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止计时器
    [timer invalidate];
    timer = nil;
}

//实现拖拽结束的方法
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //重新创建一个计时器
    timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    //再次修改新创建计时器的优先级
    //1.获取当前的消息循环对象
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    //2.改变timer对象为控件的优先级
    [runLoop addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)scrollImage
{
    //滚动一次图片
    //1.判断页码是否到了最后一页，如果到了最后一页，就滚到第一页
    if(pageControl.currentPage == (pageControl.numberOfPages-1))
    {
        pageControl.currentPage = 0;
    }
    else
    {
        pageControl.currentPage++;
    }
    //2.用页码的宽度*(页码 ＋1) == 计算除了下一页的contentOffset.x
    CGFloat offsetX = pageControl.currentPage * self.frame.size.width;
    //3.设置srcoll的contentOffset
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}
@end
