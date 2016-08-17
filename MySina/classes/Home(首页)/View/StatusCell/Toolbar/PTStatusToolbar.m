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

@property (nonatomic, strong) NSMutableArray *dividers;

@end


@implementation PTStatusToolbar

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
        // 设置工具条背景图片
        self.image = [UIImage resizedImage:@"common_card_bottom_background"];
        // 创建2个分隔线
        [self addDivider];
        [self addDivider];
    }
    return self;
}

/**
 *  添加分割线
 */
- (void)addDivider
{
	UIImageView *divider = [[UIImageView alloc] init];
	[self addSubview:divider];
	
	// 设置图片
	divider.image = [UIImage resizedImage:@"timeline_card_bottom_line"];
	divider.contentMode = UIViewContentModeCenter;
	
	// 添加到数组
	[self.dividers addObject:divider];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	// 设置按钮的frame
    NSInteger count = self.dividers.count;
	CGFloat firstDividerX = self.width / (count + 1);
	CGFloat dividerH = self.height;
//    PTLog(@"firstDividerX==%f", firstDividerX);
	
	// 设置分割线的frame
	for (int i = 0; i < count; i++) {
		UIImageView *divider = self.dividers[i];
		divider.width = PTStatusToolDividerWidth;
		divider.height = dividerH;
        divider.centerX = firstDividerX * (i + 1);
		divider.centerY = dividerH * 0.5;
	}
}

@end
