//
//  CommentsCell.h
//  LBzhihu
//
//  Created by lb on 15/10/18.
//  Copyright © 2015年 李波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkTool.h"

@interface CommentsCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *userLbael;
@property (nonatomic,strong) UIButton *likeBtn;
@property (nonatomic,strong) UILabel *likeNumberLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *timeLabel;

-(void)setTextLabelText:(NSString*)text;

@end
