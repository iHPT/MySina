//
//  PTCommonViewController.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//	发现和我通用控制器

#import "PTCommonViewController.h"
#import "PTCommonCell.h"
#import "PTCommonGroup.h"
#import "PTCommonCheckGroup.h"
#import "PTCommonItem.h"

@interface PTCommonViewController ()
/** 存放所有组的数据模型 */
@property (nonatomic, strong) NSMutableArray *groups;
@end


@implementation PTCommonViewController

- (NSMutableArray *)groups
{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableview属性
    [self setupTableView];
    
//    PTLog(@"%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    PTLog(@"%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
}

/** 设置tableView属性 */
- (void)setupTableView
{
	// 1.去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 2.设置每一组头部尾部的高度
    self.tableView.sectionHeaderHeight = PTCommonTableViewSectionHeaderHeight;
    self.tableView.sectionFooterHeight = PTCommonTableViewSectionFooterHeight;
    
    // 3.设置背景色
    self.tableView.backgroundColor = PTGlobalBackgroundColor;
		
	// 4. 调整上沿滚动区域(内容)，第0行默认y=35
    self.tableView.contentInset = UIEdgeInsetsMake(PTStatusCellMargin - 35, 0, 0, 0);
}

/** 添加group */
- (PTCommonGroup *)addGroup
{
	PTCommonGroup *group = [[PTCommonGroup alloc] init];
	[self.groups addObject:group];
    return group;
}

- (PTCommonCheckGroup *)addCheckGroup
{
    PTCommonCheckGroup *checkGroup = [[PTCommonCheckGroup alloc] init];
    [self.groups addObject:checkGroup];
    return checkGroup;
}

- (id)groupInSection:(NSInteger)section
{
    return self.groups[section];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PTCommonGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PTCommonCell *cell = [PTCommonCell cellWithTableView:tableView];
    
    PTCommonGroup *group = self.groups[indexPath.section];
    PTCommonItem *item = group.items[indexPath.row];
    cell.item = item;
    // indexPath的setter方法中设置cell背景图片
    cell.indexPath = indexPath;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	PTCommonGroup *group = self.groups[section];
	return group.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	PTCommonGroup *group = self.groups[section];
	return group.footer;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 50;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 50;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
		// 1.取出这行对应的模型
		PTCommonGroup *group = self.groups[indexPath.section];
		PTCommonItem *item = group.items[indexPath.row];
		
		// 2.判断有没有设置目标控制器
		if (item.destVc) {
			UIViewController *newVc = [[[item.destVc class] alloc] init];
            newVc.title = item.title;
            [self.navigationController pushViewController:newVc animated:YES];
		}
		
		// 3.判断有没有想要执行的操作(block)
		if (item.operation) {
			item.operation();
		};
}

@end