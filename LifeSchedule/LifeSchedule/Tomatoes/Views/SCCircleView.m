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



@end


@implementation SCCircleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (UILabel *)showLabel{
    if (_showLabel == nil) {
        _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _showLabel.textAlignment = NSTextAlignmentCenter;
        _showLabel.textColor = [UIColor blueColor];
        _showLabel.font = [UIFont systemFontOfSize:70.0f];
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
    
    CGContextStrokePath(context1);
    
    
    
    //获取上下文
    CGContextRef context2 = UIGraphicsGetCurrentContext();
    
    //设置线宽
    CGContextSetLineWidth(context2, 4);

    //设置颜色
    CGContextSetRGBStrokeColor(context2, 1, 1, 1, 1);

    //画曲线
    CGFloat tempValue = self.count/500.0;
    CGContextAddArc(context2, self.frame.size.width/2.0, self.frame.size.height/2.0, (self.frame.size.width/2.0)-30, -M_PI_2, -M_PI_2 + tempValue * (4 * M_PI_2), 0);
    
    //画圆
    CGContextStrokePath(context2);
}

- (void)startTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(action) userInfo:nil repeats:YES];
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer = NULL;
}

- (void)action{
    //时间累加
    self.count++;
    
    if (self.count == 500) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.count % 100 == 0) {
        self.showLabel.text = [NSString stringWithFormat:@"%d",5-self.count/100];
    }
    
    [self setNeedsDisplay];
}

@end
