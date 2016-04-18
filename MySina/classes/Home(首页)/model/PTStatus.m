//
//  PTStatus.m
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//	微博模型

#import "PTStatus.h"
#import "PTPhoto.h"
#import "MJExtension.h"

@implementation PTStatus

- (NSDictionary *)objectClassInArray
{
	return @{@"pic_urls" : [PTPhoto class]};
}

@end
