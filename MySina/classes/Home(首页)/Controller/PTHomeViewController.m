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
#import "PTAccount.h"
#import "PTAccountTool.h"
#import "PTStatus.h"
#import "PTUser.h"
#import "PTPhoto.h"
#import "PTLoadMoreFooter.h"
#import "UIImageView+WebCache.h"

static NSString *cellId = @"HomeViewCell";

@interface PTHomeViewController () <PTPopMenuDelegate>
/**
 *  微博数组(存放着所有的微博数据)
 */
@property (nonatomic, copy) NSMutableArray *statuses;

@property (nonatomic, strong) PTLoadMoreFooter *loadMoreFooter;

@end

@implementation PTHomeViewController

// 懒加载
- (NSMutableArray *)statuses
{
	if (!_statuses) {
		_statuses = [NSMutableArray array];
	}
	return _statuses;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// 设置导航栏的内容
	[self setupNavBar];
	
	// 集成刷新控件
	[self setupRefreshControl];
}

- (void)setupNavBar
{
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

- (void)setupRefreshControl
{
	// 1.添加下拉刷新控件
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[self.tableView addSubview:refreshControl];
	
	// 2.监听状态
	[refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
	
	// 3.让刷新控件自动进入刷新状态
	[refreshControl beginRefreshing];
	
	// 4.加载数据
	[self refreshControlValueChanged:refreshControl];
	
	// 5.添加上拉加载更多控件
	PTLoadMoreFooter *loadMoreFooter = [[PTLoadMoreFooter alloc] init];
	self.tableView.tableFooterView = loadMoreFooter;
	self.loadMoreFooter = loadMoreFooter;
}

/**
 *  当下拉刷新控件进入刷新状态（转圈圈）的时候会自动调用
 */
- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl
{
    [self loadNewStatuses:refreshControl];
}

#pragma mark - 加载微博数据
/**
 *  下拉加载最新的微博数据
 */
- (void)loadNewStatuses:(UIRefreshControl *)refreshControl
{
	// 1.获得请求管理者
	AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
	
	// 2.封装请求参数
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	params[@"access_token"] = [PTAccountTool account].access_token;
	//params[@"count"] = @10; //默认值20
	
	// 取出已加载的微博数据第一条的since_id
	PTStatus *firstStatus = [self.statuses firstObject];
	if (firstStatus) {
		params[@"since_id"] = @([firstStatus.idstr longLongValue]);
	}
	
	// 3.发送POST请求
	[mgr GET:SinaGetStatusesURL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *resultDictionary) {
			//PTLog(@"%@", resultDictionary);
	    
	    // 取出微博字典数组
	    NSArray *statusesArray = resultDictionary[@"statuses"];
	    // 微博字典数组 --> 微博模型数组
	    NSArray *newStatuses = [PTStatus objectArrayWithKeyValuesArray:statusesArray];
	    
	    // 将新数据插入到旧数据的最前面
	    NSRange range = NSMakeRange(0, newStatuses.count);
        PTLog(@"%dcount----", newStatuses.count);
        
	    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
	    [self.statuses insertObjects:newStatuses atIndexes:indexSet];
	    
	    // 重新刷新表格
	    [self.tableView reloadData];
	    
	    // 让刷新控件停止刷新（恢复默认的状态）
	    [refreshControl endRefreshing];
	    
	    // 提示用户最新的微博数量
	    [self showNewStatusesCount:newStatuses.count];
	    
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			
	    PTLog(@"请求失败---");
	    // 让刷新控件停止刷新（恢复默认的状态）
	    [refreshControl endRefreshing];
	}];
}

/**
 *  上拉加载更多微博数据
 */
- (void)loadMoreStatuses
{
	// 1.获得请求管理者
	AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
	
	// 2.封装请求参数
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	params[@"access_token"] = [PTAccountTool account].access_token;
	//params[@"count"] = 10; 默认值20
	
	// 取出已加载的微博数据第一条的since_id
	PTStatus *lastStatus = [self.statuses lastObject];
	if (lastStatus) {
		params[@"max_id"] = @([lastStatus.idstr longLongValue] - 1);
	}
	
	// 3.发送POST请求
	[mgr GET:SinaGetStatusesURL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *resultDictionary) {
			PTLog(@"%@count--------", resultDictionary);
	    
	    // 取出微博字典数组
	    NSArray *statusesArray = resultDictionary[@"statuses"];
	    // 微博字典数组 --> 微博模型数组
	    NSArray *moreStatuses = [PTStatus objectArrayWithKeyValuesArray:statusesArray];
	    
	    // 将新数据插入到旧数据的最后面
	    [self.statuses addObjectsFromArray:moreStatuses];
	    
	    // 重新刷新表格
	    [self.tableView reloadData];
	    
	    // 让刷新控件停止刷新（恢复默认的状态）
	    [self.loadMoreFooter endRefreshing];
	    
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			
	    PTLog(@"请求失败---");
	    // 让刷新控件停止刷新（恢复默认的状态）
	    [self.loadMoreFooter endRefreshing];
	}];
	
	
}

