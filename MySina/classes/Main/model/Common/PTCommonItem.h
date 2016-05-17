//
//  PTCommonItem.h
//  MySina
//
//  Created by hpt on 16/5/12.
//  Copyright © 2016年 PT. All rights reserved.
//	一个cell对应一个commonItem模型

#import <Foundation/Foundation.h>

@interface PTCommonItem : NSObject

/** 图标 */
@property (nonatomic, copy) NSString *icon;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 子标题 */
@property (nonatomic, copy) NSString *subtitle;
/** 右边的提示数字 */
@property (nonatomic, copy) NSString *badgeValue;
/** 需要跳转的控制器类名 */
@property (nonatomic, assign) Class destVc;
/** 点击这个cell想做的操作 */
@property (nonatomic, copy) void(^operation)();

- (instancetype)initWithTitle:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon;

+ (instancetype)itemWithTitle:(NSString *)title;

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;

@end
