//
//  PTEmotionPopView.h
//  MySina
//
//  Created by hpt on 16/5/3.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PTEmotionView;

@interface PTEmotionPopView : UIView

- (void)showFromEmotionView:(PTEmotionView *)fromEmotionView;
- (void)dismiss;
@end
