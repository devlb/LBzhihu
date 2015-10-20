//
//  LeftViewController.h
//  LBzhihu
//
//  Created by lb on 15/10/20.
//  Copyright © 2015年 李波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkTool.h"

@interface LeftViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) id <SelectThemeDelegate> themDelegate;
@property (nonatomic,strong) NSString *headViewTitle;
@property (nonatomic,strong) NSString *themeId;
@property (nonatomic,strong) UITableView *tableView;

@end

