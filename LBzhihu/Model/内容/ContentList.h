//
//  ContentList.h
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "JsonModel.h"
#import "StoriesItm.h"

@interface ContentList : JsonModel

@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSArray *stories;
@property (nonatomic,strong) NSArray *top_stories;
@end
