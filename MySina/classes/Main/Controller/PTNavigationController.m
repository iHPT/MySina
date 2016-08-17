//
//  PTNavigationController.m
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTNavigationController.h"

@implementation PTNavigationController

- (id)initWithNibName:(NSString *)nibOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibOrNil bundle:nibBundleOrNil];
	if (self) {
		
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

+ (void)initialize
{
    // 设置UINavigationBar的主题
	[self setupNavigationBarTheme];
	// 设置UIBarButtonItem的主题
	[self setupBarButtonItemTheme];
	
}

+ (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
	
	if (iOS7) {
        [appearance setBackgroundImage:[UIImage resizedImage:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
	}
	
	// 设置文字属性：颜色，字体，阴影
	NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
	textAttrs[NSFontAttributeName] = PTNavigationTitleFont;
//    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero]; // 默认就没有阴影，旧方法
//    NSShadow *shadow = [[NSShadow alloc] init];
//    shadow.shadowOffset = CGSizeMake(1, 1);
//    textAttrs[NSShadowAttributeName] = shadow;
    
	[appearance setTitleTextAttributes:textAttrs];
}

+ (void)setupBarButtonItemTheme
{
	// 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textAttrs[NSFontAttributeName] = PTBarButtonTitleFont;
//    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置高亮状态的文字属性
    NSMutableDictionary *highlightedTextAttrs = [[NSMutableDictionary alloc] initWithDictionary:textAttrs];
    highlightedTextAttrs[NSForegroundColorAttributeName] = [UIColor blueColor];
    [appearance setTitleTextAttributes:highlightedTextAttrs forState:UIControlStateHighlighted];
    
    // 设置禁用状态的文字属性
    NSMutableDictionary *disabledTextAttrs = [[NSMutableDictionary alloc] initWithDictionary:textAttrs];
    disabledTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disabledTextAttrs forState:UIControlStateDisabled];
    
    // 技巧: 为了让某个按钮的背景消失, 可以设置一张完全透明的背景图片
    [appearance setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
	if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
		viewController.hidesBottomBarWhenPushed = YES;
		
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_back"  highlightImageName:@"navigationbar_back_highlighted" target:self action:@selector(back)];
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_more" highlightImageName:@"navigationbar_more_highlighted" target:self action:@selector(more)];
    
	}
	[super pushViewController:viewController animated:animated];
}

- (void)back {
	[self popViewControllerAnimated:YES]; // 不再是self.navigationController，自身就是根控制器，自身的导航控制器为nil
}

- (void)more {
	[self popToRootViewControllerAnimated: YES];
}
@end