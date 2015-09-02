//
//  NetToolbar.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "NetworkTool.h"

@implementation NetworkTool

static NetworkTool *tool;

+ (instancetype)sharedNetworkTool{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        tool  = [[self alloc] init];
    });
    return tool;
}

- (void)getThemeTypeWhensuccess:(void (^)(ThemeType *))success failure:(void (^)())failure{
    NSString *urlStr = @"http://news-at.zhihu.com/api/4/themes";
   // AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];}
}
@end
