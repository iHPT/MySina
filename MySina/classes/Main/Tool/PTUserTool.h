//
//  PTUserTool.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//	微博用户管理，负责用户一切业务

#import <Foundation/Foundation.h>
#import "PTUserInfoParam.h"
#import "PTUserInfoResult.h"
#import "PTUnreadCountParam.h"
#import "PTUnreadCountResult.h"

@interface PTUserTool : NSObject

/**
 *  获取用户信息
 *
 *  @param param   请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)userInfoWithParam:(PTUserInfoParam *)param success:(void(^)(PTUserInfoResult *result))success failure:(void(^)(NSError *error))failure;

/**
 *  获取用户各种未读消息数
 *
 *  @param param   请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)unreadCountWithParam:(PTUnreadCountParam *)param success:(void(^)(PTUnreadCountResult *result))success failure:(void(^)(NSError *error))failure;
@end
