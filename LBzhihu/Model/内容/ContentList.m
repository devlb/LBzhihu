//
//  ContentList.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "ContentList.h"

@implementation ContentList

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"stories"]) {
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *dic in value) {
            [arr addObject:[[StoriesItm alloc] initWithDictionary:dic]];
        }
        self.stories = arr;
    }else if([key isEqualToString:@"top_stories"]){
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *dic in value) {
            [arr addObject:[[StoriesItm alloc] initWithDictionary:dic]];
        }
        self.top_stories = arr;
    }else{
        [super setValue:value forKey:key];
    }
}

@end
