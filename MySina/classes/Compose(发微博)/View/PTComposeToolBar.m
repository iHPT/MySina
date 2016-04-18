//
//  PTComposeToolBar.m
//  MySina
//
//  Created by hpt on 16/4/18.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTComposeToolBar.h"

@implementation PTComposeToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"compose_toolbar_background"]];
        
        [self addButtonWithImageName:@"compose_camerabutton_background" highlightedImageName:@"compose_camerabutton_background_highlighted" tag:PTComposeToolBarButtonTypeCamera];
        [self addButtonWithImageName:@"compose_toolbar_picture" highlightedImageName:@"compose_toolbar_picture_highlighted" tag:PTComposeToolBarButtonTypeCamera];
        [self addButtonWithImageName:@"compose_trendbutton_background" highlightedImageName:@"compose_trendbutton_background_highlighted" tag:PTComposeToolBarButtonTypeCamera];
        [self addButtonWithImageName:@"compose_mentionbutton_background" highlightedImageName:@"compose_mentionbutton_background_highlighted" tag:PTComposeToolBarButtonTypeCamera];
        [self addButtonWithImageName:@"compose_emoticonbutton_background" highlightedImageName:@"compose_emoticonbutton_background_highlighted" tag:PTComposeToolBarButtonTypeCamera];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int index  = 0;
    CGFloat buttonW = ScreenWidth / self.subviews.count;
    for (UIButton *button in self.subviews) {
        button.y = 0;
        button.width = buttonW;
        button.height = self.height;
        button.x = index * buttonW;
        
        index++;
    }
}

- (void)addButtonWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName tag:(PTComposeToolBarButtonType)buttonType
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageWithName:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageWithName:highlightedImageName] forState:UIControlStateHighlighted];
    button.tag = buttonType;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
}

- (void)buttonClick:(PTComposeToolBarButtonType)buttonType
{
    if ([self.delegate respondsToSelector:@selector(composeToolBar:didClickButton:)]) {
        [self.delegate composeToolBar:self didClickButton:buttonType];
        
    }
    
}

@end
