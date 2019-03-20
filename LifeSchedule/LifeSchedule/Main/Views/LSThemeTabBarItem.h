//
//  LSThemeTabBarItem.h
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/20.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSThemeTabBarItem : UITabBarItem

@property(nonatomic,copy)NSString *imageName;
@property(nonatomic,copy)NSString *selectedImageName;

-(instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImageName;

@end

NS_ASSUME_NONNULL_END
