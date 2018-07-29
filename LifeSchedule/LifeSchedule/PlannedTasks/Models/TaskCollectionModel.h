//
//  TaskCollectionModel.h
//  LifeSchedule
//
//  Created by Evan Yang on 2018/7/29.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskCollectionModel : NSObject

@property(nonatomic,copy) NSString *taskTitle;
@property(nonatomic,copy) NSString *taskDetailedInfo;

+(instancetype)createCollectionTaskModelWithTitle:(NSString *)taskTitle taskDetailInfo:(NSString *)detailInfo;

/*RowHeight*/
@property(nonatomic,assign)float  taskCellRowHeigth;


@end
