//
//  PTTabBarController.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTTabBarController.h"
#import "PTNavigationController.h"
#import "PTHomeViewController.h"
#import "PTDiscoverViewController.h"
#import "PTMessageViewController.h"
#import "PTProfileViewController.h"
#import "PTTabBar.h"
#import "PTComposeViewController.h"
#import "PTAccount.h"
#import "PTAccountTool.h"
#import "PTUnreadCountParam.h"
#import "PTUnreadCountResult.h"
#import "PTUserTool.h"

@interface PTTabBarController() <PTTabBarDelegate>

@property (nonatomic, weak) PTHomeViewController *home;

@property (nonatomic, weak) PTMessageViewController *message;

@property (nonatomic, weak) PTProfileViewController *profile;

@property (nonatomic, weak) PTTabBar *customTabBar;

@property (nonatomic, weak) UIViewController *lastSelectedViewController;

@end


@implementation PTTabBarController


- (PTTabBar *)customTabBar
{
    if (!_customTabBar) {
        PTTabBar *customTabBar = [[PTTabBar alloc] init];
        customTabBar.frame = self.tabBar.bounds;
        customTabBar.delegate = self;
        [self.tabBar addSubview:customTabBar];
        _customTabBar = customTabBar;
    }
    return _customTabBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加子控制器
    [self addAllChildViewController];
    
    // 获取用户的未读消息数，然后利用定时器每隔一段时间获取一次
    [self getUnreadCount];
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(getUnreadCount) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

//取出系统自带的tabbar并把里面的按钮(UITabBarButton:UIControl)删除掉，剩下自定义tabBar:UIView
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    for ( UIView * child in  self.tabBar.subviews) {
        
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

// 获取用户未读信息
- (void)getUnreadCount
{
	PTUnreadCountParam *param = [PTUnreadCountParam param];
	param.uid = @([PTAccountTool account].uid.intValue);
	
	[PTUserTool unreadCountWithParam:param success:^(PTUnreadCountResult *result) {
		// 显示未读新微博数
		self.home.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.status];
		// 显示未读新消息数
		self.message.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.messageCount];
		// 显示未读关于我的所有消息数
		self.profile.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.follower];
        
		// 应用程序图标上显示所有的未读数
        // set to 0 to hide. default is 0. In iOS 8.0 and later, your application must register for user notifications using -[UIApplication registerUserNotificationSettings:] before being able to set the icon badge.
        [UIApplication sharedApplication].applicationIconBadgeNumber = result.totalCount;
//        PTLog(@"%d--", [UIApplication sharedApplication].applicationIconBadgeNumber);
		
	} failure:^(NSError *error) {
		PTLog(@"请求失败---%@", error);
	}];
}

/**
 *  添加所有的子控制器
 */
- (void)addAllChildViewController
{
    PTHomeViewController *home = [[PTHomeViewController alloc] init];
    [self addChildVc:home title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    self.home = home;
    self.lastSelectedViewController = home;
    
    PTMessageViewController *message = [[PTMessageViewController alloc] init];
    [self addChildVc:message title:@"消息" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    self.message = message;
    
    PTDiscoverViewController *discover = [[PTDiscoverViewController alloc] init];
    [self addChildVc:discover title:@"发现" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    
    PTProfileViewController *profile = [[PTProfileViewController alloc] init];
    [self addChildVc:profile title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
		self.profile = profile;
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    childVc.navigationItem.title = title;
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageWithName:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName]; // 调用Image分类方法设置选中图片
    if (iOS7) {
        // 在iOS7中, 会对selectedImage的图片进行再次渲染为蓝色，声明这张图片用原图(别渲染)
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    
    PTNavigationController *navVc = [[PTNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:navVc];
    // 为自定义tabBar的每个按键添加模型
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

#pragma mark - PTTabBarDelegate
- (void)tabBarDidClickPlusButton:(PTTabBar *)tabBar
{
    // 弹出发微博控制器
    PTComposeViewController *composeVc = [[PTComposeViewController alloc] init];
    PTNavigationController *navVc = [[PTNavigationController alloc] initWithRootViewController:composeVc];
    [self presentViewController:navVc animated:YES completion:nil];
}

#pragma mark - PTTabBarDelegate
- (void)tabBar:(PTTabBar *)tabBar didSelectButtonAtIndex:(NSInteger)index
{
    // 进行控制器跳转，当前选中控制器为导航栏控制器
    self.selectedIndex = index;
    PTNavigationController *nav = self.selectedViewController;
    
    // 首页处理
    if (nav.topViewController == self.home) {
    	if (self.lastSelectedViewController == self.home) { // 第二次点击首页按钮刷新数据
    		[self.home refresh:YES];
    	} else { // 从其他控制器跳转过来，若有数据，刷新数据，若没有保持原来首页控制器tableView位置
    		[self.home refresh:NO];
    	}
    }
    
    self.lastSelectedViewController = nav.topViewController;
}


@end