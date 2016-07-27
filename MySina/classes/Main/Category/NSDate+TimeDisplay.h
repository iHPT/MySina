//
//  NSDate+TimeDisplay.h
//  MySina
//
//  Created by hpt on 16/4/16.
//  Copyright ? 2016�� PT. All rights reserved.
//	NSDate���࣬��������΢��ʱ����ʾ

#import <Foundation/Foundation.h>

@interface NSDate (TimeDisplay)

/**
 *  ����һ��ֻ�������յ�ʱ��
 */
- (NSDate *)dateWithYMD;

/**
 *  �Ƿ�Ϊ����
 */
- (BOOL)isThisYear;

/**
 *  �Ƿ�Ϊ����
 */
- (BOOL)isToday;
/**
 *  �Ƿ�Ϊ����
 */
- (BOOL)isYesterday;

/**
 *  ����뵱ǰʱ��Ĳ��(ʱؼ��ؼ��)����ؼ��ؼ�ղ���
 *	���������ͬһ�죬���ø÷�����ȡʱ���
 */
- (NSDateComponents *)deltaWithNow;

@end