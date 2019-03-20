//
//  UIFactory.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/20.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "UIFactory.h"
#import "LSThemeTabBarItem.h"

@implementation UIFactory

+ (UITabBarItem *) createTabBarItemWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImageName {
    LSThemeTabBarItem *themeTabBarItem = [[LSThemeTabBarItem alloc] initWithTitle:title imageName:imageName selectedImage:selectedImageName];
    
    return themeTabBarItem;
}

@end
