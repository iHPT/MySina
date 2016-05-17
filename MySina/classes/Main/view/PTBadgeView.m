#import "PTBadgeView.h"

@implementation PTBadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.titleLabel.font = [UIFont systemFontOfSize:10];
		[self setBackgroundImage:[UIImage resizedImage:@"main_badge"] forState:UIControlStateNormal];
		self.size = self.currentBackgroundImage.size;
		self.userInteractionEnabled = NO;
	}
	return self;
}

//- (void)setBadgeValue:(NSString *)badgeValue
//{
//	_badgeValue = [badgeValue copy];
//	
//	int value = badgeValue.intValue;
//	if (value == 0) { // 没有值可以显示
//		self.hidden = YES;
//	} else {
//			self.hidden = NO;
//			if (value >= 100) {
//				[self setTitle:@"N" forState:UIControlStateNormal];
//			} else {
//				[self setTitle:badgeValue forState:UIControlStateNormal];
//			}
//	}
//}
- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = [badgeValue copy];
    
    int value = badgeValue.intValue;
    if (value == 0) { // 没有值可以显示
        self.hidden = YES;
    } else {
        self.hidden = NO;
        // 设置文字
        [self setTitle:badgeValue forState:UIControlStateNormal];
    }
    
    // 根据文字计算自己的尺寸
//    CGSize titleSize = [badgeValue sizeWithFont:self.titleLabel.font];
    CGSize titleSize = [badgeValue sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    CGFloat backgroundWidth = self.currentBackgroundImage.size.width;
    if (titleSize.width <= backgroundWidth) {
        self.size = self.currentBackgroundImage.size;
    } else {
        self.width = titleSize.width + 8;
    }
}

@end