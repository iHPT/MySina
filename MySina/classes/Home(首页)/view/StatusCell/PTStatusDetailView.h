//
//  PTStatusDetailView.h
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//  微博数据视图 = 原创微博视图(评论) + 转发微博视图
//	有背景图片，可设置继承自UIImageView

#import <UIKit/UIKit.h>

@class PTStatusDetailViewFrame;
@interface PTStatusDetailView : UIImageView

@property (nonatomic, strong) PTStatusDetailViewFrame *detailViewFrame;

@end
