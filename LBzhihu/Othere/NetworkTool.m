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
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            failure();
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            ThemeType *t = [[ThemeType alloc] initWithDictionary:dic];
            if (t) {
               success(t);
            }else{
                failure();
            }            
        }
    }];

}

- (void)getTodayStoriesWhensuccess:(void (^)(ContentList *))success failure:(void (^)())failure{
   NSString *urlStr = @"http://news-at.zhihu.com/api/4/stories/latest";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            failure();
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            ContentList *t = [[ContentList alloc] initWithDictionary:dic];
            if (t) {
                success(t);
            }else{
                failure();
            }
        }
    }];
}

- (void)getStoriesListWithDate:(NSString *)dateString success:(void (^)(ContentList *))success failure:(void (^)())failure{
    NSString *urlStr = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/stories/before/%@",dateString];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            failure();
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            ContentList *t = [[ContentList alloc] initWithDictionary:dic];
            if (t) {
                success(t);
            }else{
                failure();
            }
        }
    }];
}

- (void)getDetailsWithStoriesId:(NSString *)storiesId success:(void (^)(DetailsModel *))success failure:(void (^)())failure{
    NSString *urlStr = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@",storiesId];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            failure();
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            DetailsModel *t = [[DetailsModel alloc] initWithDictionary:dic];
            if (t) {
                success(t);
            }else{
                failure();
            }
        }
    }];
}

- (void)getStoriesListWithStorieId:(NSString *)storieId success:(void (^)(ContentList *))success failure:(void (^)())failure{
    NSString *urlStr = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%@",storieId];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            failure();
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            ContentList *t = [[ContentList alloc] initWithDictionary:dic];
            if (t) {
                success(t);
            }else{
                failure();
            }
        }
    }];
}

@end
