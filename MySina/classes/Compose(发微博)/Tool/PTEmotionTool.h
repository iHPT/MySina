//
//  PTEmotionTool.h
//  MySina
//
//  Created by hpt on 16/5/3.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PTEmotion;

@interface PTEmotionTool : NSObject

/**
 *  默认表情
 */
+ (NSArray *)defaultEmotions;
/**
 *  emoji表情
 */
+ (NSArray *)emojiEmotions;
/**
 *  浪小花表情
 */
+ (NSArray *)lxhEmotions;
/**
 *  最近表情
 */
+ (NSArray *)recentEmotions;

/**
 *  保存最近使用的表情
 */
+ (void)addRecentEmotion:(PTEmotion *)emotion;

/**
 *  根据表情的文字描述找出对应的表情对象
 */
+ (PTEmotion *)emotionWithDesc:(NSString *)desc;

@end
