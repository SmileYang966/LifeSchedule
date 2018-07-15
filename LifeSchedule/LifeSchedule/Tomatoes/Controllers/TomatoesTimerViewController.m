//
//  TomatoesTimerViewController.m
//  LifeSchedule
//
//  Created by 杨善成 on 8/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "TomatoesTimerViewController.h"
#import "SCCircleView.h"


@interface TomatoesTimerViewController ()<SCCircleViewDelegate>
@property(nonatomic,strong) SCCircleView *circleView;
@property(nonatomic,strong) UIButton *focusBtn;
@property(nonatomic,assign) BOOL isFoucsStatus;

@property(nonatomic,assign) TomatoesStatus currentTomatoesStatus;
@end

@implementation TomatoesTimerViewController

#pragma mark-懒加载circleView以及button

- (SCCircleView *)circleView{
    if (_circleView == nil) {
        _circleView = [[SCCircleView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width , self.view.bounds.size.width)];
        _circleView.center = CGPointMake(self.view.center.x, self.view.center.y-50);
        _circleView.delegate = self;
        [self.view addSubview:_circleView];
    }
    return _circleView;
}

- (UIButton *)focusBtn{
    if (_focusBtn == nil) {
        _focusBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _focusBtn.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.circleView.frame)+50);
        _focusBtn.backgroundColor = [UIColor colorWithRed:126/255.0 green:127/255.0 blue:132/255.0 alpha:1.0];
        _focusBtn.font = [UIFont systemFontOfSize:16.0f];
        [_focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _focusBtn.layer.cornerRadius = 40;
        _focusBtn.layer.masksToBounds = YES;
        [_focusBtn addTarget:self action:@selector(focusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_focusBtn];
    }
    return _focusBtn;
}

-(void)focusBtnClicked:(UIButton *)button{

    [self.circleView stopTimer];
    
    switch (self.currentTomatoesStatus) {
            
        //如果当前的工作是Default状态，那么按钮点击后进入到工作状态
        case DefaultTomatoesStatus:
            self.currentTomatoesStatus = WorkingTomatoesStatus;
            break;
        
        //如果当前是在工作状态,分以下两种情况：
        //1.工作状态的倒计时操作还未完成，点击按钮会退回到defaultStatus
        case WorkingTomatoesStatus:
            self.currentTomatoesStatus = DefaultTomatoesStatus;
            break;
        
        //2.如果工作状态的倒计时操作已经完成，会进入到WaitToStartBreakTomatoesStatus
        case WaitToStartWorkingTomatoesStatus:
            self.currentTomatoesStatus = WorkingTomatoesStatus;
            break;
            
        //如果当前是在休息阶段，分以下两种情况:
        //1.休息阶段的倒计时操作还未完成，点击按钮会退回到defaultStatus
        case BreakTomatoesStatus:
            self.currentTomatoesStatus = DefaultTomatoesStatus;
            break;
       
        //2.如果休息阶段的倒计时操作已经完成，会进入到WaitToStartWorkingTomatoesStatus
        case WaitToStartBreakTomatoesStatus:
            self.currentTomatoesStatus = BreakTomatoesStatus;
            break;
            
        default:
            break;
    }
    
    [self processTheDifferentTomatoesStatus];
}

-(void)processTheDifferentTomatoesStatus{
    switch (self.currentTomatoesStatus) {
        case DefaultTomatoesStatus:
            [self setDefaultStatusForCircleView];
            break;
        
        case WorkingTomatoesStatus:
            [self adjustDifferentScreenWithButtonTextDesc:@"退出" buttonTextColor:[UIColor redColor] buttonBackgroundColor:[UIColor whiteColor] isHideBars:YES tintColor:[UIColor redColor]];
            
            [self.circleView startTimerWithMinutes:TOMATOESCOUNTDOWNMINUTESFORWORKING seconds:TOMATOESCOUNTDOWNSECONDS status:WorkingTomatoesStatus displayedTimeColor:[UIColor whiteColor]];
            break;
        
        case BreakTomatoesStatus:
            [self adjustDifferentScreenWithButtonTextDesc:@"退出" buttonTextColor:[UIColor greenColor] buttonBackgroundColor:[UIColor whiteColor] isHideBars:YES tintColor:[UIColor greenColor]];
            
            [self.circleView startTimerWithMinutes:TOMATOESCOUNTDOWNMINUTESFORBREAK seconds:TOMATOESCOUNTDOWNSECONDS status:BreakTomatoesStatus displayedTimeColor:[UIColor whiteColor]];
            break;
            
        default:
            break;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initOperations];
}

