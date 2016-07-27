//
//  PTStatusPhotosView.m
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//	微博图片相册，最多显示9张图片

#define PTStatusPhotosCountMax 9
#define PTStatusPhotosColumnMax(count) (count == 4 ? 2 : 3)
#define PTStatusPhotoWidth 80
#define PTStatusPhotoHeight PTStatusPhotoWidth
#define PTStatusPhotosMargin 8

#import "PTStatusPhotosView.h"
#import "PTStatusPhotoView.h"
#import "PTPhoto.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface PTStatusPhotosView ()


@end


@implementation PTStatusPhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    		self.backgroundColor = [UIColor clearColor];
    		self.userInteractionEnabled = YES;
    		
    		/** setter方法会不断调用，初始化就创建9个imageView，设置pic_urls属性时进行显示和隐藏
    		 *  而不是在每次设置属性时都重新创建相应个数的imageView
    		 */
    		for (int i = 0; i < PTStatusPhotosCountMax; i++) {
    			PTStatusPhotoView *photoView = [[PTStatusPhotoView alloc] init];
                photoView.tag = i;
    			[self addSubview:photoView];
                
                // 添加手势监听器（一个手势监听器 只能 监听对应的一个view）
                UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
                [recognizer addTarget:self action:@selector(tapPhoto:)];
                [photoView addGestureRecognizer:recognizer];
                
    		}
    }
    return self;
}

/**
 *  监听图片的点击
 */
- (void)tapPhoto:(UITapGestureRecognizer *)recognizer
{
    // 1.创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    // 2.设置图片浏览器显示的所有图片
    NSMutableArray *photos = [NSMutableArray array];
    int count = self.pic_urls.count;
    for (int i = 0; i<count; i++) {
        PTPhoto *pic = self.pic_urls[i];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        // 设置图片的路径
        photo.url = [NSURL URLWithString:pic.bmiddle_pic];
        // 设置来源于哪一个UIImageView
        photo.srcImageView = self.subviews[i];
        [photos addObject:photo];
    }
    browser.photos = photos;
    
    // 3.设置默认显示的图片索引
    browser.currentPhotoIndex = recognizer.view.tag;
    
    // 3.显示浏览器
    [browser show];
}

- (void)setPic_urls:(NSArray *)pic_urls
{
	_pic_urls = pic_urls;
	
	for (int i = 0; i < PTStatusPhotosCountMax; i++) {
		// 设置相对应的图片
		PTStatusPhotoView *photoView = self.subviews[i];
		
		
		// 将没有用到的隐藏，避免cell重用frame错乱
		if (i < pic_urls.count) {
            photoView.photo = pic_urls[i];
			photoView.hidden = NO;
		} else {
			photoView.hidden = YES;
		}
	}
}

+ (CGSize)sizeWithPhotosCount:(int)count
{
	// 获取最大列数，如果有4张图片，则两列显示，其他情况3列显示
	int colMax = PTStatusPhotosColumnMax(count);
	// 总列数:1张-1列，2张-2列，3张-3列，4张-2列，5张-3列...
  int totalCols = count >= colMax ?  colMax : count;
	int totalRows = (count + colMax - 1) / colMax;
	CGFloat height = totalRows * PTStatusPhotoHeight + (totalRows - 1) * PTStatusPhotosMargin;
	CGFloat width = totalCols * PTStatusPhotoWidth + (totalCols - 1) * PTStatusPhotosMargin;
	return CGSizeMake(width, height);
}

/** 设置9个子控件的frame */
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	// 拿到相册的总列数
	int colMax = PTStatusPhotosColumnMax(self.pic_urls.count);
	int i = 0;
	for (PTStatusPhotoView *photo in self.subviews) {
		// 设置每个相片的frame
		photo.x = i % colMax * (PTStatusPhotoWidth + PTStatusPhotosMargin);
		photo.y = i / colMax * (PTStatusPhotoHeight + PTStatusPhotosMargin);
		photo.width = PTStatusPhotoWidth;
		photo.height = PTStatusPhotoHeight;
		
		i++;
	}
}

@end
