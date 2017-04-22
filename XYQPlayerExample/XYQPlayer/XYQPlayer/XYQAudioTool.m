//
//  XYQAudioTool.m
//  XYQPlayer
//
//  Created by 夏远全 on 2017/3/7.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import "XYQAudioTool.h"
#import "XYQAudioToolLoader.h"
#import "XYQAudioToolView.h"
#import "XYQHUDView.h"

@implementation XYQAudioTool

/**
 音频格式转换可以使用终端的命令行进行转换，基本使用：afconvert -f [格式] -d [bundleFileName]
 具体使用可以使用help查看：afconvert -help
 afconvert: audio format convert 音频格式转换
 */


static NSMutableDictionary *_soundDict;
static NSMutableDictionary *_musicDict;
static NSMutableDictionary *_caDisplayLinkDict;
static NSString *playProgressRateNotification = @"playProgressRateNotification";


//****************************************************************************************//
//***************************************播放和停止音效(时间很短)*****************************//
//****************************************************************************************//
//****************************************************************************************//

#pragma mark 初始化字典
+(void)initialize
{
    
    //存放所有的音频ID,fileName作为key,SoundID作为value
    _soundDict = [NSMutableDictionary dictionary];
    
    //存放所有的音乐播放器,fileName作为key,audioPlayer作为value
    _musicDict = [NSMutableDictionary dictionary];
    
    //存储每一首歌曲的定时器,fileName作为key,caDispalyLink作为value
    _caDisplayLinkDict = [NSMutableDictionary dictionary];
    
    //设置音频会话类型
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [session setActive:YES error:nil];
}

#pragma mark 播放音效
+(void)playSoundFromBundleFileName:(NSString *)bundleFileName
{
    //判断文件名是否为空
    if (!bundleFileName)  return;
    
    //加载音效文件(短音频)   记住:每一个音效对应一个ID
    SystemSoundID soundID = [_soundDict[bundleFileName] unsignedIntValue];
    if (!soundID) {
        NSURL *url = [[NSBundle mainBundle]URLForResource:bundleFileName withExtension:nil];
        
        if (!url) return;
        
        //创建音效sound ID
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
        
        //存入字典
        [_soundDict setObject:[NSNumber numberWithUnsignedInt:soundID] forKey:bundleFileName];
        
        //使用sound ID播放
        AudioServicesPlaySystemSound(soundID);
        //AudioServicesPlayAlertSound(SystemSoundID inSystemSoundID)  //播放时手机会震动
    }
}

+(void)playSoundFromLocalFileName:(NSString *)localFileName{
    
    //判断文件名是否为空
    if (!localFileName)  return;
    
    //加载音效文件(短音频)   记住:每一个音效对应一个ID
    SystemSoundID soundID = [_soundDict[localFileName] unsignedIntValue];
    if (!soundID) {
        
        NSURL *url = [NSURL fileURLWithPath:localFileName];
        
        if (!url) return;
        
        //创建音效sound ID
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
        
        //存入字典
        [_soundDict setObject:[NSNumber numberWithUnsignedInt:soundID] forKey:localFileName];
        
        //使用sound ID播放
        AudioServicesPlaySystemSound(soundID);
        //AudioServicesPlayAlertSound(SystemSoundID inSystemSoundID)  //播放时手机会震动
    }
}


#pragma mark 销毁音效
+(void)disposeSoundFromBundleFileName:(NSString *)bundleFileName
{
    
    //判断文件名是否为空
    if (!bundleFileName)  return;
    
    //从字典中取出ID
    SystemSoundID soundID = (SystemSoundID)[[_soundDict objectForKey:bundleFileName] unsignedIntValue];
    
    //释放音效资源
    if (soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
        [_soundDict removeObjectForKey:bundleFileName];
    }
}

+(void)disposeSoundFromLocalFileName:(NSString *)localFileName{
    
    //判断文件名是否为空
    if (!localFileName)  return;
    
    //从字典中取出ID
    SystemSoundID soundID = (SystemSoundID)[[_soundDict objectForKey:localFileName] unsignedIntValue];
    
    //释放音效资源
    if (soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
        [_soundDict removeObjectForKey:localFileName];
    }
}



