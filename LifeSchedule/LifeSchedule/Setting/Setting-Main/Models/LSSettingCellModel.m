//
//  LSSettingCellModel.m
//  LifeSchedule
//
//  Created by 杨善成 on 17/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "LSSettingCellModel.h"

@implementation LSSettingCellModel

+(instancetype)LSSettingCellModelWithTitle:(NSString *)title iconWithName:(NSString *)iconName{
    LSSettingCellModel *cellModel = [[self alloc]init];
    cellModel.title = title;
    cellModel.iconName = iconName;
    return cellModel;
}

@end
