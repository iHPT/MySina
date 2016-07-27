//
//  PTHomeStatusesParam.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTBaseParam.h"

@interface PTHomeStatusesParam : PTBaseParam

/** 	false 	int64 	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。 */
@property (nonatomic, strong) NSNumber *since_id;

/** 	false 	int64 	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。 */
@property (nonatomic, strong) NSNumber *max_id;

/** 	false 	int 	单页返回的记录条数，最大不超过100，默认为20。 */
@property (nonatomic, strong) NSNumber *count;

/** 	false 	int 	返回结果的页码，默认为1。 */
@property (nonatomic, strong) NSNumber *page;

/** 	false 	int 	是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。 */
@property (nonatomic, strong) NSNumber *base_app;

/** 	false 	int 	过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。 */
@property (nonatomic, strong) NSNumber *feature;

/** 	false 	int 	返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。 */
@property (nonatomic, strong) NSNumber *trim_user;


@end
