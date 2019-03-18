//
//  ConfigurationTimeSetModel.h
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/18.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfigurationTimeSetModel : NSObject

@property(nonatomic,copy)NSString *configItemTitle;
@property(nonatomic,copy)NSString *configItemValue;
@property(nonatomic,assign)TimeCategory timeCategory;

+(instancetype)CreateConfigurationTimeSetModelWithTitle:(NSString *)configItemTitle matchedValue:(NSString *)configItemValue category:(TimeCategory) timeCategory;
@end

NS_ASSUME_NONNULL_END
