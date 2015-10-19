//
//  CommentsItmModel.m
//  LBzhihu
//
//  Created by lb on 15/10/18.
//  Copyright © 2015年 李波. All rights reserved.
//

#import "CommentsModel.h"

@implementation CommentsModel

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqual:@"comments"]) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            [arr addObject:[[CommentsItm alloc] initWithDictionary:dic]];
        }
        self.comments = arr;
    }else{
        [super setValue:value forKey:key];
    }
}

@end
