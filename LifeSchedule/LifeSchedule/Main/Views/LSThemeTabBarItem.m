//
//  LSThemeTabBarItem.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/20.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "LSThemeTabBarItem.h"
#import "ThemeManager.h"

@implementation LSThemeTabBarItem

-(instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangedNotification:) name:@"" object:nil];
    }
    return self;
}


- (instancetype) initWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImageName {
    if (self = [self init]) {
        self.title = title;
        self.imageName = imageName;         // 此时会调用[self setImageName:imageName] ---> [self
        self.selectedImageName = selectedImageName;// 此时会调用[self
    }
    
    return self;
}

- (void) setImageName:(NSString *)imageName {
    if (_imageName != imageName) {
        _imageName = imageName;
    }
    
    [self reloadThemeImage];
}

- (void) setSelectedImageName:(NSString *)selectedImageName {
    if (_selectedImageName != selectedImageName) {
        _selectedImageName = selectedImageName;
    }
    
    [self reloadThemeImage];
}

// 主题改变之后重新加载图片
- (void)themeChangedNotification:(NSNotification *)notification {
    [self reloadThemeImage];
}

- (void)reloadThemeImage {
    ThemeManager * themeManager = [ThemeManager sharedThemeManager];
    
    if (self.imageName != nil) {
        UIImage * image = [themeManager themeImageWithName:self.imageName];
        [self setImage:image];
    }
    
    if (self.selectedImageName != nil) {
        UIImage * selectedImage = [themeManager themeImageWithName:self.selectedImageName];
        [self setSelectedImage:selectedImage];
    }
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
