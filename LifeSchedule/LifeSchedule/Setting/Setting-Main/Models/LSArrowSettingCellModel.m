//
//  LSArrowCellModel.m
//  LifeSchedule
//
//  Created by 杨善成 on 18/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "LSArrowSettingCellModel.h"

@implementation LSArrowSettingCellModel

+(instancetype)LSSettingCellModelWithTitle:(NSString *)title iconWithName:(NSString *)iconName destClass:(Class)destClass{
    LSArrowSettingCellModel *model = [super LSSettingCellModelWithTitle:title iconWithName:iconName];
    model.destClass = destClass;
    return model;
}

@end
