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
#import "UIView+frame.h"
#import "StoriesCell.h"
#import "TopView.h"
#import "DetailsController.h"
//#import "LeftView.h"
#import "LeftViewController.h"
#import "UIImageView+WebCache.h"
#import <MJRefresh.h>

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,TapImageViewDelegate,SelectThemeDelegate>
{
    NSMutableArray *storieArr;
//    NSMutableArray *themeArr;
    NSMutableArray *homeDataArr;
    NSMutableArray *topStoriesArr;
    UITapGestureRecognizer *tapHome;
    UIView *containerView;//用来作为TopView和pageControl的共同父View
    int curPage;
    NSInteger curThemeId; /*<话题id，首页-1*/
    CGRect leftViewLeftFrame;//左视图在左边时位置
    CGRect leftViewRightFrame;//左视图在右边时位置
}

@property (nonatomic,strong) UIView *mainView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) TopView *topView;
@property (nonatomic,strong) HomeHeadView *headView;
@property (nonatomic,strong) LeftViewController *leftVC;
//@property (nonatomic,strong) LeftView *leftView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    curPage = 0;
    curThemeId = -1;
    leftViewLeftFrame = CGRectMake(- MAINSIZE.width , 0, LEFTVIEWW, MAINSIZE.height);
    leftViewRightFrame = CGRectMake(self.view.x,self.view.y, self.view.width, self.view.height);
    
    homeDataArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addUI];
    
    [self getTodayData];
}

- (void)addUI{
    self.mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.headView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 0, MAINSIZE.width, 44)];
   
    [self.headView.titleBtn setTitle:@"首页" forState:(UIControlStateNormal)];
    [self.headView.leftBtn addTarget:self action:@selector(showLeftView) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.topView = [[TopView alloc] initWithFrame:CGRectMake(0,0, MAINSIZE.width, TOPVIEWH)];
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
   /// pageControl.backgroundColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    pageControl.frame = CGRectMake( 100, CGRectGetMaxY(self.topView.frame) -  20, 120, 20);
    pageControl.currentPage = 0;
    self.topView.pageControl = pageControl;
    self.topView.tapDelegate = self;
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MAINSIZE.width, TOPVIEWH)];
    [containerView addSubview:self.topView];
    [containerView addSubview:pageControl];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, MAINSIZE.width, MAINSIZE.height) style:(UITableViewStylePlain)];
    self.tableView.tableHeaderView = containerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tag = HOMEMAINTABLEVIEWTAG;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.footer.automaticallyChangeAlpha = YES;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.mainView addSubview:self.tableView];
    [self.mainView addSubview:self.headView];
    [self.view addSubview:self.mainView];
    
    self.leftVC = [[LeftViewController alloc] init];
    self.leftVC.themDelegate = self;
    self.leftVC.view.frame = leftViewLeftFrame;
    [self.mainView addSubview:self.leftVC.view];
    [self addChildViewController:self.leftVC];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipe.delegate = self;
    [self.view addGestureRecognizer:swipe];
}


- (void)loadMoreData{
    if (curThemeId == -1) {
        [self loadHomeData];
    }else{
        [self loadMoreTypeData];
    }
}

#pragma mark 数据加载

// 今日的首页内容
- (void)getTodayData{
    storieArr = [NSMutableArray array];
    topStoriesArr = [NSMutableArray array];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
     __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedNetworkTool] getTodayStoriesWhensuccess:^(ContentList *contentList) {
        storieArr = contentList.stories.mutableCopy;
         homeDataArr = storieArr.mutableCopy;
        topStoriesArr = contentList.top_stories.mutableCopy;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [weakSelf.topView setStories:topStoriesArr];
            [weakSelf.tableView reloadData];
        });
        
    } failure:^{
        [[[UIAlertView alloc] initWithTitle:@"获取内容失败" message:@"获取内容失败，请检查网络" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil] show];
    }];
    
}

