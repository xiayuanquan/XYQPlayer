//
//  XYQAudioTool.h
//  XYQPlayer
//
//  Created by 夏远全 on 2017/3/7.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

/**************************************************************************************************
 在iOS中音频播放从形式上可以分为音效播放和音乐播放。
 前者主要指的是一些短音频播放，通常作为点缀音频，对于这类音频不需要进行进度、循环等控制。
 后者指的是一些较长的音频，通常是主音频，对于这些音频的播放通常需要进行精确的控制。
 在iOS中播放两类音频分别使用AudioToolbox.framework和AVFoundation.framework来完成音效和音乐播放。
***************************************************************************************************/

typedef void(^playMusicCallBack)(AVAudioPlayer *audioPlayer);
static playMusicCallBack playmusicCallBack;

@interface XYQAudioTool : NSObject

/*=================================================================================================*/
/*===========================================播放音效===============================================*/
/*=================================================================================================*/


//播放音效
/**
 @param   bundleFileName : 根目录下音效文件名
 */
+(void)playSoundFromBundleFileName:(NSString *)bundleFileName;

/**
 @param   localFileName :  本地音效文件名
 */
+(void)playSoundFromLocalFileName:(NSString *)localFileName;


//销毁音效
/**
 @param   bundleFileName : 根目录下音效文件名
 */
+(void)disposeSoundFromBundleFileName:(NSString *)bundleFileName;

/**
 @param   localFileName :  本地音效文件名
 */
+(void)disposeSoundFromLocalFileName:(NSString *)localFileName;



/*======================================================================================*/
/*=====================================播放音乐===========================================*/
/*======================================================================================*/


//播放音乐
/**
 @param   bundleFileName : 根目录下音乐文件名
 */
+(AVAudioPlayer*)playMusicFromBundleFileName:(NSString *)bundleFileName;

/**
 @param   URLOrLocalFileName :    本地或者网络音乐文件名
 */
+(AVAudioPlayer*)playMusicFromURLOrLocalFileName:(NSString *)URLOrLocalFileName;


//暂停播放音乐
/**
 @param   bundleFileName : 根目录下音乐文件名
 */
+(void)pauseMusicFromBundleFileName:(NSString *)bundleFileName;

/**
 @param   URLOrLocalFileName :    本地或者网络音乐文件名
 */
+(void)pauseMusicFromURLOrLocalFileName:(NSString *)URLOrLocalFileName;



//停止播放音乐
/**
 @param   bundleFileName : 根目录下音乐文件名
 */
+(void)stopMusicFromBundleFileName:(NSString *)bundleFileName;
/**
 @param   URLOrLocalFileName :    本地或者网络音乐文件名
 */
+(void)stopMusicFromURLOrLocalFileName:(NSString *)URLOrLocalFileName;


//返回当前进度下的播放器
+(AVAudioPlayer *)currentPlayingAudioPlayer;



//===================================播放过程的回调=========================================//
/**
 播放状态回调
 @param playMusicCallBack 回调
 */
+(void)waitPlayingStateCallBack:(playMusicCallBack)playMusicCallBack;

@end
