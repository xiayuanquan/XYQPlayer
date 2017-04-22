//
//  XYQCachesManager.m
//  XYQPlayer
//
//  Created by 夏远全 on 2017/4/22.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import "XYQCachesManager.h"
#import "XYQHUDView.h"

@implementation XYQCachesManager

static XYQCachesManager *_sharedCachesManager = nil;

+ (instancetype)sharedXYQCachesManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCachesManager = [[self alloc] init];
    });
    return _sharedCachesManager;
}

#pragma mark - 获取沙盒目录
+ (NSString *)documentsLastPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - 保存文件
+ (NSError *)writeFileFromURL:(NSURL *)fromURL toURL:(NSURL *)toURL{
    
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtURL:fromURL toURL:toURL error:&error];
    return error;
}

#pragma mark - 清除文件缓存
+ (void)clearFileCaches{

    //遍历缓存文件
    __block float fileSize = 0;
    NSArray *tempFileList = [[NSArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self documentsLastPath] error:nil]];
    XYQCachesManager *xyaCachesManager = [XYQCachesManager sharedXYQCachesManager];
    [xyaCachesManager.filePaths enumerateObjectsUsingBlock:^(NSString *URLFileName, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *URLFileNameLast = [URLFileName componentsSeparatedByString:@"/"].lastObject;
        [tempFileList enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if ([URLFileNameLast isEqualToString:fileName]) {
                 NSString *filePath = [[XYQCachesManager documentsLastPath] stringByAppendingPathComponent:URLFileNameLast];
                 fileSize += [self fileSizeAtPath:filePath];
                 [[NSFileManager defaultManager]  removeItemAtPath:filePath error:nil];
             }
         }];
        if (idx == xyaCachesManager.filePaths.count-1) {
            [XYQHUDView showBigHud:[NSString stringWithFormat:@"清除缓存%.1fM",fileSize]];
        }
    }];
}



#pragma mark - 通常用于删除缓存的时，计算缓存大小
//单个文件的大小
+ (float) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/(1024.0*1024.0);
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

@end
