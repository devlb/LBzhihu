//
//  DetailsModel.h
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "JsonModel.h"

@interface DetailsModel : JsonModel<NSCopying,NSMutableCopying>

@property (nonatomic,strong) NSString *body;
@property (nonatomic,strong) NSString *image_source;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *share_url;
@property (nonatomic,strong) NSString *ga_prefix;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSArray *css;
@property (nonatomic,strong) NSString *storiesId;

-(id)copyWithZone:(NSZone *)zone;
- (id)mutableCopyWithZone:(NSZone *)zone;

@end
