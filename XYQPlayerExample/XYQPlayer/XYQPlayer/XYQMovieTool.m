//
//  XYQMovieToolView.m
//  XYQPlayer
//
//  Created by 夏远全 on 2017/4/9.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import "XYQMovieTool.h"
#import <MediaPlayer/MediaPlayer.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface XYQMovieTool ()
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerViewController;//播放器视图控制器
@end

@implementation XYQMovieTool

#pragma mark - 单例
+ (XYQMovieTool *)sharedManager
{
    static XYQMovieTool *Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Instance = [[self alloc] init];
    });
    return Instance;
}

#pragma mark - 注册通知
-(void)addNotifitionByPush{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerThumbnailRequestFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.moviePlayer];
}
-(void)addNotifitionByPresent{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayerViewController.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerViewController.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerThumbnailRequestFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.moviePlayerViewController.moviePlayer];
}

#pragma mark - push播放本地视频
+(void)pushPlayMovieWithLocalURL:(NSString *)localURL viewController:(UIViewController *)containViewController{
    
    //实例化
    XYQMovieTool *movieTool = [XYQMovieTool sharedManager];
    
    //保证每次点击都重新创建视频播放控制器视图，避免再次点击时由于不播放的问题
    movieTool.moviePlayer = nil;
    
    //地址
    NSURL *url = [NSURL fileURLWithPath:localURL];
    
    //播放器
    movieTool.moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
    movieTool.moviePlayer.view.frame = containViewController.view.bounds;
    movieTool.moviePlayer.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [containViewController.view addSubview:movieTool.moviePlayer.view];
    
    //注册通知
    [movieTool addNotifitionByPush];
    
    //开始播放
    [movieTool.moviePlayer prepareToPlay];
    [movieTool.moviePlayer play];
}

#pragma mark - push播放网络视频
+(void)pushPlayMovieWithNetURL:(NSString *)netWorkURL viewController:(UIViewController *)containViewController{
    
    //实例化
    XYQMovieTool *movieTool = [XYQMovieTool sharedManager];
    
    //保证每次点击都重新创建视频播放控制器视图，避免再次点击时由于不播放的问题
    movieTool.moviePlayer = nil;
    
    //地址
    netWorkURL = [netWorkURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:netWorkURL];
    
    //播放器
    movieTool.moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
    movieTool.moviePlayer.view.frame = containViewController.view.bounds;
    movieTool.moviePlayer.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [containViewController.view addSubview:movieTool.moviePlayer.view];
    
    //注册通知
    [movieTool addNotifitionByPush];
    
    //开始播放
    [movieTool.moviePlayer prepareToPlay];
    [movieTool.moviePlayer play];
}

#pragma mark - present播放本地视频
+(void)presentPlayMovieWithLocalURL:(NSString *)localURL viewController:(UIViewController *)containViewController{
    
    //实例化
    XYQMovieTool *movieTool = [XYQMovieTool sharedManager];
    
    //保证每次点击都重新创建视频播放控制器视图，避免再次点击时由于不播放的问题
    movieTool.moviePlayerViewController = nil;
    
    //地址
    NSURL *url = [NSURL fileURLWithPath:localURL];
    
    //播放器
    movieTool.moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    
    //注册通知
    [movieTool addNotifitionByPresent];
    
    //开始播放
    [containViewController presentMoviePlayerViewControllerAnimated:movieTool.moviePlayerViewController];
    [movieTool.moviePlayerViewController.moviePlayer prepareToPlay];
    [movieTool.moviePlayerViewController.moviePlayer play];
}

