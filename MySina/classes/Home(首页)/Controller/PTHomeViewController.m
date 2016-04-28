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
#import "PTStatusTool.h"
#import "PTHomeStatusesParam.h"
#import "PTHomeStatusesResult.h"
#import "PTUserInfoParam.h"
#import "PTUserInfoResult.h"
#import "PTUserTool.h"
#import "PTStatusCell.h"
#import "PTStatusFrame.h"

static NSString *cellId = @"HomeViewCell";

@interface PTHomeViewController () <PTPopMenuDelegate>
/**
 *  微博frame数组(存放着所有的微博frame模型)
 */
@property (nonatomic, strong) NSMutableArray *statusFrames;

@property (nonatomic, weak) PTTitleButton *titleButton;

@property (nonatomic, weak) UIRefreshControl *refreshControl;

@property (nonatomic, weak) PTLoadMoreFooter *loadMoreFooter;

@end


@implementation PTHomeViewController

// 懒加载
- (NSMutableArray *)statusFrames
{
	if (!_statusFrames) {
		_statusFrames = [NSMutableArray array];
	}
	return _statusFrames;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// tableView属性设置
	self.tableView.backgroundColor = PTColor(211, 211, 211);
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	// 设置导航栏的内容
	[self setupNavBar];
	
	// 集成刷新控件
	[self setupRefreshControl];
	
	// 获得用户信息，设置title
	[self setupUserInfo];
}

- (void)setupUserInfo
{
	// 1.封装请求参数
	PTUserInfoParam *param = [PTUserInfoParam param];
	param.uid = @([PTAccountTool account].uid.intValue);
	
	// 2.获取用户信息
    [PTUserTool userInfoWithParam:param success:^(PTUserInfoResult *result) {
        PTLog(@"请求成功---");
        // 设置用户名为titile
        [self.titleButton setTitle:result.name forState:UIControlStateNormal];
        
        // 保存，用于程序重启显示使用
        PTAccount *account = [PTAccountTool account];
        account.name = result.name;
        [PTAccountTool save:account];
    } failure:^(NSError *error) {
        PTLog(@"请求失败---%@", error);
    }];
}

