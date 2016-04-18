#import <UIKit/UIKit.h>

@class PTPopMenu;
@protocol PTPopMenuDelegate <NSObject>

@optional
- (void)popMenuDidDismissed:(PTPopMenu *)popMenu;

@end


typedef NS_OPTIONS(NSInteger, PTPopMenuArrowPosition) {
	PTPopMenuArrowPositionCenter = 0,
	PTPopMenuArrowPositionLeft = 1,
	PTPopMenuArrowPositionRight = 2
};


@interface PTPopMenu : UIView

@property (nonatomic, assign) PTPopMenuArrowPosition arrowPosition;

@property (nonatomic, weak) id<PTPopMenuDelegate> delegate;

- (instancetype)initWithContentView:(UIView *)contentView;
+ (instancetype)popMenuWithContentView:(UIView *)contentView;

- (void)showInRect:(CGRect)rect;

@end