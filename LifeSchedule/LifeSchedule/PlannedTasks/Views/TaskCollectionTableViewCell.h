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

-(void)taskCollectionTableViewCell:(TaskCollectionTableViewCell *)cell selectedIndex:(NSIndexPath *)cellIndex;

@end

@interface TaskCollectionTableViewCell : UITableViewCell
@property(nonatomic,strong) TaskCollectionModel *taskCollectionModel;
@property(nonatomic,strong) TaskCollectionFrame *taskCollectionFrame;
@property(nonatomic,weak) id<TaskCollectionTableViewCellDelegate> delegate;

/*Just a workaround , there should be a better way to design this*/
@property(nonatomic,strong) NSIndexPath *cellIndex;

@end
