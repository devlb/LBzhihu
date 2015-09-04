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
#import <MBProgressHUD.h>

@interface DetailsController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIView *toolView;

@end

@implementation DetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUI];
    [self loadData];
}

- (void)addUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MAINSIZE.width, MAINSIZE.height - DETAILTOOLVIEWH)];
    self.webView.scrollView.bounces = YES;
    self.webView.delegate = self;
    
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - DETAILTOOLVIEWH, MAINSIZE.width, DETAILTOOLVIEWH)];
    self.toolView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.toolView];
}

- (void)loadData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载网页";
    
    
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedNetworkTool] getDetailsWithStoriesId:weakSelf.storiesId success:^(DetailsModel *detailsModel) {
      
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [weakSelf showInWebViewWithDetailsModel:detailsModel];
        });
        
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
    
    
        [htmlString appendFormat:@"<style>.avatarT {width:100%;height:200px; position:absolute; min-width:320px;} .bgwz {position:absolute; color:#fff; margin:150px 15px 0 15px; min-width:290px; font-size:1em;}</style>"];

    
    [htmlString appendFormat:@"<body>"];

    if (model.image.length > 0) {
        [htmlString appendFormat:@"<div><img class=""avatarT"" src=""%@""><p class=""bgwz"">绘画和摄影的区别在哪里？有绘画基础的人上手摄影会不会很快？</p></div>",model.image];
    }
    
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




//- (void)showInWebViewWithDetailsModel:(DetailsModel *)model{
//    NSMutableString *htmlString = [NSMutableString stringWithFormat:@"<!DOCTYPE HTML><html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"">"];
//    [htmlString appendFormat:@"<title>%@</title></head>",model.title];
//    for (NSString *cssUrlString in model.css) {
//        [htmlString appendFormat:@"<link href=""%@",cssUrlString];
//        [htmlString appendFormat:@" rel=""stylesheet"" type=""text/css"">"];
//    }
//    [htmlString appendFormat:@"<body>"];
//    [htmlString appendFormat:@"%@",model.body];
//    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"!@!n"] mutableCopy];
//    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"\r" withString:@"!@!r"] mutableCopy];
//    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"\p" withString:@"!@!p"] mutableCopy];
//    
//    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"\\"  withString:@""] mutableCopy];
//    
//    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"!@!n" withString:@"\n"] mutableCopy];
//    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"!@!r" withString:@"\r"] mutableCopy];
//    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"!@!p" withString:@"\p"] mutableCopy];
//
//    
//    [htmlString appendFormat:@"</body></html>"];
//    
//    [self.webView loadHTMLString:htmlString baseURL:nil];
//}

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
