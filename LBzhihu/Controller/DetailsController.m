//
//  DetailsController.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "DetailsController.h"
#import "NetworkTool.h"
//#import "PubilcMember.m"

@interface DetailsController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIWebView *webView;

@end

@implementation DetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUI];
    [self loadData];
}

- (void)addUI{
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat edge = 8;
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 20,MAINSIZE.width, 44)];
    self.headView.backgroundColor = HOMEHEADBACKGROUNDCOLOR;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(edge, edge, 60, 44 - 2 * edge)];
    [backBtn setTitle:@"返回" forState:(UIControlStateNormal)];
    [backBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    [self.headView addSubview:backBtn];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), MAINSIZE.width, MAINSIZE.height - CGRectGetMaxY(self.headView.frame))];
    self.webView.scrollView.bounces = YES;
    self.webView.delegate = self;
    
    [self.view addSubview:self.headView];
    [self.headView addSubview:self.webView];

}

- (void)loadData{
    
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedNetworkTool] getDetailsWithStoriesId:weakSelf.storiesId success:^(DetailsModel *detailsModel) {
        [weakSelf showInWebViewWithDetailsModel:detailsModel];
    } failure:^{
        [[[UIAlertView alloc] initWithTitle:@"获取内容失败" message:@"获取内容失败，请检查网络" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil] show];
    }];

}

#pragma mark - ******************** 拼接html语言
- (void)showInWebViewWithDetailsModel:(DetailsModel *)model{
    NSMutableString *htmlString = [NSMutableString stringWithFormat:@"<!DOCTYPE HTML><html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"">"];
    [htmlString appendFormat:@"<title>%@</title></head>",model.title];
    for (NSString *cssUrlString in model.css) {
        [htmlString appendFormat:@"<link href=""%@",cssUrlString];
        [htmlString appendFormat:@" rel=""stylesheet"" type=""text/css"">"];
    }
    [htmlString appendFormat:@"<body>"];
    [htmlString appendFormat:@"%@",model.body];
    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"!@!n"] mutableCopy];
    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"\r" withString:@"!@!r"] mutableCopy];
    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"\p" withString:@"!@!p"] mutableCopy];
    
    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"\\"  withString:@""] mutableCopy];
    
    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"!@!n" withString:@"\n"] mutableCopy];
    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"!@!r" withString:@"\r"] mutableCopy];
    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"!@!p" withString:@"\p"] mutableCopy];

    
    [htmlString appendFormat:@"</body></html>"];
    
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
