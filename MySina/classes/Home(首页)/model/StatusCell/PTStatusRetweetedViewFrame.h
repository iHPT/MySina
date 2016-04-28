//
//  PTStatusRetweetedViewFrame.h
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTStatus;
@interface PTStatusRetweetedViewFrame : NSObject

/** 昵称 */
@property (nonatomic, assign) CGRect nameFrame;

/** 正文 */
@property (nonatomic, assign) CGRect textFrame;

/** 配图相册  */
@property (nonatomic, assign) CGRect photosFrame;


/** 自己的frame */
@property (nonatomic, assign) CGRect frame;

/** 转发微博数据 */
@property (nonatomic, strong) PTStatus *retweetedStatus;

@end
