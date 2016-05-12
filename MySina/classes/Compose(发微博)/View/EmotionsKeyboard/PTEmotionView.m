//
//  PTEmotionView.m
//  MySina
//
//  Created by hpt on 16/5/3.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTEmotionView.h"
#import "PTEmotion.h"

@implementation PTEmotionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (void)setEmotion:(PTEmotion *)emotion
{
    _emotion = emotion;
    
    if (emotion.code) { // Emoji表情
        // emotion.code == 0x1f603 --> \u54367
        // emoji的大小取决于字体大小
        [self setTitle:emotion.emoji forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        // emotionView重用，未用到的image设置为空，不然其他的image会因为重用而被显示
        [self setImage:nil forState:UIControlStateNormal];
    } else { // 图片或jif表情
        NSString *iconPath = [NSString stringWithFormat:@"%@/%@", emotion.directory, emotion.png];
        [self setImage:[UIImage imageWithName:iconPath] forState:UIControlStateNormal];
        // emotionView重用，未用到的title设置为空，不然其他的title会因为重用而被显示
        [self setTitle:nil forState:UIControlStateNormal];
    }
}

@end
