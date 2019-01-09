//
//  TimeActivity+CoreDataProperties.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/1/7.
//  Copyright © 2019 EvanYang. All rights reserved.
//
//

#import "TimeActivity+CoreDataProperties.h"

@implementation TimeActivity (CoreDataProperties)

+ (NSFetchRequest<TimeActivity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"TimeActivity"];
}

@dynamic plannedBeginDate;
@dynamic activityDescription;
@dynamic isActivityCompleted;

@end
