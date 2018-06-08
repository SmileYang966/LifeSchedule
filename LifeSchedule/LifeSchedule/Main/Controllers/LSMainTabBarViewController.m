//
//  LSMainTabBarViewController.m
//  LifeSchedule
//
//  Created by 杨善成 on 8/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "LSMainTabBarViewController.h"
#import "LSNavViewController.m"

#import "CalendarViewController.h"
#import "SettingViewController.h"
#import "PlannedTasksViewController.h"
#import "TomatoesTimerViewController.h"

@interface LSMainTabBarViewController ()

@end

@implementation LSMainTabBarViewController

- (instancetype)init{
    if (self = [super init]) {
        //init方法添加所有的navigationController
        CalendarViewController *calendarVC = [[CalendarViewController alloc]init];
        LSNavViewController *calendarNav = [[LSNavViewController alloc]initWithRootViewController:calendarVC];
        
    }
    return self;
}

-(void)addRootWithViewController:(Class)class{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
