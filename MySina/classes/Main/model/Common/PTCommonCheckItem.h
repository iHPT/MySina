//
//  PTCommonCheckItem.h
//  MySina
//
//  Created by hpt on 16/5/12.
//  Copyright © 2016年 PT. All rights reserved.
//	commonCell右边为勾选的子类模型

#import "PTCommonItem.h"

@interface PTCommonCheckItem : PTCommonItem

@property (nonatomic, assign, getter = isChecked) BOOL checked;

@end
