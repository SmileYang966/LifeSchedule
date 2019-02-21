//
//  TaskCollectionModel.m
//  LifeSchedule
//
//  Created by Evan Yang on 2018/7/29.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "TaskCollectionModel.h"

@implementation TaskCollectionModel

+(instancetype)createCollectionTaskModelWithTitle:(NSString *)taskTitle taskStartedDate:(NSDate *)startedDate{
    TaskCollectionModel *taskModel = [[self alloc]init];
    taskModel.taskTitle = taskTitle;
    taskModel.taskStartedDate = startedDate;
    return taskModel;
}

@end
