//
//  ThemeType.h
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "JsonModel.h"
#import "ThemeItm.h"

@interface ThemeType : JsonModel

@property (nonatomic,strong) NSString *limit;
@property (nonatomic,strong) NSArray *others;

@end
