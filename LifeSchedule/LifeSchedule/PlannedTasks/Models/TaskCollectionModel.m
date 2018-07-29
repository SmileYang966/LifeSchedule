//
//  TaskCollectionModel.m
//  LifeSchedule
//
//  Created by Evan Yang on 2018/7/29.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "TaskCollectionModel.h"

@implementation TaskCollectionModel

+(instancetype)createCollectionTaskModelWithTitle:(NSString *)taskTitle taskDetailInfo:(NSString *)detailInfo{
    TaskCollectionModel *taskModel = [[self alloc]init];
    taskModel.taskTitle = taskTitle;
    taskModel.taskDetailedInfo = detailInfo;
    return taskModel;
}

@end
