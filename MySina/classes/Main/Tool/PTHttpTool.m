//
//  PTAccountTool.m
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTHttpTool.h"
#import "AFNetworking.h"

@implementation PTHttpTool

+ (void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure
{
	// 1.获得请求管理者
	AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
	
	// 2.发送GET请求
	[mgr GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObj) {
			if (success) {
				success(responseObj);
			}
	    
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
	    if (failure) { // 传入需要处理的请求失败代码
	    	failure(error);
	    }
	}];
	
}

+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id))success failure:(void(^)(NSError *))failure
{
	// 1.获得请求管理者
	AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
	
	// 2.发送POST请求
	[mgr POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObj) {
		if (success) {
			success(responseObj);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

// 发一张图片微博用到
+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters data:(NSData *)data fileName:(NSString *)fileName success:(void(^)(id))success failure:(void(^)(NSError *))failure
{
	// 1.获得请求管理者
  AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
	
	// 2.发送POST请求
	[mgr POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
	    [formData appendPartWithFileData:data name:@"pic" fileName:fileName mimeType:@"image/jpeg"];
	    
	} success:^(AFHTTPRequestOperation *operation, id responseObj) {
	    if (success) {
	    	success(responseObj);
	    }
	    
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
	    if (failure) {
	    	failure(error);
	    }
	}];
	
}
@end
