//
//  ViewController.m
//  XYQPlayer
//
//  Created by 夏远全 on 2017/3/7.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import "TableViewController.h"
#import "PlayMusicViewController.h"
#import "PlayMovieViewController.h"

@interface TableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)UITableView *tableView;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    if (indexPath.row==0) {
        cell.textLabel.text = @"播放音效或者音乐🎵";
    }else{
        cell.textLabel.text = @"播放视频📺";
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        PlayMusicViewController *musicVC = [[PlayMusicViewController alloc] init];
        [self.navigationController pushViewController:musicVC animated:YES];
    }
    
    if (indexPath.row == 1) {
        PlayMovieViewController *movieVC = [[PlayMovieViewController alloc] init];
        [self.navigationController pushViewController:movieVC animated:YES];
    }
}

@end
