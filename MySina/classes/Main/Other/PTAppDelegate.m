//
//  HMAppDelegate.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTAppDelegate.h"
#import "PTOAuthViewController.h"
#import "PTControllerTool.h"
#import "PTAccountTool.h"
#import "SDWebImageManager.h"
#import "AFNetworking.h"

@implementation PTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 注册允许接受提醒，声音，图标标记通知，和相机一样，第一次使用会提示
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 2.显示窗口(成为主窗口)
    [self.window makeKeyAndVisible];
    
    // 3.设置窗口的根控制器
    PTAccount *account = [PTAccountTool account];
    if (account) {
        [PTControllerTool chooseRootViewController];
    } else { // 没有登录过
        PTOAuthViewController *oAuthVc = [[PTOAuthViewController alloc] init];
        self.window.rootViewController = oAuthVc;
    }
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    	switch (status) {
    		case AFNetworkReachabilityStatusUnknown:
    		case AFNetworkReachabilityStatusNotReachable:
    			PTLog(@"未知网络");
    			[MBProgressHUD showError:@"网络异常，请检查网络设置！"];
    			break;
    		
    		case AFNetworkReachabilityStatusReachableViaWiFi:
    			PTLog(@"WIFI网络");
    			break;
    		
    		case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                PTLog(@"手机自带网络");
                break;
    	}
    }];
    [mgr startMonitoring];
    
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	// 赶紧清除图片内存缓存
	[[SDWebImageManager sharedManager].imageCache clearMemory];
	
	// 赶紧停止正在进行的图片下载操作
	[[SDWebImageManager sharedManager] cancelAll];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 进入后台继续接受消息
    // 提醒操作系统：当前这个应用程序需要在后台开启一个任务
    // 操作系统会允许这个应用程序在后台保持运行状态（能够持续的时间是不确定）
    // 为了延长这个时间，可以欺骗操作系统，设置该应用为音乐播放程序（允许后台发放，info中配置，添加属性），插入0KB的音乐文件无限循环播放，但未调用相应API，可能被发现
    // 
//    UIBackgroundTaskIdentifier taskID = [application beginBackgroundTaskWithExpirationHandler:^ {
//    [application endBackgroundTask:taskID];
//    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
