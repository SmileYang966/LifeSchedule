//
//  TaskCollectionFrame.m
//  LifeSchedule
//
//  Created by Evan Yang on 2018/7/31.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "TaskCollectionFrame.h"
#import "TaskCollectionModel.h"

#define collectionMarginX 10
#define collectionMarginY 12
#define collectionMinorMarginY 6

@implementation TaskCollectionFrame

- (void)setTaskCollectionModel:(TaskCollectionModel *)taskCollectionModel{
    _taskCollectionModel = taskCollectionModel;
    
    //CheckBox
    CGFloat checkBoxX = 10;
    CGFloat checkBoxY = collectionMarginY;
    CGFloat checkBoxWidth = 12;
    CGFloat checkBoxHeight = 12;
    self.checkBoxF = CGRectMake(checkBoxX, checkBoxY, checkBoxWidth, checkBoxHeight);
    
    //Title
    CGFloat collectionTitleX = CGRectGetMaxX(self.checkBoxF) + collectionMarginX;
    CGFloat collectionTitleY = self.checkBoxF.origin.y;
    CGSize titleLabelSize = [taskCollectionModel.taskTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f]}];
    self.collectionTitleF = CGRectMake(collectionTitleX, collectionTitleY, titleLabelSize.width, titleLabelSize.height);
    
    //Detail info
    if (taskCollectionModel.taskDetailedInfo.length != 0) {
        CGFloat collectionDetailInfoX = self.collectionTitleF.origin.x;
        CGFloat collectionDetailInfoY = CGRectGetMaxY(self.collectionTitleF) + collectionMinorMarginY;
        CGSize detailInfoLabelSize = [taskCollectionModel.taskDetailedInfo sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.0f]}];
        self.collectionDetailedInfoF = CGRectMake(collectionDetailInfoX, collectionDetailInfoY, detailInfoLabelSize.width, detailInfoLabelSize.height);
    }
    
    //Row Height
    if (taskCollectionModel.taskDetailedInfo.length != 0) {
        self.collectionRowHegiht = CGRectGetMaxY(self.collectionDetailedInfoF) + collectionMarginY;
    }else{
        self.collectionRowHegiht = CGRectGetMaxY(self.collectionTitleF) + collectionMarginY;
    }
}

@end
