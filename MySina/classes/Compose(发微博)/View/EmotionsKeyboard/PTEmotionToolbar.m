//
//  PTEmotionToolbar.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//	自定义表情键盘：底部表情选项工具条

#define PTEmotionToolbarButtonMaxCount 4

#import "PTEmotionToolbar.h"

@interface PTEmotionToolbar ()
/** 记录当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;

@end


@implementation PTEmotionToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// 添加4个按钮
		[self setupButtonWithTitle:@"最近" tag:PTEmotionTypeRecent];
		[self setupButtonWithTitle:@"默认" tag:PTEmotionTypeDefault];
		[self setupButtonWithTitle:@"Emoji" tag:PTEmotionTypeEmoji];
		[self setupButtonWithTitle:@"浪小花" tag:PTEmotionTypeLxh];
        
        // 监听表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:PTEmotionDidSelectedNotification object:nil];
	}
	return self;
}

/**
 *  添加按钮
 *
 *  @param title 按钮文字
 *  @param tag 表情类型枚举
 */
- (void)setupButtonWithTitle:(NSString *)title tag:(PTEmotionType)tag
{
	UIButton *button = [[UIButton alloc] init];
	[self addSubview:button];
	button.tag = tag;
	
	// 设置按键title
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
	button.titleLabel.font = [UIFont systemFontOfSize:16];
	
	// 设置图片背景
	int count = self.subviews.count;
	if (count == 1) { // 第一个按钮
		[button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_left_normal"] forState:UIControlStateNormal];
		[button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_left_selected"] forState:UIControlStateNormal];
	} else if (count == PTEmotionToolbarButtonMaxCount) { // 最后一个按钮
		[button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_right_normal"] forState:UIControlStateNormal];
		[button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_right_selected"] forState:UIControlStateNormal];
	} else { // 中间按钮
		[button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
		[button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_mid_selected"] forState:UIControlStateNormal];
	}
	
	// 添加点击事件
	[button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)emotionDidSelected:(UIGestureRecognizer *)note
{
    // 通知代理，控制器重新加载最近数据，刷新选中表情到最前
    if (self.selectedButton.tag == PTEmotionTypeRecent) {
        [self buttonClick:self.selectedButton];
    }
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGFloat buttonW = self.width / PTEmotionToolbarButtonMaxCount;
	CGFloat buttonH = self.height;
	for (int i = 0; i < PTEmotionToolbarButtonMaxCount; i++) {
		UIButton *button = self.subviews[i];
		button.x = i * buttonW;
		button.y = 0;
		button.width = buttonW;
		button.height = buttonH;
	}
}

- (void)buttonClick:(UIButton *)button
{
    // 1.控制按钮状态
	_selectedButton.selected = NO;
	button.selected = YES;
	_selectedButton = button;
	
	// 2.通知代理
	if ([self.delegate respondsToSelector:@selector(emotionToolbar:didSelectedButton:)]) {
		[self.delegate emotionToolbar:self didSelectedButton:button.tag];
	}
}

- (void)setDelegate:(id<PTEmotionToolbarDelegate>)delegate
{
    _delegate = delegate;
    
    // 初始选中默认，传入数据
    UIButton *defaultButton = [self viewWithTag:PTEmotionTypeDefault];
    [self buttonClick:defaultButton];
}

@end