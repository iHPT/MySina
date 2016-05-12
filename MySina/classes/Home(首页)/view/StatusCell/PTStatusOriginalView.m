//
//  PTStatusOriginalView.m
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTStatusOriginalView.h"
#import "PTStatusOriginalViewFrame.h"
#import "PTStatus.h"
#import "PTUser.h"
#import "PTStatusPhotosView.h"
#import "PTStatusLabel.h"

@interface PTStatusOriginalView ()

/** 图像 */
@property (nonatomic, weak) UIImageView *iconView;

/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;

/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;

/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;

/** 正文 */
@property (nonatomic, weak) PTStatusLabel *textLabel;

/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;

/** 相册 */
@property (nonatomic, weak) PTStatusPhotosView *photosView;

@end


@implementation PTStatusOriginalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { // 初始化子控件
        // 头像
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeCenter; // 原图居中显示
        [self addSubview:iconView];
        self.iconView = iconView;
        
        // 昵称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = PTStatusCellNameFont;
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // 时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = PTStatusCellTimeFont;
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        // 来源
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.textColor = [UIColor lightGrayColor];
        sourceLabel.font = PTStatusCellSourceFont;
        [self addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        // 正文
        PTStatusLabel *textLabel = [[PTStatusLabel alloc] init];
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        
        // 会员图标
        UIImageView *vipView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeCenter; // 原图居中显示
        [self addSubview:vipView];
        self.vipView = vipView;
        
        // 相册
        PTStatusPhotosView *photosView = [[PTStatusPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;
    }
    return self;
}

- (void)setOriginalViewFrame:(PTStatusOriginalViewFrame *)originalViewFrame
{
    _originalViewFrame = originalViewFrame;
    self.frame = originalViewFrame.frame;
    // 取出微博数据
    PTStatus *status = originalViewFrame.status;
    // 取出用户数据
    PTUser *user = status.user;
    
    // 图标
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageWithName:@"avatar_default_small"]];
    self.iconView.frame = originalViewFrame.iconFrame;
    
    // 昵称
    self.nameLabel.text = user.name;
    self.nameLabel.frame = originalViewFrame.nameFrame;
    if (user.vip) { // 会员
        self.nameLabel.textColor = [UIColor redColor];
    	// 设置会员图标和昵称字体颜色
        self.vipView.hidden = NO;
        self.vipView.frame = originalViewFrame.vipFrame;
    	self.vipView.image = [UIImage imageWithName:[NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank]];
    } else { // 非会员
    	self.vipView.hidden = YES;
    	self.nameLabel.textColor = [UIColor blackColor];
    }
    
#warning 需要时刻根据现在的时间字符串来计算时间label的frame    
    /** cell重构时timeLabel的数据有时刻更新，但frame一直是最开始“刚刚”的frame
     *  status模型的time和source的getter方法在不断被调用，需更新timeLabel值时更新frame
     *	同时为提高性能，source值不变，使用setter方法，只在第一次获取调用得到值，不需重写getter方法(会被重复调用)
     */
    // 时间
    NSString *time = status.created_at; // 刚刚 --> 1分钟前 --> 10分钟前
    self.timeLabel.text = time;
    // 设置时间标签frame
    CGFloat timeX = CGRectGetMinX(self.nameLabel.frame);
    CGFloat timeY = CGRectGetMaxY(self.nameLabel.frame) + PTStatusCellInset * 0.5;
    CGSize timeSize = [time sizeWithAttributes:@{NSFontAttributeName : PTStatusCellTimeFont}];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    
    // 来源
    self.sourceLabel.text = status.source;
    // 设置来源标签frame
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + PTStatusCellInset;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithAttributes:@{NSFontAttributeName : PTStatusCellSourceFont}];
    self.sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    
    // 正文
//    self.textLabel.text = status.text;
    self.textLabel.attributedText = status.attributedText;
    self.textLabel.frame = originalViewFrame.textFrame;
    
    // 相册
    if (status.pic_urls.count) { // 有配图
        self.photosView.frame = originalViewFrame.photosFrame;
        self.photosView.pic_urls = status.pic_urls;
        self.photosView.hidden = NO;
    } else {
        self.photosView.hidden = YES;
    }
}

@end
