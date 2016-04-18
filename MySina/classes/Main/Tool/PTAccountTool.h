//
//  PTAccountTool.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTAccount;
@interface PTAccountTool : NSObject

+ (PTAccount *)account;

+ (void)save:(PTAccount *)account;

@end
