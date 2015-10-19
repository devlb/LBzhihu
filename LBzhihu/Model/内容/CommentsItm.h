//
//  CommentsModel.h
//  LBzhihu
//
//  Created by lb on 15/10/18.
//  Copyright © 2015年 李波. All rights reserved.
//

#import "JsonModel.h"

@interface CommentsItm : JsonModel

@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *likes;

@end
