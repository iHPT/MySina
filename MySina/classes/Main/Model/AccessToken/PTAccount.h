//
//  PTAccount.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTAccount : NSObject <NSCoding>

/** 用户授权的唯一票据，用于调用微博的开放接口。 */
@property (nonatomic, copy) NSString *access_token;

/** access_token的生命周期，单位是秒数。 */
@property (nonatomic, copy) NSString *expires_in;

/** 授权用户的UID，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，
 *  第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据。
 */
@property (nonatomic, copy) NSString *uid;

/** access_token的截止时间，新增属性 */
@property (nonatomic, strong) NSDate *expires_time;

/** 用户名，新增属性，服务器返回字典不包括此属性 */
@property (nonatomic, copy) NSString *name;

/**
 *  使用第三方框架，未用到该方法
 */
+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
