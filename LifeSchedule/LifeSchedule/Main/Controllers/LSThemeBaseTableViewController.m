//
//  LSThemeBaseTableViewController.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/21.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "LSThemeBaseTableViewController.h"

@interface LSThemeBaseTableViewController ()

@property(nonatomic,strong) UIColor *bgColor;

@end

@implementation LSThemeBaseTableViewController

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadThemeImage];
}

- (void) reloadThemeImage {
    ThemeManager *themeManager = [ThemeManager sharedThemeManager];
    [self.navigationController.navigationBar setBarTintColor:self.bgColor];
    [self.tabBarController.tabBar setBarTintColor:self.bgColor];
    //    UIImage *navigationBackgroundImage = [themeManager themeImageWithName:@"navigationbar_background.png"];
    //    [self.navigationController.navigationBar setBackgroundImage:navigationBackgroundImage forBarMetrics:UIBarMetricsDefault];
    //
    //    UIImage *tabBarBackgroundImage = [themeManager themeImageWithName:@"tabbar_background.png"];
    //    [self.tabBarController.tabBar setBackgroundImage:tabBarBackgroundImage];
}


@end
