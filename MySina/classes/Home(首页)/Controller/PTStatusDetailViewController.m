//
//  PTStatusDetailViewController.m
//  MySina
//
//  Created by hpt on 16/5/18.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTStatusDetailViewController.h"
#import "PTStatusDetailView.h"
#import "PTStatusDetailViewFrame.h"
#import "PTStatus.h"
#import "PTStatusDetailBottomToolbar.h"
#import "PTStatusDetailTopToolbar.h"
#import "PTStatusTool.h"
#import "PTComment.h"
#import "PTUser.h"

@interface PTStatusDetailViewController () <UITableViewDataSource, UITableViewDelegate, PTStatusDetailTopToolbarDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) PTStatusDetailTopToolbar *topToolbar;

/** 评论数组 */
@property (nonatomic, strong) NSMutableArray *comments;

@end


@implementation PTStatusDetailViewController

- (NSMutableArray *)comments
{
    if (_comments == nil) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

- (PTStatusDetailTopToolbar *)topToolbar
{
    if (_topToolbar == nil) {
        _topToolbar = [[PTStatusDetailTopToolbar alloc] init];
        _topToolbar.status = self.status;
        _topToolbar.delegate = self;
    }
    return _topToolbar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建tableView
    [self setupTableView];
    
    // 创建detailView
    [self setupDetailView];
    
    // 创建底部工具条
    [self setupToolbar];
}

/**
 *  创建底部工具条
 */
- (void)setupToolbar
{
    PTStatusDetailBottomToolbar *toolbar = [[PTStatusDetailBottomToolbar alloc] init];
    [self.view addSubview:toolbar];
    
    toolbar.x = 0;
    toolbar.y = self.view.height - PTStatusDetailBottomToolbarHeight;
    toolbar.width = self.view.width;
    toolbar.height = PTStatusDetailBottomToolbarHeight;
    
}

/**
 *  创建detailView
 */
- (void)setupDetailView
{
    // 创建微博详情控件
    PTStatusDetailView *detailView = [[PTStatusDetailView alloc] init];
    
    // 设置微博详情的detailFrame
    PTStatusDetailViewFrame *detailViewFrame = [[PTStatusDetailViewFrame alloc] init];
    self.status.retweeted_status.detail = YES; // 微博详情显示右下角工具条
    detailViewFrame.status = self.status;
    detailView.detailViewFrame = detailViewFrame;
    
    // 微博详情控件为tableView的header
    self.tableView.tableHeaderView = detailView;
}

/**
 *  创建tableView
 */
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    // 设置frame
    tableView.width = self.view.width;
    tableView.height = self.view.height - PTStatusDetailBottomToolbarHeight;
    // 设置为全局背景颜色
    tableView.backgroundColor = PTGlobalBackgroundColor;
    // 设置代理
    tableView.dataSource = self;
    tableView.delegate = self;
    
    self.tableView = tableView;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *statusDetailCellId = @"StatusDetailCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:statusDetailCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:statusDetailCellId];
    }
    PTComment *comment = self.comments[indexPath.row];
    PTUser *user = comment.user;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageWithName:@"avatar_default"]];
    cell.textLabel.text = comment.text;
    cell.detailTextLabel.text = user.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.topToolbar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PTLog(@"didSelectRowAt:%d", indexPath.row);
}

#pragma mark - PTStatusDetailTopToolbarDelegate方法
- (void)statusDetailTopToolbar:(PTStatusDetailTopToolbar *)toolbar didClickButton:(PTStatusDetailTopToolbarButtonType)buttonType
{
    switch (buttonType) {
        case PTStatusDetailTopToolbarButtonTypeComment: // 评论
            [self loadComments];
            break;
            
        case PTStatusDetailTopToolbarButtonTypeRetweet: // 转发
            [self loadRetweeteds];
            break;
        case PTStatusDetailTopToolbarButtonTypeAttitude: // 赞
            [self loadAttitudes];
            break;
    }
    
}

- (void)loadComments
{
    PTLog(@"loadComments");
    // 1.封装请求参数
    PTCommentsParam *param = [PTCommentsParam param];
    long long int idstr = [self.status.idstr longLongValue];
    param.id = @(idstr);
    PTStatus *firstStatus = self.comments.firstObject;
    param.since_id = @([firstStatus.idstr longLongValue]);
    [PTStatusTool commentsWithParam:param success:^(PTCommentsResult *result) {
        PTLog(@"获取评论数据成功---");
//        [self.comments addObject:result];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, result.comments.count)];
        [self.comments insertObjects:result.comments atIndexes:indexSet];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        PTLog(@"获取评论数据失败---%@", error);
        }];
}

- (void)loadRetweeteds
{
    PTLog(@"loadRetweeteds");
}

- (void)loadAttitudes
{
    PTLog(@"loadAttitudes");
}

@end
