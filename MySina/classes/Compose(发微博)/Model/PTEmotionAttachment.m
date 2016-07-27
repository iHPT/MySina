//
//  PTEmotionAttachment.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTEmotionAttachment.h"
#import "PTEmotion.h"

@implementation PTEmotionAttachment

- (void)setEmotion:(PTEmotion *)emotion
{
	_emotion = emotion;
	
	self.image = [UIImage imageWithName:[NSString stringWithFormat:@"%@/%@", emotion.directory, emotion.png]];
}

@end