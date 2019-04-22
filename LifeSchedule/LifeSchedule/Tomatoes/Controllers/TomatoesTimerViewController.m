//
//  TomatoesTimerViewController.m
//  LifeSchedule
//
//  Created by 杨善成 on 8/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "TomatoesTimerViewController.h"
#import "SCCircleView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Setting+CoreDataClass.h"
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>

@interface TomatoesTimerViewController ()<SCCircleViewDelegate,AVAudioPlayerDelegate,UNUserNotificationCenterDelegate>

@property(nonatomic,strong) SCCircleView *circleView;
@property(nonatomic,strong) UIButton *focusBtn;
@property(nonatomic,assign) BOOL isFoucsStatus;

/*
 * 主要是为了颜色渐变的背景图片做准备，本来是直接计划在layer画的渐变图像
 */
@property(nonatomic,strong) UIImageView *bgImgView;
@property(nonatomic,strong) UIImage *workingImage;
@property(nonatomic,strong) UIImage *breakImage;

@property(nonatomic,assign) TomatoesStatus currentTomatoesStatus;

/*DB part*/
@property(nonatomic,strong) NSManagedObjectContext *managedObjContext;

@property(nonatomic,copy) NSString *workingTimeValue;
@property(nonatomic,copy) NSString *breakTimeValue;

@property(nonatomic,strong) AVAudioPlayer *audioPlayer;
@end

@implementation TomatoesTimerViewController

#pragma mark-懒加载circleView以及button

- (SCCircleView *)circleView{
    if (_circleView == nil) {
        _circleView = [[SCCircleView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width , self.view.bounds.size.width)];
        _circleView.center = CGPointMake(self.view.center.x, self.view.center.y-50);
        _circleView.delegate = self;
        [self.bgImgView addSubview:_circleView];
    }
    return _circleView;
}

- (UIImageView *)bgImgView{
    if (_bgImgView == nil) {
        _bgImgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:_bgImgView];
    }
    return _bgImgView;
}

- (UIImage *)workingImage{
    if (_workingImage == nil) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(1, 1);
        layer.frame = self.view.bounds;
        UIColor *workingModeWithStartColor = [UIColor colorWithRed:253/255.0 green:132/255.0 blue:80/255.0 alpha:1.0];
        UIColor *workingModeWithEndColor = [UIColor colorWithRed:253/255.0 green:102/255.0 blue:106/255.0 alpha:1.0];
        layer.colors = @[(__bridge id)workingModeWithStartColor.CGColor,(__bridge id)workingModeWithEndColor.CGColor];
        
        //开启一个imageContext,相当于开启一个画板
        UIGraphicsBeginImageContext(self.view.frame.size);
        @try{
            /*可以将layer渲染到当前的画板上，由上可知，当前画板是刚刚创建的ImageContext*/
            [layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            return img;
        }
        @finally{
            UIGraphicsEndImageContext();
        }
    }
    return _workingImage;
}

- (UIImage *)breakImage{
    if (_breakImage == nil) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(1, 1);
        layer.frame = self.view.bounds;
        UIColor *breakModeWithStartColor = [UIColor colorWithRed:97/255.0 green:214/255.0 blue:118/255.0 alpha:1.0];
        UIColor *breakModeWithEndColor = [UIColor colorWithRed:52/255.0 green:205/255.0 blue:174/255.0 alpha:1.0];
        layer.colors = @[(__bridge id)breakModeWithStartColor.CGColor,(__bridge id)breakModeWithEndColor.CGColor];
        
        //开启一个imageContext,相当于开启一个画板
        UIGraphicsBeginImageContext(self.view.frame.size);
        @try{
            [layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            return img;
        }
        @finally{
            UIGraphicsEndImageContext();
        }
    }
    return _breakImage;
}

