//
//  StoriesItm.h
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "JsonModel.h"

@interface StoriesItm : JsonModel

@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSString *storiesId;
@property (nonatomic,strong) NSString *ga_prefix;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *multipic;

@end