//****************************************************************************************//
//**********************************播放和停止音乐(时间较长)**********************************//
//****************************************************************************************//
//****************************************************************************************//



#pragma mark 播放音乐
+(AVAudioPlayer *)playMusicFromBundleFileName:(NSString *)bundleFileName{
    
    //判断文件名是否为空
    if (!bundleFileName)  return nil;
    
    //从字典中取出播放器
    AVAudioPlayer *audioPlayer = _musicDict[bundleFileName];
    
    //从字典中取出定时器
    CADisplayLink *link = _caDisplayLinkDict[bundleFileName];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    if (!audioPlayer){
        //加载音乐文件
        NSError *error = nil;
        NSURL *url = [[NSBundle mainBundle]URLForResource:bundleFileName withExtension:nil];
        if (!url) return nil;
        
        //创建播放器
        audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        
        //播放速率、音量等
        //audioPlayer.enableRate = YES;
        //audioPlayer.rate = 5.0f;
        audioPlayer.volume = 30.0f;

        if (error) return nil;
        
        //创建定时器
        if (!link) {
            link = [CADisplayLink displayLinkWithTarget:self selector:@selector(startTimer:)];
        }
        
        //将播放器存入字典中
        [_musicDict setObject:audioPlayer forKey:bundleFileName];
        
        //将定时器存入字典中
        [_caDisplayLinkDict setObject:link forKey:bundleFileName];
        
        //创建缓冲(以便后面的播放流畅)
        [audioPlayer prepareToPlay];
        
        //开始播放
        [audioPlayer play];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        playmusicCallBack([XYQAudioTool currentPlayingAudioPlayer]);
        [link setPaused:NO];
    }
    
    if (!audioPlayer.isPlaying)
    {
        //开始播放
        [audioPlayer play];
        playmusicCallBack([XYQAudioTool currentPlayingAudioPlayer]);
        [link setPaused:NO];
    }
    
    return audioPlayer;
}


+(AVAudioPlayer*)playMusicFromURLOrLocalFileName:(NSString *)URLOrLocalFileName{
    
    //判断文件名是否为空
    if (!URLOrLocalFileName)  return nil;
    
    //判断文件是否在本地存在
    NSString *localFileName = nil;
    if ([URLOrLocalFileName hasPrefix:@"http"] || [URLOrLocalFileName hasPrefix:@"https"]) {
        localFileName = [[XYQAudioToolLoader shareToolLoader] URLFileNameIsExsitesInLocalDocument:URLOrLocalFileName];
        if (!localFileName)
        {
            return nil;
        }
    }
    
    //从字典中取出播放器
    AVAudioPlayer *audioPlayer = _musicDict[URLOrLocalFileName];
    
    //从字典中取出定时器
    CADisplayLink *link = _caDisplayLinkDict[URLOrLocalFileName];
    
    if (!audioPlayer){
        
        //加载音乐文件
        NSError *error = nil;
        NSURL *url = [NSURL fileURLWithPath:localFileName];
        if (!url) return nil;
        
        //创建播放器
        audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        
        //播放速率、音量等
        //audioPlayer.enableRate = YES;
        //audioPlayer.rate = 5.0f;
        audioPlayer.volume = 30.0f;
        
        if (error) return nil;
        
        //创建定时器
        if (!link) {
            link = [CADisplayLink displayLinkWithTarget:self selector:@selector(startTimer:)];
        }
        
        //将播放器存入字典中
        [_musicDict setObject:audioPlayer forKey:URLOrLocalFileName];
        
        //将定时器存入字典中
        [_caDisplayLinkDict setObject:link forKey:URLOrLocalFileName];
        
        //创建缓冲(以便后面的播放流畅)
        [audioPlayer prepareToPlay];
        
        //开始播放
        [audioPlayer play];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        playmusicCallBack([XYQAudioTool currentPlayingAudioPlayer]);
        [link setPaused:NO];
    }
    
    if (!audioPlayer.isPlaying)
    {
        //开始播放
        [audioPlayer play];
        playmusicCallBack([XYQAudioTool currentPlayingAudioPlayer]);
        [link setPaused:NO];
    }
    
    return audioPlayer;
}


