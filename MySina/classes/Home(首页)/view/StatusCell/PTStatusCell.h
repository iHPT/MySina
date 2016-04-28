//
//  PTStatusCell.h
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTStatusFrame;
@interface PTStatusCell : UITableViewCell

@property (nonatomic, strong) PTStatusFrame *statusFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
