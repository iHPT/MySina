//
//  PTEmotionListView.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//	自定义表情键盘显示表情的上半部分：表情list

#import "PTEmotionListView.h"
#import "PTEmotionGridView.h"

@interface PTEmotionListView () <UIScrollViewDelegate>

/** 显示所有表情的UIScrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 显示页码的UIPageControl */
@property (nonatomic, weak) UIPageControl *pageControl;

@end


@implementation PTEmotionListView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// 1.显示所有表情的UIScrollView
		[self setupEmotionScrollView];
		
		// 2.显示页码的UIPageControl
		[self setupPageControl];
		
}
	return self;
}

/** 显示所有表情的UIScrollView */
- (void)setupEmotionScrollView
{
		UIScrollView *scrollView = [[UIScrollView alloc] init];
		[self addSubview:scrollView];
		
		// 滚动条是UIScrollView的子控件
		// 隐藏滚动条，可以屏蔽多余的子控件
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.pagingEnabled = YES;
		scrollView.delegate = self;
		self.scrollView = scrollView;
}

/** 显示页码的UIPageControl */
- (void)setupPageControl
{
    // 创建pageControl并添加
	UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.backgroundColor = [UIColor clearColor];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    // 设置背景图片
	[pageControl setValue:[UIImage imageWithName:@"compose_keyboard_dot_normal"] forKeyPath:@"_pageImage"];
	[pageControl setValue:[UIImage imageWithName:@"compose_keyboard_dot_selected"] forKeyPath:@"_currentPageImage"];
    
    // 添加点击事件
    [pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventValueChanged];
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    // 移除所有的表情页，不然会无限增加
    //    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 设置总页数
    int totalPages = (self.emotions.count + PTEmotionMaxCountPerPage - 1) / PTEmotionMaxCountPerPage;
    self.pageControl.numberOfPages = totalPages;
    // 只有一页时隐藏pageControl
    self.pageControl.hidesForSinglePage = YES;
    
    int currentGridViewCount = self.scrollView.subviews.count;
    for (int i = 0; i < totalPages; i++) {
        PTEmotionGridView *gridView = nil;
        if (i >= currentGridViewCount) {
            gridView = [[PTEmotionGridView alloc] init];
            [self.scrollView addSubview:gridView];
//            gridView.backgroundColor = PTRANDOM_COLOR;
        } else {
            gridView = self.scrollView.subviews[i];
        }
        // 设置表情内容
        NSRange range;
        range.location = i * PTEmotionMaxCountPerPage;
        range.length = PTEmotionMaxCountPerPage;
        //        int maxCountAllowed = pages * PTEmotionMaxCountPerPage;
        if (emotions.count < (i + 1) * PTEmotionMaxCountPerPage) { // 对越界进行判断处理
            range.length = emotions.count - range.location;
        }
        gridView.emotions = [emotions subarrayWithRange:range];
        
        gridView.hidden = NO;
    }
    
    //    PTLog(@"gridViewCount==%d", self.scrollView.subviews.count);
    
    // 隐藏后面的不需要用到的gridView
    for (int i = totalPages; i<currentGridViewCount; i++) {
        PTEmotionGridView *gridView = self.scrollView.subviews[i];
        gridView.hidden = YES;
    }
    
    // 需重新布局子控件，每次有清空并新创建子控件，重新布局设置子控件尺寸
    [self setNeedsLayout];
    
    // 表情滚动到最前面
    self.scrollView.contentOffset = CGPointZero;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	// 设置分页子控件frame
	self.pageControl.x = 0;
	self.pageControl.width = self.width;
	self.pageControl.height = 20;
	self.pageControl.y = self.height - self.pageControl.height;
	
	// 设置listView的frame
	self.scrollView.x = 0;
	self.scrollView.y = 0;
	self.scrollView.width = self.width;
	self.scrollView.height = self.pageControl.y;
	
	// 设置listView内部子控件的frame
	int count = self.pageControl.numberOfPages;
	CGFloat gridViewW = self.scrollView.width;
	CGFloat gridViewH = self.scrollView.height;
    self.scrollView.contentSize = CGSizeMake(count * gridViewW, 0);
	for (int i = 0; i < count; i++) {
        UIView *gridView = self.scrollView.subviews[i];
		gridView.x = i * gridViewW;
		gridView.y = 0;
		gridView.width = gridViewW;
		gridView.height = gridViewH;
	}
}

- (void)pageControlClick:(UIPageControl *)pageControl
{
    self.scrollView.contentOffset = CGPointMake(pageControl.currentPage * self.scrollView.width, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.width + 0.5);
}

@end