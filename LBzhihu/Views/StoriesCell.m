//
//  StoriesCell.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "StoriesCell.h"
//#import "PubilcMember.m"
#import "NetworkTool.h"

@implementation StoriesCell

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat edge = 8;
    CGFloat imgW = STORIESCELLH - edge * 2;
    CGFloat imgH = imgW;
    if (self.imageView.image == nil) {
        imgW = 0;
    }
    
    self.textLabel.frame = CGRectMake(edge, edge, MAINSIZE.width - 3 * edge - imgW, imgH);
    [self.textLabel setNumberOfLines:0];
    
    self.imageView.frame = CGRectMake(MAINSIZE.width - edge - imgW, edge, imgW, imgH);
    
    [self setSeparatorInset:UIEdgeInsetsZero];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
