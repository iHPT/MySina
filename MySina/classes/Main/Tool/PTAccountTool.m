//
//  PTAccountTool.m
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTAccountTool.h"
#import "PTAccount.h"

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

@end
