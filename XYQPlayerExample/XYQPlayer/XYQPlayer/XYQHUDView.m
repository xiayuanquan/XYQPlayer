//
//  XYQHUDView.m
//  XYQPlayer
//
//  Created by 夏远全 on 2017/3/9.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import "XYQHUDView.h"


static UIView *containView;

@implementation XYQHUDView

#pragma mark - 显示文本弹框
+(void)showHud:(NSString *)message{
    
    //容器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    containView = window;
    
    //存在就不再重创建
    for (UIView *xyqview in containView.subviews) {
        if ([xyqview isKindOfClass:[XYQHUDView class]]){
            return;
        }
    }
    
    //子视图
    CGPoint point = CGPointMake(window.center.x, window.center.y+40);
    XYQHUDView *hud = [[XYQHUDView alloc] initWithFrame:CGRectMake(point.x,point.y,0,0)];
    hud.layer.cornerRadius = 5.0;
    hud.text = message;
    hud.textColor = [UIColor grayColor];
    hud.textAlignment = NSTextAlignmentCenter;
    hud.layer.masksToBounds = YES;
    hud.backgroundColor = [UIColor whiteColor];
    hud.font = [UIFont systemFontOfSize:14];
    
    //动画显示
    [UIView animateWithDuration:.5f
                          delay:.0f
         usingSpringWithDamping:0.6f
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                       hud.frame = CGRectMake(0, 0, 120, 40);
                       hud.center = point;
                       [containView addSubview:hud];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideHud];
        });
    }];
}

#pragma mark - 显示进度弹框
+(void)showHudWithProgress:(CGFloat)progress inView:(UIView *)view{
    
    //存在就不再重创建
    containView = view;
    for (UIView *xyqview in view.subviews) {
        if ([xyqview isKindOfClass:[XYQHUDView class]]){
            return;
        }
    }
    
    //容器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint point = CGPointMake(window.center.x, window.center.y);
    XYQHUDView *hud = [[XYQHUDView alloc] initWithFrame:CGRectMake(point.x,point.y,0,0)];
    hud.center = point;
    hud.layer.cornerRadius = 10.0;
    hud.layer.masksToBounds = YES;
    hud.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    
    //添加文本label
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 110, 20)];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont systemFontOfSize:13];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = [NSString stringWithFormat:@"缓存进度: %.1f%%",progress*100];
    [hud addSubview:textLabel];
    
    //动画显示
    [UIView animateWithDuration:.5f
                          delay:.0f
         usingSpringWithDamping:0.6f
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         hud.frame = CGRectMake(0, 0, 110, 110);
                         hud.center = point;
                         [hud creatAnimation:hud];//layer动画
                         [view addSubview:hud];
                         [view bringSubviewToFront:hud];
     } completion:nil];
}

#pragma mark - 刷新进度
+(void)updateHudProgress:(CGFloat)progress{
    
    for (UIView *xyqview in containView.subviews) {
        if ([xyqview isKindOfClass:[XYQHUDView class]]){
            UILabel *textLabel = (UILabel *)xyqview.subviews[0];
            textLabel.text = [NSString stringWithFormat:@"缓存进度: %.1f%%",progress*100];
            return;
        }
    }
}

#pragma mark - 关闭弹框
+(void)hideHud{
    
    for (UIView *xyqview in containView.subviews) {
        if ([xyqview isKindOfClass:[XYQHUDView class]]){
            [xyqview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [xyqview removeFromSuperview];
        }
    }
}

#pragma mark - private method
#pragma mark - layer animaiton
- (void)creatAnimation:(XYQHUDView *)containView
{
    //动画层
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds          = CGRectMake(0, 0, 110, 90);
    replicatorLayer.cornerRadius    = 10.0;
    replicatorLayer.position        = CGPointMake(55, 45);
    [containView.layer addSublayer:replicatorLayer];
    
    
    //圆点
    CALayer *dot        = [CALayer layer];
    dot.bounds          = CGRectMake(0, 0, 12, 12);
    dot.position        = CGPointMake(25, 25);
    dot.backgroundColor = [UIColor whiteColor].CGColor;
    dot.cornerRadius    = 6.0;
    dot.masksToBounds   = YES;
    [replicatorLayer addSublayer:dot];
    
    
    //拷贝圆点个数
    CGFloat count                     = 10.0;
    replicatorLayer.instanceCount     = count;
    CGFloat angel                     = 2* M_PI/count;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angel, 0, 0, 1);
    
    
    //放缩动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration    = 1.0;
    animation.fromValue   = @1;
    animation.toValue     = @0.1;
    animation.repeatCount = MAXFLOAT;
    [dot addAnimation:animation forKey:nil];
    
    
    replicatorLayer.instanceDelay = 1.0/ count;
    dot.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
}

@end
