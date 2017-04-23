//
//  PlayViewController.m
//  XYQPlayer
//
//  Created by 夏远全 on 2017/3/9.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import "PlayMusicViewController.h"
#import "XYQAllHeader.h"

@interface PlayMusicViewController ()
@property (strong,nonatomic)XYQAudioToolView *audioPlayerView;
@end

@implementation PlayMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除缓存" style:UIBarButtonItemStylePlain target:self action:@selector(clearCache)];
    
    //1、网络音乐
    //[self testPlay_Local_URL_Music:@[@"http://120.25.226.186:32812/xxx/minion_02.mp3"]];
    
    //2、本地音乐
    [self testPlay_Bundle_Music:[self musicArray]];
    
}

//测试创建音乐播放器(播放沙盒本地音乐包括从网络音乐下载缓存)
- (void)testPlay_Local_URL_Music:(NSArray *)musicFileLinkArray{
    
    self.audioPlayerView = [XYQAudioToolView openAudioPlayerView:musicFileLinkArray  audioPlayerViewController:self];
    self.audioPlayerView.diskIsHide = YES;
}


//测试创建音乐播放器(播放bundle根目录下的音乐)
- (void)testPlay_Bundle_Music:(NSArray *)musicNameArray{
    
    self.audioPlayerView = [XYQAudioToolView openAudioPlayerView:musicNameArray  audioPlayerViewController:self];
    self.audioPlayerView.diskIsHide = YES;
}

//Bundle根目录子下所有的音乐文件名
- (NSArray *)musicArray{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Musics" ofType:@"plist"];
    NSArray *musicNameArr = [NSArray arrayWithContentsOfFile:path];
    return musicNameArr;
}

//清除缓存
- (void)clearCache{
    [XYQCachesManager clearFileCaches];
}

//关闭播放器
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.audioPlayerView dismissAudioPlayerView];
}

@end
