//
//  SCCircleView.h
//  Ios倒计时功能
//
//  Created by Evan Yang on 11/07/2018.
//  Copyright © 2018 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCircleView : UIView

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign)int count;

- (void)startTimer;
- (void) stopTimer;

@end
