//
//  TaskCollectionTableViewCell.h
//  LifeSchedule
//
//  Created by Evan Yang on 2018/7/29.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskCollectionModel;
@interface TaskCollectionTableViewCell : UITableViewCell

@property(nonatomic,strong) TaskCollectionModel *taskCollectionModel;

@end
