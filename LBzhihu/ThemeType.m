//
//  ThemeType.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "ThemeType.h"

@implementation ThemeType

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"others"]) {
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *dic in value) {
            [arr addObject:[[ThemeItm alloc] initWithDictionary:dic]];
        }
        self.others = arr;
    }else{
        [super setValue:value forKey:key];
    }
}

@end
