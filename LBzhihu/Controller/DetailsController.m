//
//  DetailsController.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "DetailsController.h"
#import "NetworkTool.h"
#import "UIView+frame.h"

#import <MBProgressHUD.h>
#import "UIButton+Badge.h"
#import "DetailsController.m"
#import "CommentsController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <ShareSDKUI/ShareSDKUI.h>

@interface DetailsController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *btns;
    ShareModel *shareModel;
    UIActivityIndicatorView *shareLoadingView;
    UIView *sharePanelView;
}
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIView *toolView;
@property (nonatomic,strong) MBProgressHUD *hud;

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
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.bounces = YES;
    self.webView.delegate = self;
    
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - DETAILTOOLVIEWH, MAINSIZE.width, DETAILTOOLVIEWH)];
    self.toolView.backgroundColor = [UIColor whiteColor];
    self.toolView.translatesAutoresizingMaskIntoConstraints = NO;
    
    btns = [NSMutableArray array];
    NSArray *names = @[@"back",@"next",@"like:",@"share",@"comments"];
    NSArray *imgs = @[@"Comment_Icon_Back@2x.png",@"News_Navigation_Next_Highlight@2x.png",@"News_Navigation_Vote@2x.png",@"News_Navigation_Share@2x.png",@"News_Navigation_Comment@2x.png"];
    
   
    CGFloat btnH = DETAILTOOLVIEWH;
    CGFloat btnW = 60;
    CGFloat edge = (MAINSIZE.width - 5 * btnW) / 6.0;
    CGFloat top = (DETAILTOOLVIEWH - btnH) / 2.0;
    
    for(int i = 0;i < 5;i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * btnW + (i + 1) * edge, top, btnW, btnH)];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn.tag = DETAILSTOOLTAG + i;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon.bundle/%@",imgs[i]]] forState:(UIControlStateNormal)];
        SEL s =  NSSelectorFromString(names[i]);
        [btn addTarget:self action:s forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.toolView addSubview:btn];
        [btns addObject:btn];
    }
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.toolView];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipe.delegate = self;
    [self.view addGestureRecognizer:swipe];
}

- (void)loadData{
    
   self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"正在加载网页";
    
    StoriesItm *itm = self.storieArr[self.curIndex];
    shareModel = [ShareModel new];
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedNetworkTool] getDetailsWithStoriesId:itm.storiesId success:^(DetailsModel *model) {
        shareModel.title = model.title.mutableCopy;
        shareModel.imageUrl = model.image.mutableCopy;
        shareModel.shareUrl = model.share_url.mutableCopy;
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf showInWebViewWithDetailsModel:model];
        });
        
    } failure:^{
        [[[UIAlertView alloc] initWithTitle:@"获取内容失败" message:@"获取内容失败，请检查网络" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil] show];
    }];

    
    [[NetworkTool sharedNetworkTool] getDetailsInfoWithWithStoriesId:itm.storiesId   success:^(DetailsInfo *infon) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ;
            UIButton *pop = btns[2];
            pop.badgeValue = [NSString stringWithFormat:@"%@",infon.popularity];
            pop.badgeBGColor = [UIColor clearColor];
            pop.badgeTextColor = [UIColor grayColor];
            pop.badgeOriginX = 30;
            
            UIButton *com = btns[4];
            com.badgeValue = [NSString stringWithFormat:@"%@",infon.popularity];
            com.badgeBGColor = [UIColor clearColor];
            com.badgeTextColor = [UIColor grayColor];
            com.badgeOriginX = 30;
            com.badgeOriginY = -0.5;
            
            com.badgeValue = [NSString stringWithFormat:@"%@",infon.comments];
        });
        
    } failure:^{
        nil;
    }];
    
    
}

#pragma mark - ******************** 拼接html语言

- (void)showInWebViewWithDetailsModel:(DetailsModel *)model{
    //有些主题下不使用拼接，直接显示web
    if(model.body == nil){
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.share_url]];
        [self.webView loadRequest:request];
        return;
    }
    
    
    NSMutableString *htmlString = [NSMutableString stringWithFormat:@"<!DOCTYPE HTML><html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"">"];
    [htmlString appendFormat:@"<title>%@</title></head>",model.title];
    for (NSString *cssUrlString in model.css) {
        [htmlString appendFormat:@"<link href=""%@",cssUrlString];
        [htmlString appendFormat:@" rel=""stylesheet"" type=""text/css"">"];
    }
    
    [htmlString appendFormat:@"<style>.avatarT {width:100%%;height:200px; position:absolute; min-width:320px;} .bgwz {position:absolute; color:#fff; margin:150px 15px 0 15px; min-width:290px; font-size:1em;}</style>"];
    
    
    [htmlString appendFormat:@"<body>"];
    
    if (model.image.length > 0) {
        [htmlString appendFormat:@"<div><img class=""avatarT"" src=""%@""><p class=""bgwz"">%@</p></div>",model.image,model.title];
    }
    
    [htmlString appendFormat:@"%@",model.body];
