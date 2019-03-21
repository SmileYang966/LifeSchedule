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
#import "LSSettingTableViewController.h"
#import "PlannedTasksViewController.h"
#import "TomatoesTimerViewController.h"


@interface LSMainTabBarViewController ()

@end

@implementation LSMainTabBarViewController

- (instancetype)init{
    if (self = [super init]) {
        //init方法添加所有的navigationController        
        [self addChildControllerWithClass:[PlannedTasksViewController class] itemTitle:@"任务" itemImageName:@"mainTask" selectedItemImageName:@"mainTask_Blue"];
        [self addChildControllerWithClass:[CalendarViewController class] itemTitle:@"日历" itemImageName:@"calendar" selectedItemImageName:@"calendar_Blue"];
        [self addChildControllerWithClass:[TomatoesTimerViewController class] itemTitle:@"计时" itemImageName:@"countdown" selectedItemImageName:@"countdown_Blue"];
        [self addChildControllerWithClass:[LSSettingTableViewController class] itemTitle:@"设置" itemImageName:@"setting" selectedItemImageName:@"setting_Blue"];
    }
    return self;
}

-(void)addChildControllerWithClass:(Class)class itemTitle:(NSString *)itemTitle itemImageName:(NSString *)itemImageName selectedItemImageName:(NSString *)selectedImageName{
    UIViewController *vc = [[class alloc]init];
    //Below code  - Navigation Title and TabBarItem will be set the same title string
    vc.title = itemTitle;
    //image有一个UIImageRenderingModeAlwaysOriginal这个属性，可以防止image被ios系统自动渲染
//    [vc.tabBarItem setImage:[[UIImage imageNamed:itemImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [vc.tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    LSThemeTabBarItem *themeTabBarItem = [[LSThemeTabBarItem alloc]initWithTitle:itemTitle imageName:itemImageName selectedImage:selectedImageName];
    vc.tabBarItem = themeTabBarItem;
    
    NSDictionary *attrDictSelected = @{NSForegroundColorAttributeName : [UIColor colorWithRed:64/255.0 green:147/255.0 blue:210/255.0 alpha:1.0f]};
    [vc.tabBarItem setTitleTextAttributes:attrDictSelected forState:UIControlStateSelected];
    
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