- (void)setupNavBar
{
	// 添加左右导航按钮
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_friendsearch" highlightImageName:@"navigationbar_friendsearch_highlighted" target:self action:@selector(searchFriend)];
	self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_pop" highlightImageName:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];

	// 设置中间titleButton
	PTTitleButton *titleButton = [[PTTitleButton alloc] init];
    self.navigationItem.titleView = titleButton;
    self.titleButton = titleButton;
	// 设置尺寸
	titleButton.height = 35;
	// 设置文字，如果有账号缓存，使用用户名，没有就显示“首页”
	NSString *name = [PTAccountTool account].name;
	[titleButton setTitle:(name ? name :@"首页") forState:UIControlStateNormal];
	// 设置图标
	[titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
	// 设置背景
	[titleButton setBackgroundImage:[UIImage imageWithName:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
  // 监听按钮点击
	[titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)setupRefreshControl
{
	// 1.添加下拉刷新控件
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[self.tableView addSubview:refreshControl];
	self.refreshControl = refreshControl;
	
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


/** PTTabBarController调用：
 *  第一次选中的是首页，第二次选中首页，有数据-刷新，没数据-回顶部
 *  第一次选中其他控制器，第二次选中首页，首页有新数据-刷新，没数据-保持以前首页tableView位置
 */
- (void)refresh:(BOOL)fromSelf
{
    PTLog(@"%@", self.tabBarItem.badgeValue);
	if (self.tabBarItem.badgeValue) { // 首页只有有数据，就刷新
		// 刷新数据
		[self loadNewStatuses:self.refreshControl];
		
	} else if (fromSelf) { // 首页没有数据，第二次点击仍然是首页，回顶部
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

/**
 *  微博模型数组--转--微博frame模型数组
 *
 *  @param statuses 微博模型数组
 *
 *  @return 微博frame模型数组
 */
- (NSArray *)statusFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *statusFrames = [NSMutableArray array];
    for (PTStatus *status in statuses) {
        PTStatusFrame *statusFrame = [[PTStatusFrame alloc] init];
        // 传递微博模型数据，计算所有子控件的frame
        statusFrame.status = status;
        [statusFrames addObject:statusFrame];
    }
    return statusFrames;
}

#pragma mark - 加载微博数据
/**
 *  下拉加载最新的微博数据
 */
- (void)loadNewStatuses:(UIRefreshControl *)refreshControl
{
	// 1.封装请求参数
	PTHomeStatusesParam *param = [PTHomeStatusesParam param];
//	param.count = @10; //默认值20
    PTStatusFrame *statusFrame = [self.statusFrames firstObject];
    PTStatus *firstStatus = statusFrame.status;
	if (firstStatus) {
		param.since_id = @([firstStatus.idstr longLongValue]);
	}
	
	// 获取当前用户最新微博数据
	[PTStatusTool homeStatusesWithParam:param success:^(PTHomeStatusesResult *result) {
        PTLog(@"加载微博数据请求成功---");
		// 微博模型frame数组
		NSArray *newStatusFrames = [self statusFramesWithStatuses:result.statuses];
        for (PTStatusFrame *frame in newStatusFrames) {
            PTStatus *status = frame.status;
//            PTLog(@"%d -- %d", status.user.mbtype, status.user.mbrank);
            PTLog(@"%d---", status.pic_urls.count);
        }
		// 将新数据插入到旧数据的最前面
		NSRange range = NSMakeRange(0, newStatusFrames.count);
		
		NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
		[self.statusFrames insertObjects:newStatusFrames atIndexes:indexSet];
		
		// 重新刷新表格
		[self.tableView reloadData];
		
		// 让刷新控件停止刷新（恢复默认的状态）
		[refreshControl endRefreshing];
		
		// 提示用户最新的微博数量
		[self showNewStatusesCount:newStatusFrames.count];
		
		
	} failure:^(NSError *error) {
		PTLog(@"加载微博数据请求失败---");
	  // 让刷新控件停止刷新（恢复默认的状态）
	  [refreshControl endRefreshing];
		
	}];
}

/**
 *  上拉加载更多微博数据
 */
- (void)loadMoreStatuses
{
	// 1.封装请求参数
	PTHomeStatusesParam *param = [PTHomeStatusesParam param];
	
	// 取出已加载的微博数据最后一条的since_id
    PTStatusFrame *statusFrame = [self.statusFrames lastObject];
    PTStatus *lastStatus = statusFrame.status;
	param.max_id = @([lastStatus.idstr longLongValue] - 1);
	
	// 2.获取更多微博数据
	[PTStatusTool homeStatusesWithParam:param success:^(PTHomeStatusesResult *result) {
		// 微博frame模型数组
		NSArray *newStatusFrames = [self statusFramesWithStatuses:result.statuses];
		// 将新数据插入到旧数据的最后面
		[self.statusFrames addObjectsFromArray:newStatusFrames];
		
		// 重新刷新表格
		[self.tableView reloadData];
		
		// 让刷新控件停止刷新（恢复默认的状态）
		[self.loadMoreFooter endRefreshing];
	} failure:^(NSError *error) {
		PTLog(@"请求失败---%@", error);
		// 让刷新控件停止刷新（恢复默认的状态）
		[self.loadMoreFooter endRefreshing];
	}];
}

/**
 *  显示更新微博数量
 */
- (void)showNewStatusesCount:(int)count
{
	// 刷新后未读消息数清零
	[UIApplication sharedApplication].applicationIconBadgeNumber -= self.tabBarItem.badgeValue.intValue;
	self.tabBarItem.badgeValue = nil;
	
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
    self.loadMoreFooter.hidden = self.statusFrames.count == 0;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PTStatusCell *cell = [PTStatusCell cellWithTableView:tableView];
    
    PTStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    cell.statusFrame = statusFrame;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PTStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    return statusFrame.cellHeight;
}

#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *newVc = [[UIViewController alloc] init];
    newVc.view.backgroundColor = [UIColor redColor];
    newVc.title = @"新控制器";
    [self.navigationController pushViewController:newVc animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.statusFrames.count <= 0 || self.loadMoreFooter.refreshing)
    {
        NSLog(@"DoNothing");
        return;
    }
    // 1.tableView剩余显示在window中的高度 = tabtableView的高度 - 移出window上方的高度
    CGFloat delta = scrollView.contentSize.height - scrollView.contentOffset.y;
    // 刚好能完整看到footer的高度
    CGFloat sawFooterH = self.view.height - self.tabBarController.tabBar.height;
    
    // 2.如果能看见整个footer
    if (delta <= (sawFooterH - 0)) { // 等于0时footer刚过在tabBar上
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
