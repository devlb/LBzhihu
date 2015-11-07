//
//  AppDelegate.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "StartViewController.h"

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/TencentOAuth.h>

#define SHAREAPPKEY @"a42f5c9c6808"
#define WXAPPID @"wxf88c6046c12be3d0"
#define WXAPPSECRET  @"70334fa07279c16949410af92b1a9b20"
#define QQAPPID @"1104842141"
#define QQAPPKEY @"jfylB0GELAaeKKz7"

//QQAPPID转为16进制后 41DA8D9D
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:rect];
  //  640 1136
    [self share];
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    StartViewController *startVC = [[StartViewController alloc] init];
    
    BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"];
    if (isFirstStart) {
        self.window.rootViewController = startVC;
    }else{
         self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:homeVC];
    }
   
    self.window.tintColor = [UIColor colorWithRed:139/255.0 green:139/255.0 blue:131/255.0 alpha:1];
    
    [self.window makeKeyAndVisible];
    
   
    return YES;
}

- (void)share{
    [ShareSDK registerApp:SHAREAPPKEY activePlatforms:@[@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType){
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            default:
                break;
        }
        
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformSubTypeWechatSession:
                
            case SSDKPlatformSubTypeWechatTimeline:
                [appInfo SSDKSetupWeChatByAppId:WXAPPID appSecret:WXAPPSECRET];
                break;
            case SSDKPlatformSubTypeQQFriend:
            case SSDKPlatformSubTypeQZone:
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:QQAPPID appKey:QQAPPKEY authType:SSDKAuthTypeBoth];
                
                break;
            default:
                break;
        }
    }];
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
