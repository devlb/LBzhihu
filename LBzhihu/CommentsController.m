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
#import "UIView+frame.h"
#import "EditCommentsController.h"

@interface CommentsController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSMutableArray *data;
    NSMutableArray *heightArr;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *toolView;

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
    CGFloat toolH = 40;
    CGFloat backBtnW = 40;
    CGFloat editBtnW = 70;
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MAINSIZE.width, 20)];
    statusView.backgroundColor = HOMEHEADBACKGROUNDCOLOR;

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSIZE.width, MAINSIZE.height - toolH) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
   
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINSIZE.height - toolH, MAINSIZE.width, toolH)];
    self.toolView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backBtnW, self.toolView.height)];
    [backBtn setImage:[UIImage imageNamed:@"icon.bundle/Comment_Icon_Back@2x.png"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake((MAINSIZE.width - editBtnW) / 2, 0, editBtnW, self.toolView.height)];
  
    [editBtn setTitle:@"写评论" forState:(UIControlStateNormal)];
    [editBtn setImage:[UIImage imageNamed:@"icon.bundle/Comment_Icon_Compose_Highlight@2x.png"] forState:(UIControlStateNormal)];
    [editBtn addTarget:self action:@selector(editComments:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.toolView addSubview:backBtn];
    [self.toolView addSubview:editBtn];
    
    [self.view addSubview:statusView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolView];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipe.delegate = self;
    [self.view addGestureRecognizer:swipe];

    
}

- (void)loadData{
    data = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],nil];
    
    __weak typeof(self) weakSelf = self;
    
    [[NetworkTool sharedNetworkTool] getLongComments:self.storiesId success:^(CommentsModel *commentsModel) {
        [data replaceObjectAtIndex:0 withObject:commentsModel.comments];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        
    } failure:^{
        [[[UIAlertView alloc] initWithTitle:@"获取评论失败" message:@"请稍后再试" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] show];
    }];
    
    [[NetworkTool sharedNetworkTool] getShortComments:self.storiesId success:^(CommentsModel *commentsModel) {
        [data replaceObjectAtIndex:1 withObject:commentsModel.comments];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        
    } failure:^{
        [[[UIAlertView alloc] initWithTitle:@"获取评论失败" message:@"请稍后再试" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] show];
    }];

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

    [cell.likeBtn setTitle:[NSString stringWithFormat:@"%@",itm.likes] forState:(UIControlStateNormal)];
    [cell.likeBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    
    [cell.likeBtn setImage:[UIImage imageNamed:@"icon.bundle/Comment_Vote@2x.png"] forState:(UIControlStateNormal)];
    
    [cell.likeBtn addTarget:self action:@selector(like:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:itm.avatar] placeholderImage:[UIImage imageNamed:@"icon.bundle/Account_Avatar@2x.png"]];
    
    [cell setTextLabelText:itm.content];
    
    cell.timeLabel.text = [self sectionStrByCreateTime:[itm.time floatValue]];
    
    [heightArr[indexPath.section] addObject:@(cell.frame.size.height)];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSIZE.width, 44)];
    label.backgroundColor = HOMEHEADBACKGROUNDCOLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:label.font.fontName size:20];
    label.text = (section == 0) ? @"长评论" : @"短评论";
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSMutableArray *arr = heightArr[indexPath.section];
    if ([arr count] > 0) {
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

- (void)like:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSArray *imgs = @[
                      [UIImage imageNamed:@"icon.bundle/Comment_Vote@2x.png"],
                      [UIImage imageNamed:@"icon.bundle/Comment_Voted@2x.png"]
                      ];
    NSArray *titles = @[
                        [NSString stringWithFormat:@"%d",[sender.titleLabel.text intValue] - 1],
                        [NSString stringWithFormat:@"%d",[sender.titleLabel.text intValue] + 1]
                        ];
    
   if(!sender.selected) {
        [sender setImage:imgs[0] forState:(UIControlStateNormal)];
        [sender setTitle:titles[0] forState:(UIControlStateNormal)];
    }else{
        [sender setImage:imgs[1] forState:(UIControlStateNormal)];
         [sender setTitle:titles[1] forState:(UIControlStateNormal)];
    }
    
}

- (void)swipe:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self back];
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editComments:(UIButton *)sender{
    EditCommentsController *editCommentVC = [[EditCommentsController alloc] init];
    [self.navigationController pushViewController:editCommentVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
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