#pragma mark - present播放网络视频
+(void)presentPlayMovieWithNetURL:(NSString *)netWorkURL viewController:(UIViewController *)containViewController{
    
    //实例化
    XYQMovieTool *movieTool = [XYQMovieTool sharedManager];
    
    //保证每次点击都重新创建视频播放控制器视图，避免再次点击时由于不播放的问题
    movieTool.moviePlayerViewController = nil;
    
    //地址
    netWorkURL = [netWorkURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:netWorkURL];
    
    //播放器
    movieTool.moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    
    //注册通知
    [movieTool addNotifitionByPresent];
    
    //开始播放
    [containViewController presentMoviePlayerViewControllerAnimated:movieTool.moviePlayerViewController];
    [movieTool.moviePlayerViewController.moviePlayer prepareToPlay];
    [movieTool.moviePlayerViewController.moviePlayer play];
}


#pragma mark - 获取视频截图
+(void)thumbnailImageRequestWithTimes:(NSArray *)timesArr{
    
    XYQMovieTool *movieTool = [XYQMovieTool sharedManager];
    if (movieTool.moviePlayer) {
       [movieTool.moviePlayer requestThumbnailImagesAtTimes:timesArr timeOption:MPMovieTimeOptionNearestKeyFrame];
    }
    if (movieTool.moviePlayerViewController) {
        [movieTool.moviePlayerViewController.moviePlayer requestThumbnailImagesAtTimes:timesArr timeOption:MPMovieTimeOptionNearestKeyFrame];
    }
}

#pragma mark - 取消播放并移除所有通知监控
+(void)cancelPlay{
    
    XYQMovieTool *movieTool = [XYQMovieTool sharedManager];
    if (movieTool.moviePlayer) {
        [movieTool.moviePlayer stop];
        movieTool.moviePlayer = nil;
    }
    if (movieTool.moviePlayerViewController) {
        [movieTool.moviePlayerViewController.moviePlayer stop];
        [movieTool.moviePlayerViewController dismissMoviePlayerViewControllerAnimated];
        movieTool.moviePlayerViewController = nil;
    }
    
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    movieTool = nil;
}


#pragma mark - 播放状态改变，注意播放完成时的状态是暂停
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    if (self.moviePlayer) {
        switch (self.moviePlayer.playbackState) {
            case MPMoviePlaybackStatePlaying:
                NSLog(@"moviePlayer:正在播放...");
                break;
            case MPMoviePlaybackStatePaused:
                NSLog(@"moviePlayer:暂停播放...");
                break;
            case MPMoviePlaybackStateStopped:
                NSLog(@"moviePlayer:停止播放...");
                break;
            default:
                NSLog(@"moviePlayer:播放状态:%ld",(long)self.moviePlayer.playbackState);
                break;
        }
    }
    if (self.moviePlayerViewController) {
        switch (self.moviePlayerViewController.moviePlayer.playbackState) {
            case MPMoviePlaybackStatePlaying:
                NSLog(@"moviePlayerViewController:正在播放...");
                break;
            case MPMoviePlaybackStatePaused:
                NSLog(@"moviePlayerViewController:暂停播放...");
                break;
            case MPMoviePlaybackStateStopped:
                NSLog(@"moviePlayerViewController:停止播放...");
                break;
            default:
                NSLog(@"moviePlayerViewController:播放状态:%ld",(long)self.moviePlayerViewController.moviePlayer.playbackState);
                break;
        }
    }
}

#pragma mark - 播放完成
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    if (self.moviePlayer) {
       NSLog(@"moviePlayer:播放完成----%ld",(long)self.moviePlayer.playbackState);
    }
    if (self.moviePlayerViewController) {
        NSLog(@"moviePlayerViewController:播放完成----%ld",(long)self.moviePlayerViewController.moviePlayer.playbackState);
    }
}


#pragma mark - 缩略图请求完成,此方法每次截图成功都会调用一次
-(void)mediaPlayerThumbnailRequestFinished:(NSNotification *)notification{
    NSLog(@"视频截图完成...");
    
    UIImage *image=notification.userInfo[MPMoviePlayerThumbnailImageKey];
    
    //保存图片到相册(此处第一次调用会请求用户获得访问相册权限)
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}


#pragma mark - dealloc
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

#pragma clang diagnostic pop
