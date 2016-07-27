//
//  PTComposePhotosView.m
//  MySina
//
//  Created by hpt on 16/4/18.
//  Copyright © 2016年 PT. All rights reserved.
//

#define PTComposePhotosViewColumnsMax 3

#import "PTComposePhotosView.h"

@implementation PTComposePhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
			
		}
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 10.0;
    CGFloat imageViewW = (ScreenWidth - (PTComposePhotosViewColumnsMax + 1) * margin) / PTComposePhotosViewColumnsMax;
    CGFloat imageViewH = imageViewW;
    
    int index = 0;
    for (UIImageView *imageView in self.subviews) {
    		int col = index % PTComposePhotosViewColumnsMax;
    		int row = index / PTComposePhotosViewColumnsMax;
    		
        imageView.width = imageViewW;
        imageView.height = imageViewH;
        imageView.x = margin + (margin + imageViewW) * col;
        imageView.y = (margin + imageViewH) * row;
        
        index++;
    }
}

- (void)addImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:imageView];
    
    [self setNeedsLayout];
}


@end
