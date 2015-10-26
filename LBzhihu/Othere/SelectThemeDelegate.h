//
//  SelectThemeDelegate.h
//  LBzhihu
//
//  Created by lb on 15/10/20.
//  Copyright © 2015年 李波. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SelectThemeDelegate <NSObject>



- (void)selectThemeIdWithThemeId:(NSString *)themeId headViewTitle:(NSString *)headViewTitle;

@end
