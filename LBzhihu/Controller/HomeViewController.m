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
#import <MJRefresh.h>

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,TapImageViewDelegate>
{
    NSMutableArray *storieArr;
    NSMutableArray *themeArr;
    NSMutableArray *homeDataArr;
    NSMutableArray *topStoriesArr;
    UITapGestureRecognizer *tapHome;
    UIView *containerView;//用来作为TopView和pageControl的共同父View
    int curPage;
    int curThemeId; /*<话题id，首页-1*/
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
    
    curPage = 0;
    curThemeId = -1;
    homeDataArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addUI];
    
    [self getTodayData];
}

- (void)addUI{
    self.mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.headView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 20, MAINSIZE.width, 44)];
   
    [self.headView.titleBtn setTitle:@"首页" forState:(UIControlStateNormal)];
    [self.headView.leftBtn addTarget:self action:@selector(goLeftView) forControlEvents:(UIControlEventTouchUpInside)];

   
    self.topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, MAINSIZE.width, TOPVIEWH)];
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
   /// pageControl.backgroundColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    pageControl.frame = CGRectMake( 100, CGRectGetMaxY(self.topView.frame) -  20, 120, 20);
    pageControl.currentPage = 0;
    self.topView.pageControl = pageControl;
    self.topView.tapDelegate = self;
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), MAINSIZE.width, TOPVIEWH)];
    [containerView addSubview:self.topView];
    [containerView addSubview:pageControl];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), MAINSIZE.width, MAINSIZE.height - CGRectGetMaxY(self.headView.frame)) style:(UITableViewStylePlain)];
    self.tableView.tableHeaderView = containerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tag = HOMEMAINTABLEVIEWTAG;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.footer.automaticallyChangeAlpha = YES;
    
    [self.mainView addSubview:self.headView];
    [self.mainView addSubview:self.tableView];
    [self.view addSubview:self.mainView];
    
    self.leftView = [[LeftView alloc] initWithFrame:CGRectMake(- 0.7 *CGRectGetWidth(self.view.frame) , 20, 0.7 *CGRectGetWidth(self.view.frame), MAINSIZE.height - 20)];
    self.leftView.headImgView.image = [UIImage imageNamed:@"头像.png"];
    [self.leftView.homeBtn addTarget:self action:@selector(goHome) forControlEvents:(UIControlEventTouchDragInside)];
    
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


- (void)loadMoreData{
    [self loadHomeData];
    
}

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
        
//        NSMutableArray *topStories = [NSMutableArray arrayWithArray:contentList.top_stories];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [weakSelf.topView setStories:topStoriesArr];
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
             [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[itm.images firstObject]] placeholderImage:[UIImage imageNamed:@"icon.bundle/Image_Preview@2x.png"]];
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
        cell.backgroundColor = LEFTVIEWBACKGROUNDCOLOR;
        ThemeItm *itm = themeArr[indexPath.row];
        cell.textLabel.text = itm.name;
        return cell;
    }
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
    if (tableView.tag == HOMEMAINTABLEVIEWTAG) {
        
        DetailsController *detailsVC = [[DetailsController alloc] init];
        detailsVC.storieArr = storieArr.mutableCopy;
        detailsVC.curIndex = indexPath.row;
        
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
        curThemeId = [itm.themeId intValue];
        storieArr = [NSMutableArray array];
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

- (void)goHome{
    curThemeId = -1;
    [self tapHome];
}

- (void)tapHome{
    NSLog(@"首页");
    self.leftView.frame = CGRectMake(- CGRectGetWidth(self.leftView.frame), 20, CGRectGetWidth(self.leftView.frame), CGRectGetHeight(self.leftView.frame));
    self.mainView.alpha = 1;
    [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
   
    if (curThemeId == -1) {
        self.tableView.tableHeaderView = containerView;
    }else{
        self.tableView.tableHeaderView = [UIView new];
    }
    
   // self.mainView.userInteractionEnabled = YES;
    [self.headView.titleBtn setTitle:@"首页" forState:(UIControlStateNormal)];
   [self.mainView removeGestureRecognizer:tapHome];
    
    storieArr = homeDataArr;
    [self.tableView reloadData];
}

//加载某个话题下的列表
- (void)loadTypeDataWithStorieId:(NSString *)storieId{
  //  storieArr = [NSMutableArray array];
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
    NSString *idString = [NSString stringWithFormat:@"%d/before/%@",curThemeId,storieId];
    [self loadTypeDataWithStorieId:idString];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

#pragma mark TapImageViewDelegate

- (void)tapImageView:(UIImageView *)imageView{
    int index = imageView.tag - TOPVIEWIMGTAG;
    DetailsController *detailsVC = [[DetailsController alloc] init];
    detailsVC.storieArr = topStoriesArr;
    detailsVC.curIndex = index;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
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
