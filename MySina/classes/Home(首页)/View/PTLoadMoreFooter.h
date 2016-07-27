//
//  PTLoadMoreFooter.h
//  MySina
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTLoadMoreFooter : UIView

@property (nonatomic, assign, getter=isRefreshing) BOOL refreshing;

- (void)beginRefreshing;

- (void)endRefreshing;

@end