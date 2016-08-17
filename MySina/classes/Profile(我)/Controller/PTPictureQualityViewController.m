//
//  PTPictureQualityViewController.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//	图片质量设置

#import "PTPictureQualityViewController.h"
#import "PTCommonItem.h"
#import "PTCommonCheckItem.h"
#import "PTCommonGroup.h"
#import "PTCommonCheckGroup.h"
#import "PTCommonCell.h"

@interface PTPictureQualityViewController ()
@property (nonatomic, strong) PTCommonCheckGroup *checkGroup;
@end

@implementation PTPictureQualityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(PTStatusCellMargin - 18, 0, 0, 0);
	
    // 初始化模型数据
    [self setupGroups];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    PTCommonCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
//    PTLog(@"cell.y = %f", cell.y);
}

- (void)setupGroups
{
    /** 0组 */
    [self setupGroup0];
    
    /** 1组 */
    [self setupGroup1];
    
    /** 2组 */
    [self setupGroup2];
}

- (void)setupGroup2
{
    PTCommonGroup *group = [self addGroup];
    
    PTCommonItem *item = [PTCommonItem itemWithTitle:@"查看上传图片质量"];
    item.operation = ^{
        
        PTCommonCheckItem *checkItem = self.checkGroup.items[self.checkGroup.checkedIndex];
//        PTLog(@"%@", checkItem.title);
    };
    
    group.items = @[item];
}

- (void)setupGroup0
{
    PTCommonCheckGroup *checkGroup = [self addCheckGroup];
    
    PTCommonCheckItem *high = [PTCommonCheckItem itemWithTitle:@"高清"];
    high.subtitle = @"(建议在wifi或3G网络使用)";
    
    PTCommonCheckItem *normal = [PTCommonCheckItem itemWithTitle:@"普通"];
    normal.subtitle = @"(上传速度快，省流量)";
    
    checkGroup.header = @"上传图片质量";
    checkGroup.checkedIndex = 1; // checkedIndex从沙盒中读取
    checkGroup.items = @[high, normal];
    self.checkGroup = checkGroup;
}

- (void)setupGroup1
{
    PTCommonCheckItem *normal = [PTCommonCheckItem itemWithTitle:@"普通"];
    normal.subtitle = @"(上传速度快，省流量)";
    
    PTCommonCheckItem *high = [PTCommonCheckItem itemWithTitle:@"高清"];
    high.subtitle = @"(建议在wifi或3G网络使用)";
    
    PTCommonCheckGroup *group = [self addCheckGroup];
    group.header = @"下载图片质量";
    group.items = @[high, normal];
    group.checkedIndex = 0; // checkedIndex从沙盒中读取
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取出这组对应的group对象
    PTCommonCheckGroup *group = [self groupInSection:indexPath.section];
    
    if ([group isKindOfClass:[PTCommonCheckGroup class]]) {
        // 2.选中这组的点击的行
        group.checkedIndex = indexPath.row;
        
        // 将勾选的位置存进沙盒
        
        // 3.刷新表格
        [self.tableView reloadData];
    } else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

@end
