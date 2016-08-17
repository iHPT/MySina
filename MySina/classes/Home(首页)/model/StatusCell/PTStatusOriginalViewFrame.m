//
//  PTStatusOriginalViewFrame.m
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTStatusOriginalViewFrame.h"
#import "PTStatus.h"
#import "PTUser.h"
#import "PTStatusPhotosView.h"

@implementation PTStatusOriginalViewFrame

- (void)setStatus:(PTStatus *)status
{
    _status = status;
    // 去除用户模型
    PTUser *user = status.user;
    
    // 图像
    CGFloat iconX = PTStatusCellInset;
    CGFloat iconY = PTStatusCellInset;
    CGFloat iconW = 35;
    CGFloat iconH = iconW;
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 昵称
    CGFloat nameX = CGRectGetMaxX(self.iconFrame) + PTStatusCellInset;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.name sizeWithAttributes:@{NSFontAttributeName : PTStatusCellNameFont}];
    self.nameFrame = (CGRect){{nameX, nameY}, nameSize};
    
    // 正文
    CGFloat textX = PTStatusCellInset;
    CGFloat textY = CGRectGetMaxY(self.iconFrame) + PTStatusCellInset;
    CGSize maxSize = CGSizeMake(ScreenWidth - 2 * PTStatusCellInset, MAXFLOAT);
//    CGSize textSize = [status.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : PTStatusCellTextFont} context:nil].size;
    CGSize textSize = [status.attributedText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.textFrame = (CGRect){{textX, textY}, textSize};
    
    // 会员图标
    if (user.vip) {
	    CGFloat vipX = CGRectGetMaxX(self.nameFrame) + PTStatusCellInset * 0.5;
	    CGFloat vipY = nameY;
	    CGFloat vipH = nameSize.height;
	    CGFloat vipW = vipH;
	    self.vipFrame = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    CGFloat h = 0;
     // 相册
    if (status.pic_urls.count) {
    	CGFloat photosX = PTStatusCellInset;
	    CGFloat photosY = CGRectGetMaxY(self.textFrame) + PTStatusCellInset;
	    CGSize photosSize = [PTStatusPhotosView sizeWithPhotosCount:status.pic_urls.count];
	    self.photosFrame = (CGRect){{photosX, photosY}, photosSize};
	    
    	h = CGRectGetMaxY(self.photosFrame) + PTStatusCellInset;
    } else {
    	h = CGRectGetMaxY(self.textFrame) + PTStatusCellInset;
    }
    
    // 自己的frame
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = ScreenWidth;
    self.frame = CGRectMake(x, y, w, h);
}
@end
