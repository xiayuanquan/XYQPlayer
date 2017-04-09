//
//  XYQProgress.h
//  XYQPlayer
//
//  Created by 夏远全 on 2017/4/7.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import <UIKit/UIKit.h>

/**************************************************************************************************
                                            自定义时间进度条
 ***************************************************************************************************/

@interface XYQTimeProgress : UIView
/**
 进度起始值
 */
@property (assign,nonatomic)NSTimeInterval startValue;
/**
 进度终点值
 */
@property (assign,nonatomic)NSTimeInterval endValue;
/**
 进度率
 */
@property (assign,nonatomic)CGFloat progressRate;


/**
 创建进度条

 @param frame         尺寸
 @param startValue    起始值
 @param endValue      终点值

 */
+(instancetype)createProgressWithFrame:(CGRect)frame StartValue:(NSTimeInterval)startValue  endValue:(NSTimeInterval)endValue;
+(instancetype)createProgressWithStartValue:(NSTimeInterval)startValue  endValue:(NSTimeInterval)endValue;

@end
