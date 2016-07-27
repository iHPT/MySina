//
//  PTDiscoverViewController.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTDiscoverViewController.h"
#import "PTSearchBar.h"
#import "PTCommonArrowItem.h"
#import "PTMoreViewController.h"
#import "PTCommonGroup.h"

@interface PTDiscoverViewController ()

@property (nonatomic, weak) PTSearchBar *searchBar;

@end
@implementation PTDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏中间放一个搜索框
    [self setupSearchBar];
    
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
    
    /** 1组 */
    [self setupGroup1];
    
    /** 2组 */
    [self setupGroup2];
}

/**
 *  0组
 */
- (void)setupGroup0
{
    PTCommonGroup *group = [self addGroup];
    
    PTCommonArrowItem *hot_status = [[PTCommonArrowItem alloc] initWithTitle:@"热门微博" icon:@"hot_status"];
    hot_status.subtitle = @"笑话，娱乐，神最右都搬到这啦";
    hot_status.operation = ^() {
        PTLog(@"点击了热门微博...");
    };
    
    PTCommonArrowItem *findPeople = [[PTCommonArrowItem alloc] initWithTitle:@"找人" icon:@"find_people"];
    findPeople.subtitle = @"名人、有意思的人尽在这里";
    
    group.items = @[hot_status, findPeople];
}

/**
 *  1组
 */
- (void)setupGroup1
{
    PTCommonGroup *group = [self addGroup];
    
    PTCommonArrowItem *gameCenter = [PTCommonArrowItem itemWithTitle:@"游戏中心" icon:@"game_center"];
    PTCommonArrowItem *near = [PTCommonArrowItem itemWithTitle:@"周边" icon:@"near"];
    PTCommonArrowItem *app = [PTCommonArrowItem itemWithTitle:@"应用" icon:@"app"];
    app.operation = ^{
        PTLog(@"点击了应用.....");
    };
    
    group.items = @[gameCenter, near, app];
}

/**
 *  2组
 */
- (void)setupGroup2
{
    PTCommonGroup *group = [self addGroup];
    
    PTCommonArrowItem *video = [PTCommonArrowItem itemWithTitle:@"视频" icon:@"video"];
    PTCommonArrowItem *music = [PTCommonArrowItem itemWithTitle:@"音乐" icon:@"music"];
    PTCommonArrowItem *movie = [PTCommonArrowItem itemWithTitle:@"电影" icon:@"movie"];
    PTCommonArrowItem *cast = [PTCommonArrowItem itemWithTitle:@"播客" icon:@"cast"];
    
    PTCommonArrowItem *more = [PTCommonArrowItem itemWithTitle:@"更多" icon:@"more"];
    more.destVc = [PTMoreViewController class];
    
    group.items = @[video, music, movie, cast, more];
}


/**
 *  导航栏中间放一个搜索框
 */
- (void)setupSearchBar
{
    PTSearchBar *searchBar = [PTSearchBar searchBar];
    searchBar.width = 300;
    searchBar.height = 30;
    searchBar.placeholder = @"请输入搜索条件";
    searchBar.font = [UIFont systemFontOfSize:15];
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.searchBar endEditing:YES];
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
}

@end
