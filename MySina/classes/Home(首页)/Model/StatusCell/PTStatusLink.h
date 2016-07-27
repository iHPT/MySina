//
//  PTStatusLink.h
//  MySina
//
//  Created by hpt on 16/5/10.
//  Copyright © 2016年 PT. All rights reserved.
//  一个link对象封装一个链接

#import <Foundation/Foundation.h>

@interface PTStatusLink : NSObject

/** 链接文字 */
@property (nonatomic, copy) NSString *text;
/** 链接的范围 */
@property (nonatomic, assign) NSRange range;
/** 链接的边框 */
@property (nonatomic, strong) NSArray *rects;

@end
