//
//  PTStatusDetailBottomToolbar.m
//  MySina
//
//  Created by hpt on 16/5/19.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTStatusDetailBottomToolbar.h"

@implementation PTStatusDetailBottomToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage resizedImage:@"statusdetail_toolbar_background"];
    }
    return self;
}

@end
