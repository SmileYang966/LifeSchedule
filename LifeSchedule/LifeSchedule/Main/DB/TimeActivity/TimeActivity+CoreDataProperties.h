//
//  TimeActivity+CoreDataProperties.h
//  LifeSchedule
//
//  Created by Evan Yang on 2019/1/7.
//  Copyright © 2019 EvanYang. All rights reserved.
//
//

#import "TimeActivity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TimeActivity (CoreDataProperties)

+ (NSFetchRequest<TimeActivity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *plannedBeginDate;
@property (nullable, nonatomic, copy) NSString *activityDescription;
@property (nonatomic) BOOL isActivityCompleted;

@end

NS_ASSUME_NONNULL_END