#pragma mark -初始化操作
-(void)initOperations{
    //Create foucuBtn on UI
    [self focusBtn];
    
    //初始阶段为DefaultTomatoesStatus
     self.currentTomatoesStatus = DefaultTomatoesStatus;
    [self setDefaultStatusForCircleView];
}

-(void)setDefaultStatusForCircleView{
    //设置当前的时间点
    NSString *circleTitle = @"";
    if ([self IsForenoon]) {
        circleTitle = @"上午好";
    }else{
        circleTitle = @"下午好";
    }
    
    [self.circleView setCircleTitleWithStr:circleTitle textColor:[UIColor lightGrayColor]];
    [self adjustDifferentScreenWithButtonTextDesc:@"开始专注" buttonTextColor:[UIColor whiteColor] buttonBackgroundColor:[UIColor lightGrayColor] isHideBars:NO tintColor:[UIColor whiteColor]];
}

//判断当前时间是上午还是下午
-(bool)IsForenoon{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    [formatter setDateFormat:@"HH"];//大写的HH代表24小时制,而小写的hh代表12小时制
    [formatter setTimeZone:localZone];
    NSDate *currentDate = [NSDate date];
    NSString *str = [formatter stringFromDate:currentDate];
    NSInteger hour = [str integerValue];
    if (hour >= 0 && hour < 12) {
        return true;
    }else{
        return false;
    }
}

#pragma mark-倒计时结束后触发的Delegate
- (void)SCCircleViewTimeFinishedWithTomatoesStatus:(TomatoesStatus)finishedStatus{
    if (finishedStatus == BreakTomatoesStatus) {//1.休息时间结束后，进入到工作时间
        self.currentTomatoesStatus = WaitToStartWorkingTomatoesStatus;
        [self.circleView setCircleTitleWithStr:@"01 : 00" textColor:[UIColor whiteColor]];
        [self adjustDifferentScreenWithButtonTextDesc:@"开始专注" buttonTextColor:[UIColor redColor] buttonBackgroundColor:[UIColor whiteColor] isHideBars:YES tintColor:[UIColor redColor]];
    }
    
    if (finishedStatus == WorkingTomatoesStatus) {//2.工作时间结束后，进入到休息时间
        self.currentTomatoesStatus = WaitToStartBreakTomatoesStatus;
        [self.circleView setCircleTitleWithStr:@"02 : 00" textColor:[UIColor whiteColor]];
        [self adjustDifferentScreenWithButtonTextDesc:@"开始休息" buttonTextColor:[UIColor greenColor] buttonBackgroundColor:[UIColor whiteColor] isHideBars:YES tintColor:[UIColor greenColor]];
    }
}

// Used scenario 1 - 当工作时间的倒计时以及休息时间的倒计时expired后，需要自动进行相应的切换，规则如下:
// 1.当前是工作状态 则切换为 休息时间界面
// 2.当前是休息状态 则切换为 工作时间界面

// Used scenario 2 - 当工作时间的倒计时正在进行中时，此刻点击button进行状态的变化，需要调用以下的方法进行处理
-(void)adjustDifferentScreenWithButtonTextDesc:(NSString *)buttonTextStr buttonTextColor:(UIColor *)btnTextColor buttonBackgroundColor:(UIColor *)buttonBgColor isHideBars:(BOOL)hideBars tintColor:(UIColor *)tintColor{
    [self.circleView stopTimer];
    [self.focusBtn setTitle:buttonTextStr forState:UIControlStateNormal];
    [self.focusBtn setTitleColor:btnTextColor forState:UIControlStateNormal];
    [self.focusBtn setBackgroundColor:buttonBgColor];
    self.circleView.backgroundColor = tintColor;
    self.view.backgroundColor = tintColor;
    if (hideBars) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self setTabBarVisible:NO animated:YES completion:nil];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self setTabBarVisible:YES animated:YES completion:nil];
    }
}

#pragma mark-TabBar-NavgationBar隐藏与否
-(void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(BOOL value))completion{
    
    if ([self tabBarIsVisible] == visible) {
        return completion != nil ? completion(YES) : nil;
    }
    
    CGRect frame = self.tabBarController.tabBar.frame;
    CGFloat height = frame.size.height;
    CGFloat offsetY = visible ? -height : height;
    
    CGFloat duration = animated ? 0.3 : 0.0;
    [UIView animateWithDuration:duration animations:^{
        self.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    } completion:completion];
}

-(BOOL)tabBarIsVisible{
    return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}
@end
