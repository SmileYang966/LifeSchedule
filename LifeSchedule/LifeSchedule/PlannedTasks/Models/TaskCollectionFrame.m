//
//  TaskCollectionFrame.m
//  LifeSchedule
//
//  Created by Evan Yang on 2018/7/31.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "TaskCollectionFrame.h"
#import "TaskCollectionModel.h"


@implementation TaskCollectionFrame

- (void)setTaskCollectionModel:(TaskCollectionModel *)taskCollectionModel{
    _taskCollectionModel = taskCollectionModel;
    
    //CheckBox
    CGFloat checkBoxX = COLLECTIONCELLMARGINX;
    CGFloat checkBoxY = COLLECTIONCELLMARGINY;
    CGFloat checkBoxWidth = 20;
    CGFloat checkBoxHeight = 20;
    self.checkBoxF = CGRectMake(checkBoxX, checkBoxY, checkBoxWidth, checkBoxHeight);
    
    //Title
    CGFloat collectionTitleX = CGRectGetMaxX(self.checkBoxF) + COLLECTIONCELLMARGINX;
    CGFloat collectionTitleY = self.checkBoxF.origin.y;
    CGSize titleLabelSize = [taskCollectionModel.taskTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:COLLECTIONCELLTITLELABELFONTOFSIZE]}];
    self.collectionTitleF = CGRectMake(collectionTitleX, collectionTitleY, titleLabelSize.width, titleLabelSize.height);
    
    //Detail info
    if (taskCollectionModel.taskDetailedInfo.length != 0) {
        CGFloat collectionDetailInfoX = self.collectionTitleF.origin.x;
        CGFloat collectionDetailInfoY = CGRectGetMaxY(self.collectionTitleF) + COLLECTIONCELLMINORMARGINY;
        CGSize detailInfoLabelSize = [taskCollectionModel.taskDetailedInfo sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:COLLECTIONCELLDETAILINFOLABELOFSIZE]}];
        self.collectionDetailedInfoF = CGRectMake(collectionDetailInfoX, collectionDetailInfoY, detailInfoLabelSize.width, detailInfoLabelSize.height);
    }
    
    //Row Height
    if (taskCollectionModel.taskDetailedInfo.length != 0) {
        self.collectionRowHegiht = CGRectGetMaxY(self.collectionDetailedInfoF) + COLLECTIONCELLMARGINY;
    }else{
        self.collectionRowHegiht = CGRectGetMaxY(self.collectionTitleF) + COLLECTIONCELLMARGINY;
    }
}

@end
