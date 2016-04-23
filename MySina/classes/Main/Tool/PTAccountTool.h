//
//  PTAccountTool.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTAccessTokenParam.h"
#import "PTAccount.h"

@interface PTAccountTool : NSObject

+ (PTAccount *)account;

+ (void)save:(PTAccount *)account;

/**
 *  获得accesToken
 *
 *  @param param   请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)accessTokenWithParam:(PTAccessTokenParam *)param success:(void(^)(PTAccount *))success failure:(void(^)(NSError *error))failure;

@end
