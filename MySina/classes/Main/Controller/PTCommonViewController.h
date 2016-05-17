//
//  PTCommonViewController.h
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//	发现和我通用控制器

#import <UIKit/UIKit.h>
@class PTCommonGroup, PTCommonCheckGroup;

@interface PTCommonViewController : UITableViewController

/** 添加一个group到groups数组 */
- (PTCommonGroup *)addGroup;

/** 添加一个checkGroup到groups数组 */
- (PTCommonCheckGroup *)addCheckGroup;

/** 通过section获取group */
- (id)groupInSection:(NSInteger)section;

@end