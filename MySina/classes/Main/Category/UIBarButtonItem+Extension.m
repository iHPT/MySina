#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (instancetype)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
	[button setBackgroundImage:[UIImage imageWithName:imageName] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageWithName:selectedImageName] forState:UIControlStateHighlighted];
	
	button.size = button.currentBackgroundImage.size;
	
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end