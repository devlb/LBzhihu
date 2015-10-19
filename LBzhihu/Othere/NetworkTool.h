//
//  NetToolbar.h
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ThemeType.h"
#import "ThemeItm.h"
#import "StoriesItm.h"
#import "ContentList.h"
#import "DetailsModel.h"
#import "Public.m"
#import "DetailsInfo.h"
#import "CommentsModel.h"

@interface NetworkTool : NSObject

+ (instancetype)sharedNetworkTool;

- (void)getThemeTypeWhensuccess:(void (^)(ThemeType *themeType))success failure:(void (^)())failure;

- (void)getTodayStoriesWhensuccess:(void (^)(ContentList *contentList))success failure:(void (^)())failure;

- (void)getStoriesListWithDate:(NSString *)dateString success:(void (^)(ContentList *contentList))success failure:(void (^)())failure;

- (void)getDetailsWithStoriesId:(NSString *)storiesId success:(void (^)(DetailsModel *detailsModel))success failure:(void (^)())failure;

- (void)getStoriesListWithStorieId :(NSString *)storieId success:(void (^)(ContentList *contentList))success failure:(void (^)())failure;

- (void)getDetailsInfoWithWithStoriesId:(NSString *)storiesId success:(void(^)(DetailsInfo *infon))success failure:(void (^)())failure;

- (void)getLongComments:(NSString *)storieId success:(void (^)(CommentsModel *commentsModel))success failure:(void (^)())failure;

- (void)getShortComments:(NSString *)storieId success:(void (^)(CommentsModel *commentsModel))success failure:(void (^)())failure;

@end
