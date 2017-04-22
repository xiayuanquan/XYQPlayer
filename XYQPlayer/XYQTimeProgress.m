//
//  XYQProgress.m
//  XYQPlayer
//
//  Created by 夏远全 on 2017/4/7.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import "XYQTimeProgress.h"

@interface XYQTimeProgress ()
/**
 进度起始值label
 */
@property (strong,nonatomic)UILabel *startValueLabel;
/**
 进度终点值label
 */
@property (strong,nonatomic)UILabel *endValueLabel;
/**
 滑动条
 */
@property (strong,nonatomic)UIProgressView *progressUI;

@end

@implementation XYQTimeProgress


#pragma mark - 添加子控件
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.startValueLabel];
        [self addSubview:self.endValueLabel];
        [self addSubview:self.progressUI];
    }
    return self;
}


#pragma mark -  初始化
+(instancetype)createProgressWithFrame:(CGRect)frame StartValue:(NSTimeInterval)startValue  endValue:(NSTimeInterval)endValue{
    XYQTimeProgress *progress = [[self alloc] initWithFrame:frame];
    progress.startValue = startValue;
    progress.endValue = endValue;
    return progress;
}
+(instancetype)createProgressWithStartValue:(NSTimeInterval)startValue  endValue:(NSTimeInterval)endValue{
    XYQTimeProgress *progress = [[self alloc] init];
    progress.startValue = startValue;
    progress.endValue = endValue;
    return progress;
}

#pragma mark - 格式化时间
- (NSString *)formatValue:(NSTimeInterval)value{

    if (value<60) {
        NSString *duration = [NSString stringWithFormat:@"00:%02ld",(long)value];
        return duration;
    }
    else{
        NSString *duration = [NSString stringWithFormat:@"%.2f",value/60];
        NSInteger min = [[duration componentsSeparatedByString:@"."][0] integerValue];
        NSInteger sec = (NSInteger)[[duration componentsSeparatedByString:@"."][1] floatValue] * 0.6;
        duration = [NSString stringWithFormat:@"%02ld:%02ld",(long)min,(long)sec];
        return duration;
    }
}

// 起始值
-(void)setStartValue:(NSTimeInterval)startValue{
    self.startValueLabel.text = [self formatValue:startValue];
}

// 终点值
-(void)setEndValue:(NSTimeInterval)endValue{
    self.endValueLabel.text = [self formatValue:endValue];
}

// 进度率
-(void)setProgressRate:(CGFloat)progressRate{
    self.progressUI.progress = progressRate;
}


#pragma mark - 懒加载
-(UILabel *)startValueLabel{
    if (!_startValueLabel) {
        _startValueLabel = [[UILabel alloc] init];
        _startValueLabel.font = [UIFont systemFontOfSize:13];
        _startValueLabel.textColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        _startValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _startValueLabel;
}
-(UILabel *)endValueLabel{
    if (!_endValueLabel) {
        _endValueLabel = [[UILabel alloc] init];
        _endValueLabel.font = [UIFont systemFontOfSize:13];
        _endValueLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _endValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _endValueLabel;
}
-(UIProgressView *)progressUI{
    if (!_progressUI) {
        _progressUI = [[UIProgressView alloc] init];
        _progressUI.trackTintColor = [UIColor whiteColor];
        _progressUI.progressTintColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    }
    return _progressUI;
}


#pragma mark - layoutSubViews
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat W = self.frame.size.width;
    CGFloat H = self.frame.size.height;
    
    self.startValueLabel.frame = CGRectMake(0, -H/2.5, 40, H);
    self.progressUI.frame = CGRectMake(CGRectGetMaxX(self.startValueLabel.frame)+3, 0, W-80, H);
    self.endValueLabel.frame = CGRectMake(CGRectGetMaxX(self.progressUI.frame)+3, -H/2.5, 40, H);
}
@end
