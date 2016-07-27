//
//  PTMoreViewController.h
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//	点击发现中更多选项进入moreViewController

#import "PTMoreViewController.h"
#import "PTCommonArrowItem.h"
#import "PTCommonGroup.h"

@implementation PTMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化模型数据
    [self setupGroups];
}

/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    /** 0组 */
    [self setupGroup0];
}

/**
 *  0组
 */
- (void)setupGroup0
{
	PTCommonGroup *group = [self addGroup];
		
    PTCommonArrowItem *shop = [PTCommonArrowItem itemWithTitle:@"精选商品" icon:@"shop"];
    PTCommonArrowItem *lottery = [PTCommonArrowItem itemWithTitle:@"彩票" icon:@"lottery"];
    PTCommonArrowItem *food = [PTCommonArrowItem itemWithTitle:@"美食" icon:@"food"];
    PTCommonArrowItem *car = [PTCommonArrowItem itemWithTitle:@"汽车" icon:@"car"];
    PTCommonArrowItem *tour = [PTCommonArrowItem itemWithTitle:@"旅游" icon:@"tour"];
    PTCommonArrowItem *news = [PTCommonArrowItem itemWithTitle:@"新浪新闻" icon:@"news"];
    PTCommonArrowItem *recommend = [PTCommonArrowItem itemWithTitle:@"官方推荐" icon:@"recommend"];
    PTCommonArrowItem *read = [PTCommonArrowItem itemWithTitle:@"读书" icon:@"read"];
    
    group.items = @[shop, lottery, food, car, tour, news, recommend, read];
}

@end
