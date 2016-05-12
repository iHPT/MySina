//
//  PTEmotionListView.h
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//	自定义表情键盘显示表情的上半部分：表情list

#import <UIKit/UIKit.h>

@interface PTEmotionListView : UIScrollView

/** 需要展示的所有表情 */
@property (nonatomic, strong) NSArray *emotions;

@end
