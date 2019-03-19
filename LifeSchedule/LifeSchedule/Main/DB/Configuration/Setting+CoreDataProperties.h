//
//  Setting+CoreDataProperties.h
//  
//
//  Created by Evan Yang on 2019/3/19.
//
//

#import "Setting+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Setting (CoreDataProperties)

+ (NSFetchRequest<Setting *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *settingValue;
@property (nullable, nonatomic, copy) NSString *settingKeyName;

@end

NS_ASSUME_NONNULL_END
