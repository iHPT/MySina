//
//  PTLoadMoreFooter.m
//  MySina
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTLoadMoreFooter.h"

@interface PTLoadMoreFooter ()

@property (nonatomic, weak) UILabel *statusLabel;

@property (nonatomic, weak) UIActivityIndicatorView *loadingIndicator;
@end


@implementation PTLoadMoreFooter

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.frame = CGRectMake(0, 0, ScreenWidth, 44);
        self.backgroundColor = [UIColor clearColor];
		
		UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.text = @"上拉可以加载更多数据";
		statusLabel.textColor = [UIColor whiteColor];
		statusLabel.textAlignment = NSTextAlignmentRight;
//		statusLabel.backgroundColor = [UIColor orangeColor];
		[self addSubview:statusLabel];
		self.statusLabel = statusLabel;
		
		UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] init];
		[self addSubview:loadingIndicator];
		self.loadingIndicator = loadingIndicator;
	}
	return self;
}

- (void)layoutSubviews
{
	self.statusLabel.frame = CGRectMake(40, 4, 200, 36);
	
	self.loadingIndicator.frame = CGRectMake(CGRectGetMaxX(self.statusLabel.frame), 4, 36, 36);
}

- (void)beginRefreshing
{
	self.statusLabel.text = @"正在拼命加载更多数据...";
	[self.loadingIndicator startAnimating];
	self.refreshing = YES;
}

- (void)endRefreshing
{
	self.statusLabel.text = @"上拉可以加载更多数据";
	[self.loadingIndicator stopAnimating];
	self.refreshing = NO;
}


@end