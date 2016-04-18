//
//  PTControllerTool.m
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTControllerTool.h"
#import "PTNewfeatureViewController.h"
#import "PTTabBarController.h"

@implementation PTControllerTool

+ (void)chooseRootViewController
{
    // 获取沙盒版本号
    NSString *bundleVersion = @"CFBundleVersion";
    //    NSString *budnleVersion = (__bridge NSString *)kCFBundleVersionKey;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastBundleVersion = [userDefaults objectForKey:bundleVersion];
    
    // 获得当前打开软件的版本号，项目plist文件的CFBundleVersion键值
    NSString *currentBundleVersion = [NSBundle mainBundle].infoDictionary[bundleVersion];
    
    // 获取应用程序主Window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([currentBundleVersion isEqualToString:lastBundleVersion]) { // 如果和上次版本号相同，跳过版本新特性
        window.rootViewController = [[PTTabBarController alloc] init];
        
    } else { // 和上次不相等，显示版本新特性
        window.rootViewController = [[PTNewfeatureViewController alloc] init];
        
        // 存储这次使用的软件版本
        [userDefaults setObject:currentBundleVersion forKey:bundleVersion];
        [userDefaults synchronize];
    }

}

@end
