//
//  PTBaseToolbar.h
//  MySina
//
//  Created by hpt on 16/5/18.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PTStatus;

@interface PTBaseToolbar : UIImageView
/** 微博数据 */
@property (nonatomic, strong) PTStatus *status;

/** 子类访问，detail中按钮图片稍小 */
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) UIButton *repostsButton;
@property (nonatomic, weak) UIButton *commentsButton;
@property (nonatomic, weak) UIButton *attitudesButton;

- (UIButton *)creatButtonWithIcon:(NSString *)icon defaultTitle:(NSString *)defaultTitle titleFontSize:(NSUInteger)size;
@end
