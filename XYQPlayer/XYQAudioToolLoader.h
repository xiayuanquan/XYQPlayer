//
//  XYQAudioToolLoader.h
//  XYQPlayer
//
//  Created by 夏远全 on 2017/3/7.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**************************************************************************************************
                        从网络上缓冲下载音乐文件，然后存储到本地
 ***************************************************************************************************/

@interface XYQAudioToolLoader : NSObject

/**
 进度率
 */
@property (assign,nonatomic)CGFloat progressRate;

/**
 类方法创建实例
 */
+ (instancetype)shareToolLoader;

/**
 判断该网络文件是否在本地存在，如果存在直接返回本地文件，否则存到本地后再返回
 @return 返回本地文件路径
 */
- (NSString *)URLFileNameIsExsitesInLocalDocument:(NSString *)URLFileName;


/**
 执行下载任务
 @param URLFileName 文件URL
 */
- (void)excuteLoadMusic:(NSString *)URLFileName;

@end
