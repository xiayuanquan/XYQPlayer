//
//  PlayMovieViewController.m
//  XYQPlayer
//
//  Created by 夏远全 on 2017/4/9.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import "PlayMovieViewController.h"
#import "XYQAllHeader.h"

@interface PlayMovieViewController ()

@end

@implementation PlayMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1、push网络视频
    //[XYQMovieTool pushPlayMovieWithNetURL:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4" viewController:self];
    
    //2、push本地视频
    NSString *localMoive = [[NSBundle mainBundle] pathForResource:@"localmovie" ofType:@"mp4"];
    [XYQMovieTool pushPlayMovieWithLocalURL:localMoive viewController:self];
}


//注意：这里面的方法提供参考，具体的使用场景自己去把握
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //1、present网络视频
    //[XYQMovieTool presentPlayMovieWithNetURL:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4" viewController:self];
    
    //2、present本地视频
    NSString *localMoive = [[NSBundle mainBundle] pathForResource:@"localmovie" ofType:@"mp4"];
    [XYQMovieTool presentPlayMovieWithLocalURL:localMoive viewController:self];
}


//关闭播放器
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [XYQMovieTool cancelPlay];
}

@end
