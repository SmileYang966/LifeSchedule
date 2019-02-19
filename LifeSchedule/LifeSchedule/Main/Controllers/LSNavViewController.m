//
//  LSNavViewController.m
//  LifeSchedule
//
//  Created by 杨善成 on 8/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "LSNavViewController.h"


@interface LSNavViewController ()

@end

@implementation LSNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * Why do we need to override the pushViewController function ?
 * Currently, only the main screen (Four screens need to show the tabbar)
 * The other screen default to hide the tabbar . If we want to this rule adapted for all screen, we should override the pushViewController
 * by the navigationController which defined by ourselves.
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"viewController class=%@ count=%ld",[viewController class],[self.viewControllers count]);
    if (self.viewControllers.count>=1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


@end
