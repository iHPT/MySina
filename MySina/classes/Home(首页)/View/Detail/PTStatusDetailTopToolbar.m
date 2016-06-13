//
//  PTStatusDetailTopToolbar.m
//  MySina
//
//  Created by hpt on 16/5/19.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTStatusDetailTopToolbar.h"
#import "PTStatus.h"

@interface PTStatusDetailTopToolbar ()

/** 封装三个按钮的imageView */
@property (nonatomic, weak) UIImageView *buttonsView;
/** 转发按钮 */
@property (nonatomic, weak) UIButton *retweetButton;
/** 评论按钮 */
@property (nonatomic, weak) UIButton *commentButton;
/** 赞按钮 */
@property (nonatomic, weak) UIButton *attitudeButton;
/** 三角显示图片 */
@property (nonatomic, weak) UIImageView *triangleIndicator;
/** 分割线 */
@property (nonatomic, weak) UIImageView *divider;

/** 选中按钮 */
@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation PTStatusDetailTopToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = PTGlobalBackgroundColor;
        self.width = frame.size.width;
        
        [self setupButtonsView];
        
    }
    return self;
}

- (void)setupButtonsView
{
    UIImageView *buttonsView = [[UIImageView alloc] init];
    buttonsView.image = [UIImage resizedImage:@"statusdetail_comment_top_background"];
    buttonsView.userInteractionEnabled = YES;
    [self addSubview:buttonsView];
    self.buttonsView = buttonsView;
    
    // 添加转发按钮
    UIButton *retweetButton = [self createButtonWithTitle:@"转发" tag:PTStatusDetailTopToolbarButtonTypeRetweet];
    [buttonsView addSubview:retweetButton];
    self.retweetButton = retweetButton;
    [retweetButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加评论按钮
    UIButton *commentButton = [self createButtonWithTitle:@"评论" tag:PTStatusDetailTopToolbarButtonTypeComment];
    [buttonsView addSubview:commentButton];
    self.commentButton = commentButton;
    [commentButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加赞按钮
    UIButton *attitudeButton = [self createButtonWithTitle:@"赞" tag:PTStatusDetailTopToolbarButtonTypeAttitude];
    [buttonsView addSubview:attitudeButton];
    self.attitudeButton = attitudeButton;
    [attitudeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加三角指示图片
    UIImageView *triangleIndicator = [[UIImageView alloc] init];
    triangleIndicator.image = [UIImage resizedImage:@"statusdetail_comment_top_arrow"];
    [buttonsView addSubview:triangleIndicator];
    self.triangleIndicator = triangleIndicator;
    
    // 添加分割线
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage resizedImage:@"statusdetail_comment_line"];
    divider.size = divider.image.size;
    [buttonsView addSubview:divider];
    self.divider = divider;
    
}

- (void)buttonClick:(UIButton *)button
{
    // 设置选中按钮选中状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    // 移动三角图标到选中按钮下方
    self.triangleIndicator.centerX = self.selectedButton.centerX;
    
    // 调用代理方法
    if ([self.delegate respondsToSelector:@selector(statusDetailTopToolbar:didClickButton:)])
    {
        [self.delegate statusDetailTopToolbar:self didClickButton:button.tag];
    }
}

- (void)setDelegate:(id<PTStatusDetailTopToolbarDelegate>)delegate
{
    _delegate = delegate;
    
    [self buttonClick:self.commentButton];
}

- (UIButton *)createButtonWithTitle:(NSString *)title tag:(PTStatusDetailTopToolbarButtonType)buttonType
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    button.tag = buttonType;
    
    return button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // buttonsView的frame
    CGFloat buttonsViewX = 0;
    CGFloat buttonsViewY = 6;
    CGFloat buttonsViewW = self.width;
    CGFloat buttonsViewH = self.height - buttonsViewY;
    self.buttonsView.frame = CGRectMake(buttonsViewX, buttonsViewY, buttonsViewW, buttonsViewH);
    
    // 转发按钮frame
    CGFloat retweetButtonX = 0;
    CGFloat retweetButtonY = 0;
//    CGFloat retweetButtonW = [self.retweetButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.retweetButton.titleLabel.font}].width + 8;
    CGFloat retweetButtonW = 70;
    CGFloat retweetButtonH = buttonsViewH;
    self.retweetButton.frame = CGRectMake(retweetButtonX, retweetButtonY, retweetButtonW, retweetButtonH);
    
    // 分割线frame
    CGFloat dividerX = CGRectGetMaxX(self.retweetButton.frame);
    CGFloat dividerY = retweetButtonY;
    CGFloat dividerW = 1;
    CGFloat dividerH = buttonsViewH;
    self.divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    
    // 评论按钮frame
    CGFloat commentButtonX = CGRectGetMaxX(self.divider.frame);
    CGFloat commentButtonY = retweetButtonY;
//    CGFloat commentButtonW = [self.commentButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.commentButton.titleLabel.font}].width + 8;
    
    CGFloat commentButtonW = retweetButtonW;
    CGFloat commentButtonH = buttonsViewH;
    self.commentButton.frame = CGRectMake(commentButtonX, commentButtonY, commentButtonW, commentButtonH);
    
    // 赞按钮frame
    CGFloat attitudeButtonY = retweetButtonY;
//    CGFloat attitudeButtonW = [self.attitudeButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.attitudeButton.titleLabel.font}].width + 8;
    
    CGFloat attitudeButtonW = retweetButtonW;
    CGFloat attitudeButtonH = buttonsViewH;
    CGFloat attitudeButtonX = buttonsViewW - attitudeButtonW;
    self.attitudeButton.frame = CGRectMake(attitudeButtonX, attitudeButtonY, attitudeButtonW, attitudeButtonH);
    
    // 三角图片的frame
    self.triangleIndicator.width = 12;
    self.triangleIndicator.height = 7;
    self.triangleIndicator.centerX = self.commentButton.centerX;
    self.triangleIndicator.centerY = self.buttonsView.height - self.triangleIndicator.size.height;
}

- (void)setStatus:(PTStatus *)status
{
    _status = status;
    
    [self.retweetButton setTitle:[NSString stringWithFormat:@"转发 %d", status.reposts_count] forState:UIControlStateNormal];
    
    [self.commentButton setTitle:[NSString stringWithFormat:@"评论 %d", status.comments_count] forState:UIControlStateNormal];
    
    [self.attitudeButton setTitle:[NSString stringWithFormat:@"赞 %d", status.attitudes_count] forState:UIControlStateNormal];
}

@end
