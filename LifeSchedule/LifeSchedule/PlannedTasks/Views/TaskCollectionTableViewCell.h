//
//  TaskCollectionTableViewCell.h
//  LifeSchedule
//
//  Created by Evan Yang on 2018/7/29.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskCollectionModel;
@class TaskCollectionFrame;

@class TaskCollectionTableViewCell;

@protocol TaskCollectionTableViewCellDelegate<NSObject>

-(void)taskCollectionTableViewCellSelected;

@end

@interface TaskCollectionTableViewCell : UITableViewCell
@property(nonatomic,strong) TaskCollectionModel *taskCollectionModel;
@property(nonatomic,strong) TaskCollectionFrame *taskCollectionFrame;
@property(nonatomic,weak) id<TaskCollectionTableViewCellDelegate> delegate;

@end
