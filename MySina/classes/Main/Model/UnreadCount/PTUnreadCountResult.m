//
//  PTUnreadCountResult.m
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTUnreadCountResult.h"

@implementation PTUnreadCountResult

// 未读新消息数
- (int)messageCount
{
	return self.cmt + self.dm + self.mention_status + self.mention_cmt;
}

//未读关于我的所有消息数
- (int)totalCount
{
	return self.status + self.messageCount + self.follower;
}

@end
