//
//  PTEmotion.h
//  SinaBlog
//
//  Created by hpt on 16/4/10.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTEmotion : NSObject

/** 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;
/** 表情的文png图片名 */
@property (nonatomic, copy) NSString *png;
/** 表情的文字描述(繁体) */
@property (nonatomic, copy) NSString *cht;
//
////@property (nonatomic, copy) NSString *gif;
//
//@property (nonatomic, assign) BOOL type;
/** emoji表情的编码 */
@property (nonatomic, copy) NSString *code;

/** 表情的存放文件夹\目录 */
@property (nonatomic, copy) NSString *directory;
/** emoji表情的字符 */
@property (nonatomic, copy) NSString *emoji;

@end
