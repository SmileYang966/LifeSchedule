//
//  LSBaseViewController.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/20.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "LSBaseViewController.h"


@interface LSBaseViewController ()

@property(nonatomic,strong) UIColor *bgColor;

@end

@implementation LSBaseViewController

-(id)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangedNotification:) name:@"ThemeChangedNotification" object:nil];
    }
    [self reloadThemeImage];
    return self;
}

-(void)themeChangedNotification:(NSNotification *)notification{
    self.bgColor = notification.userInfo[@"Color"];
    [self reloadThemeImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reloadThemeImage];
}

- (void) reloadThemeImage {
    ThemeManager *themeManager = [ThemeManager sharedThemeManager];
    
    [[UINavigationBar appearance] setBarTintColor:self.bgColor];
    [[UITabBar appearance] setBarTintColor:self.bgColor];
    
//    [self.navigationController.navigationBar setBarTintColor:self.bgColor];
//    [self.tabBarController.tabBar setBarTintColor:self.bgColor];
    
//    UIImage *navigationBackgroundImage = [themeManager themeImageWithName:@"navigationbar_background.png"];
//    [self.navigationController.navigationBar setBackgroundImage:navigationBackgroundImage forBarMetrics:UIBarMetricsDefault];
//
//    UIImage *tabBarBackgroundImage = [themeManager themeImageWithName:@"tabbar_background.png"];
//    [self.tabBarController.tabBar setBackgroundImage:tabBarBackgroundImage];
}

@end
