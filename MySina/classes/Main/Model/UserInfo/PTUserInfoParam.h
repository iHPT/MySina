//
//  PTUserInfoParam.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTBaseParam.h"

@interface PTUserInfoParam : PTBaseParam

/** 	false 	int64 	需要查询的用户ID。 */
@property (nonatomic, strong) NSString *uid;

@end
