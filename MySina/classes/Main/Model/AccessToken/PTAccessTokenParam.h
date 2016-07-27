//
//  PTAccessTokenParam.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTAccessTokenParam : NSObject

/**  	true 	string 	申请应用时分配的AppKey。 */
@property (nonatomic, copy) NSString *client_id;

/** 	true 	string 	申请应用时分配的AppSecret。 */
@property (nonatomic, copy) NSString *client_secret;

/** 	true 	string 	请求的类型，填写authorization_code  */
@property (nonatomic, copy) NSString *grant_type;

/** 	true 	string 	调用authorize获得的code值。 */
@property (nonatomic, copy) NSString *code;

/** 	true 	string 	回调地址，需需与注册应用里的回调地址一致。 */
@property (nonatomic, copy) NSString *redirect_uri;

+ (instancetype)param;

@end
