//
//  XYQCachesManager.h
//  XYQPlayer
//
//  Created by 夏远全 on 2017/4/22.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import <Foundation/Foundation.h>

/**************************************************************************************************
                        缓存管理类：计算缓存大小、清理缓存
 ***************************************************************************************************/

@interface XYQCachesManager : NSObject

/**
 文件路径数组
 */
@property (strong,nonatomic)NSArray *filePaths;


/**
 是否存在缓存
 */
@property (assign,nonatomic)BOOL    isExisitCaches;

/**
 单例
 */
+ (instancetype)sharedXYQCachesManager;

/**
 沙盒根目录
 @return 根目录
 */
+ (NSString *)documentsLastPath;


/**
 保存文件到指定路径下
 @param fromURL 初始文件的路径
 @param toURL   指定保存的路径
 @return 保存状态
 */
+ (NSError *)writeFileFromURL:(NSURL *)fromURL toURL:(NSURL *)toURL;


/**
 计算单个文件的大小
 @param filePath 文件路径
 @return 缓存大小
 */
+ (float)fileSizeAtPath:(NSString*) filePath;


/**
 计算遍历文件夹获得文件夹大小
 @param folderPath 文件夹路径
 @return 缓存大小
 */
+ (float)folderSizeAtPath:(NSString*) folderPath;


/**
 清除文件缓存
 */
+ (void)clearFileCaches;

@end
