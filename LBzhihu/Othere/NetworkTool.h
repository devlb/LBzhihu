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

#pragma mark colour


#define HOMEHEADBACKGROUNDCOLOR [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1]


#pragma mark height

#define MAINSIZE ([[UIScreen mainScreen] bounds].size)
#define HOMEHEADHEIGHT 44
#define IMAGEANDTITLEVIEWHEIGHT 200
#define STORIESCELLH 100
#define TOPVIEWH 130

#define LEFTHEADVIEWH 80
#define LEFTHOMEVIEWH 40

#pragma mark tag

#define HOMELEFTTABLEVIEWTAG 80
#define HOMEMAINTABLEVIEWTAG 81


@interface NetworkTool : NSObject

+ (instancetype)sharedNetworkTool;

- (void)getThemeTypeWhensuccess:(void (^)(ThemeType *themeType))success failure:(void (^)())failure;

- (void)getStoriesListWithDate:(NSString *)dateString success:(void (^)(ContentList *contentList))success failure:(void (^)())failure;

- (void)getDetailsWithStoriesId:(NSString *)storiesId success:(void (^)(DetailsModel *detailsModel))success failure:(void (^)())failure;

- (void)getStoriesListWithStorieId :(NSString *)storieId success:(void (^)(ContentList *contentList))success failure:(void (^)())failure;

@end
