//
//  SCCircleView.h
//  Ios倒计时功能
//
//  Created by Evan Yang on 11/07/2018.
//  Copyright © 2018 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCCircleViewDelegate <NSObject>
-(void)SCCircleViewTimeFinishedWithTomatoesStatus:(TomatoesStatus)finishedStatus;
@end

@interface SCCircleView : UIView

@property(nonatomic,strong) NSTimer *timer;

- (void)startTimerWithMinutes:(NSInteger)minutes seconds:(NSInteger)seconds status:(TomatoesStatus)tomatoesStatus displayedTimeColor:(UIColor *)color;
- (void)setCircleTitleWithStr:(NSString *)title textColor:(UIColor *)titleColor;
- (void) stopTimer;

@property(nonatomic,weak)id<SCCircleViewDelegate> delegate;

@end
