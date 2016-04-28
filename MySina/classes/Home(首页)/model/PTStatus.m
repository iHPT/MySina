//
//  PTStatus.m
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//	微博模型

#import "PTStatus.h"
#import "PTPhoto.h"
#import "MJExtension.h"
#import "NSDate+TimeDisplay.h"

@implementation PTStatus

- (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls" : [PTPhoto class]};
}


- (NSString *)created_at
{
//    PTLog(@"created_at--getter");
    
	// Mon Feb 16 16:13:07 +0800 2014
	NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
#warning -- 系统为中文，需设置为local为英文样式，不然返回nil
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    [fmt setLocale:locale];
    [fmt setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
	// 获得微博发布的具体时间
    NSDate *createDate = [fmt dateFromString:_created_at];

	if (createDate.isThisYear) {// 是今年
		if (createDate.isToday){ // 是今天
			// 获取和现在的时间差
			NSDateComponents *deltaComponents = [createDate deltaWithNow];
			if (deltaComponents.hour >= 1) { // 多少小时前
				return [NSString stringWithFormat:@"%d小时前", deltaComponents.hour];
			} else if (deltaComponents.minute >= 1) { // 多少分钟前
				return [NSString stringWithFormat:@"%d分钟前", deltaComponents.minute];
			} else { // 刚刚
				return @"刚刚";
			}
			
		} else if (createDate.isYesterday) { // 是昨天--- 昨天 xx:xx
			fmt.dateFormat = @"昨天 HH:mm";
			return [fmt stringFromDate:createDate];
		} else { // 至少是前天--- xx-xx
			fmt.dateFormat = @"MM-dd HH:mm";
			return [fmt stringFromDate:createDate];
		}
		
	} else { // 不是今年--- xxxx-xx-xx
		fmt.dateFormat = @"yyyy-MM-dd";
		return [fmt stringFromDate:createDate];
	}
}

// _source == <a href="http://weibo.com/" rel="nofollow">微博 weibo.com</a>
// destSource = 来自微博 weibo.com
//- (NSString *)source
//{
//    PTLog(@"source--getter--%@", _source);
////    return @"hahha";
//	// 截取范围
//	NSRange range;
//	range.location = [_source rangeOfString:@">"].location + 1;
//	range.length = [_source rangeOfString:@"</"].location - range.location;
//	// 开始截取
//	NSString *subsource = [_source substringWithRange:range];
//	// 头部拼接一个“来自”
//	return [NSString stringWithFormat:@"来自 %@", subsource];
//}

- (void)setSource:(NSString *)source
{
    if ([source isEqualToString:@""]) {
        return;
    }
    
    // 截取范围
    NSRange range;
    range.location = [source rangeOfString:@">"].location + 1;
    range.length = [source rangeOfString:@"</"].location - range.location;
    // 开始截取
    NSString *subsource = [source substringWithRange:range];
    
    _source = [NSString stringWithFormat:@"来自%@", subsource];
}

@end
