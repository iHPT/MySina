//
//  PTTextView.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTTextView.h"

@interface PTTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;
@end


@implementation PTTextView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        
        // 设置两者默认的字体
        self.font = [UIFont systemFontOfSize:14];
        
		[self addSubview:self.placeholderLabel];
#warning 不要设置自己的代理为自己本身
        // 监听自己发出的UITextViewTextDidChangeNotification通知，调用[self textDidChange]方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
	}
	return self;
}

- (void)textDidChange
{
    self.placeholderLabel.hidden = (self.text.length != 0);
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UILabel *)placeholderLabel
{
    if (_placeholderLabel == nil) {
        // 添加一个显示提醒文字的label（显示占位文字的label）
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.backgroundColor = [UIColor clearColor];
        
        // 设置默认的占位文字颜色
        placeholderLabel.textColor = [UIColor lightGrayColor];
        
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

- (void)layoutSubviews
{
	self.placeholderLabel.x = 5;
	self.placeholderLabel.y = 8;
	self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
    
	// 根据文字计算label的高度
	CGSize maxSize = CGSizeMake(self.placeholderLabel.width, MAXFLOAT);
	CGSize placeholderLabelSize = [self.placeholderLabel.text sizeWithFont:self.placeholderLabel.font constrainedToSize:maxSize];
//    CGSize placeholderLabelSize = [self.placeholderLabel.text boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:<#(nullable NSDictionary<NSString *,id> *)#> context:<#(nullable NSStringDrawingContext *)#>
	self.placeholderLabel.height = placeholderLabelSize.height;
}

- (void)setPlaceholder:(NSString *)placeholder
{
#warning 如果是copy策略，setter最好这么写
	_placeholder = [placeholder copy];
	
	self.placeholderLabel.text = placeholder;
	
	// 更换文字，placeholderLabel高度会变
	[self setNeedsLayout];
}

- (void)setFont:(UIFont *)font
{
	// 继承属性设置，先调用父类属性设置
	[super setFont:font];
	
	self.placeholderLabel.font = font;
	// 更改字体，placeholderLabel高度会变
	[self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)color
{
	self.placeholderLabel.textColor = color;
	
}

@end