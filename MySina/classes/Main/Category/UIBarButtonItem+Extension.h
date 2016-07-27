#import "UIBarButtonItem+Extension.h"

@interface UIBarButtonItem (Extension)

+ (instancetype)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action;

@end