
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

- (id)copyWithZone:(nullable NSZone *)zone{
    DetailsModel *model = [super copyWithZone:zone];
    model.body = self.body.copy;
    model.image_source = self.image_source.copy;
    model.title = self.title.copy;
    model.image = self.image.copy;
    model.share_url = self.share_url.copy;
    model.ga_prefix = self.ga_prefix.copy;
    model.type = self.type.copy;
    model.css = self.css.copy;
    model.storiesId = self.storiesId.copy;
    return model;
}


- (id)mutableCopyWithZone:(nullable NSZone *)zone{
    DetailsModel *model = [super mutableCopyWithZone:zone];
   
    model.body = self.body.mutableCopy;
    model.image_source = self.image_source.mutableCopy;
    model.title = self.title.mutableCopy;
    model.image = self.image.mutableCopy;
    model.share_url = self.share_url.mutableCopy;
    model.ga_prefix = self.ga_prefix.mutableCopy;
    model.type = self.type.mutableCopy;
    model.css = self.css.mutableCopy;
    model.storiesId = self.storiesId.mutableCopy;
    return model;

}

@end
