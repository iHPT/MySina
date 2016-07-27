//
//  PTUnreadCountResult.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTUnreadCountResult : NSObject

/** 字段类型 	字段说明 */
/** 	int 	新微博未读数 */
@property (nonatomic, assign) int status;

/** 	int 	新粉丝数 */
@property (nonatomic, assign) int follower;

/** 	int 	新评论数 */
@property (nonatomic, assign) int cmt;

/** 	int 	新私信数 */
@property (nonatomic, assign) int dm;

/** 	int 	新提及我的微博数 */
@property (nonatomic, assign) int mention_status;

/** 	int 	新提及我的评论数 */
@property (nonatomic, assign) int mention_cmt;

/** 	int 	微群消息未读数 */
@property (nonatomic, assign) int group;

/** 	int 	私有微群消息未读数 */
@property (nonatomic, assign) int private_group;

/** 	int 	新通知未读数 */
@property (nonatomic, assign) int notice;

/** 	int 	新邀请未读数 */
@property (nonatomic, assign) int invite;

/** 	int 	新勋章数 */
@property (nonatomic, assign) int badge;

/** 	int 	相册消息未读数 */
@property (nonatomic, assign) int photo;

/** 	int 	{{{3}}} */
@property (nonatomic, assign) int msgbox;


// 未读新消息数
- (int)messageCount;

//未读关于我的所有消息数
- (int)totalCount;

@end
