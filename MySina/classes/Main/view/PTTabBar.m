#import "PTTabBar.h"
#import "PTTabBarButton.h"

@interface PTTabBar ()

// 记录选中tabBarButton的index
@property (nonatomic, assign) NSInteger selectedIndex;

// 中间加号按钮
@property (nonatomic, weak) UIButton *plusButton;

// 用于存储tabBarButton的数组
@property (nonatomic, strong) NSMutableArray *tabBarButtons;

@end


@implementation PTTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// 设置背景
		[self setupBg];
	}
	return self;
}

/**
 *  加号按钮的懒加载
 */
- (UIButton *)plusButton
{
	if (!_plusButton) {
		UIButton *plusButton = [[UIButton alloc] init];
		// 设置背景
		[plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button"] forState:UIControlStateNormal];
		[plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
		// 设置图标
		[plusButton setImage:[UIImage imageWithName:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
		[plusButton setImage:[UIImage imageWithName:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
		
		// 添加按钮点击事件
		[plusButton addTarget:self action:@selector(plusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
		// 添加
		[self addSubview:plusButton];
		_plusButton = plusButton;
	}
	return _plusButton;
}

/**
 *  数组的懒加载
 */
- (NSMutableArray *)tabBarButtons
{
	if (!_tabBarButtons) {
		_tabBarButtons = [NSMutableArray array];
	}
	return _tabBarButtons;
}

/**
 *  添加一个选项卡按钮
 *
 *  @param item 选项卡按钮对应的模型数据(标题\图标\选中的图标)
 */
- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
	PTTabBarButton *tabBarBtn = [[PTTabBarButton alloc] init];
	tabBarBtn.item = item;
	[tabBarBtn addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	
	[self addSubview:tabBarBtn];
	
	// 添加到数组
	[self.tabBarButtons addObject:tabBarBtn];
	
	// 默认选中第一个按钮
	if (self.tabBarButtons.count == 1) {
		[self tabBarButtonClick:tabBarBtn];
	}
}

- (void)plusButtonClick:(UIButton *)plusButton
{	// 通知代理
	if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
		[self.delegate tabBarDidClickPlusButton:self];
	}
}

/**
 *  点击选项卡按钮
 */
- (void)tabBarButtonClick:(PTTabBarButton *)tabBarButton
{
	 // 原来选中按钮取消选中，当前选中按钮
    PTTabBarButton *selectedButton = self.tabBarButtons[_selectedIndex];
	selectedButton.selected = NO; // 原来选中按钮取消选中
	tabBarButton.selected = YES;
	_selectedIndex = [self.subviews indexOfObject:tabBarButton];
	
	// 调用代理方法
	if ([self.delegate respondsToSelector:@selector(tabBar:didSelectButtonAtIndex:)]) {
		[self.delegate tabBar:self didSelectButtonAtIndex:self.selectedIndex];
	}
}

/**
 *  布局子控件
 */
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	// 1.计算加号按钮的位置和尺寸
	[self setupPlusButtonFrame];
	
	// 2.设置选项卡按钮的位置和尺寸
	[self setupTabBarButtonsFrame];
}

/**
 *  计算加号按钮的位置和尺寸
 */
- (void)setupPlusButtonFrame
{
	self.plusButton.size = self.plusButton.currentBackgroundImage.size;
	self.plusButton.center = self.center;
}

/**
 *  设置选项卡按钮的位置和尺寸
 */
- (void)setupTabBarButtonsFrame
{
	int index = 0;
	
	CGFloat buttonY = 0;
	CGFloat buttonW = self.width / (self.tabBarButtons.count + 1);
	CGFloat buttonH = self.height;
	
	for (PTTabBarButton *tabBarButton in self.tabBarButtons) {
		CGFloat buttonX;
		if (index >= 2) { // 4个，6个...按钮都适用
			buttonX = buttonW * (index + 1);
		} else {
			buttonX = buttonW * index;
		}
		tabBarButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
		
		index++;
	}
}

/**
 *  设置背景
 */
- (void)setupBg
{
    if (!iOS7) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"tabbar_background"]];
    }
}

@end