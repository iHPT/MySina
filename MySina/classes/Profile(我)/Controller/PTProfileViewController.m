//
//  PTProfileViewController.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTProfileViewController.h"
#import "PTSettingViewController.h"
#import "PTCommonArrowItem.h"
#import "PTCommonGroup.h"

@interface PTProfileViewController ()

@end

@implementation PTProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
		
		// 初始化模型数据
    [self setupGroups];
}

- (void)setupGroups
{
    /** 0组 */
    [self setupGroup0];
    
    /** 1组 */
    [self setupGroup1];
    
    /** 2组 */
    [self setupGroup2];
    
    /** 3组 */
    [self setupGroup3];
}

/**
 *  0组
 */
- (void)setupGroup0
{
    PTCommonGroup *group = [self addGroup];
    
    PTCommonArrowItem *newFriend = [PTCommonArrowItem itemWithTitle:@"新的好友" icon:@"new_friend"];
    newFriend.badgeValue = @"5";
    
    group.items = @[newFriend];
}

/**
 *  1组
 */
- (void)setupGroup1
{
    PTCommonGroup *group = [self addGroup];
    
    PTCommonArrowItem *album = [PTCommonArrowItem itemWithTitle:@"我的相册" icon:@"album"];
    album.subtitle = @"(24300)";
    album.badgeValue = @"17854";
    
    PTCommonArrowItem *collect = [PTCommonArrowItem itemWithTitle:@"我的收藏" icon:@"collect"];
    collect.subtitle = @"(10)";
    collect.badgeValue = @"1";
    
    PTCommonArrowItem *like = [PTCommonArrowItem itemWithTitle:@"赞" icon:@"like"];
    like.subtitle = @"(36)";
    like.badgeValue = @"10";
    
    group.items = @[album, collect, like];
}

/**
 *  2组
 */
- (void)setupGroup2
{
}

/**
 *  3组
 */
- (void)setupGroup3
{
}

/**
 * 点击设置跳转控制器
 */
- (void)setting
{
    PTSettingViewController *setting = [[PTSettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}

@end
