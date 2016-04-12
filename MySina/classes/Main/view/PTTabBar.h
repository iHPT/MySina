#import <UIKit/UIKit.h>

@class PTTabBar;

@protocol PTTabBarDelegate <NSObject>
@optional
// 将选中按钮的index传回PTTabBarController，以便完成跳转
- (void)tabBar:(PTTabBar *)tabBar didSelectButtonAtIndex:(NSInteger)index;
// 选中plusButton回到PTTabBarController进行弹出发微博控制器
- (void)tabBarDidClickPlusButton:(PTTabBar *)tabBar;
@end


@interface PTTabBar : UIView

@property (nonatomic, weak) id<PTTabBarDelegate> delegate;

- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@end