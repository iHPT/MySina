//
//  PTCommonItem.m
//  MySina
//
//  Created by hpt on 16/5/12.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTCommonItem.h"

@implementation PTCommonItem


- (instancetype)initWithTitle:(NSString *)title
{
    return [self initWithTitle:title icon:nil];
}

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon
{
    self = [super init];
    if (self) {
        self.title = title;
        self.icon = icon;
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title
{
    return [[self alloc] initWithTitle:title];
}

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon
{
    return [[self alloc] initWithTitle:title icon:icon];
}

@end
