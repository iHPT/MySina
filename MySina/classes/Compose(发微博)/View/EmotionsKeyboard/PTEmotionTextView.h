//
//  PTEmotionTextView.h
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTTextView.h"
@class PTEmotion;

@interface PTEmotionTextView : PTTextView
/**
 *  拼接表情到最后面
 */
- (void)appendEmotion:(PTEmotion *)emotion;

/**
 *  具体的文字内容:发送微博时，写微博中的图片内容实际以文本内容形式发送
 */
- (NSString *)realText;
@end