//
- (void)loadHomeData{
    NSDate *date = [[NSDate date] initWithTimeInterval:- 24 *60 * 60 * curPage sinceDate:[NSDate date]];;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *dateStr = [formatter stringFromDate:date];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedNetworkTool] getStoriesListWithDate:dateStr success:^(ContentList *contentList) {
       // storieArr = contentList.stories.mutableCopy;
        
        for (id tmp in contentList.stories.mutableCopy) {
            [storieArr addObject:tmp];
        }
        curPage ++;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [hud hide:YES];
            weakSelf.tableView.footer.hidden = YES;
           
        });
            weakSelf.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(loadMoreData)];
    } failure:^{
        [[[UIAlertView alloc] initWithTitle:@"获取内容失败" message:@"获取内容失败，请检查网络" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil] show];
    }];
}

//加载某个话题下的列表
- (void)loadTypeDataWithStorieId:(NSString *)storieId{
    __weak  typeof(self) weakSelf = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    [[NetworkTool sharedNetworkTool] getStoriesListWithStorieId:storieId success:^(ContentList *contentList) {
        
        for (id tmp in contentList.stories.mutableCopy) {
            [storieArr addObject:tmp];
        }
        homeDataArr = storieArr;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [hud hide:YES];
        });
        
        weakSelf.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(loadMoreTypeData)];
        
    } failure:^{
        [[[UIAlertView alloc] initWithTitle:@"获取失败" message:@"获取列表,请检查网络" delegate:nil cancelButtonTitle:@"取消 " otherButtonTitles:@"确定", nil] show];
    }];
    
}

//加载更多话题内容
- (void)loadMoreTypeData{
    StoriesItm *itm = [storieArr lastObject];
    NSString *storieId =  itm.storiesId;
    NSString *idString = [NSString stringWithFormat:@"%ld/before/%@",curThemeId,storieId];
    [self loadTypeDataWithStorieId:idString];
}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return storieArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
             [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[itm.images firstObject]] placeholderImage:[UIImage imageNamed:@"icon.bundle/Image_Preview@2x.png"]];
        }else{
            cell.imageView.image = nil;
        }
        
        return cell;
}


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
    
        DetailsController *detailsVC = [[DetailsController alloc] init];
        detailsVC.storieArr = storieArr.mutableCopy;
        detailsVC.curIndex = indexPath.row;
        
        [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma maek 视图切换
#pragma mark 左视图

- (void)swipe:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self showLeftView];
    }
}

- (void)showLeftView{
    self.tableView.userInteractionEnabled = NO;
    [self.leftVC.view becomeFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.leftVC.view.frame = leftViewRightFrame;
        self.mainView.alpha = 0.6;
        self.headView.alpha = 1;
    }];
}

- (void)showMainView{
    self.tableView.userInteractionEnabled = YES;
    [self.leftVC.view becomeFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.leftVC.view.frame = leftViewLeftFrame;
        self.mainView.alpha = 1;
    }];

}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

#pragma mark TapImageViewDelegate

- (void)tapImageView:(UIImageView *)imageView{
    int index = (int)imageView.tag - TOPVIEWIMGTAG;
    DetailsController *detailsVC = [[DetailsController alloc] init];
    detailsVC.storieArr = topStoriesArr;
    detailsVC.curIndex = index;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
}

//改变顶部的headview颜色
-( void )scrollViewDidScroll:( UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 44 || offsetY <= -44) {
        return;
    }
    self.headView.alpha = offsetY / 44.0 ;
}


- (void)selectThemeIdWithThemeId:(NSString *)themeId headViewTitle:(NSString *)headViewTitle{
    [self showMainView];
    NSInteger intThemeId = [themeId intValue];
    if(intThemeId == curThemeId){
        return;
    }
    storieArr = [NSMutableArray array];
    curThemeId = intThemeId;
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    [self.headView.titleBtn setTitle:headViewTitle forState:(UIControlStateNormal)];
    
    if(intThemeId == -1){
        [self loadHomeData];
        
        self.tableView.tableHeaderView = containerView;
        return;
    }
    
    self.tableView.tableHeaderView = [UIView new];
   
    [self loadTypeDataWithStorieId:themeId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigationdidselect

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
