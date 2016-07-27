//
//  PTUnreadCountParam.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTBaseParam.h"

@interface PTUnreadCountParam : PTBaseParam

/** 	true 	int64 	需要获取消息未读数的用户UID，必须是当前登录用户。  */
@property (nonatomic, strong) NSNumber *uid;

@end
