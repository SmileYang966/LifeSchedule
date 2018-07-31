//
//  TaskCollectionFrame.h
//  LifeSchedule
//
//  Created by Evan Yang on 2018/7/31.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TaskCollectionModel;
@interface TaskCollectionFrame : NSObject

@property(nonatomic,strong) TaskCollectionModel *taskCollectionModel;

/**CheckBox*/
@property(nonatomic,assign) CGRect checkBoxF;

/**Collection title*/
@property(nonatomic,assign) CGRect collectionTitleF;

/**Collection detailed info*/
@property(nonatomic,assign) CGRect collectionDetailedInfoF;

/**Row Hegiht*/
@property(nonatomic,assign) CGFloat collectionRowHegiht;

@end
