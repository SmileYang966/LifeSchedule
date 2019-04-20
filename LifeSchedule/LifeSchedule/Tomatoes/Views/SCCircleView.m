//
//  SCCircleView.m
//  Ios倒计时功能
//
//  Created by Evan Yang on 11/07/2018.
//  Copyright © 2018 Evan. All rights reserved.
//




#import "SCCircleView.h"



@interface SCCircleView()

@property(nonatomic,strong) UILabel *showLabel;

@property(nonatomic,assign)int count;
@property(nonatomic,assign)NSInteger minutes;
@property(nonatomic,assign)NSInteger seconds;
@property(nonatomic,assign)NSInteger totalDuration;

@property(nonatomic,assign)TomatoesStatus currentTomatoesStatus;


@property(nonatomic,assign) CFAbsoluteTime startedTime;
@property(nonatomic,assign) CFAbsoluteTime enterBackgroundTime;
@property(nonatomic,assign) CFAbsoluteTime enterForegroundTime;
@property(nonatomic,assign) int savedCountLastTime;

@end


@implementation SCCircleView



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillGoToBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillGoToForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (UILabel *)showLabel{
    if (_showLabel == nil) {
        _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
        _showLabel.textAlignment = NSTextAlignmentCenter;
        _showLabel.font = [UIFont systemFontOfSize:60.0f];
        _showLabel.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.width*0.5);
        [self addSubview:_showLabel];
    }
    return _showLabel;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //获取上下文
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    
    //设置线宽
    CGContextSetLineWidth(context1, 3);

    //设置颜色
    CGContextSetRGBStrokeColor(context1, 224/255.0, 223/255.0, 224/255.0, 1);

    //画曲线
    CGContextAddArc(context1, self.frame.size.width/2.0, self.frame.size.height/2.0, (self.frame.size.width/2.0)-30, -M_PI_2, 3 * M_PI_2, 0);
    
    //画圆
    CGContextStrokePath(context1);
    
    
    
    //获取上下文
    CGContextRef context2 = UIGraphicsGetCurrentContext();
    
    //设置线宽
    CGContextSetLineWidth(context2, 4);

    //设置颜色
    CGContextSetRGBStrokeColor(context2, 1, 1, 1, 1);

    //画曲线
    if (self.minutes*60+self.seconds!=0) {
        double tempValue = (double)self.count/(self.totalDuration * 1.0);
        CGContextAddArc(context2, self.frame.size.width/2.0, self.frame.size.height/2.0, (self.frame.size.width/2.0)-30, -M_PI_2, -M_PI_2 + tempValue * (4 * M_PI_2), 0);
    }

    //画圆
    CGContextStrokePath(context2);
}

//不管是工作时间倒计时还是休息时间倒计时，点相应的button永远只调用一次
- (void)startTimerWithMinutes:(NSInteger)minutes seconds:(NSInteger)seconds status:(TomatoesStatus)tomatoesStatus displayedTimeColor:(UIColor *)color{
    self.minutes = minutes;
    self.seconds = seconds;
    self.currentTomatoesStatus = tomatoesStatus;
    self.showLabel.text = [NSString stringWithFormat:@"%02ld : %02ld",minutes,seconds];
    self.showLabel.textColor = color;
    self.totalDuration = minutes * 60 + seconds;
    self.startedTime = CFAbsoluteTimeGetCurrent();
//    self.count = beginCount;
//    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];

    [self startTimer];
}

-(void)startTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer{
    [self.timer invalidate];
    //取消之前绘制的图像，恢复到初始状态
    if (self.count !=0) {
        self.savedCountLastTime = self.count;
    }
    self.count=0;
    [self setNeedsDisplay];
    self.timer = NULL;
}

-(void)timerAction{
    self.count++;
    
    //If the second = 0,minute -1 and second=59
    if (self.seconds==0) {
        self.minutes--;
        self.seconds = 59;
    }else{
        self.seconds--;
    }
    
    if (self.minutes==0 && self.seconds==0) {
        [self.timer invalidate];
        //番茄时间到了，应该休息一下了
    
        if ([self.delegate respondsToSelector:@selector(SCCircleViewTimeFinishedWithTomatoesStatus:)]) {
            [self.delegate SCCircleViewTimeFinishedWithTomatoesStatus:self.currentTomatoesStatus];
        }
    }else{
        self.showLabel.text = [NSString stringWithFormat:@"%02ld : %02ld",self.minutes,self.seconds];
    }
    [self setNeedsDisplay];
}

- (void)setCircleTitleWithStr:(NSString *)title textColor:(UIColor *)titleColor{
    self.showLabel.text = title;
    self.showLabel.textColor = titleColor;
}

-(void)appWillGoToBackground{
    [self stopTimer];
    self.enterBackgroundTime = CFAbsoluteTimeGetCurrent();
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillGoToForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)appWillGoToForeground{
    self.enterForegroundTime = CFAbsoluteTimeGetCurrent();
    
    //1.重新计算self.count
    long backgroundDuration = lround(self.enterForegroundTime - self.enterBackgroundTime);
    NSLog(@"backgroundDuration=%ld",backgroundDuration);
    self.count = (int)backgroundDuration + self.savedCountLastTime;
    [self setNeedsDisplay];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillGoToBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
 
    
    //2.计算显示的倒计时时间
    NSInteger restTotalTime = self.totalDuration - self.count;
    if (restTotalTime > 0) {
        //显示剩余时间
        NSInteger restMins = restTotalTime / 60;
        NSInteger restSeconds = restTotalTime % 60;
        self.showLabel.text = [NSString stringWithFormat:@"%02ld : %02ld",restMins,restSeconds];
        self.minutes = restMins;
        self.seconds = restSeconds;
        //3.重新开启timer，继续运行
        [self startTimer];
    }else{
        //显示0
        self.showLabel.text = [NSString stringWithFormat:@"%02ld : %02ld",(NSInteger)0,(NSInteger)0];
        [self stopTimer];
    }
}


@end
