//
//  XYQMovieToolView.h
//  XYQPlayer
//
//  Created by 夏远全 on 2017/4/9.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**************************************************************************************************
                              播放本地和网络视屏
 其实MPMoviePlayerController如果不作为嵌入视频来播放（例如在新闻中嵌入一个视频），通常在播放时都是占满一个屏幕的，特别是在iPhone、
 iTouch上。
 因此从iOS3.2以后苹果也在思考既然MPMoviePlayerController在使用时通常都是将其视图view添加到另外一个视图控制器中作为子视
 图，那么何不直接创建一个控制器视图内部创建一个MPMoviePlayerController属性并且默认全屏播放，开发者在开发的时候直接使用这个视图控
 器。
 这个内部有一个MPMoviePlayerController的视图控制器就是MPMoviePlayerViewController，它继承于UIViewController。
 MPMoviePlayerViewController内部多了一个moviePlayer属性和一个带有url的初始化方法，同时它内部实现了一些作为模态视图展示所特有的
 功
 能，例如默认是全屏模式展示、弹出后自动播放、作为模态窗口展示时如果点击“Done”按钮会自动退出模态窗口等。在下面的示例中就不直接将播放器
 放到主视图控制器，而是放到一个模态视图控制器中。
 ***************************************************************************************************/



@interface XYQMovieTool : NSObject


/**
 播放本地视频

 @param localURL    本地视频url
 @param containViewController 播放容器
 */
+(void)pushPlayMovieWithLocalURL:(NSString *)localURL viewController:(UIViewController *)containViewController;

/**
 播放网络视频
 
 @param netWorkURL  网络视频url
 @param containViewController 播放容器
 */
+(void)pushPlayMovieWithNetURL:(NSString *)netWorkURL viewController:(UIViewController *)containViewController;

/**
 播放本地视频
 
 @param localURL    本地视频url
 @param containViewController 播放容器
 */
+(void)presentPlayMovieWithLocalURL:(NSString *)localURL viewController:(UIViewController *)containViewController;

/**
 播放网络视频
 
 @param netWorkURL  网络视频url
 @param containViewController 播放容器
 */
+(void)presentPlayMovieWithNetURL:(NSString *)netWorkURL viewController:(UIViewController *)containViewController;


/**
 获取视频截图，此处必须先播放才能截图
 @param timesArr 时间帧数组,单位秒(s)
 */
+(void)thumbnailImageRequestWithTimes:(NSArray *)timesArr;

/**
 取消播放
 */
+(void)cancelPlay;

@end
