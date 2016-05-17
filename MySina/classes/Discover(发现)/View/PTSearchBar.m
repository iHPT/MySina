//
//  PTSearchBar.h
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTSearchBar.h"

@implementation PTSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// 设置背景
		self.background = [UIImage resizedImage:@"searchbar_textfield_background"];
		
//        // 设置内容 -- 垂直居中
//        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
		// 添加左边放大镜图片
		UIImageView *leftView = [[UIImageView alloc] init];
		leftView.image = [UIImage imageWithName:@"searchbar_textfield_search_icon"];
		leftView.width = leftView.image.size.width + 10;
		leftView.height = leftView.image.size.height;
		leftView.contentMode = UIViewContentModeCenter;
		self.leftView = leftView;
		self.leftViewMode = UITextFieldViewModeAlways;
		
		// 设置右边永远显示清除按钮
		self.clearButtonMode = UITextFieldViewModeAlways;
	}
	return self;
}

+ (instancetype)searchBar
{
	return [[self alloc] init];
}

@end
