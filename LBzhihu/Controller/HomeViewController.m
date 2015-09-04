//
//  HomeViewController.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHeadView.h"
#import "NetworkTool.h"
#import "StoriesCell.h"
#import "TopView.h"
#import "DetailsController.h"
#import "LeftView.h"
#import "UIImageView+WebCache.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *storieArr;
    NSMutableArray *themeArr;
    NSMutableArray *homeDataArr;
    UITapGestureRecognizer *tapHome;
    UIView *containerView;//用来作为TopView和pageControl的共同父View
}

@property (nonatomic,strong) UIView *mainView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) TopView *topView;
@property (nonatomic,strong) HomeHeadView *headView;
@property (nonatomic,strong) LeftView *leftView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    homeDataArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addUI];
    
    [self getTodayData];
}

- (void)addUI{
    self.mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.headView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 20, MAINSIZE.width, 44)];
    
    [self.headView.titleBtn setTitle:@"首页" forState:(UIControlStateNormal)];
    [self.headView.titleBtn addTarget:self action:@selector(goLeftView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.headView.rightBtn setTitle:@"设置" forState:(UIControlStateNormal)];
   
    self.topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, MAINSIZE.width, TOPVIEWH)];
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
   /// pageControl.backgroundColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    pageControl.frame = CGRectMake( 100, CGRectGetMaxY(self.topView.frame) -  20, 120, 20);
    pageControl.currentPage = 0;
    self.topView.pageControl = pageControl;
    

    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), MAINSIZE.width, TOPVIEWH)];
    [containerView addSubview:self.topView];
    [containerView addSubview:pageControl];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), MAINSIZE.width, MAINSIZE.height - CGRectGetMaxY(self.headView.frame)) style:(UITableViewStylePlain)];
    self.tableView.tableHeaderView = containerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tag = HOMEMAINTABLEVIEWTAG;
   
    
    [self.mainView addSubview:self.headView];
    //[self.mainView addSubview:self.topView];
    
    [self.mainView addSubview:self.tableView];
    [self.view addSubview:self.mainView];
    
    self.leftView = [[LeftView alloc] initWithFrame:CGRectMake(- 0.8 *CGRectGetWidth(self.view.frame) , 20, 0.8 *CGRectGetWidth(self.view.frame), MAINSIZE.height - 20)];
    self.leftView.headImgView.image = [UIImage imageNamed:@"头像.png"];
    self.leftView.userNameLabel.text = @"用户";
    [self.leftView.homeBtn addTarget:self action:@selector(tapHome) forControlEvents:(UIControlEventTouchDragInside)];
    
    UITapGestureRecognizer *ontap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHome)];
    ontap.delegate = self;
    [self.leftView.homeView addGestureRecognizer:ontap];
    
    self.leftView.tableView.delegate = self;
    self.leftView.tableView.dataSource = self;
    self.leftView.tableView.tag = HOMELEFTTABLEVIEWTAG;
    
    [self.view addSubview:self.leftView];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipe.delegate = self;
    [self.view addGestureRecognizer:swipe];
}



- (void)getTodayData{
    storieArr = [NSMutableArray array];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
     __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedNetworkTool] getTodayStoriesWhensuccess:^(ContentList *contentList) {
        storieArr = contentList.stories.mutableCopy;
         homeDataArr = storieArr.mutableCopy;
        NSMutableArray *topStories = [NSMutableArray arrayWithArray:contentList.top_stories];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [weakSelf.topView setStories:topStories];
            [weakSelf.tableView reloadData];
        });
        
    } failure:^{
        [[[UIAlertView alloc] initWithTitle:@"获取内容失败" message:@"获取内容失败，请检查网络" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil] show];
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NetworkTool sharedNetworkTool] getThemeTypeWhensuccess:^(ThemeType *themeType) {
            themeArr = themeType.others.mutableCopy;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.leftView.tableView reloadData];
            });
            
        } failure:^{
            [[[UIAlertView alloc] initWithTitle:@"获取失败" message:@"获取话题列表,请检查网络" delegate:nil cancelButtonTitle:@"取消 " otherButtonTitles:@"确定", nil] show];
        }];
    });

}

