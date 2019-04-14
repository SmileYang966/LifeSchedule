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

@interface LaunchViewController ()<DHGuidePageHUDDelegate>

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStaticGuidePage];
}

#pragma mark - 设置APP静态图片引导页
- (void)setStaticGuidePage {
    NSArray *imageNameArray = @[@"guideImage1.jpg",@"guideImage2.jpg",@"guideImage3.jpg",@"guideImage4.jpg",@"guideImage5.jpg"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.bounds imageNameArray:imageNameArray buttonIsHidden:NO];
    guidePage.hUDDelegate = self;
    guidePage.slideInto = YES;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:guidePage];
}

- (void)goToHomeViewControllerWithGuidePageHUD:(UIView *)DhGuidePageHUD{
    LSMainTabBarViewController *mainTabBarController = [[LSMainTabBarViewController alloc]init];
    CATransition *transtition = [CATransition animation];
    transtition.duration = 1.0f;
    transtition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [UIApplication sharedApplication].keyWindow.rootViewController = mainTabBarController;
    /*设置转场动画*/
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transtition forKey:@"animation"];
}

@end
