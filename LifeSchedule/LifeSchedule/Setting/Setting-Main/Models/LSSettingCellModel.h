//
//  LSSettingCellModel.h
//  LifeSchedule
//
//  Created by 杨善成 on 17/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSSettingCellModel : NSObject

@property(nonatomic,copy) NSString *iconName;
@property(nonatomic,copy) NSString *title;

+(instancetype)LSSettingCellModelWithTitle:(NSString *)title iconWithName:(NSString *)iconName;

@end
