//
//  CommentsController.m
//  LBzhihu
//
//  Created by lb on 15/10/18.
//  Copyright © 2015年 李波. All rights reserved.
//

#import "CommentsController.h"
#import "NetworkTool.h"
#import "UIImageView+WebCache.h"
#import "CommentsCell.h"

@interface CommentsController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSMutableArray *data;
    NSMutableArray *heightArr;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation CommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
     data = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],nil];
    heightArr = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],nil];
    
    [self addSubView];
    [self loadData];
}

- (void)addSubView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    [self.view addSubview:self.tableView];

    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipe.delegate = self;
    [self.view addGestureRecognizer:swipe];
}

- (void)loadData{
    data = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],nil];
    
    [[NetworkTool sharedNetworkTool] getLongComments:self.storiesId success:^(CommentsModel *commentsModel) {
        [data replaceObjectAtIndex:0 withObject:commentsModel.comments];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^{
        [[[UIAlertView alloc] initWithTitle:@"获取评论失败" message:@"请稍后再试" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] show];
    }];
    
//    [[NetworkTool sharedNetworkTool] getShortComments:self.storiesId success:^(CommentsModel *commentsModel) {
//        [data replaceObjectAtIndex:1 withObject:commentsModel.comments];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//        
//    } failure:^{
//        [[[UIAlertView alloc] initWithTitle:@"获取评论失败" message:@"请稍后再试" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] show];
//    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsItm *itm = data[indexPath.section][indexPath.row];
    
    CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[CommentsCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
    }
    cell.userLbael.text = itm.author;
    cell.likeNumberLabel.text = [NSString stringWithFormat:@"%@",itm.likes];
    [cell.likeBtn setImage:[UIImage imageNamed:@"icon.bundle/Comment_Vote.png"] forState:(UIControlStateNormal)];
    [cell.likeBtn addTarget:self action:@selector(like:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:itm.avatar] placeholderImage:[UIImage imageNamed:@"icon.bundle/Account_Avatar@2x.png"]];
    [cell setTextLabelText:itm.content];
    cell.timeLabel.text = [self sectionStrByCreateTime:[itm.time floatValue]];
    
    [heightArr[indexPath.section] addObject:@(cell.frame.size.height)];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([heightArr[0] count] > 0 || [heightArr[1] count] > 0) {
        NSMutableArray *arr = heightArr[indexPath.section];
        NSNumber *num = arr[indexPath.row];
        return [num floatValue];
    
    }
    return 0.0;
}

//时间戳转为字符串
- (NSString *)sectionStrByCreateTime:(NSTimeInterval)interval{
    static NSDateFormatter *formatter = nil;
    if (nil == formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM-dd HH:mm";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:date];
}

- (void)like:(UIButton *)btn{
    NSArray *imgs = @[[UIImage imageNamed:@"icon.bundle/Comment_Vote.png"],[UIImage imageNamed:@"icon.bundle/Comment_Voted@2x.png"]];
    UIImage *image = [btn.imageView.image isEqual:imgs[0]] ? imgs[1] : imgs[0];
    [btn setImage:image forState:(UIControlStateNormal)];
}

- (void)swipe:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
