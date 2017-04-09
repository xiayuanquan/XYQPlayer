//
//  UIImage+XYQCornerRadius.m
//  XYQPlayer
//
//  Created by 夏远全 on 2017/3/8.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import "UIImage+XYQCornerRadius.h"

@implementation UIImage (XYQCornerRadius)


#pragma mark - 添加圆角
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw,fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


#pragma mark - 绘制圆角图片
+ (UIImage *)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}


#pragma mark - 图片开始旋转
+ (void)startRotation:(UIImageView *)rotationView{
    
    //1.判断myView.layer上是否添加了动画
    CAAnimation *animation = [rotationView.layer animationForKey:@"rotationAnimation"];
    if (animation) {
        //2.判断是否暂停、恢复
        if (rotationView.layer.speed == 0) {
            //恢复动画
            [self resumeAnimation:rotationView.layer];
        }
    }
    else{
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 5;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = MAXFLOAT;
        [rotationView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

#pragma mark- 暂停动画
+ (void)pauseAnimation:(CALayer *)layer {
    //开始时间：0
    //layer.beginTime
    //1.取出当前时间，转成动画暂停的时间
    CFTimeInterval pauseTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    //2.设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
    layer.timeOffset = pauseTime;
    
    //3.将动画的运行速度设置为0， 默认的运行速度是1.0
    layer.speed = 0;
}


#pragma mark - 恢复动画
+ (void)resumeAnimation:(CALayer *)layer  {
    
    //1.将动画的时间偏移量作为暂停的时间点
    CFTimeInterval pauseTime = layer.timeOffset;
    
    //2.计算出开始时间
    CFTimeInterval begin = CACurrentMediaTime() - pauseTime;
    [layer setTimeOffset:0];
    [layer setBeginTime:begin];
    layer.speed = 1;
}


@end
