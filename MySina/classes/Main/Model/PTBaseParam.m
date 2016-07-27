//
//  PTBaseParam.m
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTBaseParam.h"
#import "PTAccount.h"
#import "PTAccountTool.h"

@implementation PTBaseParam

- (instancetype)init
{
	self = [super init];
	if (self) {
		PTAccount *account = [PTAccountTool account];
		self.access_token = account.access_token;
	}
	return self;
}

+ (instancetype)param
{
	return [[self alloc] init];
}

@end