- (UIButton *)focusBtn{
    if (_focusBtn == nil) {
        _focusBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _focusBtn.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.circleView.frame)+50);
        _focusBtn.backgroundColor = [UIColor colorWithRed:126/255.0 green:127/255.0 blue:132/255.0 alpha:1.0];
        _focusBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _focusBtn.layer.cornerRadius = 40;
        _focusBtn.layer.masksToBounds = YES;
        [_focusBtn addTarget:self action:@selector(focusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_focusBtn];
    }
    return _focusBtn;
}

- (NSManagedObjectContext *)managedObjContext{
    if (_managedObjContext == NULL) {
        _managedObjContext = [CoreDataManager sharedManager].dBContext;
    }
    return _managedObjContext;
}

-(void)focusBtnClicked:(UIButton *)button{
    [self.circleView stopTimer];
    
    /*If the music is playing ,just stop the current music*/
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
    }
    
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
            [self removeAllLocalPushNotis];
            [self cancelRegisterNotifications];
            break;
        
        case WorkingTomatoesStatus:
            [self adjustDifferentScreenWithButtonTextDesc:@"退出" buttonTextColor:[UIColor redColor] buttonBackgroundColor:[UIColor whiteColor] isHideBars:YES tintColor:[UIColor redColor]];
            
            [self.circleView startTimerWithMinutes:[self.workingTimeValue integerValue] seconds:0 status:WorkingTomatoesStatus displayedTimeColor:[UIColor whiteColor]];
            
            [self createNotificationWithTomatoesStatus:WorkingTomatoesStatus];
            break;
        
        case BreakTomatoesStatus:
            [self adjustDifferentScreenWithButtonTextDesc:@"退出" buttonTextColor:[UIColor greenColor] buttonBackgroundColor:[UIColor whiteColor] isHideBars:YES tintColor:[UIColor greenColor]];
            
            [self.circleView startTimerWithMinutes:[self.breakTimeValue integerValue] seconds:0 status:BreakTomatoesStatus displayedTimeColor:[UIColor whiteColor]];
            
            [self createNotificationWithTomatoesStatus:BreakTomatoesStatus];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Need to do the initData here to update the working time and break time in time
    [self initData];
}


#pragma mark -初始化操作
-(void)initOperations{
    //Create foucuBtn on UI
    [self focusBtn];
    
    //初始阶段为DefaultTomatoesStatus
     self.currentTomatoesStatus = DefaultTomatoesStatus;
    [self setDefaultStatusForCircleView];
}

-(void)initData{
    Setting *workTimeSetting = [self querySettingObjectWithKeyName:@"workTime"];
    Setting *breakTimeSetting = [self querySettingObjectWithKeyName:@"breakTime"];
    //Set the workingTime value && Set the breakTime value
    self.workingTimeValue = workTimeSetting.settingValue;
    self.breakTimeValue = breakTimeSetting.settingValue;
}

