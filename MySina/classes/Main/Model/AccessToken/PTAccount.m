//
//  PTAccount.m
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTAccount.h"

@implementation PTAccount

/**
 *  使用第三方框架，未用到该方法
 */
+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    PTAccount *account = [[PTAccount alloc] init];
    
    account.access_token = dict[@"access_token"];
    account.expires_in = dict[@"expires_in"];
    account.uid = dict[@"uid"];
    
    // 确定帐号的过期时间 ： 帐号创建时间 + 有效期
    NSDate *now = [NSDate date];
    account.expires_time = [NSDate dateWithTimeInterval:[account.expires_in floatValue] sinceDate:now];
    
    return account;
}

- (void)setExpires_in:(NSString *)expires_in
{
    _expires_in =  [expires_in copy];
    
    // 确定帐号的过期时间 ： 帐号创建时间 + 有效期
    NSDate *now = [NSDate date];
    self.expires_time = [now dateByAddingTimeInterval:expires_in.doubleValue];
}

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.expires_time = [aDecoder decodeObjectForKey:@"expires_time"];
        
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.expires_time forKey:@"expires_time"];
    
    [aCoder encodeObject:self.name forKey:@"name"];
}

@end
