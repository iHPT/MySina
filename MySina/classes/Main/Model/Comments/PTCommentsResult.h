//
//  PTCommentsResult.h
//  MySina
//
//  Created by hpt on 16/5/23.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTCommentsResult : NSObject

/** 评论数组 */
@property (nonatomic, strong) NSArray *comments;
/** 评论总数 */
@property (nonatomic, assign) int total_number;

@end
