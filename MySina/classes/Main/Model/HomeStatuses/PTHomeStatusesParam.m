//
//  PTHomeStatusesParam.m
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTHomeStatusesParam.h"

@implementation PTHomeStatusesParam

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.count = @20;
		self.page = @1;
		self.feature = @0;
		self.base_app = @0;
		self.trim_user = @0;
	}
	return self;
}


- (void)setCount:(NSNumber *)count
{
	// count最大不超过100，默认为20
	_count = ([count integerValue] > 100) ? @100 : count;
}

@end
