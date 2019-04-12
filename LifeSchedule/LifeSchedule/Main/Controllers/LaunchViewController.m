//
//  LaunchViewController.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/4/11.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "LaunchViewController.h"
#import "DHGuidePageHUD.h"
#import "LSMainTabBarViewController.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.lightGrayColor;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstTimeToEnterTheScreen"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTimeToEnterTheScreen"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstTimeToEnterTheScreen"];
        [self setStaticGuidePage];
    }
}

#pragma mark - 设置APP静态图片引导页
- (void)setStaticGuidePage {
    NSArray *imageNameArray = @[@"guideImage1.jpg",@"guideImage2.jpg",@"guideImage3.jpg",@"guideImage4.jpg",@"guideImage5.jpg"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.bounds imageNameArray:imageNameArray buttonIsHidden:NO];
    guidePage.slideInto = YES;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    LSMainTabBarViewController *mainTabBarController = [[LSMainTabBarViewController alloc]init];
    keyWindow.rootViewController = mainTabBarController;
    
    [keyWindow addSubview:guidePage];
}


@end
