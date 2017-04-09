//
//  XYQAudioToolView.m
//  XYQPlayer
//
//  Created by 夏远全 on 2017/3/7.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import "XYQAudioToolView.h"
#import "UIImage+XYQCornerRadius.h"
#import "XYQAudioTool.h"
#import "XYQHUDView.h"
#import "XYQTimeProgress.h"

static NSInteger currentIndex = 0; //当前音乐索引

@interface XYQAudioToolView ()
/**
 进度条比例
 */
@property (assign,nonatomic)CGFloat progressRate;
/**
 播放/停止按钮
 */
@property (strong,nonatomic)UIButton *playOrStopButton;
/**
 上一首按钮
 */
@property (strong,nonatomic)UIButton *preVButton;
/**
 下一首按钮
 */
@property (strong,nonatomic)UIButton *nextButton;
/**
 光盘视图
 */
@property (strong,nonatomic)UIImageView *lightDisk;
/**
 背景图
 */
@property (strong,nonatomic)UIImageView *bgView;
/**
 进度条
 */
@property (strong,nonatomic)XYQTimeProgress *progress;
/**
 播放器所在的控制器
 */
@property (strong,nonatomic)UIViewController *containViewController;
/**
 写入的数据量
 */
@property (assign,nonatomic)int64_t totalBytesWritten;
/**
 总数据量
 */
@property (assign,nonatomic)int64_t totalBytesExpectedToWrite;

@end


@implementation XYQAudioToolView

#pragma mark - 初始化通知
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playProgressRate:) name:@"playProgressRateNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveLocationPath:) name:@"saveLocationPathNotification" object:nil];
        [self setupSubView];
    }
    return self;
}

#pragma mark - 移除通知
-(void)dealloc{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 创建播放器
+(instancetype)openAudioPlayerView:(NSArray *)musicArr audioPlayerViewController:(UIViewController *)controller{
    
    XYQAudioToolView *audioView = [[self alloc]initWithFrame:controller.view.bounds];
    audioView.musicArr = musicArr;
    audioView.containViewController = controller;
    audioView.bgView = [[UIImageView alloc] initWithFrame:controller.view.bounds];
    audioView.bgView.image = [UIImage imageNamed:@"Source.bundle/source/audiobook_bg_icon"];
    [controller.view addSubview:audioView.bgView];
    [controller.view addSubview:audioView];
    return audioView;
}

#pragma mark - 初始化子视图
- (void)setupSubView{
    
    //播放、暂停
    self.playOrStopButton = [[UIButton alloc] init];
    [self.playOrStopButton addTarget:self action:@selector(playOrPauseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrStopButton setImage:[UIImage imageNamed:@"Source.bundle/source/audiobook_start_blue_icon"] forState:UIControlStateNormal];
    [self.playOrStopButton setImage:[UIImage imageNamed:@"Source.bundle/source/audiobook_stop_blue_icon"] forState:UIControlStateSelected];
    self.playOrStopButton.selected = NO;
    [self addSubview:self.playOrStopButton];
    
    
    //上一首
    self.preVButton = [[UIButton alloc] init];
    [self.preVButton addTarget:self action:@selector(preVButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.preVButton setImage:[UIImage imageNamed:@"Source.bundle/source/audiobook_last_icon"] forState:UIControlStateNormal];
    [self addSubview:self.preVButton];
    
    
    //下一首
    self.nextButton = [[UIButton alloc]init];
    [self.nextButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setImage:[UIImage imageNamed:@"Source.bundle/source/audiobook_next_icon"] forState:UIControlStateNormal];
    [self addSubview:self.nextButton];
    
    
    //光盘
    self.lightDisk = [[UIImageView alloc]init];
    self.lightDisk.contentMode = UIViewContentModeScaleAspectFit;
    self.lightDisk.image = [UIImage createRoundedRectImage:[UIImage imageNamed:@"Source.bundle/source/audiobook_bg_icon"] size:CGSizeMake(180, 180) radius:90];
    [self addSubview:self.lightDisk];
    
    //进度条
    self.progress = [XYQTimeProgress createProgressWithStartValue:0 endValue:0];
    [self addSubview:self.progress];
}


#pragma mark - 关闭播放器
-(void)dismissAudioPlayerView{
    [self stopIndex:currentIndex];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}

#pragma mark - 处理缓存路径通知
- (void)saveLocationPath:(NSNotification *)notification{
    
    //获取缓存路径
    NSString  *locationPath = (NSString *)notification.object;
    NSLog(@"locationPath---%@",locationPath);
    
    //下载完成开始播放
    if (locationPath != nil) {
        NSLog(@"下载存储完成");
        
        //回到主线程操作
        dispatch_async(dispatch_get_main_queue(), ^{
            [XYQHUDView hideHud];
            self.playOrStopButton.selected = NO;
            [self playOrPauseButtonPressed:self.playOrStopButton];
        });
    }
}

#pragma mark - 处理播放进度通知
- (void)playProgressRate:(NSNotification *)notification{
    
    //播放进度条显示进度
    NSDictionary   *playTimeDic = (NSDictionary *)notification.object;
    NSTimeInterval currentTime = [playTimeDic[@"currentTime"] doubleValue];
    NSTimeInterval durationTime = [playTimeDic[@"totalTime"] doubleValue];
    NSLog(@"播放进度:----%lf",currentTime/durationTime);
    
    //回到主线程操作
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progress.progressRate = currentTime/durationTime;
        self.progress.startValue = currentTime;
        self.progress.endValue = durationTime;
    });
    
    //自动顺序循环播放歌曲
    if (currentTime == durationTime) {
        
        //如果此首歌不是最后一首播放结束，自动切换下一首歌
        if (currentIndex < self.musicArr.count-1) {
            [self stopIndex:currentIndex];
            currentIndex ++;
        }
        //如果此首歌是最后一首播放结束，自动从头开始
        else{
            [self stopIndex:currentIndex];
            currentIndex = 0;
        }
        self.playOrStopButton.selected = NO;
        [self playOrPauseButtonPressed:self.playOrStopButton];
    }
}

#pragma mark - 隐藏/显示光盘
-(void)setDiskIsHide:(BOOL)diskIsHide{
    self.lightDisk.hidden = diskIsHide;
    if (diskIsHide) {
        self.bgView.alpha = 1.0;
    }else{
        self.bgView.alpha = 0.3;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.lightDisk.hidden = !self.lightDisk.hidden;
    if (self.lightDisk.hidden) {
        self.bgView.alpha = 1.0;
    }else{
        self.bgView.alpha = 0.3;
    }
}


#pragma mark - 播放或者暂停播放
- (void)playOrPauseButtonPressed:(UIButton *)sender{
    
    //获取当前播放器
    [XYQAudioTool waitPlayingStateCallBack:^(AVAudioPlayer *audioPlayer) {
        NSLog(@"%@",audioPlayer);
    }];
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self playingIndex:currentIndex];
    }else{
        [self puaseIndex:currentIndex];
    }
    self.containViewController.title = [NSString stringWithFormat:@"%@",self.musicArr[currentIndex]];
}


