
//
//  ThemeItm.h
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "JsonModel.h"

@interface ThemeItm : JsonModel

@property (nonatomic,strong) NSString *color;
@property (nonatomic,strong) NSString *thumbnail;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *themeId;
@property (nonatomic,strong) NSString *name;

@end
