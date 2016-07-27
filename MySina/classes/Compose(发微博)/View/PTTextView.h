//
//  PTTextView.h
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, strong) UIColor *placeholderColor;

- (void)textDidChange;
@end
