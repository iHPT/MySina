#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (instancetype)imageWithName:(NSString *)name
{
	UIImage *image = nil;
	
	if (iOS7) {
		image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_ios7", name]];
	}
	if (!image) {
		image = [UIImage imageNamed:name];
	}
	
	return image;
}

+ (instancetype)resizedImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageWithName:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}
@end