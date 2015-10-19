//
//  CommentsItmModel.h
//  LBzhihu
//
//  Created by lb on 15/10/18.
//  Copyright © 2015年 李波. All rights reserved.
//

#import "JsonModel.h"
#import "CommentsItm.h"

@interface CommentsModel : JsonModel

@property (nonatomic,strong) NSArray *comments;

@end
