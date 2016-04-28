//
//  PTUser.m
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//	用户模型

#import "PTUser.h"

@implementation PTUser

- (BOOL)isVip
{
	return self.mbtype > 2;
}

@end