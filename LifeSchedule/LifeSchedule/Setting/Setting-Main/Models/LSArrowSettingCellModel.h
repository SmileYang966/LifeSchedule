//
//  LSArrowCellModel.h
//  LifeSchedule
//
//  Created by 杨善成 on 18/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "LSSettingCellModel.h"

@interface LSArrowSettingCellModel : LSSettingCellModel

@property(nonatomic,assign) Class destClass;

+(instancetype)LSSettingCellModelWithTitle:(NSString *)title iconWithName:(NSString *)iconName destClass:(Class)destClass;

@end
