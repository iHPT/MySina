//
//  PTStatusTool.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//	微博业务类，负责微博数据一切业务，包括数据请求和缓存

#import <Foundation/Foundation.h>
#import "PTHomeStatusesParam.h"
#import "PTHomeStatusesResult.h"
#import "PTSendStatusParam.h"
#import "PTStatus.h"
#import "PTCommentsParam.h"
#import "PTCommentsResult.h"

@interface PTStatusTool : NSObject

/**
 *  加载首页的微博数据
 *
 *  @param param   请求参数
 */
+ (void)homeStatusesWithParam:(PTHomeStatusesParam *)param success:(void(^)(PTHomeStatusesResult *result))success failure:(void(^)(NSError *error))failure;

/**
 *  发送简单的文字微博
 *
 *  @param param   请求参数
 */
+ (void)sendStatusWithParam:(PTSendStatusParam *)param success:(void(^)(PTStatus *))success failure:(void(^)(NSError *error))failure;

/**
 *  发送一张图片微博
 *
 *  @param param   请求参数
 *  @param image   要发送的图片参数
 */
+ (void)sendStatusWithParam:(PTSendStatusParam *)param image:(UIImage *)image fileName:(NSString *)fileName success:(void(^)(PTStatus *))success failure:(void(^)(NSError *error))failure;

/**
 *  加载评论数据
 */
+ (void)commentsWithParam:(PTCommentsParam *)param success:(void (^)(PTCommentsResult *result))success failure:(void (^)(NSError *error))failure;

@end
