//
//  PTCommonCell.h
//  MySina
//
//  Created by hpt on 16/5/12.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PTCommonItem;

@interface PTCommonCell : UITableViewCell

@property (nonatomic, strong) PTCommonItem *item;

/** 背景图片有上边圆角和下边圆角，需根据cell数量来设置背景图片 */
@property (nonatomic, strong) NSIndexPath *indexPath;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
