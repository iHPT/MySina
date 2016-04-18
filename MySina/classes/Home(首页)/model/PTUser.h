//
//  PTUser.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//	用户模型

#import <Foundation/Foundation.h>

@interface PTUser : NSObject

/** string 	友好显示名称 */
@property (nonatomic, copy) NSString *name;

/** string 	用户头像地址（中图），50×50像素 */
@property (nonatomic, copy) NSString *profile_image_url;



@end
