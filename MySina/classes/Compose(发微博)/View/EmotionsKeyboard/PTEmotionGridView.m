//
//  PTEmotionGridView.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//	表情list的一页


#import "PTEmotionGridView.h"
#import "PTEmotion.h"
#import "PTEmotionView.h"
#import "PTEmotionPopView.h"
#import "PTEmotionTool.h"

@interface PTEmotionGridView ()

@property (nonatomic, weak) UIButton *deleteButton;

@property (nonatomic, strong) NSMutableArray *emotionViews;

@property (nonatomic, strong) PTEmotionPopView *popView;
@end


@implementation PTEmotionGridView

- (NSMutableArray *)emotionViews
{
    if (!_emotionViews) {
        self.emotionViews = [NSMutableArray array];
    }
    return _emotionViews;
}

- (PTEmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [[PTEmotionPopView alloc] init];
    }
    return _popView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        // 添加删除按钮
        UIButton *deleteButton = [[UIButton alloc] init];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
        // 设置背景图片
        [deleteButton setImage:[UIImage imageWithName:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageWithName:@"compose_emotion_delete_highlighted"] forState:UIControlStateSelected];
        // 添加点击事件
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 给自己添加一个长按手势识别器
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:recognizer];
	}
	return self;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    int currentEmotionViewCount = self.emotionViews.count;
    for (int i = 0; i < emotions.count; i++) {
        PTEmotionView *emotionView = nil;
        if (i >= currentEmotionViewCount) { // emotionView不够用
            emotionView = [[PTEmotionView alloc] init];
//            emotionView.backgroundColor = PTRANDOM_COLOR;
            [self addSubview:emotionView];
            // 添加到数组
            [self.emotionViews addObject:emotionView];
            // 添加点击事件
            [emotionView addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
        } else { // emotionView够用
            emotionView = self.emotionViews[i];
        }
        
        // 传递emotion模型
        emotionView.emotion = emotions[i];
        emotionView.hidden = NO;
    }
    //    PTLog(@"currentEmotionViewCount==%d", self.emotionViews.count);
    // 隐藏多余的emotionView
    for (int i = emotions.count; i < currentEmotionViewCount; i++) {
        PTEmotionView *emotionView = self.emotionViews[i];
        emotionView.hidden = YES;
    }
}

/**
 *  根据触摸点返回对应的表情控件
 */
- (PTEmotionView *)emotionViewWithPoint:(CGPoint)point
{
    __block PTEmotionView *foundEmotionView = nil;
    [self.emotionViews enumerateObjectsUsingBlock:^(PTEmotionView *emotionView, NSUInteger idx, BOOL *stop) {
#warning 没有显示的表情就不需要处理
        if (CGRectContainsPoint(emotionView.frame, point) && emotionView.hidden == NO) {
            foundEmotionView = emotionView;
            // 停止遍历
            *stop = YES;
        }
    }];
    return foundEmotionView;
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    // 1.捕获触摸点
    CGPoint pressPoint = [recognizer locationInView:recognizer.view];
    
    // 2.遍历子控件，获取触摸点落在哪个表情上
    PTEmotionView *emotionView = [self emotionViewWithPoint:pressPoint];
    if (recognizer.state == UIGestureRecognizerStateEnded) { // 手松开了
        // 移除表情弹出控件
        [self.popView dismiss];
        // 选中表情
        [self selectEmotion:emotionView.emotion];
    } else { // 手没有松开
        // 显示表情弹出控件
        [self.popView showFromEmotionView:emotionView];
    }
}

/**
 *  监听表情的单击
 */
- (void)emotionClick:(PTEmotionView *)emotionView
{
    [self.popView showFromEmotionView:emotionView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView dismiss];
    });
    // 选中表情
    [self selectEmotion:emotionView.emotion];
}

/**
 *  选中表情
 */
- (void)selectEmotion:(PTEmotion *)emotion
{
    if (emotion == nil) return;
    
#warning 注意：先添加使用的表情，再发通知
    // 保存使用记录
    [PTEmotionTool addRecentEmotion:emotion];
    // 发出一个选中表情的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:PTEmotionDidSelectedNotification object:nil userInfo:@{PTSelectedEmotion : emotion}];
}

/**
 *  点击了删除按钮
 */
- (void)deleteClick
{
    // 发出一个选中表情的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:PTEmotionDidDeletedNotification object:nil userInfo:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置listView内部emotionView的frame
    int i = 0;
    CGFloat buttonW = (self.width - 2 * PTEmotionGridViewInsetLeft) / PTEmotionMaxColumns;
    CGFloat buttonH = (self.height - 2 * PTEmotionGridViewInsetTop) / PTEmotionMaxRows;
    for (UIButton *emotionView in self.emotionViews) {
        emotionView.x = PTEmotionGridViewInsetLeft + (i % PTEmotionMaxColumns) * buttonW;
        emotionView.y = PTEmotionGridViewInsetTop + (i / PTEmotionMaxColumns) * buttonH;
        emotionView.width = buttonW;
        emotionView.height = buttonH;
        
        i++;
    }
    
    // 设置listView内部deleteButton的frame
    self.deleteButton.width = buttonW;
    self.deleteButton.height = buttonH;
    self.deleteButton.x = self.width - PTEmotionGridViewInsetLeft - self.deleteButton.width;
    self.deleteButton.y = self.height - PTEmotionGridViewInsetTop - self.deleteButton.height;
    
}

@end