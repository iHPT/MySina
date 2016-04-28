//
//  PTStatusDetailViewFrame.m
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTStatusDetailViewFrame.h"
#import "PTStatusOriginalViewFrame.h"
#import "PTStatusRetweetedViewFrame.h"
#import "PTStatus.h"

@implementation PTStatusDetailViewFrame

- (void)setStatus:(PTStatus *)status
{
    _status = status;
    
    // 1.计算原创微博的frame
    PTStatusOriginalViewFrame *originalViewFrame = [[PTStatusOriginalViewFrame alloc] init];
    originalViewFrame.status = status;
    self.originalViewFrame = originalViewFrame;
    
    // 2.计算转发微博的frame
    CGFloat h = 0;
    if (status.retweeted_status) { // 如果有转发微博
        PTStatusRetweetedViewFrame *retweetedViewFrame = [[PTStatusRetweetedViewFrame alloc] init];
        retweetedViewFrame.retweetedStatus = status.retweeted_status;
        
        // 调整转发微博的y值
        CGRect rect = retweetedViewFrame.frame;
        rect.origin.y = CGRectGetMaxY(self.originalViewFrame.frame);
        retweetedViewFrame.frame = rect;
        self.retweetedViewFrame = retweetedViewFrame;
        
        h = CGRectGetMaxY(self.retweetedViewFrame.frame);
    } else{
        h = CGRectGetMaxY(self.originalViewFrame.frame);
    }
    
    CGFloat x = 0;
    CGFloat y = PTStatusCellMargin;
    CGFloat w = ScreenWidth;
    self.frame = CGRectMake(x, y, w, h);
    
}

@end
