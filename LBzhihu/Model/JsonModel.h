//
//  JsonModel.h
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonModel : NSObject<NSCopying,NSMutableCopying>

- (instancetype)initWithDictionary:(NSDictionary *)dic;

-(id)copyWithZone:(NSZone *)zone;

- (id)mutableCopyWithZone:(NSZone *)zone;

@end
