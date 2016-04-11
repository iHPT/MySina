#import "PTTabBar.h"

@interface PTTabBar()

@property (nonatomic, weak) UIButton *plusButton;
@end


@implementation PTTabBar


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	if (self) {
		if (!iOS7) { // iOS6设置背景为白色图片，但iOS7需保留穿透效果，不设置图片(即透明)
			self.backgroundImage = [UIImage imageWithName:@"tabbar_background"];
		}
		/** 
		 *选中图片效果和其他有差异，可通过设置selectionIndicatorImage属性来改变，但若设置为空，默认会被覆盖(即为实际看到效果)，所以给他一种透明图片背景
		*/
		self.selectionIndicatorImage = [UIImage imageWithName:@"navigationbar_button_background"];
		// 添加加号按钮
		[self setupPlusButton];
		
	}
	return self;
}

/**
 *  添加加号按钮
 */
- (void)setupPlusButton
{
	UIButton *plusButton = [[UIButton alloc] init];
	// 设置背景
	[plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button"] forState:UIControlStateNormal];
	[plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
	// 设置图标
	[plusButton setImage:[UIImage imageWithName:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
	[plusButton setImage:[UIImage imageWithName:@"tarbbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
	// 添加
	[plusButton addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:plusButton];
	self.plusButton = plusButton;
}

- (void)plusButtonClick
{
    // 通知代理
    if ([self.tabBarDelegate respondsToSelector:@selector(tabBarDidClickedPlusButton:)]) {
        [self.tabBarDelegate tabBarDidClickedPlusButton:self];
    }
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	// 设置plusButton的frame
	[self setupPlusButtonFrame];
	
	// 设置所有tabbarButton的frame
	[self setupAllTabBarButtonFrame];
	
}

/**
 *  设置所有tabbarButton的frame
 */
- (void)setupPlusButtonFrame
{
	self.plusButton.size = self.plusButton.currentBackgroundImage.size;
	self.plusButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}

/**
 *  设置所有tabbarButton的frame
 */
- (void)setupAllTabBarButtonFrame
{
	int index = 0;
	
	for (UIView *tabBarButton in self.subviews) {
		// 如果不是UITabBarButton(即plusButton)， 直接跳过
		if (![tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
			
		// 根据索引调整位置
		[self setupTabBarButtonFrame:tabBarButton atIndex:index];
		
//		// 遍历UITabBarButton中的所有子控件
//		[self setupTabBarButtonTextColor:tabBarButton atIndex:index];
		
		// 索引增加
		index++;
	}
}

/**
 *  设置某个按钮的frame
 *
 *  @param tabBarButton 需要设置的按钮
 *  @param index        按钮所在的索引
 */
- (void)setupTabBarButtonFrame:(UIView *)tabBarButton atIndex:(int)index
{
	// 计算button的尺寸)
	CGFloat buttonW = self.width / (self.items.count + 1);
	CGFloat buttonH = self.height;
	
	tabBarButton.width = buttonW;
	tabBarButton.height = buttonH;
	if (index >= 2) {
			tabBarButton.x = buttonW * (index + 1);
		} else {
        tabBarButton.x = buttonW * index;
    }
    tabBarButton.y = 0;
}

/**
 *  设置某个按钮的文字颜色
 *
 *  @param tabBarButton 需要设置的按钮
 *  @param index        按钮所在的索引
 */
//- (void)setupTabBarButtonTextColor:(UIView *)tabBarButton atIndex:(int)index
//{
//	// 获取选中按钮的索引
//	int selectedIndex = [self.items indexOfObject:self.selectedItem];
//	
//	for (UILabel *childView in tabBarButton.subviews) {
//		// 说明不是个Label
//		if (![childView isKindOfClass:[UILable class]]) continue;
//		
//		// 设置字体
//		label.font = [UIFont systemFontOfSize:10];
//		if (selectedIndex == index) { // 说明这个Button选中, 设置label颜色为橙色
//			childView.textColor = [UIColor orangeColor];
//		} else { // 说明这个Button没有选中, 设置label颜色为黑色
//			childView.textColor = [UIColor balckColor];
//		}
//	}
//}

@end