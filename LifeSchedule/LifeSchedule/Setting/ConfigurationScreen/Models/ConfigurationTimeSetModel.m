//
//  ConfigurationTimeSetModel.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/18.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "ConfigurationTimeSetModel.h"

@interface  ConfigurationTimeSetModel()

@end

@implementation ConfigurationTimeSetModel

+(instancetype)CreateConfigurationTimeSetModelWithTitle:(NSString *)configItemTitle matchedValue:(NSString *)configItemValue category:(TimeCategory) timeCategory{
    ConfigurationTimeSetModel *timeSetModel = [[ConfigurationTimeSetModel alloc]init];
    timeSetModel.configItemTitle = configItemTitle;
    timeSetModel.configItemValue = configItemValue;
    timeSetModel.timeCategory = timeCategory;
    return timeSetModel;
}

@end
