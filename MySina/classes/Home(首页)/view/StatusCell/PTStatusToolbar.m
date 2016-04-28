//
//  PTStatusToolbar.m
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTStatusToolbar.h"
#import "PTStatus.h"

@interface PTStatusToolbar ()

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) NSMutableArray *dividers;

@property (nonatomic, weak) UIButton *repostsButton;
@property (nonatomic, weak) UIButton *commentsButton;
@property (nonatomic, weak) UIButton *attitudesButton;

@end


@implementation PTStatusToolbar

- (NSMutableArray *)buttons
{
	if (!_buttons) {
		_buttons = [NSMutableArray array];
	}
	return _buttons;
}

- (NSMutableArray *)dividers
{
	if (!_dividers) {
		_dividers = [NSMutableArray array];
	}
	return _dividers;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    		// 设置自己的imageView属性
        self.image = [UIImage resizedImage:@"timeline_card_bottom_background"];
        self.userInteractionEnabled = YES;
        
        // 创建3个按钮添加到视图和数组
        self.repostsButton = [self creatButtonWithIcon:@"timeline_icon_retweet" defaultTitle:@"转发"];
        self.commentsButton = [self creatButtonWithIcon:@"timeline_icon_comment" defaultTitle:@"评论"];
        self.attitudesButton = [self creatButtonWithIcon:@"timeline_icon_unlike" defaultTitle:@"赞"];
        
        // 创建2个分隔线
        [self addDivider];
        [self addDivider];
    }
    return self;
}

/**
 *  创建按钮
 *
 *  @param icon  图标
 *  @param title 标题
 */
- (UIButton *)creatButtonWithIcon:(NSString *)icon defaultTitle:(NSString *)defaultTitle
{
	UIButton *button = [[UIButton alloc] init];
	[self addSubview:button];
		
	// 设置title
	[button setTitle:defaultTitle forState:UIControlStateNormal];
	[button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont systemFontOfSize:13];
	
	// 设置图片
	[button setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage resizedImage:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
	button.adjustsImageWhenHighlighted = NO;
	
	// 设置间距
	button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	
	// 添加到数组
	[self.buttons addObject:button];
	
	return button;
}

/**
 *  添加分割线
 */
- (void)addDivider
{
	UIImageView *divider = [[UIImageView alloc] init];
	[self addSubview:divider];
	
	// 设置图片
	divider.image = [UIImage imageWithName:@"timeline_card_bottom_line"];
	divider.contentMode = UIViewContentModeCenter;
	
	// 添加到数组
	[self.dividers addObject:divider];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	// 设置按钮的frame
	CGFloat buttonW = self.width / self.buttons.count;
	CGFloat buttonH = self.height;
	for (int i = 0; i < self.buttons.count; i++) {
		UIButton *button = self.buttons[i];
		button.x = buttonW * i;
		button.y = 0;
		button.width = buttonW;
		button.height = buttonH;
	}
	
	// 设置分割线的frame
	for (int i = 0; i < self.dividers.count; i++) {
		UIImageView *divider = self.dividers[i];
		divider.width = 3;
		divider.height = buttonH;
		divider.centerX = buttonW * (i + 1);
		divider.centerY = buttonH * 0.5;
	}
}

- (void)setStatus:(PTStatus *)status
{
	_status = status;
	
	NSString *repostsStr = [self stringFromCount:status.reposts_count placeholder:@"转发"];
	[self.repostsButton setTitle:repostsStr forState:UIControlStateNormal];
	
	NSString *commentsStr = [self stringFromCount:status.comments_count placeholder:@"评论"];
	[self.commentsButton setTitle:commentsStr forState:UIControlStateNormal];
	
	NSString *attitudesStr = [self stringFromCount:status.attitudes_count placeholder:@"赞"];
	[self.attitudesButton setTitle:attitudesStr forState:UIControlStateNormal];
	
}

/**
 *  将显示的转发数/评论数/赞 转换成另一种显示的字符串
 *	也可另写一个方法，将button也作为参数传入，一步设置
 */
- (NSString *)stringFromCount:(int)count placeholder:(NSString *)placeholder
{
	NSString *convertedStr = placeholder;
	if (count >= 10000) { // [10000, 无限大)
		convertedStr = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
		// 用空串替换掉所有的.0
		convertedStr = [convertedStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
	} else if (count > 0) {
        convertedStr = [NSString stringWithFormat:@"%d", count];
	}
	return convertedStr;
}


@end
