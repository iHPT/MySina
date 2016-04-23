//
//  PTAccountTool.m
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTAccountTool.h"
#import "PTHttpTool.h"
#import "MJExtension.h"

@implementation PTAccountTool

+ (PTAccount *)account
{
    // 读取帐号
    PTAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:PTAccountFilePath];
    
    // 判断帐号是否已经过期
    NSDate *now = [NSDate date];
    if ([now compare:account.expires_time] == NSOrderedDescending) {
        return nil;
    }
    return account;
}

+ (void)save:(PTAccount *)account
{
    // 归档
    [NSKeyedArchiver archiveRootObject:account toFile:PTAccountFilePath];
}

+ (void)accessTokenWithParam:(PTAccessTokenParam *)param success:(void(^)(PTAccount *))success failure:(void(^)(NSError *error))failure
{
	NSDictionary *params = param.keyValues;
	[PTHttpTool post:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(id responseObj) {
		PTAccount *result = [PTAccount objectWithKeyValues:responseObj];
		success(result);
		
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

@end
