//
//  PTUserTool.m
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTUserTool.h"
#import "PTHttpTool.h"
#import "MJExtension.h"

@implementation PTUserTool


+ (void)userInfoWithParam:(PTUserInfoParam *)param success:(void(^)(PTUserInfoResult *result))success failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = param.keyValues;
    
    PTLog(@"currentThread==%@", [NSThread currentThread]);
    [PTHttpTool get:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(id responseObj) {
        if (success) {
            PTUserInfoResult *result = [PTUserInfoResult objectWithKeyValues:responseObj];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  获取用户各种未读消息数
 */
+ (void)unreadCountWithParam:(PTUnreadCountParam *)param success:(void(^)(PTUnreadCountResult *result))success failure:(void(^)(NSError *error))failure
{
	NSDictionary *params = param.keyValues;
    
    [PTHttpTool get:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(id responseObj) {
        if (success) {
            PTUnreadCountResult *result = [PTUnreadCountResult objectWithKeyValues:responseObj];
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
