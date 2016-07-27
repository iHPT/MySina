//
//  PTStatusFrame.h
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PTStatus, PTStatusDetailViewFrame;

@interface PTStatusFrame : NSObject

/** 子控件的frame数据 */
@property (nonatomic, assign) CGRect toolbarFrame;
@property (nonatomic, strong) PTStatusDetailViewFrame *detailViewFrame;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

/** 微博数据 */
@property (nonatomic, strong) PTStatus *status;

@end
