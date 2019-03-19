//
//  Setting+CoreDataProperties.m
//  
//
//  Created by Evan Yang on 2019/3/19.
//
//

#import "Setting+CoreDataProperties.h"

@implementation Setting (CoreDataProperties)

+ (NSFetchRequest<Setting *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Setting"];
}

@dynamic settingValue;
@dynamic settingKeyName;

@end
