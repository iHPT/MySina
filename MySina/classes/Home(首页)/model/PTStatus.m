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
#import "PTEmotionAttachment.h"
#import "PTEmotionTool.h"
#import "RegexKitLite.h"
#import "PTRegexResult.h"
#import "PTUser.h"

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

- (NSArray *)regexResultsWithText:(NSString *)text
{
	// 用来存放所有的匹配结果
	NSMutableArray *regexResults = [NSMutableArray array];
	
	// 匹配表情
    NSString *regex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
	[text enumerateStringsMatchedByRegex:regex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
		PTRegexResult *regexResult = [[PTRegexResult alloc] init];
		regexResult.string = *capturedStrings;
		regexResult.range = *capturedRanges;
		regexResult.emotion = YES;
		[regexResults addObject:regexResult];
	}];
	
	// 匹配非表情
	[text enumerateStringsSeparatedByRegex:regex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
		PTRegexResult *regexResult = [[PTRegexResult alloc] init];
		regexResult.string = *capturedStrings;
		regexResult.range = *capturedRanges;
		regexResult.emotion = NO;
		[regexResults addObject:regexResult];
	}];
	
	// 排序
	[regexResults sortUsingComparator:^NSComparisonResult(PTRegexResult *result1, PTRegexResult *result2) {
		int loc1 = result1.range.location;
		int loc2 = result2.range.location;
		return [@(loc1) compare:@(loc2)];
//			if (loc1 < loc2) {
//			    return NSOrderedAscending; // 升序（右边越来越大）
//			} else if (loc1 > loc2) {
//			    return NSOrderedDescending; // 降序（右边越来越小）
//			} else {
//			    return NSOrderedSame;
//			}
	}];
	
	return regexResults;
}

- (void)setUser:(PTUser *)user
{
    _user = user;
    
    [self createAttributedText];
}

- (void)setText:(NSString *)text
{
	_text = [text copy];
    
    [self createAttributedText];
}

- (void)setRetweeted_status:(PTStatus *)retweeted_status
{
    _retweeted_status = retweeted_status;
    
    self.retweeted = NO;
    
    _retweeted_status.retweeted = YES;
}

- (void)setRetweeted:(BOOL)retweeted
{
    _retweeted = retweeted;
    
    [self createAttributedText];
}

/**
 *  正文：有转发微博时，昵称和正文一起显示(不使用单独的Label)，没有转发微博时只显示正文
 */
- (void)createAttributedText
{
    if (self.user == nil && self.text == nil) return;
    
    if (self.retweeted) {
        NSString *totalText = [NSString stringWithFormat:@"@%@ : %@", self.user.name, self.text];
        
        self.attributedText = [self attributedStringWithText:totalText];
        
    } else {
        self.attributedText = [self attributedStringWithText:self.text];
    }
}

/**
 *	实际获取的微博表情数据为字符，需转换成图片表情，用属性attributeText属性表示
 */
- (NSAttributedString *)attributedStringWithText:(NSString *)text
{
    // 1.匹配字符串
    NSArray *regexResults = [self regexResultsWithText:text];
    
    // 2.根据匹配结果，拼接对应的图片表情和普通文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    // 遍历
    [regexResults enumerateObjectsUsingBlock:^(PTRegexResult *regexResult, NSUInteger idx, BOOL *stop) {
        PTEmotion *emotion = nil;
        if (regexResult.isEmotion) { // 表情
            emotion = [PTEmotionTool emotionWithDesc:regexResult.string];
        }
        
        if (emotion) {
            // 创建附件对象
            PTEmotionAttachment *attach = [[PTEmotionAttachment alloc] init];
            
            // 获取表情
            attach.emotion = [PTEmotionTool emotionWithDesc:regexResult.string];
            attach.bounds = CGRectMake(0, -3, PTStatusCellTextFont.lineHeight, PTStatusCellTextFont.lineHeight);
            
            // 将附件包装成富文本
            [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
            
        } else { // 非表情（直接拼接普通文本）
            NSMutableAttributedString *substring = [[NSMutableAttributedString alloc] initWithString:regexResult.string];
            
            // 匹配#话题#
            NSString *trendRegex = @"#[a-zA-Z0-9\\u4e00-\\u9fa5]+#";
            [regexResult.string enumerateStringsMatchedByRegex:trendRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substring addAttribute:NSForegroundColorAttributeName value:PTStatusHighlightedTextColor range:*capturedRanges];
                /** 添加link识别属性 */
                [substring addAttribute:PTStatusLinkText value:*capturedStrings range:*capturedRanges];
            }];
            
            // 匹配@提到
            NSString *mentionRegex = @"@[a-zA-Z0-9\\u4e00-\\u9fa5\\-_]+ ?";
            [regexResult.string enumerateStringsMatchedByRegex:mentionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substring addAttribute:NSForegroundColorAttributeName value:PTStatusHighlightedTextColor range:*capturedRanges];
                [substring addAttribute:PTStatusLinkText value:*capturedStrings range:*capturedRanges];
            }];
            
            // 匹配超链接
            NSString *linkReges = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";
            [regexResult.string enumerateStringsMatchedByRegex:linkReges usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substring addAttribute:NSForegroundColorAttributeName value:PTStatusHighlightedTextColor range:*capturedRanges];
                [substring addAttribute:PTStatusLinkText value:*capturedStrings range:*capturedRanges];
            }];
            
            [attributedString appendAttributedString:substring];
        }
    }];
    // 设置字体
    [attributedString addAttribute:NSFontAttributeName value:PTStatusRichTextFont range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
}

@end
