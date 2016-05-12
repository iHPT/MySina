//
//  PTEmotionView.h
//  MySina
//
//  Created by hpt on 16/5/3.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PTEmotion;

@interface PTEmotionView : UIButton

/** 需要展示表情 */
@property (nonatomic, strong) PTEmotion *emotion;

@end
