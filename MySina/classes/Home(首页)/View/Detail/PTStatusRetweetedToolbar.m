//
//  PTStatusRetweetedToolbar.m
//  MySina
//
//  Created by hpt on 16/5/18.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTStatusRetweetedToolbar.h"

@implementation PTStatusRetweetedToolbar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttons = nil;
        // 创建3个按钮添加到视图和数组
        self.repostsButton = [self creatButtonWithIcon:@"statusdetail_icon_retweet" defaultTitle:@"转发" titleFontSize:13];
        self.commentsButton = [self creatButtonWithIcon:@"statusdetail_icon_comment" defaultTitle:@"评论" titleFontSize:13];
        self.attitudesButton = [self creatButtonWithIcon:@"statusdetail_icon_like" defaultTitle:@"赞" titleFontSize:13];
    }
    return self;
}

@end
