//
//  PTStatus.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//	微博模型

#import "PTStatus.h"

@class PTUser;

@interface PTStatus : NSObject

// 	字段类型 	字段说明 
/** 	string 	微博创建时间 */
@property (nonatomic, copy) NSString *created_at;

/** 	string 	字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;

/** 	string 	微博信息内容 */
@property (nonatomic, copy) NSString *text;
/** 	string 	实际获取的微博表情数据为字符，需转换成图片表情，用属性attributeText属性表示 */
@property (nonatomic, copy) NSAttributedString *attributedText;

/** 	string 	微博来源 */
@property (nonatomic, copy) NSString *source;

/** 	object 	微博作者的用户信息字段 详细 */
@property (nonatomic, strong) PTUser *user;

/** 	object 	被转发的原微博信息字段，当该微博为转发微博时返回 */
@property (nonatomic, strong) PTStatus *retweeted_status;

/** 	int 	转发数 */
@property (nonatomic, assign) int reposts_count;

/** 	int 	评论数 */
@property (nonatomic, assign) int comments_count;

/** 	int 	表态数 */
@property (nonatomic, assign) int attitudes_count;

/** 	object 	微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。 */
@property (nonatomic, copy) NSArray *pic_urls;

/** 	bool 	是否为转发微博 */
@property (nonatomic, assign, getter=isRetweeted) BOOL retweeted;

/** 	bool 	微博cell是否是详情微博(详情微博转发微博右下角显示工具条，首页不显示) */
@property (nonatomic, assign, getter=isDeatil) BOOL detail;

@end
