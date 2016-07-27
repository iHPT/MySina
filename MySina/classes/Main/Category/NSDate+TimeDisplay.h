//
//  NSDate+TimeDisplay.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright ? 2016年 PT. All rights reserved.
//	NSDate分类，辅助用于微博时间显示

#import <Foundation/Foundation.h>

@interface NSDate (TimeDisplay)

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;

/**
 *  获得与当前时间的差距(时丶分丶秒)，年丶月丶日不管
 *	所以如果是同一天，可用该方法获取时间差
 */
- (NSDateComponents *)deltaWithNow;

@end