#pragma mark - 手动切换上一首
- (void)preVButtonPressed:(UIButton *)sender{
    if (self.musicArr.count==1 || currentIndex == 0) {
        [XYQHUDView showHud:@"已经是第一首"];
        return;
    }
    
    [self stopIndex:currentIndex];
    currentIndex --;
    self.playOrStopButton.selected = NO;
    [self playOrPauseButtonPressed:self.playOrStopButton];
}


#pragma mark - 手动切换下一首
- (void)nextButtonPressed:(UIButton *)sender{
    if (self.musicArr.count==1 || currentIndex == self.musicArr.count-1) {
        [XYQHUDView showHud:@"已经是最后一首"];
        return;
    }
    [self stopIndex:currentIndex];
    currentIndex ++;
    self.playOrStopButton.selected = NO;
    [self playOrPauseButtonPressed:self.playOrStopButton];
}


#pragma mark - 播放(音乐和光盘旋转)
- (void)playingIndex:(NSInteger)index{
    
    NSString *fileName = self.musicArr[index];
    if ([fileName hasPrefix:@"http"] || [fileName hasPrefix:@"https"] || [fileName rangeOfString:@"Documents"].location != NSNotFound) {
        [XYQAudioTool playMusicFromURLOrLocalFileName:fileName];
        [UIImage startRotation:self.lightDisk];
        return;
    }
    [XYQAudioTool playMusicFromBundleFileName:fileName];
    [UIImage startRotation:self.lightDisk];
}


#pragma mark - 暂停(音乐和光盘旋转)
- (void)puaseIndex:(NSInteger)index{
    
    NSString *fileName = self.musicArr[index];
    if ([fileName hasPrefix:@"http"] || [fileName hasPrefix:@"https"] || [fileName rangeOfString:@"Documents"].location != NSNotFound) {
        [XYQAudioTool pauseMusicFromURLOrLocalFileName:fileName];
        [UIImage pauseAnimation:self.lightDisk.layer];
        return;
    }
    [XYQAudioTool pauseMusicFromBundleFileName:fileName];
    [UIImage pauseAnimation:self.lightDisk.layer];
}


#pragma mark - 停止(音乐和光盘旋转)
- (void)stopIndex:(NSInteger)index{

    NSString *fileName = self.musicArr[index];
    if ([fileName hasPrefix:@"http"] || [fileName hasPrefix:@"https"] || [fileName rangeOfString:@"Documents"].location != NSNotFound) {
        [XYQAudioTool stopMusicFromURLOrLocalFileName:fileName];
        [UIImage pauseAnimation:self.lightDisk.layer];
        return;
    }
    [XYQAudioTool stopMusicFromBundleFileName:fileName];
    [UIImage pauseAnimation:self.lightDisk.layer];
}


#pragma mark - 布局frame
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //屏幕宽高
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    self.playOrStopButton.frame = CGRectMake(width/2-20, height-120, 40, 40);
    self.preVButton.frame = CGRectMake(CGRectGetMinX(self.playOrStopButton.frame)-120, height-120, 40, 40);
    self.nextButton.frame = CGRectMake(CGRectGetMaxX(self.playOrStopButton.frame)+80, height-120, 40, 40);
    self.lightDisk.frame = CGRectMake(width/2-90, height/2-90, 180, 180);
    self.progress.frame = CGRectMake(CGRectGetMinX(self.playOrStopButton.frame)-120, height-140, width-2*CGRectGetMinX(self.preVButton.frame), 20);
}

@end
