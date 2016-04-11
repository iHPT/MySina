#import "PTTitleButton.h"

@implementation PTTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// 内部图标居中
		self.imageView.contentMode = UIViewContentModeCenter;
		// 文字对齐
		self.titleLabel.textAlignment = NSTextAlignmentRight;
		// 文字颜色
		[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		// 字体
		self.titleLabel.font = PTNavigationTitleFont;
		// 高亮的时候不需要调整内部的图片为灰色
		self.adjustsImageWhenHighlighted = NO;
	}
	return self;
}

/**
 *  设置内部文字的frame
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
	CGFloat titleY = 0;
	CGFloat titleH = self.height;
	CGFloat titleW = self.width - self.height;
	CGFloat titleX = 0;
	
	return CGRectMake(titleX, titleY, titleW, titleH);
}

/**
 *  设置内部图标的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
	CGFloat imageY = 0;
	CGFloat imageH = self.height;
	CGFloat imageW = imageH;
	CGFloat imageX = self.width - imageW; // self.height == self.imageView.height (UIView+Extension)
	
	return CGRectMake(imageX, imageY, imageW, imageH);
}

@end