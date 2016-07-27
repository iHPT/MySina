//
//  PTEmotionToolbar.h
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//	自定义表情键盘：底部表情选项工具条

typedef NS_OPTIONS(NSUInteger, PTEmotionType) {
	PTEmotionTypeRecent = 0, // 最近
	PTEmotionTypeDefault, // 默认
	PTEmotionTypeEmoji, // Emoji
	PTEmotionTypeLxh // 浪小花
};


#import <UIKit/UIKit.h>
@class PTEmotionToolbar;

@protocol PTEmotionToolbarDelegate <NSObject>
@optional
- (void)emotionToolbar:(PTEmotionToolbar *)toolbar didSelectedButton:(PTEmotionType)emotionType;
@end


@interface PTEmotionToolbar : UIView

@property (nonatomic, weak) id<PTEmotionToolbarDelegate> delegate;

@end
