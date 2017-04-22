//
//  XYQAudioToolLoader.m
//  XYQPlayer
//
//  Created by 夏远全 on 2017/3/7.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import "XYQAudioToolLoader.h"
#import "XYQAudioTool.h"
#import "XYQHUDView.h"
#import "XYQCachesManager.h"

@interface XYQAudioToolLoader ()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>
@property (copy,nonatomic)NSString *localfileName;
@property (copy,nonatomic)NSString *URLFileName;
@end

static NSString *loadProgressRateNotification = @"loadProgressRateNotification";
static NSString *saveLocationPathNotification = @"saveLocationPathNotification";

@implementation XYQAudioToolLoader


#pragma mark - 实例化
+ (instancetype)shareToolLoader{
    return [[self alloc] init];
}

#pragma mark - 返回缓存路径
- (NSString *)URLFileNameIsExsitesInLocalDocument:(NSString *)URLFileName{
    
    //这个可以查找Documents路径下的所有文件
    self.URLFileName = [URLFileName copy];
    NSArray * tempFileList = [[NSArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[XYQCachesManager documentsLastPath] error:nil]];
    
    //下载,并缓存到本地
    if (tempFileList.count==0) {
         [self excuteLoadMusic:URLFileName];
         return self.localfileName;
    }
    
    NSString *URLFileNameLast = [URLFileName componentsSeparatedByString:@"/"].lastObject;
    [tempFileList enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //判断音乐是否在本地
        if (![URLFileNameLast isEqualToString:fileName] && idx==tempFileList.count-1) {
                [self excuteLoadMusic:URLFileName]; //下载,并缓存到本地
            }
        else{
                self.localfileName = [[XYQCachesManager documentsLastPath] stringByAppendingPathComponent:URLFileNameLast];
                *stop = YES;
            }
     }];
    
    return self.localfileName;
}


#pragma mark - 执行下载操作
- (void)excuteLoadMusic:(NSString *)URLFileName{
    
    //创建会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    //创建URL
    NSURL *url = [NSURL URLWithString:URLFileName];
    
    //创建下载任务
    NSURLSessionDownloadTask *downTask = [session downloadTaskWithURL:url];
    
    //启动任务
    [downTask resume];
    
    //显示加载弹框
    [XYQHUDView showHudWithProgress:0 inView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - NSURLSessionDownloadDelegate
#pragma mark - 下载代理方法
//下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    self.progressRate = 1.0 * totalBytesWritten/totalBytesExpectedToWrite;
    NSLog(@"%lld-----%lld-----下载进度:%lf",totalBytesWritten,totalBytesExpectedToWrite,self.progressRate);
    
    //回到主线程操作
    dispatch_async(dispatch_get_main_queue(), ^{
        [XYQHUDView updateHudProgress:self.progressRate];
    });
}

//写入数据到本地
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    
    self.localfileName = [[XYQCachesManager documentsLastPath] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    NSError *error = [XYQCachesManager writeFileFromURL:location toURL:[NSURL fileURLWithPath:self.localfileName]];
    if (error) {
        self.localfileName = nil;
    }else{
        
        //发送缓存路径通知
        [[NSNotificationCenter defaultCenter] postNotificationName:saveLocationPathNotification object:self.localfileName];
    }
}


@end
