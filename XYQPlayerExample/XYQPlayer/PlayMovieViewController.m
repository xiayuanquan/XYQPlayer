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
    
    //1、push视频
    [XYQMovieTool pushPlayMovieWithNetURL:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4" viewController:self];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //2、present视频
    //[XYQMovieTool presentPlayMovieWithNetURL:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4" viewController:self];
}

//关闭播放器
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [XYQMovieTool cancelPlay];
}

@end
