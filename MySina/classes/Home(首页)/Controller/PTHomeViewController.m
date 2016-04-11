//
//  PTHomeViewController.m
//  MySina
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTHomeViewController.h"
#import "PTTitleButton.h"
#import "PTPopMenu.h"

static NSString *cellId = @"HomeViewCell";

@interface PTHomeViewController () <PTPopMenuDelegate>

@end

@implementation PTHomeViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
	// 添加左右导航按钮
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_friendsearch" highlightImageName:@"navigationbar_friendsearch_highlighted" target:self action:@selector(searchFriend)];
	self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_pop" highlightImageName:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];

	// 设置中间titleButton
	PTTitleButton *titleButton = [[PTTitleButton alloc] init];
	[titleButton setTitle:@"金桔柠檬" forState:UIControlStateNormal];
    titleButton.width = 120;
    titleButton.height = 35;
    
	[titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
	[titleButton setBackgroundImage:[UIImage imageWithName:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
    
	[titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.titleView = titleButton;
}

- (void)titleClick:(PTTitleButton *)titleButton
{
	[titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
	//button.backgroundColor = [UIColor yellowColor];
	
	PTPopMenu *menu = [[PTPopMenu alloc] initWithContentView:button];
	menu.arrowPosition = PTPopMenuArrowPositionCenter;
	menu.delegate = self;
	[menu showInRect:CGRectMake(120, 64, 80, 200)];
}

#pragma -mark PTPopMenuDelegate
- (void)popMenuDidDismissed:(PTPopMenu *)popMenu
{
	PTTitleButton *titleButton = (PTTitleButton *)self.navigationItem.titleView;
	[titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
}

- (void)searchFriend
{
	PTLog(@"searchFriend---");
}

- (void)pop
{
    PTLog(@"pop---");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"首页测试数据--%i", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *newVc = [[UIViewController alloc] init];
    newVc.view.backgroundColor = [UIColor redColor];
    newVc.title = @"新控制器";
    [self.navigationController pushViewController:newVc animated:YES];

    PTLog(@"%d", self.navigationController.viewControllers.count);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
