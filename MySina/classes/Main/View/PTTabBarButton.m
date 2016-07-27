
#define PTTabBarButtonImageRatio 0.6

#import "PTTabBarButton.h"
#import "PTBadgeView.h"

@interface PTTabBarButton ()

@property (nonatomic, weak) PTBadgeView *badgeButton;
@end


@implementation PTTabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		//图片居中
		self.imageView.contentMode = UIViewContentModeCenter;
		//文字居中
		self.titleLabel.textAlignment = NSTextAlignmentCenter;
		//设置字体
		self.titleLabel.font = [UIFont systemFontOfSize:12];
		
		//文字颜色
		[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
		
		//添加一个提醒数字按钮
		PTBadgeView *badgeView = [[PTBadgeView alloc] init];
//        badgeButton.badgeValue = @"15";
        badgeView.hidden = YES;
		[self addSubview:badgeView];
		self.badgeButton = badgeView;
	}
	return self;
}

// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
	CGFloat imageW = contentRect.size.width;
	CGFloat imageH = contentRect.size.height * PTTabBarButtonImageRatio; // 用按键0.6的高度显示图片
	return CGRectMake(0, 0, imageW, imageH);
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	// 设置提醒数字的位置和尺寸
	self.badgeButton.x = self.width - self.badgeButton.width - 10;
	self.badgeButton.y = 0;
}

// 内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
	CGFloat titleY = contentRect.size.height * PTTabBarButtonImageRatio; // 用按键0.4的高度显示文字
	CGFloat titleW = contentRect.size.width;
	CGFloat titleH = contentRect.size.height - titleY;
	return CGRectMake(0, titleY, titleW, titleH);
}

- (void)setItem:(UITabBarItem *)item
{
	_item = item;
	
	// 文字
	[self setTitle:item.title forState:UIControlStateNormal];
	// 图标
	[self setImage:item.image forState:UIControlStateNormal];
	// 选中的图标
	[self setImage:item.selectedImage forState:UIControlStateSelected];
	
	// self监听item的4个属性值的改变
	[item addObserver:self forKeyPath:@"title" options:0 context:nil];
	[item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
	[item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
}

- (void)dealloc
{
	[self.item removeObserver:self forKeyPath:@"title"];
	[self.item removeObserver:self forKeyPath:@"image"];
	[self.item removeObserver:self forKeyPath:@"selectedImage"];
	[self.item removeObserver:self forKeyPath:@"badgeValue"];
}

/**
 *  当利用KVO监听到某个对象的属性改变了, 就会调用这个方法
 *
 *  @param keyPath 被改变的属性的名称
 *  @param object  被监听的那个对象
 *  @param change  存放者被改变属性的值
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)contex
{
	// 1.设置数字
	self.badgeButton.badgeValue = self.item.badgeValue;
	
	// 2.设置按钮的文字
	[self setTitle:self.item.title forState:UIControlStateNormal];
	[self setTitle:self.item.title forState:UIControlStateSelected];
	
	// 3.设置图片
	[self setImage:self.item.image forState:UIControlStateNormal];
	[self setImage:self.item.selectedImage forState:UIControlStateSelected];
}

// 高亮状态按钮不发生任何变化
- (void)setHighlighted:(BOOL)highlighted { }

@end