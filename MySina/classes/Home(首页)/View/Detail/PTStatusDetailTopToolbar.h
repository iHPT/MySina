//
//  PTStatusDetailTopToolbar.h
//  MySina
//
//  Created by hpt on 16/5/19.
//  Copyright © 2016年 PT. All rights reserved.
//

typedef NS_ENUM(NSInteger, PTStatusDetailTopToolbarButtonType) {
    PTStatusDetailTopToolbarButtonTypeRetweet,
    PTStatusDetailTopToolbarButtonTypeComment,
    PTStatusDetailTopToolbarButtonTypeAttitude
};

#import <UIKit/UIKit.h>
@class PTStatusDetailTopToolbar;

@protocol PTStatusDetailTopToolbarDelegate <NSObject>
@optional
- (void)statusDetailTopToolbar:(PTStatusDetailTopToolbar *)toolbar didClickButton:(PTStatusDetailTopToolbarButtonType)buttonType;
@end


@class PTStatus;
@interface PTStatusDetailTopToolbar : UIView

@property (nonatomic, strong) PTStatus *status;

@property (nonatomic, weak) id<PTStatusDetailTopToolbarDelegate> delegate;
@end
