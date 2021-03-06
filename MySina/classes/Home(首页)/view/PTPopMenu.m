#import "PTPopMenu.h"

@interface PTPopMenu()

// 最底部的遮盖 ：屏蔽除菜单以外控件的事件
@property (nonatomic, weak) UIButton *cover;

// 容器 ：容纳具体要显示的内容contentView
@property (nonatomic, weak) UIImageView *container;

//
//  PTPopMenu.m
//  MySina
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

// 具体显示内容
@property (nonatomic, strong) UIView *contentView;

@end


@implementation PTPopMenu


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	if (self) {
		// 添加一个遮盖按钮
		UIButton *cover = [[UIButton alloc] init];
		cover.backgroundColor = [UIColor blackColor];
		cover.alpha = 0.3;
		[cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:cover];
		self.cover = cover;
		
		// 添加带箭头的菜单图片
		UIImageView *container = [[UIImageView alloc] init];
		container.userInteractionEnabled = YES;
		[self addSubview:container];
		self.container = container;
	}
	return self;
}

- (instancetype)initWithContentView:(UIView *)contentView
{
	if (self = [super init]) {
		self.contentView = contentView;
	}
	return self;
}

+ (instancetype)popMenuWithContentView:(UIView *)contentView
{
	return [[self alloc] initWithContentView:contentView];
}

- (void)showInRect:(CGRect)rect
{
	// 添加菜单整体到窗口身上
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	self.frame = window.bounds;
	[window addSubview:self];
    
	// 设置遮盖按钮的frame
	self.cover.frame = self.frame;
	
	// 设置容器的frame
	self.container.frame = rect;
/**
 *  若在init方法中设置图片，则该方法被调用时container的frame发生改变，图片会被拉伸
 */
    self.container.image = [UIImage resizedImage:@"popover_background"];
    
    // contentView添加到容器中
	[self.container addSubview:self.contentView];
	
	// 设置容器里面contentView的frame
    CGFloat topMargin = 15;
    CGFloat leftMargin = 7;
    CGFloat rightMargin = 7;
    CGFloat bottomMargin = 8;
    
    self.contentView.x = leftMargin;
    self.contentView.y = topMargin;
    self.contentView.width = self.container.width - leftMargin - rightMargin;
    self.contentView.height = self.container.height - topMargin - bottomMargin;
}

- (void)setArrowPosition:(PTPopMenuArrowPosition)arrowPosition
{
	_arrowPosition = arrowPosition;
	
	switch (self.arrowPosition) {
		case PTPopMenuArrowPositionLeft:
			self.container.image = [UIImage imageWithName:@"popover_background_left"];
			break;
		case PTPopMenuArrowPositionRight:
			self.container.image = [UIImage imageWithName:@"popover_background_right"];
			break;
		default:
			self.container.image = [UIImage imageWithName:@"popover_background"];
			break;
	}
}

- (void)coverClick
{
	[self removeFromSuperview];
	
	if ([self.delegate respondsToSelector:@selector(popMenuDidDismissed:)]) {
		[self.delegate popMenuDidDismissed:self];
	}
}

@end