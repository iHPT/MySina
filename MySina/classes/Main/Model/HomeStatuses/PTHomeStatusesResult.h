//
//  PTHomeStatusesResult.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTHomeStatusesResult : NSObject

/** 获取的微博数组 */
@property (nonatomic, copy) NSArray *statuses;

/** 用户所有微博条数 */
@property (nonatomic, strong) NSNumber *total_number;
@end
