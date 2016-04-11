#import <UIKit/UIKit.h>

@class PTTabBar;

@protocol PTTabBarDelegate <NSObject>

@optional
- (void)tabBarDidClickedPlusButton:(PTTabBar *)tabBar;

@end


@interface PTTabBar : UITabBar

@property (nonatomic, weak) id<PTTabBarDelegate> tabBarDelegate; // 本身继承自UITabBar，拥有delegate属性，另命名
@end