//
//  NSFileManager+Size.h
//  MySina
//
//  Created by hpt on 16/6/2.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Size)
/**
 *  计算路径的文件大小
 *
 *  @param path 文件或文件夹路径
 *
 *  @return 返回文件字节(Byte)大小
 */
- (long long)fileSizeAtPath:(NSString *)path;
/**
 *  计算路径的文件大小
 *
 *  @param path 文件或文件夹路径
 *
 *  @return 返回文件MB大小
 */
- (CGFloat)fileMegaBytesAtPath:(NSString *)path;
@end
