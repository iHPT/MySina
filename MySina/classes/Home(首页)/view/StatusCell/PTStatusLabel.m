//
//  PTStatusLabel.m
//  MySina
//
//  Created by hpt on 16/5/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#define PTStatusLinkBackgroundTag 1000

#import "PTStatusLabel.h"
#import "PTStatusLink.h"

@interface PTStatusLabel ()

@property (nonatomic, weak) UITextView *textView;

@property (nonatomic, strong) NSMutableArray *links;

@end


@implementation PTStatusLabel

/** 懒加载：每个status文本框被点击时创建，重复点击不再创建，点击其他status时清空，并重新创建 */
- (NSMutableArray *)links
{
	if (!_links) {
		_links = [NSMutableArray array];

		// 搜索所有的链接
		[self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *, id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            PTLog(@"%@", attrs);
            NSString *linkText = attrs[PTStatusLinkText];
            if (linkText == nil) return;

            // 创建一个链接
            PTStatusLink *link = [[PTStatusLink alloc] init];
            link.text = linkText;
            link.range = range;

            // 处理矩形框
            NSMutableArray *rects = [NSMutableArray array];
            // 设置选中的字符范围为当前link，以便获取其边框
            self.textView.selectedRange = range;
            NSArray *selectionRects = [self.textView selectionRectsForRange:self.textView.selectedTextRange];
            // 去掉边框宽高为0的
            for (UITextSelectionRect *selectionRect in selectionRects) {
                if (selectionRect.rect.size.width == 0 && selectionRect.rect.size.height == 0) return;
                [rects addObject:selectionRect];
            }
            link.rects = rects;

            [_links addObject:link];

        }];
	}
	return _links;
    PTLog(@"%@", _links);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITextView *textView = [[UITextView alloc] init];
        textView.backgroundColor = [UIColor clearColor];
        [self addSubview:textView];
        self.textView = textView;

        textView.editable = NO;
        textView.scrollEnabled = NO;
        textView.userInteractionEnabled = NO;
        self.textView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
    }
    return self;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    _attributedText = attributedText;

    self.textView.attributedText = attributedText;
    
    // 点击其他status文本时会调用setAttributedText:方法，将links清空
    self.links = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.textView.frame = self.bounds;
}

/**
 0.查找出所有的链接（用一个数组存放所有的链接）
 
 1.在touchesBegan方法中，根据触摸点找出被点击的链接
 2.在被点击链接的边框范围内添加一个有颜色的背景
 
 3.在touchesEnded或者touchedCancelled方法中，移除所有的链接背景
 */
#pragma mark - 触摸事件处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    // 得出被点击的那个链接
    PTStatusLink *touchingLink = [self touchingLinkWithPoint:point];
    
    // 设置链接选中的背景
    [self showLinkBackground:touchingLink];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
		UITouch *touch = [touches anyObject];
		CGPoint point = [touch locationInView:touch.view];
		
		// 获取被点击的那个链接，当手指移出链接范围，移除链接背景
		PTStatusLink *touchingLink = [self touchingLinkWithPoint:point];
		if (touchingLink == nil) {
				// 相当于触摸被取消
    		[self touchesCancelled:touches withEvent:event];
		}
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    // 获取被点击的那个链接
    PTStatusLink *touchingLink = [self touchingLinkWithPoint:point];
    
//    if (touchingLink == nil) return;
    
    // 链接被点击，发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:PTStatusLinkDidSelectedNotification object:nil userInfo:@{PTStatusLinkText : touchingLink.text}];
    
    // 相当于触摸被取消
    [self touchesCancelled:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    PTLog(@"touchesCancelled");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeLinkBackground];
    });
}

/**
 *  如果点击的是非链接，将点击事件传递给父视图
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 得出被点击的那个链接
    PTStatusLink *touchingLink = [self touchingLinkWithPoint:point];
    
    // 如果点击的是非链接，将点击事件传递给父视图
    if (touchingLink == nil) return self.superview;
    
    return self;
}

/**
 *  根据触摸点找出被触摸的链接
 *
 *  @param point 触摸点
 */
- (PTStatusLink *)touchingLinkWithPoint:(CGPoint)point
{
		__block PTStatusLink *touchingLink = nil;
		[self.links enumerateObjectsUsingBlock:^(PTStatusLink *link, NSUInteger idx, BOOL *stop) {
			for (UITextSelectionRect *selectionRect in link.rects) {
				if (CGRectContainsPoint(selectionRect.rect, point)) {
					touchingLink = link;
                    break;
                    *stop = YES;
				}
			}
		}];
		
		return touchingLink;
}

#pragma mark - 链接背景处理
- (void)showLinkBackground:(PTStatusLink *)link
{
		for (UITextSelectionRect *selectionRect in link.rects) {
			UIView *bg = [[UIView alloc] init];
			bg.tag = PTStatusLinkBackgroundTag;
			bg.frame = selectionRect.rect;
			bg.layer.cornerRadius = 2;
			bg.backgroundColor = PTStatusLinkSelectedBackgroundColor;
			[self insertSubview:bg atIndex:0];
		}
}

- (void)removeLinkBackground
{
		for (UIView *subview in self.subviews) {
			if (subview.tag == PTStatusLinkBackgroundTag) {
				[subview removeFromSuperview];
			}
		}
}

@end
