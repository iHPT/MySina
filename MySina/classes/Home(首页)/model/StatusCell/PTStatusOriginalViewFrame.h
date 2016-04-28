//
//  PTStatusOriginalViewFrame.h
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTStatus;
@interface PTStatusOriginalViewFrame : NSObject

/** 头像 */
@property (nonatomic, assign) CGRect iconFrame;

/** 昵称 */
@property (nonatomic, assign) CGRect nameFrame;

/** 正文 */
@property (nonatomic, assign) CGRect textFrame;

/** 会员图标 */
@property (nonatomic, assign) CGRect vipFrame;

/** 配图相册  */
@property (nonatomic, assign) CGRect photosFrame;


/** 微博数据 */
@property (nonatomic, strong) PTStatus *status;

/** 自己的frame */
@property (nonatomic, assign) CGRect frame;

@end
