//
//  PTCommentsResult.m
//  MySina
//
//  Created by hpt on 16/5/23.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTCommentsResult.h"
#import "MJExtension.h"
#import "PTComment.h"

@implementation PTCommentsResult

- (NSDictionary *)objectClassInArray
{
    return @{@"comments" : [PTComment class]};
}

@end
