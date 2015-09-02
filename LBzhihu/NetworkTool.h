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

@interface NetworkTool : NSObject

+ (instancetype)sharedNetworkTool;

- (void)getThemeTypeWhensuccess:(void (^)(ThemeType *themeType))success failure:(void (^)())failure;

@end
