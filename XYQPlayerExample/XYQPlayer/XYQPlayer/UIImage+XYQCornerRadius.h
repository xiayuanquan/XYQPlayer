//
//  UIImage+XYQCornerRadius.h
//  XYQPlayer
//
//  Created by 夏远全 on 2017/3/8.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import <UIKit/UIKit.h>

/**************************************************************************************************
                                     切割圆角图片、旋转动画
 ***************************************************************************************************/

@interface UIImage (XYQCornerRadius)

/**
 圆角图片

 @param image 原始图片
 @param size  尺寸
 @param r     半径
 */
+ (UIImage *)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;


/**
 开始旋转
 @param rotationView 旋转视图
 */
+ (void)startRotation:(UIImageView *)rotationView;

/**
 暂停动画
 @param layer 旋转视图layer
 */
+ (void)pauseAnimation:(CALayer *)layer;

@end
