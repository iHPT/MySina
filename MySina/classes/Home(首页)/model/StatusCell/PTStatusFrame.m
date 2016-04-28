//
//  PTStatusFrame.m
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTStatusFrame.h"
#import "PTStatusDetailViewFrame.h"

@implementation PTStatusFrame

- (void)setStatus:(PTStatus *)status
{
    _status = status;
    
    // 1.计算微博具体内容（微博整体）
    [self setupDetailViewFrame];
    
    // 2.计算底部工具条
    [self setupToolbarFrame];
    
    // 3.计算cell的高度
    self.cellHeight = CGRectGetMaxY(self.toolbarFrame);
    
}

- (void)setupDetailViewFrame
{
    PTStatusDetailViewFrame *detailViewFrame = [[PTStatusDetailViewFrame alloc] init];
    detailViewFrame.status = self.status;
    self.detailViewFrame = detailViewFrame;
}

- (void)setupToolbarFrame
{
    CGFloat toolbarX = 0;
    CGFloat toolbarY = CGRectGetMaxY(self.detailViewFrame.frame);
    CGFloat toolbarW = ScreenWidth;
    CGFloat toolbarH = 35;
    self.toolbarFrame = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
}

@end
