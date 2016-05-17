//
//  PTStatusCell.m
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTStatusCell.h"
#import "PTStatusDetailView.h"
#import "PTStatusToolbar.h"
#import "PTStatusFrame.h"

static NSString *statusCellId = @"StatusCellId";

@interface PTStatusCell ()

@property (nonatomic, weak) PTStatusDetailView *detailView;

@property (nonatomic, weak) PTStatusToolbar *toolbar;

@end

@implementation PTStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // cell背景色设置
        self.backgroundColor = [UIColor clearColor];
        
        // 初始化子控件
        // 微博数据视图
        PTStatusDetailView *detailView = [[PTStatusDetailView alloc] init];
        [self.contentView addSubview:detailView];
        self.detailView = detailView;
        
        // 工具条视图
        PTStatusToolbar *toolbar = [[PTStatusToolbar alloc] init];
        [self.contentView addSubview:toolbar];
        self.toolbar = toolbar;
     }
    
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    PTStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:statusCellId];
    if (!cell) {
        cell = [[PTStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:statusCellId];
    }
    return cell;
}

- (void)setStatusFrame:(PTStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    // 2.底部工具条的frame数据
    self.detailView.detailViewFrame = statusFrame.detailViewFrame;
    
    // 2.底部工具条的frame数据
    self.toolbar.frame = statusFrame.toolbarFrame;
    self.toolbar.status = statusFrame.status;
}

@end
