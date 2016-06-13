//
//  PTBaseToolbar.m
//  MySina
//
//  Created by hpt on 16/5/18.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTBaseToolbar.h"
#import "PTStatus.h"

@interface PTBaseToolbar ()


@end


@implementation PTBaseToolbar

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        // 创建3个按钮添加到视图和数组
        self.repostsButton = [self creatButtonWithIcon:@"timeline_icon_retweet" defaultTitle:@"转发" titleFontSize:15];
        self.commentsButton = [self creatButtonWithIcon:@"timeline_icon_comment" defaultTitle:@"评论" titleFontSize:15];
        self.attitudesButton = [self creatButtonWithIcon:@"timeline_icon_unlike" defaultTitle:@"赞" titleFontSize:15];
    }
    return self;
}

/**
 *  创建按钮
 *
 *  @param icon  图标
 *  @param title 标题
 */
- (UIButton *)creatButtonWithIcon:(NSString *)icon defaultTitle:(NSString *)defaultTitle titleFontSize:(NSUInteger)size
{
    UIButton *button = [[UIButton alloc] init];
    [self addSubview:button];
    
    // 设置title
    [button setTitle:defaultTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    
    // 设置图片
    [button setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage resizedImage:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    button.adjustsImageWhenHighlighted = NO;
    
    // 设置间距
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    // 添加到数组
    [self.buttons addObject:button];
    
    return button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    CGFloat buttonW = self.width / self.buttons.count;
    CGFloat buttonH = self.height;
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        button.x = buttonW * i;
        button.y = 0;
        button.width = buttonW;
        button.height = buttonH;
    }
}

- (void)setStatus:(PTStatus *)status
{
    _status = status;
    
    NSString *repostsStr = [self stringFromCount:status.reposts_count placeholder:@"转发"];
    [self.repostsButton setTitle:repostsStr forState:UIControlStateNormal];
    
    NSString *commentsStr = [self stringFromCount:status.comments_count placeholder:@"评论"];
    [self.commentsButton setTitle:commentsStr forState:UIControlStateNormal];
    
    NSString *attitudesStr = [self stringFromCount:status.attitudes_count placeholder:@"赞"];
    [self.attitudesButton setTitle:attitudesStr forState:UIControlStateNormal];
}

/**
 *  将显示的转发数/评论数/赞 转换成另一种显示的字符串
 *	也可另写一个方法，将button也作为参数传入，一步设置
 */
- (NSString *)stringFromCount:(int)count placeholder:(NSString *)placeholder
{
    NSString *convertedStr = placeholder;
    if (count >= 10000) { // [10000, 无限大)
        convertedStr = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
        // 用空串替换掉所有的.0
        convertedStr = [convertedStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    } else if (count > 0) {
        convertedStr = [NSString stringWithFormat:@"%d", count];
    }
    return convertedStr;
}

@end
