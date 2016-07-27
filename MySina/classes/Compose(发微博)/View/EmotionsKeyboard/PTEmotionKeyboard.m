//
//  PTEmotionKeyboard.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//	自定义表情键盘 = 底部表情选项工具条 + 表情list

#import "PTEmotionKeyboard.h"
#import "PTEmotionListView.h"
#import "PTEmotionToolbar.h"
#import "PTEmotion.h"
#import "PTEmotionTool.h"

@interface PTEmotionKeyboard () <PTEmotionToolbarDelegate>

/** 表情列表 */
@property (nonatomic, weak) PTEmotionListView *listView;
/** 表情工具条 */
@property (nonatomic, weak) PTEmotionToolbar *toolbar;

@end


@implementation PTEmotionKeyboard

+ (instancetype)keyboard
{
	return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"emoticon_keyboard_background"]];
		// 1.添加表情列表
		[self setupListView];
		
		// 2.添加表情工具条
		[self setupToolbar];
}
	return self;
}

- (void)setupListView
{
	PTEmotionListView *listView = [[PTEmotionListView alloc] init];
	[self addSubview:listView];
	self.listView = listView;
}

- (void)setupToolbar
{
	PTEmotionToolbar *toolbar = [[PTEmotionToolbar alloc] init];
	toolbar.delegate = self;
	[self addSubview:toolbar];
	self.toolbar = toolbar;
	
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	// 设置toolbar的frame
    self.toolbar.x = 0;
	self.toolbar.width = self.width;
    self.toolbar.height = 40;
    self.toolbar.y = self.height - self.toolbar.height;
	
	// 设置listView的frame
    self.listView.x = 0;
    self.listView.y = 0;
	self.listView.width = self.width;
	self.listView.height = self.toolbar.y;
	
}

#pragma mark - PTEmotionToolbarDelegate
- (void)emotionToolbar:(PTEmotionToolbar *)toolbar didSelectedButton:(PTEmotionType)tag
{
	switch(tag) {
		case PTEmotionTypeDefault: // 默认
			self.listView.emotions = [PTEmotionTool defaultEmotions];
			break;
		
		case PTEmotionTypeEmoji: // Emoji
			self.listView.emotions = [PTEmotionTool emojiEmotions];
			break;
		
		case PTEmotionTypeLxh: // 浪小花
			self.listView.emotions = [PTEmotionTool lxhEmotions];
			break;
		
        case PTEmotionTypeRecent: // 浪小花
            self.listView.emotions = [PTEmotionTool recentEmotions];
			break;
	}
}

@end