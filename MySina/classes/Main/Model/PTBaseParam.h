//
//  PTBaseParam
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//	封装拥有access_token属性值得基类
//

#import <Foundation/Foundation.h>

@interface PTBaseParam : NSObject

/** 用户授权的唯一票据，用于调用微博的开放接口。 */
@property (nonatomic, copy) NSString *access_token;

+ (instancetype)param;
@end
