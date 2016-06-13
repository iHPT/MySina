//
//  PTStatusDetailViewController.h
//  MySina
//
//  Created by hpt on 16/5/18.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PTStatus;

@interface PTStatusDetailViewController : UIViewController
/** 微博数据 */
@property (nonatomic, strong) PTStatus *status;
@end
