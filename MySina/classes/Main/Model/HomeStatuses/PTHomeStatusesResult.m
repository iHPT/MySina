//
//  PTHomeStatusesResult.m
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTHomeStatusesResult.h"
#import "MJExtension.h"
#import "PTStatus.h"

@implementation PTHomeStatusesResult

- (NSDictionary *)objectClassInArray
{
    return @{@"statuses" : [PTStatus class]};
}

@end
