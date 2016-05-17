//
//  PTSettingViewController.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTSettingViewController.h"
#import "PTCommonArrowItem.h"
#import "PTCommonGroup.h"
#import "PTGeneralSettingViewController.h"

@interface PTSettingViewController ()

@end

@implementation PTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    // 初始化模型数据
    [self setupGroups];
    
    // 添加底部的控件
    [self setupFooter];
}

/**
 *  添加底部的控件
 */
- (void)setupFooter
{
    // 添加退出当前帐号 按钮
    UIButton *logout = [[UIButton alloc] init];
    self.tableView.tableFooterView = logout;
    
    // 设置文字
    [logout setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [logout setTitleColor:PTColor(186, 24, 23) forState:UIControlStateNormal];
    logout.titleLabel.font = [UIFont systemFontOfSize:15];
    // 设置背景
    [logout setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    
    
//    if (!iOS7) {
//        self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
//    }
    
    // 设置高度(不用设置宽度)
    logout.height = 40;
    
    // tableView的tableFooterView和tableHeaderView的宽度默认跟tableView一样
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
    
    PTCommonArrowItem *account = [PTCommonArrowItem itemWithTitle:@"帐号管理"];
    group.items = @[account];
}

- (void)setupGroup1
{
    PTCommonGroup *group = [self addGroup];
    
    PTCommonArrowItem *theme = [PTCommonArrowItem itemWithTitle:@"主题、背景"];
    group.items = @[theme];
}

- (void)setupGroup2
{
    PTCommonGroup *group = [self addGroup];
    
    PTCommonArrowItem *notice = [PTCommonArrowItem itemWithTitle:@"通知和提醒"];
    PTCommonArrowItem *general = [PTCommonArrowItem itemWithTitle:@"通用设置"];
    general.destVc = [PTGeneralSettingViewController class];
    
    PTCommonArrowItem *safe = [PTCommonArrowItem itemWithTitle:@"隐私与安全"];
    group.items = @[notice, general, safe];
}

- (void)setupGroup3
{
    PTCommonGroup *group = [self addGroup];
    
    PTCommonArrowItem *opinion = [PTCommonArrowItem itemWithTitle:@"意见反馈"];
    PTCommonArrowItem *about = [PTCommonArrowItem itemWithTitle:@"关于微博"];
    group.items = @[opinion, about];
}

@end
