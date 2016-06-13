//
//  NSFileManager+Size.m
//  MySina
//
//  Created by hpt on 16/6/2.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "NSFileManager+Size.h"

@implementation NSFileManager (Size)
/**
 *  计算路径的文件大小
 *
 *  @param path 文件或文件夹路径
 *
 *  @return 返回文件字节(Byte)大小
 */
- (long long)fileSizeAtPath:(NSString *)path
{
//    // 1.文件管理者
//    NSFileManager *fm = [NSFileManager defaultManager];
    
    // 2.判断file是否存在
    BOOL isDirectory = NO;
    BOOL isFileExists = [self fileExistsAtPath:path isDirectory:&isDirectory];
    // 文件\文件夹不存在
    if (!isFileExists) return 0;
    
    // 3.判断file是否为文件夹
    if (isDirectory) { // 是文件夹
        long long totalSize = 0;
        NSArray *subpaths = [self contentsOfDirectoryAtPath:path error:nil];
        for (NSString *subpath in subpaths) {
            NSString *absoluteSubpath = [path stringByAppendingPathComponent:subpath];
            totalSize += [self fileSizeAtPath:absoluteSubpath];
        }
        return totalSize;
    } else { // 不是文件夹, 文件
        // 直接计算当前文件的尺寸
        NSDictionary *fileAttrs = [self attributesOfItemAtPath:path error:nil];
        return [fileAttrs[NSFileSize] longLongValue];
    }
}
/**
 *  计算路径的文件大小
 *
 *  @param path 文件或文件夹路径
 *
 *  @return 返回文件MB大小
 */
- (CGFloat)fileMegaBytesAtPath:(NSString *)path
{
    long long fileBytes = [self fileSizeAtPath:path];
    return (CGFloat)fileBytes / (1000 * 1000);
}
@end
