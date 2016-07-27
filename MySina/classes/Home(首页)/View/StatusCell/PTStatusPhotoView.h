//
//  PTStatusPhotoView.h
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//	微博图片，显示相册中的单张图片

#import <UIKit/UIKit.h>
@class PTPhoto;

@interface PTStatusPhotoView : UIImageView

@property (nonatomic, strong) PTPhoto *photo;

@end
