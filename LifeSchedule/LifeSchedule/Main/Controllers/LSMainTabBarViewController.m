//
//  LSMainTabBarViewController.m
//  LifeSchedule
//
//  Created by 杨善成 on 8/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "LSMainTabBarViewController.h"

#import "LSNavViewController.h"

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
        [self addChildControllerWithClass:[CalendarViewController class] itemTitle:@"任务" itemImageName:@"tabbar_profile"];
        [self addChildControllerWithClass:[SettingViewController class] itemTitle:@"日历" itemImageName:@"tabbar_profile"];
        [self addChildControllerWithClass:[PlannedTasksViewController class] itemTitle:@"番茄" itemImageName:@"tabbar_profile"];
        [self addChildControllerWithClass:[TomatoesTimerViewController class] itemTitle:@"设置" itemImageName:@"tabbar_profile"];
    }
    return self;
}

-(void)addChildControllerWithClass:(Class)class itemTitle:(NSString *)itemTitle itemImageName:(NSString *)itemImageName{
    UIViewController *vc = [[class alloc]init];
    //Below code  - Navigation Title and TabBarItem will be set the same title string
    vc.title = itemTitle;
    //image有一个UIImageRenderingModeAlwaysOriginal这个属性，可以防止image被ios系统自动渲染
    [vc.tabBarItem setImage:[[UIImage imageNamed:itemImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    LSNavViewController *nav = [[LSNavViewController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
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
