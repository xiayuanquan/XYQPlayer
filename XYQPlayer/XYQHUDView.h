//
//  XYQHUDView.h
//  XYQPlayer
//
//  Created by 夏远全 on 2017/3/9.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import <UIKit/UIKit.h>

/**************************************************************************************************
                            自定义消息弹出框：单纯的文本弹框、加载动画弹框
 ***************************************************************************************************/

@interface XYQHUDView : UILabel

/**
 显示文本提示框

 @param message 消息
 */
+(void)showHud:(NSString *)message;



/**
 显示进度提示框

 @param progress 进度百分比
 @param view     容器
 */
+(void)showHudWithProgress:(CGFloat)progress inView:(UIView *)view;

/**
 刷新进度

 @param progress 进度百分比
 */
+(void)updateHudProgress:(CGFloat)progress;


/**
 隐藏提示框
 */
+(void)hideHud;

@end