- (void)showNewStatusesCount:(int)count
{
	// 1.创建一个UILabel
	UILabel *label = [[UILabel alloc] init];
	
	// 2.显示文字
	if (count) {
	    label.text = [NSString stringWithFormat:@"共有%d条新的微博数据", count];
	} else {
	    label.text = @"没有最新的微博数据";
	}
	
	// 3.设置Label属性
    label.backgroundColor = [UIColor orangeColor];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [UIFont systemFontOfSize:14];
	
	// 4.设置frame
	CGFloat labelH = 35;
	label.frame = CGRectMake(0, 64 - labelH, ScreenWidth, labelH);
	
	// 5.添加到导航控制器的view，且在TableView上面，NavigationBar下面
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
	
	CGFloat duration = 0.75;
	label.alpha = 0.0;
    
	[UIView animateWithDuration:duration animations: ^{
		// 往下移动一个label的高度
		label.transform = CGAffineTransformMakeTranslation(0, labelH);
		label.alpha = 0.9;
		
	} completion:^(BOOL finished) { // 向下移动完毕
		// 延迟delay秒后，再执行动画
		CGFloat delay = 1.0;
		[UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations: ^{
			// 恢复到原来的位置
			label.transform = CGAffineTransformIdentity;
			label.alpha = 0.0;
			
		} completion:^(BOOL finished) {
			// 删除控件
			[label removeFromSuperview];
		}];
	}];
	
	
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

#pragma mark - Table view 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.loadMoreFooter.hidden = self.statuses.count == 0;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statuses.count;
    PTLog(@"%d", self.statuses.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    
    // 取出字典模型
    PTStatus *status = self.statuses[indexPath.row];
    
    // 取出用户模型
    PTUser *user = status.user;
    
    // 设置Cell
    cell.textLabel.text = status.text;
    //cell.detailTextLabel.text = status.text;
    cell.detailTextLabel.text = user.name;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageWithName:@"avatar_default_small"]];
    
    return cell;
}

#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *newVc = [[UIViewController alloc] init];
    newVc.view.backgroundColor = [UIColor redColor];
    newVc.title = @"新控制器";
    [self.navigationController pushViewController:newVc animated:YES];

    PTLog(@"%u", self.navigationController.viewControllers.count);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.statuses.count <= 0 || self.loadMoreFooter.refreshing)
    {
        NSLog(@"跳出盘帝国");
        return;
    }
    // 1.差距
    CGFloat delta = scrollView.contentSize.height - scrollView.contentOffset.y;
    // 刚好能完整看到footer的高度
    CGFloat sawFooterH = self.view.height - self.tabBarController.tabBar.height;
    
    // 2.如果能看见整个footer
    if (delta <= (sawFooterH - 0)) {
        NSLog(@"看全了footer");
        // 进入上拉刷新状态
        [self.loadMoreFooter beginRefreshing];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 加载更多的微博数据
            [self loadMoreStatuses];
        });
    }
}

@end
