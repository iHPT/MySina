//
//  PTStatusTool.m
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTStatusTool.h"
#import "PTHttpTool.h"
#import "MJExtension.h"
#import "FMDB.h"
#import "PTStatus.h"

static FMDatabase *_db;

@implementation PTStatusTool

+ (void)initialize
{
    // 初始化时创建数据库
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *statusesDataPath = [docPath stringByAppendingPathComponent:@"statusesData"];
    _db = [FMDatabase databaseWithPath:statusesDataPath];
    
    // 创表
    if ([_db open]) {
        // status_dict字段为NSData类型数据
        BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_home_statuses (id INTEGER PRIMARY KEY AUTOINCREMENT, access_token TEXT NOT NULL, status_idstr TEXT NOT NULL, status_dict BLOB NOT NULL)"];
        if (result) {
            PTLog(@"创表成功!");
        } else {
            PTLog(@"创表失败!");
        }
    } else {
        PTLog(@"打开数据库失败!");
    }
}

/**
 *  加载首页的微博数据
 */
+ (void)homeStatusesWithParam:(PTHomeStatusesParam *)param success:(void(^)(PTHomeStatusesResult *result))success failure:(void(^)(NSError *error))failure;
{
    NSArray *statuses = [self cachedHomeStatusesWithParam:param];
    // 从数据库加载缓存数据
    if (statuses.count) { // 有缓存数据，将微博数组作为block参数返还到上一层控制器方法中
        PTHomeStatusesResult *result = [[PTHomeStatusesResult alloc] init];
        result.statuses = statuses;
        success(result);
    } else { // 没有缓存数据
        NSDictionary *params = param.keyValues;
        
        [PTHttpTool get:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params success:^(id responseObj) {
            // 将新浪返回的字典数组进行缓存
            NSArray *statusDictArray = responseObj[@"statuses"];
            [self saveStatusesDataWithStatusDictArray:statusDictArray accessToken:param.access_token];
            
            if (success) {
//                PTLog(@"responseObj===%@", responseObj);
                PTHomeStatusesResult *result = [PTHomeStatusesResult objectWithKeyValues:responseObj];
                success(result);
            }
        } failure:^(NSError *error) {
            if (error) {
                failure(error);
            }
        }];
    }
}

// 获取缓存的statuses模型数组
+ (NSArray *)cachedHomeStatusesWithParam:(PTHomeStatusesParam *)param
{
    FMResultSet *resultSet = nil;
    // 需进行param判断，首次加载since_id没有值
    if (param.since_id) { // 加载新微博数据会进行缓存查找
        resultSet = [_db executeQuery:@"SELECT * FROM t_home_statuses WHERE access_token = ? AND status_idstr > ? ORDER BY status_idstr DESC LIMIT ?", param.access_token, param.since_id, param.count];
    } else if (param.max_id) { // 加载更多微博数据会进行缓存查找
        resultSet = [_db executeQuery:@"SELECT * FROM t_home_statuses WHERE access_token = ? AND  status_idstr <= ? ORDER BY status_idstr DESC LIMIT ?", param.access_token, param.max_id, param.count];
    } else {
        resultSet = [_db executeQuery:@"SELECT * FROM t_home_statuses WHERE access_token = ? ORDER BY status_idstr DESC LIMIT ?", param.access_token, param.count];
    }
    
    NSMutableArray *cachedStatuses = [NSMutableArray array];
    // 查询结果进行数据转换
    while ([resultSet next]) {
        NSData *statusDictData = [resultSet objectForColumnName:@"status_dict"];
        NSDictionary *statusDict = [NSKeyedUnarchiver unarchiveObjectWithData:statusDictData];
        PTStatus *status = [PTStatus objectWithKeyValues:statusDict];
        [cachedStatuses addObject:status];
    }
    
    return cachedStatuses;
}

/**
 *  缓存微博数据
 */
+ (void)saveStatusesDataWithStatusDictArray:(NSArray *)statusDictArray accessToken:(NSString *)access_token
{
    for (NSDictionary *statusDict in statusDictArray) {
        // 本来存入的是字典，但[resultSet objectForColumnName:@"status_dict"]方法取出来的是字符串(整个字典当一串字符串)，所以把字典转成NSData进行存储
        NSData *statusData = [NSKeyedArchiver archivedDataWithRootObject:statusDict];
        [_db executeUpdate:@"INSERT INTO t_home_statuses (access_token, status_idstr, status_dict) VALUES (?, ?, ?)", access_token, statusDict[@"idstr"], statusData];
    }
}

/**
 *  发送一条文字微博
 */
+ (void)sendStatusWithParam:(PTSendStatusParam *)param success:(void(^)(PTStatus *))success failure:(void(^)(NSError *error))failure
{
	NSDictionary *params = param.keyValues;
	[PTHttpTool post:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(id responseObj) {
		if (success) {
			PTStatus *status = [PTStatus objectWithKeyValues:responseObj];
			success(status);
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

/**
 *  发送一张图片微博
 */
+ (void)sendStatusWithParam:(PTSendStatusParam *)param image:(UIImage *)image fileName:(NSString *)fileName success:(void(^)(PTStatus *))success failure:(void(^)(NSError *error))failure;
{
	NSDictionary *params = param.keyValues;
	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
	[PTHttpTool post:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params data:imageData fileName:fileName success:^(id responseObj) {
		if (success) {
			PTStatus *status = [PTStatus objectWithKeyValues:responseObj];
			success(status);
		}
	} failure:^(NSError *error) {
		if (failure) {
			failure(error);
		}
	}];
}

/**
 *  加载评论数据
 */
+ (void)commentsWithParam:(PTCommentsParam *)param success:(void (^)(PTCommentsResult *result))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = param.keyValues;
    
    [PTHttpTool get:@"https://api.weibo.com/2/comments/show.json" parameters:params success:^(id responseObj) {
        if (success) {
//            PTLog(@"responseObj==%@", responseObj);
            PTCommentsResult *result = [PTCommentsResult objectWithKeyValues:responseObj];
            success(result);
        }
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

@end
