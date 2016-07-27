/**
 图片的加载：
 [UIImage imageNamed:@"home"];  加载png图片

 一、非retina屏幕
 1、3.5 inch（320 x 480）
 * home.png
 
 二、retina屏幕
 1、3.5 inch（640 x 960）
 * home@2x.png
 
 2、4.0 inch（640 x 1136）
 * home-568h@2x.png（如果home是程序的启动图片，才支持自动加载）
 
 三、举例（以下情况都是系统自动加载）
 1、home是启动图片
 * iPhone 1\3G\3GS -- 3.5 inch 非retina ：home.png
 * iPhone 4\4S -- 3.5 inch retina ：home@2x.png
 * iPhone 5\5S\5C -- 4.0 inch retina ：home-568h@2x.png
 
 2、home不是启动图片
 * iPhone 1\3G\3GS -- 3.5 inch 非retina ：home.png
 * iPhone 4\4S -- 3.5 inch retina ：home@2x.png
 * iPhone 5\5S\5C -- 4.0 inch retina ：home@2x.png
 
 3、总结
 * home.png ：3.5 inch 非retina
 * home@2x.png ：retina
 * home-568h@2x.png ：4.0 inch retina + 启动图片
 */

/**
 创建了一个控件，就是看不见
 1.当前控件没有添加到父控件中
 2.当前控件的hidden = YES
 3.当前控件的alpha <= 0.01
 4.没有设置尺寸（frame.size、bounds.size）
 5.位置不对（当前控件显示到窗口以外的区域）
 6.背景色是clearColor
 7.当前控件被其他可见的控件挡住了
 8.当前控件是个显示图片的控件（没有设置图片\图片不存在，比如UIImageView）
 9.当前控件是个显示文字的控件（没有设置文字\文字颜色跟后面的背景色一样，比如UILabel、UIButton）
 10.检查父控件的前9种情况
 
 一个控件能看见，但是点击后没有任何反应：
 1.当前控件的userInteractionEnabled = NO
 2.当前控件的enabled = NO
 3.当前控件不在父控件的边框范围内
 4.当前控件被一个背景色是clearColor的控件挡住了
 5.检查父控件的前4种情况
 6.。。。。。。
 
 文本输入框没有在主窗口上：文本输入框的文字无法输入
 */

#define PTNewfeatureImagesCount 4

#import "PTNewfeatureViewController.h"
#import "PTTabBarController.h"

@interface PTNewfeatureViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;

@end


@implementation PTNewfeatureViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// 1.添加UISrollView
	[self setupScrollView];
	
	// 2.添加pageControl
	[self setupPageControl];
}

- (void)setupScrollView
{
	UIScrollView *scrollView = [[UIScrollView alloc] init];
	scrollView.delegate = self;
	scrollView.frame = self.view.bounds;
	scrollView.contentSize = CGSizeMake(ScreenWidth * PTNewfeatureImagesCount, ScreenHeight);
    scrollView.backgroundColor = PTColor(146, 246, 246);
	scrollView.pagingEnabled = YES;
	scrollView.bounces = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:scrollView];
	
	for (int i = 0; i < PTNewfeatureImagesCount; i++) {
		// 创建UIImageView
		UIImageView *imageView = [[UIImageView alloc] init];
		imageView.userInteractionEnabled = YES;
		
		NSString *imageName = [NSString stringWithFormat:@"new_feature_%d", i + 1];
//		if (FourInch) { // 4inch  需要手动去加载4inch对应的-568h图片
//            imageName = [NSString stringWithFormat:@"%@-568H", imageName];
//		}
		imageView.image = [UIImage imageWithName:imageName];
		// 添加imageView
		[scrollView addSubview:imageView];
		
		// 设置frame
		imageView.frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, ScreenHeight);
	
	
        // 给最后一个imageView添加按钮
        if (i == PTNewfeatureImagesCount - 1) {
            
            [self setupLastImageView:imageView];
        }
    }
}

- (void)setupLastImageView:(UIImageView *)imageView
{
		[self setupStartButton:imageView];
		
		[self setupShareButton:imageView];
}

/**
 *  添加开始按钮
 */
- (void)setupStartButton:(UIImageView *)imageView
{
	UIButton *startButton = [[UIButton alloc] init];
	// 1.设置文字
	[startButton setTitle:@"开始微博" forState:UIControlStateNormal];
	[startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	// 2.设置背景图片
	[startButton setBackgroundImage:[UIImage imageWithName:@"new_feature_finish_button"] forState:UIControlStateNormal];
	[startButton setBackgroundImage:[UIImage imageWithName:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
	
	// 3.设置frame
	startButton.size = startButton.currentBackgroundImage.size;
	startButton.centerX = ScreenWidth * 0.5;
	startButton.centerY = ScreenHeight * 0.8;
	
	// 4.添加事件
	[startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
	
	[imageView addSubview:startButton];
}

- (void)setupShareButton:(UIImageView *)imageView
{
	UIButton *shareButton = [[UIButton alloc] init];
	
	[shareButton setTitle:@"分享到好友" forState:UIControlStateNormal];
	[shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[shareButton setImage:[UIImage imageWithName:@"new_feature_share_false"] forState:UIControlStateNormal];
	[shareButton setImage:[UIImage imageWithName:@"new_feature_share_true"] forState:UIControlStateSelected];
	// 监听点击
	[shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];

	shareButton.size = CGSizeMake(150, 35);
	shareButton.centerX = self.view.width * 0.5;
	shareButton.centerY = self.view.height * 0.7;
	
	// 设置title左内边距，与案件保持一定间距
	shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	
	[imageView addSubview:shareButton];
}


- (void)setupPageControl
{
	UIPageControl *pageControl = [[UIPageControl alloc] init];
	pageControl.numberOfPages = PTNewfeatureImagesCount;
	// 设置圆点的颜色
	pageControl.currentPageIndicatorTintColor = PTColor(253, 98, 42); // 当前页的小圆点颜色
	pageControl.pageIndicatorTintColor = PTColor(189, 189, 189); // 非当前页的小圆点颜色
	pageControl.center = CGPointMake(ScreenWidth * 0.5, ScreenHeight - 30);
	self.pageControl = pageControl;
	
	[self.view addSubview:pageControl];
}


- (void)start
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    // 显示主控制器（PTTabBarController）
	PTTabBarController *tabBarController = [[PTTabBarController alloc] init];
	[UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
}

- (void)share:(UIButton *)shareButton
{
	shareButton.selected = !shareButton.isSelected;
	PTLog(@"share---");
	
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	// 设置页码
	CGFloat page = scrollView.contentOffset.x / ScreenWidth;
	self.pageControl.currentPage = (int)(page + 0.5);
	
}

@end