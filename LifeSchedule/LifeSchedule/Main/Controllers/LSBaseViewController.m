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
    [[UINavigationBar appearance] setBarTintColor:self.bgColor];
    [[UITabBar appearance] setBarTintColor:self.bgColor];
}

@end
