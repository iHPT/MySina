//
//  PTGeneralSettingViewController.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#define PTSDImageCacheDirectory [NSString stringWithFormat:@"%@/default/com.hackemist.SDWebImageCache.default", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]]
#import "PTGeneralSettingViewController.h"
#import "PTCommonGroup.h"
#import "PTCommonArrowItem.h"
#import "PTCommonSwitchItem.h"
#import "PTCommonLabelItem.h"
#import "PTPictureQualityViewController.h"
#import "NSFileManager+Size.h"

@interface PTGeneralSettingViewController ()

@end

@implementation PTGeneralSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    /** 4组 */
    [self setupGroup4];
}

- (void)setupGroup0
{
    PTCommonGroup *group = [self addGroup];
    
    PTCommonLabelItem *readMode = [PTCommonLabelItem itemWithTitle:@"阅读模式"];
    readMode.text = @"有图模式";
    
    PTCommonLabelItem *font = [PTCommonLabelItem itemWithTitle:@"字号大小"];
    font.text = @"大";
    
    PTCommonSwitchItem *showMark = [PTCommonSwitchItem itemWithTitle:@"显示备注"];
    
    group.items = @[readMode, font, showMark];
}

- (void)setupGroup1
{
    PTCommonGroup *group = [self addGroup];
    
    PTCommonArrowItem *picture = [PTCommonArrowItem itemWithTitle:@"图片质量设置"];
    picture.destVc = [PTPictureQualityViewController class];
    
    group.items = @[picture];
}

- (void)setupGroup2
{
    PTCommonGroup *group = [self addGroup];
    
    PTCommonSwitchItem *voice = [PTCommonSwitchItem itemWithTitle:@"声音"];
    
    group.items = @[voice];
}

- (void)setupGroup3
{
    PTCommonGroup *group = [self addGroup];
    
    PTCommonLabelItem *language = [PTCommonLabelItem itemWithTitle:@"多语言环境"];
    language.text = @"跟随系统";
    
    group.items = @[language];
}

- (void)setupGroup4
{
    PTCommonGroup *group = [self addGroup];
    
    PTCommonArrowItem *clearCache = [PTCommonArrowItem itemWithTitle:@"清除图片缓存"];
    CGFloat imageCache = [self getImageCache];
    NSString *fileSize = [NSString stringWithFormat:@"(%.1fM)", imageCache];
//    PTLog(@"fileSize==%@", fileSize);
    fileSize = [fileSize stringByReplacingOccurrencesOfString:@".0" withString:@""];
    clearCache.subtitle = fileSize;
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(clearCache) weakClearCache = clearCache;
    clearCache.operation = ^ {
        PTLog(@"%@", PTSDImageCacheDirectory);
        [MBProgressHUD showMessage:@"正在清除缓存..."];
        
        // 清除缓存
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:PTSDImageCacheDirectory error:nil];
        
        // 设置subtitle
        weakClearCache.subtitle = nil;
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        [MBProgressHUD hideHUD];
    };
    PTCommonArrowItem *clearHistory = [PTCommonArrowItem itemWithTitle:@"清空搜索历史"];
    
    group.items = @[clearCache, clearHistory];
}

- (void)dealloc
{
    PTLog(@"PTGeneralSettingViewController---dealloc");
}

/**
 *  获取文件文件大小
 */
- (CGFloat)getImageCache
{
    // 创建文件管理者，计算文件大小
    NSFileManager *fm = [NSFileManager defaultManager];
    CGFloat fileSize = [fm fileMegaBytesAtPath:PTSDImageCacheDirectory];
    return fileSize;
}

@end
