
//
//  DetailsModel.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "DetailsModel.h"

@implementation DetailsModel

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [super setValue:value forKey:@"storiesId"];
    }else{
        [super setValue:value forKey:key];
    }
}

@end