#pragma mark 暂停音乐
+(void)pauseMusicFromBundleFileName:(NSString *)bundleFileName
{
    
    //判断文件名是否为空
    if (!bundleFileName)  return;
    
    //从字典中取出播放器
    AVAudioPlayer *audioPlayer = _musicDict[bundleFileName];
    
    //从字典中取出定时器
    CADisplayLink *link = _caDisplayLinkDict[bundleFileName];
    
    //暂停
    if (audioPlayer && audioPlayer.isPlaying) {
        [audioPlayer pause];
        playmusicCallBack([XYQAudioTool currentPlayingAudioPlayer]);
        [link setPaused:YES];
    }
}

+(void)pauseMusicFromURLOrLocalFileName:(NSString *)URLOrLocalFileName{
    
    //判断文件名是否为空
    if (!URLOrLocalFileName)  return;
    
    //从字典中取出播放器
    AVAudioPlayer *audioPlayer = _musicDict[URLOrLocalFileName];
    
    //从字典中取出定时器
    CADisplayLink *link = _caDisplayLinkDict[URLOrLocalFileName];
    
    //暂停
    if (audioPlayer && audioPlayer.isPlaying) {
        [audioPlayer pause];
        playmusicCallBack([XYQAudioTool currentPlayingAudioPlayer]);
        [link setPaused:YES];
    }
}


#pragma mark 停止音乐
+(void)stopMusicFromBundleFileName:(NSString *)bundleFileName
{
    
    //判断文件名是否为空
    if (!bundleFileName)  return;
    
    //从字典中取出播放器
    AVAudioPlayer *audioPlayer = _musicDict[bundleFileName];
    
    //从字典中取出定时器
    CADisplayLink *link = _caDisplayLinkDict[bundleFileName];
    
    //停止并移除播放器
    if (audioPlayer)
    {
        [audioPlayer stop];
        playmusicCallBack([XYQAudioTool currentPlayingAudioPlayer]);
        [_musicDict removeObjectForKey:bundleFileName];
        [link invalidate];
        link = nil;
        [_caDisplayLinkDict removeObjectForKey:bundleFileName];
    }
}

+(void)stopMusicFromURLOrLocalFileName:(NSString *)URLOrLocalFileName{
    
    //判断文件名是否为空
    if (!URLOrLocalFileName)  return;
    
    //从字典中取出播放器
    AVAudioPlayer *audioPlayer = _musicDict[URLOrLocalFileName];
    
    //从字典中取出定时器
    CADisplayLink *link = _caDisplayLinkDict[URLOrLocalFileName];
    
    //停止并移除播放器
    if (audioPlayer)
    {
        [audioPlayer stop];
        playmusicCallBack([XYQAudioTool currentPlayingAudioPlayer]);
        [_musicDict removeObjectForKey:URLOrLocalFileName];
        [link invalidate];
        link = nil;
        [_caDisplayLinkDict removeObjectForKey:URLOrLocalFileName];
    }
}


#pragma mark 返回当前进度下的播放器
+(AVAudioPlayer *)currentPlayingAudioPlayer
{
    for(NSString *fileName in _musicDict) {
        AVAudioPlayer *audioplayer = _musicDict[fileName];
        
        if (audioplayer.isPlaying) {
            return audioplayer;
        }
    }
    return nil;
}


#pragma mark - 计算总时长
+(NSTimeInterval )caluceAllDuration{
    AVAudioPlayer *audioPlayer = [self currentPlayingAudioPlayer];
    return audioPlayer.duration;
}


#pragma mark - 开启计时器,发送播放进度通知
+(void)startTimer:(CADisplayLink*)link{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:playProgressRateNotification object:@{@"currentTime":@([self currentPlayingAudioPlayer].currentTime),@"totalTime":@([self currentPlayingAudioPlayer].duration)}];
}

#pragma mark - 回调播放器
+(void)waitPlayingStateCallBack:(playMusicCallBack)playMusicCallBack{
    
    if (playMusicCallBack) {
        playmusicCallBack = playMusicCallBack;
    }
}


@end
