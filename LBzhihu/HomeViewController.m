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

@interface HomeViewController ()
{
    CGSize mainSize;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mainSize = [[UIScreen mainScreen] bounds].size;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addUI];
    [[NetworkTool sharedNetworkTool] getThemeTypeWhensuccess:^(ThemeType *themeType) {
        
    } failure:^{
        
    }];
}

- (void)addUI{
    HomeHeadView *headView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 20, mainSize.width, 44)];
    headView.leftImageView.image = [UIImage imageNamed:@""];
    headView.titleLabel.text = @"首页";
    [headView.rightBtn setTitle:@"设置" forState:(UIControlStateNormal)];
    
    [self.view addSubview:headView];

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
