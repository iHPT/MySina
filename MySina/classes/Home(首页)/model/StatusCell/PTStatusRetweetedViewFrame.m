//
//  PTStatusRetweetedViewFrame.m
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTStatusRetweetedViewFrame.h"
#import "PTStatus.h"
#import "PTUser.h"
#import "PTStatusPhotosView.h"

@implementation PTStatusRetweetedViewFrame

- (void)setRetweetedStatus:(PTStatus *)retweetedStatus
{
    _retweetedStatus = retweetedStatus;
    // 去除用户模型
    PTUser *user = retweetedStatus.user;
    
    // 昵称
    CGFloat nameX = PTStatusCellInset;
    CGFloat nameY = PTStatusCellInset;
    NSString *displayStr = [NSString stringWithFormat:@"@%@", user.name];
    CGSize nameSize = [displayStr sizeWithAttributes:@{NSFontAttributeName : PTStatusCellNameFont}];
    self.nameFrame = (CGRect){{nameX, nameY}, nameSize};
    
    // 正文
    CGFloat textX = PTStatusCellInset;
    CGFloat textY = PTStatusCellInset * 0.5;
    CGSize maxSize = CGSizeMake(ScreenWidth - 2 * PTStatusCellInset, MAXFLOAT);
//    CGSize textSize = [retweetedStatus.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : PTStatusCellTextFont} context:nil].size;
    CGSize textSize = [retweetedStatus.attributedText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.textFrame = (CGRect){{textX, textY}, textSize};
    
    CGFloat h = 0;
    // 相册
    if (retweetedStatus.pic_urls.count) {
    	CGFloat photosX = PTStatusCellInset;
	    CGFloat photosY = CGRectGetMaxY(self.textFrame) + PTStatusCellInset;
	    CGSize photosSize = [PTStatusPhotosView sizeWithPhotosCount:retweetedStatus.pic_urls.count];
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
