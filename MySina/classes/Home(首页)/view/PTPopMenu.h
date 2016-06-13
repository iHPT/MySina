//
//  PTPopMenu.h
//  MySina
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//  弹出框，弹出框的frame为整个屏幕，有个遮盖填充屏幕，中间有个container(UIImageView)，container中用于显示要显示的contentView

typedef NS_OPTIONS(NSInteger, PTPopMenuArrowPosition) {
    PTPopMenuArrowPositionCenter = 0,
    PTPopMenuArrowPositionLeft = 1,
    PTPopMenuArrowPositionRight = 2
};

#import <UIKit/UIKit.h>

@class PTPopMenu;
@protocol PTPopMenuDelegate <NSObject>

@optional
- (void)popMenuDidDismissed:(PTPopMenu *)popMenu;

@end


@interface PTPopMenu : UIView

@property (nonatomic, assign) PTPopMenuArrowPosition arrowPosition;

@property (nonatomic, weak) id<PTPopMenuDelegate> delegate;

- (instancetype)initWithContentView:(UIView *)contentView;
+ (instancetype)popMenuWithContentView:(UIView *)contentView;

- (void)showInRect:(CGRect)rect;

@end