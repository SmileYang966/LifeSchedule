//
//  TaskCollectionGroupModel.h
//  LifeSchedule
//
//  Created by Evan Yang on 2018/7/29.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskCollectionGroupModel : NSObject

@property(nonatomic,copy)NSString *groupHeaderTitle;
@property(nonatomic,strong) NSArray *TaskCollectionItems;
@property(nonatomic,copy)NSString *groupFooterTitle;

@end
