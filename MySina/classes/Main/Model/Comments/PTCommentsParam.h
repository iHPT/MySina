//
//  PTCommentsParam.h
//  MySina
//
//  Created by hpt on 16/5/23.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTBaseParam.h"

@interface PTCommentsParam : PTBaseParam

/** 	true	int64	需要查询的微博ID */
@property (nonatomic, strong) NSNumber *id;

/** 	false 	int64 	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。 */
@property (nonatomic, strong) NSNumber *since_id;

/** 	false 	int64 	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。 */
@property (nonatomic, strong) NSNumber *max_id;

/** 	false 	int 	单页返回的记录条数，最大不超过100，默认为20。 */
@property (nonatomic, strong) NSNumber *count;

/** 	false 	int 	返回结果的页码，默认为1。 */
@property (nonatomic, strong) NSNumber *page;

/**     false	int	作者筛选类型，0：全部、1：我关注的人、2：陌生人，默认为0。 */

@property (nonatomic, strong) NSNumber *filter_by_author;

/**     false	int	来源筛选类型，0：全部、1：来自微博的评论、2：来自微群的评论，默认为0。 */
@property (nonatomic, strong) NSNumber *filter_by_source;

@end
