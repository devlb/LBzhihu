//
//  CommentsCell.m
//  LBzhihu
//
//  Created by lb on 15/10/18.
//  Copyright © 2015年 李波. All rights reserved.
//

#import "CommentsCell.h"


@implementation CommentsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addUI];
    }
    return self;
}



- (void)addUI{
    CGFloat edge = 8;
    CGFloat userLabelW = 120;
    CGFloat userLabelH = 30;
    CGFloat likeBtnW = 70;
    CGFloat likeBtnH = 40;

    self.imgView =  [[UIImageView alloc] initWithFrame:CGRectMake(edge, edge, COMMENTSCELLIMGW, COMMENTSCELLIMGW)];
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = COMMENTSCELLIMGW / 2.0;
    
    self.userLbael = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame) + edge, edge, userLabelW, userLabelH)];
    self.userLbael.adjustsFontSizeToFitWidth = YES;
    self.userLbael.backgroundColor = [UIColor clearColor];
    [self.userLbael setTextColor:[UIColor blackColor]];
    
    self.likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(MAINSIZE.width - likeBtnW, edge, likeBtnW, likeBtnH)];
    self.likeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    
    self.timeLabel = [[UILabel alloc] init];
    [self.timeLabel setTextColor:[UIColor grayColor]];
    
    [self addSubview:self.imgView];
    [self addSubview:self.userLbael];
    [self addSubview:self.likeBtn];
    [self addSubview:self.contentLabel];
    [self addSubview:self.timeLabel];
}


//赋值 and 自动换行,计算出cell的高度
-(void)setTextLabelText:(NSString*)text{
    CGFloat timeLabelW = 130;
    CGFloat timeLabelH = 20;
    CGFloat edge = 8;
    
    //获得当前cell高度
    CGRect frame = [self frame];
    CGFloat labelX = CGRectGetMaxX(self.imgView.frame) + edge;//contentLabel和timelabel的原点X
    
    //文本赋值
    self.contentLabel.text = text;
    //设置label的最大行数
    self.contentLabel.numberOfLines = 50;
    CGSize size = CGSizeMake(MAINSIZE.width - labelX, MAXFLOAT);
  
    CGFloat labelHeight = [self HeightStr:text font:self.contentLabel.font scopeWidth:size.width scopeHeight:size.height];

    
    self.contentLabel.frame = CGRectMake(labelX , CGRectGetMaxY(self.userLbael.frame) + edge, size.width, labelHeight);
    
    self.timeLabel.frame = CGRectMake(labelX, CGRectGetMaxY(self.contentLabel.frame), timeLabelW, timeLabelH);
    
    //计算出自适应的高度
    frame.size.height = labelHeight + COMMENTSCELLIMGW + 4 * edge + CGRectGetHeight(self.timeLabel.frame);
    
    self.frame = frame;
    
}

#pragma mark - 计算cell高度  str 字符串长度 scopeWidth显示范围的宽  scopeHeight显示范围的高
- (CGFloat )HeightStr:(NSString *)str font:(UIFont *)font scopeWidth:(NSInteger)scopeWidth scopeHeight:(NSInteger)scopeHeight{        NSDictionary * dic = [NSDictionary dictionary];

    dic = @{NSFontAttributeName:font};
    //字符串的显示范围
    CGSize scope = CGSizeMake(scopeWidth, scopeHeight);
    CGRect rect = [str boundingRectWithSize:scope options:
                   NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    CGFloat cellH = ceil(rect.size.height + 20);
    return cellH;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
