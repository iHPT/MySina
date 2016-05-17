//
//  PTCommonCheckGroup.m
//  MySina
//
//  Created by hpt on 16/5/12.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTCommonCheckGroup.h"
#import "PTCommonCheckItem.h"

@implementation PTCommonCheckGroup

- (void)setCheckedIndex:(NSInteger)checkedIndex
{
    _checkedIndex = checkedIndex;
    
    // 屏蔽外面的SB行为(乱传参数行为)
    int count = self.items.count;
    if (checkedIndex < 0 || checkedIndex >= count) return;
    
    for (int i = 0; i<count; i++) {
        PTCommonCheckItem *item = self.items[i];
        
        if (i == checkedIndex) {
            item.checked = YES;
        } else {
            item.checked = NO;
        }
    }
}

- (void)setItems:(NSArray *)items
{
    [super setItems:items];
    
    self.checkedIndex = self.checkedIndex;
}

@end
