//
//  PTEmotionPopView.m
//  MySina
//
//  Created by hpt on 16/5/3.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTEmotionPopView.h"
#import "PTEmotionView.h"

@interface PTEmotionPopView ()

@property (nonatomic, weak) PTEmotionView *emotionView;

@end


@implementation PTEmotionPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageWithName:@"emoticon_keyboard_magnifier"];
        self.backgroundColor = [UIColor colorWithPatternImage:image];
        
        self.frame = CGRectMake(0, 0, 64, 92);
        PTEmotionView *emotionView = [[PTEmotionView alloc] init];
//        emotionView.backgroundColor = [UIColor greenColor];
        [self addSubview:emotionView];
        self.emotionView = emotionView;
    }
    return self;
}


- (void)showFromEmotionView:(PTEmotionView *)fromEmotionView
{
//    if (fromEmotionView == nil) return;
    
    // 1.显示表情
    self.emotionView.emotion = fromEmotionView.emotion;
    
    // 2.添加到窗口上
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    [window addSubview:self];
    
    // 3.设置位置
    CGFloat centerX = fromEmotionView.centerX;
    CGFloat centerY = fromEmotionView.centerY - 0.5 * self.height;
    CGPoint center = CGPointMake(centerX, centerY);
    self.center = [window convertPoint:center fromView:fromEmotionView.superview];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)layoutSubviews
{
    self.emotionView.x = 16;
    self.emotionView.y = 16;
    self.emotionView.width = 32;
    self.emotionView.height = 32;
}

@end
