//
//  ThemeManager.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/20.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "ThemeManager.h"

static ThemeManager *_sharedThemeManager;

@interface  ThemeManager()

@end

@implementation ThemeManager

- (instancetype) init {
    if(self = [super init]) {
        NSString *themePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        self.themePlistDict = [NSDictionary dictionaryWithContentsOfFile:themePath];
    }
    return self;
}


+ (ThemeManager *) sharedThemeManager {
    @synchronized(self) {
        if (_sharedThemeManager == NULL) {
            _sharedThemeManager = [[ThemeManager alloc]init];
        }
    }
    return _sharedThemeManager;
}

- (void)setThemeName:(NSString *)themeName{
    _themeName = themeName;
}


- (UIImage *) themeImageWithName:(NSString *)imageName {
    if (imageName == nil) {
        return nil;
    }
    
    NSString *themePath = [self themePath];
    NSString *themeImagePath = [themePath stringByAppendingPathComponent:imageName];
    UIImage *themeImage = [UIImage imageWithContentsOfFile:themeImagePath];
    
    return themeImage;
}

// 返回主题路径
- (NSString *)themePath {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    if (self.themeName == nil || [self.themeName isEqualToString:@""]) {
        return resourcePath;
    }
    
    
    NSString *themeSubPath = [self.themePlistDict objectForKey:self.themeName];    // Skins/blue
    NSString *themeFilePath = [resourcePath stringByAppendingPathComponent:themeSubPath]; // .../Skins/blue
    
    return themeFilePath;
}

@end
