//
//  ThemeItm.m
//  LBzhihu
//
//  Created by lb on 15/9/2.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "ThemeItm.h"

@implementation ThemeItm

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        [super setValue:value forKey:@"desc"];
    }else if ([key isEqualToString:@"id"]){
        [super setValue:value forKey:@"themeId"];
    }else{
        [super setValue:value forKey:key];
    }
    
}

@end
