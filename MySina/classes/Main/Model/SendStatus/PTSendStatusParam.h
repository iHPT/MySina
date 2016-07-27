//
//  PTSendStatusParam.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//	发送一条微博的参数哦模型，返回的数据是发送的微博
//

#import <Foundation/Foundation.h>
#import "PTBaseParam.h"

@interface PTSendStatusParam : PTBaseParam

/** 	true 	string 	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。 */
@property (nonatomic, copy) NSString *status;

/** 	false 	int 	微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见，3：指定分组可见，默认为0。 */
@property (nonatomic, strong) NSNumber *visible;

/** 	false 	string 	微博的保护投递指定分组ID，只有当visible参数为3时生效且必选。 */
@property (nonatomic, copy) NSString *list_id;

/** 	true 	binary 	要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。 */
@property (nonatomic, strong) NSData *pic;

/** 	false 	float 	纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。 */
@property (nonatomic, strong) NSNumber *lat;

///** 	false 	float 	经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。 */
//@property (nonatomic, strong) NSNumber *long;

/** 	false 	string 	元数据，主要是为了方便第三方应用记录一些适合于自己使用的信息，每条微博可以包含一个或者多个元数据，必须以json字串的形式提交，字串长度不超过512个字符，具体内容可以自定。 */
@property (nonatomic, copy) NSString *annotations;

/** 	false 	string 	开发者上报的操作用户真实IP，形如：211.156.0.1。 */
@property (nonatomic, copy) NSString *rip;

@end