-(Setting *)querySettingObjectWithKeyName:(NSString *)settingKeyName{
    NSError *error = NULL;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Setting"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"settingKeyName=%@",settingKeyName];
    fetchRequest.predicate = predicate;
    return [[self.managedObjContext executeFetchRequest:fetchRequest error:&error] firstObject];
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
    [self cancelRegisterNotifications];
    if (finishedStatus == BreakTomatoesStatus) {//1.休息时间结束后，进入到工作时间
        self.currentTomatoesStatus = WaitToStartWorkingTomatoesStatus;
        NSString *workingTitleStr = [NSString stringWithFormat:@"%02ld : 00",[self.workingTimeValue integerValue]];
        [self.circleView setCircleTitleWithStr:workingTitleStr textColor:[UIColor whiteColor]];
        [self adjustDifferentScreenWithButtonTextDesc:@"开始专注" buttonTextColor:[UIColor redColor] buttonBackgroundColor:[UIColor whiteColor] isHideBars:YES tintColor:[UIColor redColor]];
//        [self playRestAudio];
    }
    
    if (finishedStatus == WorkingTomatoesStatus) {//2.工作时间结束后，进入到休息时间
        self.currentTomatoesStatus = WaitToStartBreakTomatoesStatus;
        NSString *breakTitleStr = [NSString stringWithFormat:@"%02ld : 00",[self.breakTimeValue integerValue]];
        [self.circleView setCircleTitleWithStr:breakTitleStr textColor:[UIColor whiteColor]];
        [self adjustDifferentScreenWithButtonTextDesc:@"开始休息" buttonTextColor:[UIColor greenColor] buttonBackgroundColor:[UIColor whiteColor] isHideBars:YES tintColor:[UIColor greenColor]];
//        [self playContinueWorkingAudio];
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
    self.circleView.backgroundColor = [UIColor clearColor];
    
    if (self.currentTomatoesStatus==WorkingTomatoesStatus ||
        self.currentTomatoesStatus==BreakTomatoesStatus ||
        self.currentTomatoesStatus==WaitToStartWorkingTomatoesStatus ||
        self.currentTomatoesStatus==WaitToStartBreakTomatoesStatus) {
        [self adjustGradientColorByTomatoesMode];
    }else{
        self.bgImgView.image = nil;
        self.bgImgView.backgroundColor = AppMajorTintColor;
    }
    
    if (hideBars) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self setTabBarVisible:NO animated:YES completion:nil];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self setTabBarVisible:YES animated:YES completion:nil];
    }
}

-(void)adjustGradientColorByTomatoesMode{
    if (self.currentTomatoesStatus==WorkingTomatoesStatus ||
        self.currentTomatoesStatus==WaitToStartWorkingTomatoesStatus) {
        self.bgImgView.image = self.workingImage;
    }else if(self.currentTomatoesStatus==BreakTomatoesStatus ||
             self.currentTomatoesStatus==WaitToStartBreakTomatoesStatus){
        self.bgImgView.image = self.breakImage;
    }
}

#pragma mark-Play Audio
-(void)playRestAudio{
    NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:@"breakTimeExpired" ofType:@"mp3"];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:musicFilePath] error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //连续震动?
//    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, soundCompleteCallback, NULL);
}


void soundCompleteCallback(SystemSoundID sound,void * clientData) {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  //震动
}

-(void)playContinueWorkingAudio{
    NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:@"workingTimeExpired" ofType:@"mp3"];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:musicFilePath] error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //连续震动?
//    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, soundCompleteCallback, NULL);
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

#pragma mark -TouchBegin
/*Touch the screen to stop the music when the music is playing*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
    }
}

#pragma mark -audioPlayerDidFinishPlaying
/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"stop button action");
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
}

#pragma mark -local push
-(void)createNotificationWithTomatoesStatus:(TomatoesStatus)tomatoesStatus{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.title = @"番茄计时";
    
    NSString *notiId;
    NSTimeInterval interval;
    if (tomatoesStatus == WorkingTomatoesStatus) {
        content.body = @"您完成了一个工作周期，休息一下吧😊";
        notiId = @"workingTomatoesStatus";
        interval = [self.workingTimeValue integerValue] * 60.0f;
    }else {
        content.body = @"一个休息周期结束了，继续工作吧😊";
        notiId = @"breakTomatoesStatus";
        interval = [self.breakTimeValue integerValue] * 60.0f;
    }
    
    NSDate *futureDate = [[NSDate alloc]initWithTimeIntervalSinceNow:interval];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *notifyComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:futureDate];
    UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:notifyComponents repeats:NO];
    //To make sure the notification id is always unique, just fetch the current time as the part of notificationId
    
    content.sound = [UNNotificationSound soundNamed:@"countdownNotification.m4r"];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:notiId content:content trigger:calendarTrigger];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"成功发送通知");
    }];
}

- (void)removeAllLocalPushNotis{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:@[@"workingTomatoesStatus",@"breakTomatoesStatus"]];
}

- (void)cancelRegisterNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self.circleView name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.circleView name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}

@end
