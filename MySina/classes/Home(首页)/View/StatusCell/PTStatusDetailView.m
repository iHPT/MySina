//
//  PTStatusDetailView.m
//  MySina
//
//  Created by hpt on 16/4/24.
//  Copyright © 2016年 PT. All rights reserved.
//  微博数据视图 = 原创微博视图(评论) + 转发微博视图

#import "PTStatusDetailView.h"
#import "PTStatusOriginalView.h"
#import "PTStatusRetweetedView.h"
#import "PTStatusDetailViewFrame.h"
#import "PTStatusOriginalViewFrame.h"
#import "PTStatusRetweetedViewFrame.h"

@interface PTStatusDetailView ()

@property (nonatomic, weak) PTStatusOriginalView *originalView;

@property (nonatomic, weak) PTStatusRetweetedView *retweetedView;

@end

@implementation PTStatusDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizedImage:@"timeline_card_top_background"];
        
        // 初始化子控件
        // 原创微博视图(评论)
        PTStatusOriginalView *originalView = [[PTStatusOriginalView alloc] init];
        [self addSubview:originalView];
        self.originalView = originalView;
        
        // 转发微博视图
        PTStatusRetweetedView *retweetedView = [[PTStatusRetweetedView alloc] init];
        [self addSubview:retweetedView];
        self.retweetedView = retweetedView;
    }
    
    return self;
}

- (void)setDetailViewFrame:(PTStatusDetailViewFrame *)detailViewFrame
{
    _detailViewFrame = detailViewFrame;
    
    self.frame = detailViewFrame.frame;
    
    // 1.原创微博的frame数据
    self.originalView.originalViewFrame = detailViewFrame.originalViewFrame;
    
    // 2.原创转发的frame数据
    self.retweetedView.retweetedViewFrame = detailViewFrame.retweetedViewFrame;
}

@end
