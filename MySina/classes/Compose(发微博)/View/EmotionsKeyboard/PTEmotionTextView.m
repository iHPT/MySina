//
//  PTEmotionTextView.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTEmotionTextView.h"
#import "PTEmotion.h"
#import "PTEmotionAttachment.h"

@implementation PTEmotionTextView

/**
 *  拼接表情到最后面
 */
- (void)appendEmotion:(PTEmotion *)emotion
{
	if (emotion.emoji) { // 是Emoji
		[self insertText:emotion.emoji];
		
	} else { // 是图片表情
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
		// 创建一个带有图片表情的富文本
		PTEmotionAttachment *attach = [[PTEmotionAttachment alloc] init];
        attach.emotion = emotion;
		attach.bounds = CGRectMake(0, -3, self.font.lineHeight, self.font.lineHeight);
		NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
		
		// 记录表情的插入位置
		int insertIndex = self.selectedRange.location;
		// 插入表情图片到光标位置
		[attributedString insertAttributedString:attachString atIndex:insertIndex];
		
		// 设置字体
        [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedString.length)];
		
		// 重新赋值(光标会自动回到文字的最后面)
		self.attributedText = attributedString;
		// 让光标回到表情后面的位置
		self.selectedRange = NSMakeRange(insertIndex + 1, 0);
	}
    
    PTLog(@"appendEmotion: %@", self.attributedText);
}

/**
 *  具体的文字内容:发送微博时，写微博中的图片内容实际以文本内容形式发送
 */
- (NSString *)realText
{
	// 1.创建用来拼接所有文字的字符串
    NSMutableString *string = [NSMutableString string];
    PTLog(@"attributedText==%@", self.attributedText);
	// 2.遍历富文本里面的所有内容
	[self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		PTEmotionAttachment *attach = attrs[@"NSAttachment"];
		if (attach) { // 如果是带有附件的富文本
			[string appendString:attach.emotion.chs];
			
		} else { // 普通的文本
			// 截取range范围的普通文本
			NSString *substring = [self.attributedText attributedSubstringFromRange:range].string;
			[string appendString:substring];
		}
	}];
    PTLog(@"%@", string);
	return string;
}

@end