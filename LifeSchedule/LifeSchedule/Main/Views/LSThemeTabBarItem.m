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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangedNotification:) name:@"ThemeChangedNotification" object:nil];
    }
    return self;
}

-(void)themeChangedNotification:(NSNotification *)notification{
    [self reloadThemeImage];
    
    NSDictionary *attrDictSelected = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self setTitleTextAttributes:attrDictSelected forState:UIControlStateSelected];
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


- (void)reloadThemeImage {
    if (self.imageName != nil) {
        [self setImage:[[UIImage imageNamed:self.imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    
    if (self.selectedImageName != nil) {
        [self setSelectedImage:[[UIImage imageNamed:self.selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
