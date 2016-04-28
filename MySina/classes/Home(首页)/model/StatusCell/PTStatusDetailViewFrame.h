//
//  PTStatusDetailViewFrame.h
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTStatus, PTStatusOriginalViewFrame, PTStatusRetweetedViewFrame;
@interface PTStatusDetailViewFrame : NSObject

/** 原创微博frame模型 */
@property (nonatomic, strong) PTStatusOriginalViewFrame *originalViewFrame;

/** 转发微博frame模型 */
@property (nonatomic, strong) PTStatusRetweetedViewFrame *retweetedViewFrame;

/** 自己的frame */
@property (nonatomic, assign) CGRect frame;

/** 微博数据 */
@property (nonatomic, strong) PTStatus *status;

@end
