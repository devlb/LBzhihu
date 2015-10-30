//
//  LeftViewController.m
//  LBzhihu
//
//  Created by lb on 15/10/20.
//  Copyright © 2015年 李波. All rights reserved.
//

#import "LeftViewController.h"
#import "NetworkTool.h"
@interface LeftViewController ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *themeArr;
}

@property (nonatomic,strong) UIButton *homeBtn;
@property (nonatomic,strong) UIView *tapView;

@end


@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubView];
    [self loadData];
}

- (void)addSubView{

    self.view.backgroundColor = [UIColor clearColor];
    
    self.homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, LEFTVIEWW, LEFTHOMEVIEWH)];
    self.homeBtn.backgroundColor = [UIColor clearColor];
    [self.homeBtn setTitle:@"首页" forState:(UIControlStateNormal)];
    [self.homeBtn setImage:[UIImage imageNamed:@"icon.bundle/Menu_Icon_Home@2x.png"] forState:(UIControlStateNormal)];
    [self.homeBtn setTitleColor:HOMEHEADBACKGROUNDCOLOR forState:(UIControlStateNormal)];
    [self.homeBtn addTarget:self action:@selector(goHome) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, LEFTVIEWW, MAINSIZE.height - 44) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.accessibilityNavigationStyle = UITableViewCellAccessoryDisclosureIndicator;
    self.tableView.tableHeaderView = self.homeBtn;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = LEFTVIEWBACKGROUNDCOLOR;
    self.tableView.tag = HOMELEFTTABLEVIEWTAG;
    
    self.tapView = [[UIView alloc] initWithFrame:CGRectMake(LEFTVIEWW,0, MAINSIZE.width - LEFTVIEWW, MAINSIZE.height)];
    self.tapView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pop)];
    tap.delegate = self;
    [self.tapView addGestureRecognizer:tap];
    [self.view addSubview:self.tapView];
    
    //添加毛玻璃效果
    UIBlurEffect * blurEffect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * blureffectView=[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    blureffectView.frame= CGRectMake(0, 0,LEFTVIEWW, MAINSIZE.height);
    [self.view addSubview:blureffectView];

    [self.view addSubview:self.tableView];
    

}

- (void)loadData{
    themeArr = [NSMutableArray array];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NetworkTool sharedNetworkTool] getThemeTypeWhensuccess:^(ThemeType *themeType) {
    
            themeArr = themeType.others.mutableCopy;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [weakSelf.tableView reloadData];
            });
        
        } failure:^{
            [[[UIAlertView alloc] initWithTitle:@"获取失败" message:@"获取话题列表,请检查网络" delegate:nil cancelButtonTitle:@"取消 " otherButtonTitles:@"确定", nil] show];
        }];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return themeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ThemeItm *itm = themeArr[indexPath.row];
    self.themeId = itm.themeId;
    self.headViewTitle = itm.name;
    [self pop];
}

- (void)pop{
    [self.themDelegate selectThemeIdWithThemeId:self.themeId headViewTitle:self.headViewTitle];
}

- (void)goHome{
//    self.curIndex = -1;
    self.themeId = @"-1";
    [self.themDelegate selectThemeIdWithThemeId:self.themeId headViewTitle:@"首页"];
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