- (void)loadHomeData{
    storieArr = [NSMutableArray array];
    NSDate *date = [[NSDate date] initWithTimeInterval:24 *60 * 60 sinceDate:[NSDate date]];;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *dateStr = [formatter stringFromDate:date];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedNetworkTool] getStoriesListWithDate:dateStr success:^(ContentList *contentList) {
        storieArr = contentList.stories.mutableCopy;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [hud hide:YES];
        });
        
    } failure:^{
        [[[UIAlertView alloc] initWithTitle:@"获取内容失败" message:@"获取内容失败，请检查网络" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil] show];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == HOMEMAINTABLEVIEWTAG) {
         return storieArr.count;
    }else{
        return themeArr.count;
    }
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == HOMEMAINTABLEVIEWTAG) {
        static NSString *identifier = @"storiesCell";
        StoriesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[StoriesCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        }
        if (!storieArr.count > 0) {
            return cell;
        }
        StoriesItm *itm = storieArr[indexPath.row];
        cell.textLabel.text = itm.title;
        if (itm.images.count > 0) {
             [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[itm.images firstObject]] placeholderImage:[UIImage imageNamed:@"知乎.png"]];
        }else{
            cell.imageView.image = nil;
        }
        
        return cell;
    }else{//leftViewTable
        
        static NSString *idfentifier = @"leftCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:idfentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        ThemeItm *itm = themeArr[indexPath.row];
        cell.textLabel.text = itm.name;
        return cell;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    CGFloat edge = 8;
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSIZE.width, 40)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(edge, 0, 100, 40)];
//    label.backgroundColor = [UIColor clearColor];
//    label.text = @"今日要闻";
//    label.textColor = [UIColor redColor];
//    
//    [bgView addSubview:label];
//    
//    if (tableView.tag == HOMEMAINTABLEVIEWTAG) {
//        return bgView;
//    }else{
//        return [UIView new];
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == HOMEMAINTABLEVIEWTAG) {
        return STORIESCELLH;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == HOMEMAINTABLEVIEWTAG) {
        StoriesItm *itm = storieArr[indexPath.row];
        DetailsController *detailsVC = [[DetailsController alloc] init];
        detailsVC.storiesId = itm.storiesId;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }else{//leftViewTableView
        [UIView animateWithDuration:0.3 animations:^{
            self.leftView.frame = CGRectMake(-  CGRectGetWidth(self.leftView.frame) , 20, CGRectGetWidth(self.leftView.frame), CGRectGetHeight(self.leftView.frame));
            self.mainView.alpha = 1;
            
        }];
       // self.mainView.userInteractionEnabled = YES;
        [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
        self.tableView.tableHeaderView = [UIView new];
        [self.mainView removeGestureRecognizer:tapHome];
        ThemeItm *itm = themeArr[indexPath.row];
        [self.headView.titleBtn setTitle:itm.name forState:(UIControlStateNormal)];
        [self loadTypeDataWithStorieId:itm.themeId];
    }
}


#define 左视图

- (void)swipe:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [UIView animateWithDuration:0.5 animations:^{
            self.leftView.frame = CGRectMake(0, 20, CGRectGetWidth(self.leftView.frame), CGRectGetHeight(self.leftView.frame));
            self.mainView.alpha = 0.6;
        }];
        // self.mainView.userInteractionEnabled = NO;
        [self addTapHome];
    }
}

- (void)goLeftView{
    self.leftView.frame = CGRectMake(0, 20, CGRectGetWidth(self.leftView.frame), CGRectGetHeight(self.leftView.frame));
    self.mainView.alpha = 0.6;
   // self.mainView.userInteractionEnabled = NO;
    
    [self addTapHome];
}

- (void)addTapHome{
    tapHome = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHome)];
    tapHome.delegate = self;
    [self.mainView addGestureRecognizer:tapHome];
}

- (void)tapHome{
    NSLog(@"首页");
    self.leftView.frame = CGRectMake(- CGRectGetWidth(self.leftView.frame), 20, CGRectGetWidth(self.leftView.frame), CGRectGetHeight(self.leftView.frame));
    self.mainView.alpha = 1;
    self.tableView.tableHeaderView = containerView;
    [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
    
   // self.mainView.userInteractionEnabled = YES;
    [self.headView.titleBtn setTitle:@"首页" forState:(UIControlStateNormal)];
   [self.mainView removeGestureRecognizer:tapHome];
    storieArr = homeDataArr;
    [self.tableView reloadData];
}

- (void)loadTypeDataWithStorieId:(NSString *)storieId{
    storieArr = [NSMutableArray array];
    __weak  typeof(self) weakSelf = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    [[NetworkTool sharedNetworkTool] getStoriesListWithStorieId:storieId success:^(ContentList *contentList) {
        storieArr = contentList.stories.mutableCopy;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [hud hide:YES];
        });
    } failure:^{
        [[[UIAlertView alloc] initWithTitle:@"获取失败" message:@"获取列表,请检查网络" delegate:nil cancelButtonTitle:@"取消 " otherButtonTitles:@"确定", nil] show];
    }];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
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
