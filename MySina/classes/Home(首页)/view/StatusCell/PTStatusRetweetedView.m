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

@interface PTStatusRetweetedView ()

/** 昵称 */
@property (nonatomic, weak) UILabel *nameLable;

/** 正文 */
@property (nonatomic, weak) UILabel *textLabel;

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
        // 昵称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = PTColor(74, 102, 105);
        nameLabel.font = PTStatusCellNameFont;
        _textLabel.numberOfLines = 0;
        [self addSubview:nameLabel];
        self.nameLable = nameLabel;
        
        // 正文
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = PTStatusCellTextFont;
        textLabel.numberOfLines = 0;
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
    // 取出用户模型
    PTUser *user = retweetedStatus.user;
    
    // 昵称
    self.nameLable.text = [NSString stringWithFormat:@"@%@", user.name];
    self.nameLable.frame = retweetedViewFrame.nameFrame;
    
    // 正文
    self.textLabel.text = retweetedStatus.text;
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

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    
//    [self setNeedsDisplay];
//}
//
//- (void)drawRect:(CGRect)rect
//{
//    [[UIImage resizedImage:@"timeline_retweet_background"] drawInRect:rect];
//}

@end
