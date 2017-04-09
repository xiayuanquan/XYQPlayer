//
//  XYQAudioToolView.h
//  XYQPlayer
//
//  Created by 夏远全 on 2017/3/7.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**************************************************************************************************
                                    自定义播放音乐的界面
 ***************************************************************************************************/


@interface XYQAudioToolView : UIView
/**
 文件地址数组（可以本地文件、网络文件）
 */
@property (strong,nonatomic)NSArray *musicArr;

/**
 光盘是否隐藏
 */
@property (assign,nonatomic)BOOL diskIsHide;

/**
 打开播放器
 @param musicArr       播放文件数组
 @param viewController 播放视图所在控制器
 */
+(instancetype)openAudioPlayerView:(NSArray *)musicArr audioPlayerViewController:(UIViewController *)viewController;


/**
 关闭播放器
 */
-(void)dismissAudioPlayerView;

@end
