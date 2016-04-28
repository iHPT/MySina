//
//  PTStatusToolbar.h
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//	封装底部的工具条

#import <UIKit/UIKit.h>
@class PTStatus;

@interface PTStatusToolbar : UIImageView

/** 微博数据 */
@property (nonatomic, strong) PTStatus *status;

@end
