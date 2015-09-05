//
//  DetailsInfo.h
//  LBzhihu
//
//  Created by lb on 15/9/5.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "JsonModel.h"

@interface DetailsInfo : JsonModel

@property (nonatomic,strong) NSString *long_comments;
@property (nonatomic,strong) NSString *popularity;
@property (nonatomic,strong) NSString *short_comments;
@property (nonatomic,strong) NSString *comments;

@end
