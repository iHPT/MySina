//
//  PTStatusPhotoView.m
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//	微博图片相册，最多显示9张图片

#import "PTStatusPhotoView.h"
#import "UIImageView+WebCache.h"
#import "PTPhoto.h"

@interface PTStatusPhotoView ()

@property (nonatomic, weak) UIImageView *gif;

@end


@implementation PTStatusPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    	self.userInteractionEnabled = YES;
    	self.contentMode = UIViewContentModeScaleAspectFill;
    	self.clipsToBounds = YES;
    	
    	/** imageWithName:方法创建后就有frame:{{0, 0}, image.size}
    	 *  使用alloc/init创建，然后设置image是没有frame的;
    	 */
    	// 添加一个gif图标
        UIImage *image = [UIImage imageWithName:@"timeline_image_gif"];
    	UIImageView *gif = [[UIImageView alloc] initWithImage:image];
    	[self addSubview:gif];
    	self.gif = gif;
    	
    	
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	// 创建时gif就有了frame
	self.gif.x = self.width - self.gif.width;
	self.gif.y = self.height - self.gif.height;
}

- (void)setPhoto:(PTPhoto *)photo
{
	_photo = photo;
	
	[self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageWithName:@"timeline_image_placeholder"]];
	
	// 如果是gif则显示gif角标，否则隐藏
	NSString *extensionName = photo.thumbnail_pic.pathExtension.lowercaseString;
	self.gif.hidden = ![extensionName isEqualToString:@"gif"];
}

@end
