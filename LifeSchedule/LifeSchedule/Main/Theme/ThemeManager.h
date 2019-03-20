//
//  ThemeManager.h
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/20.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThemeManager : NSObject

@property (nonatomic, copy) NSString *themeName;           // 主题名字
@property (nonatomic, retain) NSDictionary *themePlistDict;    // 主题属性列表字典

+ (ThemeManager *) sharedThemeManager;

- (UIImage *) themeImageWithName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
