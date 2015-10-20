//
//  JsonModel.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "JsonModel.h"

@implementation JsonModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if(self = [super init]){
        [super setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@没找到:key:%@  value:%@",[self class],key,value);
}

-(id)copyWithZone:(NSZone *)zone{
    id jm = [[[self class] allocWithZone:zone] init];
    return jm;
}

- (id)mutableCopyWithZone:(NSZone *)zone{

    return [self copyWithZone:zone];
}

@end
