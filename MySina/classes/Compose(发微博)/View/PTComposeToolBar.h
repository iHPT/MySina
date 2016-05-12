//
//  PTComposeToolBar.h
//  MySina
//
//  Created by hpt on 16/4/18.
//  Copyright © 2016年 PT. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, PTComposeToolBarButtonType)
{
    PTComposeToolBarButtonTypeCamera = 0,
    PTComposeToolBarButtonTypePicture,
    PTComposeToolBarButtonTypeTrend,
    PTComposeToolBarButtonTypeMention,
    PTComposeToolBarButtonTypeEmotion
};

#import <UIKit/UIKit.h>

@class PTComposeToolBar;
@protocol PTComposeToolBarDelegate <NSObject>

@optional
- (void)composeToolBar:(PTComposeToolBar *)composeToolBar didClickButton:(PTComposeToolBarButtonType)buttonType;

@end

@interface PTComposeToolBar : UIView

/** 决定表情符按钮是像是笑脸图片还是键盘键盘图片 */
@property (nonatomic, assign, getter = isShowEmotionButton) BOOL showEmotionButton;

@property (nonatomic, weak) id<PTComposeToolBarDelegate> delegate;

@end
