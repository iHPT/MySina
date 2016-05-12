//
//  PTStatusRetweetedView.m
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTStatusRetweetedView.h"
#import "PTStatusRetweetedViewFrame.h"
#import "PTStatus.h"
#import "PTUser.h"
#import "PTStatusPhotosView.h"
#import "PTStatusLabel.h"

@interface PTStatusRetweetedView ()

/** 正文 */
@property (nonatomic, weak) PTStatusLabel *textLabel;

/** 相册 */
@property (nonatomic, weak) PTStatusPhotosView *photosView;

@end


@implementation PTStatusRetweetedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            self.userInteractionEnabled = YES;
    		self.image = [UIImage resizedImage:@"timeline_retweet_background"];
    		self.highlightedImage = [UIImage resizedImage:@"timeline_retweet_background_highlighted"];
    		
    	// 初始化子控件
        // 正文
        PTStatusLabel *textLabel = [[PTStatusLabel alloc] init];
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        
        // 相册
        PTStatusPhotosView *photosView = [[PTStatusPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;
    }
    return self;
}

- (void)setRetweetedViewFrame:(PTStatusRetweetedViewFrame *)retweetedViewFrame
{
    _retweetedViewFrame = retweetedViewFrame;
    self.frame = retweetedViewFrame.frame;
    
    // 取出微博模型
    PTStatus * retweetedStatus = retweetedViewFrame.retweetedStatus;
    
    // 正文
    self.textLabel.attributedText = retweetedStatus.attributedText;
    self.textLabel.frame = retweetedViewFrame.textFrame;
    
    // 相册
    if (retweetedStatus.pic_urls.count) { // 有配图
        self.photosView.frame = retweetedViewFrame.photosFrame;
        self.photosView.pic_urls = retweetedStatus.pic_urls;
        self.photosView.hidden = NO;
    } else {
        self.photosView.hidden = YES;
    }
}


@end
