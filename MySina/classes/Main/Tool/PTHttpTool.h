//
//  PTHttpTool.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTHttpTool : NSObject

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure;

/**
 *  发送一个带body的POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param params  body数据
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters data:(NSData *)data fileName:(NSString *)fileName success:(void(^)(id))success failure:(void(^)(NSError *))failure;


@end
