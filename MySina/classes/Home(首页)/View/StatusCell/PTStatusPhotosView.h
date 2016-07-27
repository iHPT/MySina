//
//  PTStatusPhotosView.h
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//	微博图片相册，最多显示9张图片

#import <UIKit/UIKit.h>

@interface PTStatusPhotosView : UIView

/** 存放status.pic_urls属性---PTPhoto模型数组 */
@property (nonatomic, strong) NSArray *pic_urls;


+ (CGSize)sizeWithPhotosCount:(int)count;

@end
