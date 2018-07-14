//
//  TomatoesTimerViewController.m
//  LifeSchedule
//
//  Created by 杨善成 on 8/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "TomatoesTimerViewController.h"
#import "SCCircleView.h"

@interface TomatoesTimerViewController ()

@property(nonatomic,strong) SCCircleView *circleView;

@property(nonatomic,strong) UIButton *focusBtn;

@property(nonatomic,assign) BOOL isFoucsStatus;

@end

@implementation TomatoesTimerViewController

- (SCCircleView *)circleView{
    if (_circleView == nil) {
        _circleView = [[SCCircleView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width , self.view.bounds.size.width)];
        _circleView.center = CGPointMake(self.view.center.x, self.view.center.y-50);
        [self.view addSubview:_circleView];
    }
    return _circleView;
}

- (UIButton *)focusBtn{
    if (_focusBtn == nil) {
        _focusBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _focusBtn.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.circleView.frame)+50);
        _focusBtn.backgroundColor = [UIColor colorWithRed:126/255.0 green:127/255.0 blue:132/255.0 alpha:1.0];
        [_focusBtn setTitle:@"开始专注" forState:UIControlStateNormal];
        _focusBtn.font = [UIFont systemFontOfSize:13.0f];
        [_focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _focusBtn.layer.cornerRadius = 40;
        _focusBtn.layer.masksToBounds = YES;
        [_focusBtn addTarget:self action:@selector(focusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_focusBtn];
    }
    return _focusBtn;
}

-(void)focusBtnClicked:(UIButton *)button{
    self.isFoucsStatus = !self.isFoucsStatus;
    if (self.isFoucsStatus) {//开启定时器
        self.view.backgroundColor = UIColor.redColor;
        [self.circleView startTimer];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self setTabBarVisible:YES animated:YES completion:^(BOOL value) {
            NSLog(@"开启定时器");
        }];
    }else{//注销定时器
        self.view.backgroundColor = UIColor.whiteColor;
        [self.circleView stopTimer];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self setTabBarVisible:NO animated:YES completion:^(BOOL value) {
            NSLog(@"注销定时器");
        }];
    }
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self focusBtn];
    
    NSLog(@"TabBarFrame=%@----NavigationBar frame=%@----self.view.frame=%@",NSStringFromCGRect(self.tabBarController.tabBar.frame),NSStringFromCGRect(self.navigationController.navigationBar.frame),NSStringFromCGRect(self.view.frame));
    
    NSLog(@"UISCreen.bounds=%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
}

@end