//    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"!@!n"] mutableCopy];
//    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"\r" withString:@"!@!r"] mutableCopy];
//    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"\p" withString:@"!@!p"] mutableCopy];
//    
//    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"\\"  withString:@""] mutableCopy];
//    
//    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"!@!n" withString:@"\n"] mutableCopy];
//    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"!@!r" withString:@"\r"] mutableCopy];
//    htmlString = [[htmlString stringByReplacingOccurrencesOfString:@"!@!p" withString:@"\p"] mutableCopy];
    
    
    [htmlString appendFormat:@"</body></html>"];
    
    [self.webView loadHTMLString:htmlString baseURL:nil];
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.hud hide:YES];
}

- (void)swipe:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self back];
    }
}


#pragma mark toolView

- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)next{
    self.curIndex ++;
    if (self.curIndex >= self.storieArr.count) {
        return;
    }
    [self loadData];
}

- (void)like:(UIButton *)sender{
    NSLog(@"赞");
    CGFloat imgW = 90;
    CGFloat imgH = 30;
    UIButton *pop = btns[2];
    
    NSArray *imgs = @[@"icon.bundle/News_Navigation_Vote@2x.png",@"icon.bundle/News_Navigation_Voted@2x.png"];
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [sender setImage:[UIImage imageNamed:imgs[0]] forState:(UIControlStateNormal)];
        pop.badgeValue = [NSString stringWithFormat:@"%d",[pop.badgeValue intValue] - 1];
        return;
    }
    
    [sender setImage:[UIImage imageNamed:imgs[1]] forState:(UIControlStateNormal)];
    pop.badgeValue = [NSString stringWithFormat:@"%d",[pop.badgeValue intValue] + 1];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(sender.x, MAINSIZE.height - imgH, imgW, imgH)];
    imageView.image = [UIImage imageNamed:@"icon.bundle/News_Number_Bg@2x.png"];
    imageView.tag = LIKEIMAGEVIETAG;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageView.width, imageView.height - 10)];
    label.text = pop.badgeValue;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;

    
    [UIView animateWithDuration:0.5 animations:^{
        imageView.y = self.toolView.y - imgH;
        label.text = [NSString stringWithFormat:@"%d",[label.text intValue]];
    }];
    
    
    [imageView addSubview:label];
    [self.view addSubview:imageView];
    
    [self performSelector:@selector(removeImageView) withObject:nil afterDelay:0.5];
}

- (void)removeImageView{
    UIImageView *imgView = [self.view viewWithTag:LIKEIMAGEVIETAG];
    [imgView removeFromSuperview];
}




#pragma mark 分享
- (void)share{
    
    NSURL *url = [NSURL URLWithString:shareModel.shareUrl];
    NSString *title = shareModel.title;
    NSString *text = @"分享自@李波知乎";
    if (shareModel.imageUrl == nil) {
        shareModel.imageUrl = @"http://photo.163.com/devlibo/#m=2&aid=297774132&pid=9451740439";
    }
    NSArray *imgArr = @[shareModel.imageUrl];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text images:imgArr url:url title:title type:(SSDKContentTypeWebPage)];
    __weak id weekSelf = self;
    
        [ShareSDK showShareActionSheet:self.view
                             items:@[@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateBegin:{
                           [weekSelf showLoadingView:YES];
                        
                           break;
                       }
                       case SSDKResponseStateSuccess:{
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:{
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@", error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateCancel:{
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
               }];
    
    
}

- (void)showLoadingView:(BOOL)flag
{
    if (flag) {
        [self.view addSubview:sharePanelView];
        [shareLoadingView startAnimating];
        return;
    }
    
    [sharePanelView removeFromSuperview];
}

- (void)addShareUI{
    //加载等待视图
    sharePanelView = [[UIView alloc] initWithFrame:self.view.bounds];
    sharePanelView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    sharePanelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    shareLoadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    shareLoadingView.frame = CGRectMake((self.view.frame.size.width - shareLoadingView.frame.size.width) / 2, (self.view.frame.size.height - shareLoadingView.frame.size.height) / 2, shareLoadingView.frame.size.width, shareLoadingView.frame.size.height);
    shareLoadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [sharePanelView addSubview:shareLoadingView];
}


#pragma mark 评论
- (void)comments{

    NSLog(@"评论");
    StoriesItm *itm = self.storieArr[self.curIndex];
    
    CommentsController *commentVC = [CommentsController new];
    commentVC.storiesId = itm.storiesId;
    [self.navigationController pushViewController:commentVC animated:YES];
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
