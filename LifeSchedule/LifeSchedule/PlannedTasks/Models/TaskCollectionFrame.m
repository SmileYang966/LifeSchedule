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
    CGFloat checkBoxWidth = 25;
    CGFloat checkBoxHeight = 25;
    self.checkBoxF = CGRectMake(checkBoxX, checkBoxY, checkBoxWidth, checkBoxHeight);
    
    //Title
    CGFloat collectionTitleX = CGRectGetMaxX(self.checkBoxF) + COLLECTIONCELLMARGINX;
    CGFloat collectionTitleY = self.checkBoxF.origin.y;
    CGSize titleLabelSize = [taskCollectionModel.taskTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:COLLECTIONCELLTITLELABELFONTOFSIZE]}];
    CGFloat collectionTitleWidth = UIScreen.mainScreen.bounds.size.width - CGRectGetMaxX(self.checkBoxF) - COLLECTIONCELLMARGINX-5.0f;
    self.collectionTitleF = CGRectMake(collectionTitleX, collectionTitleY, collectionTitleWidth, titleLabelSize.height);
    
    //Detail info
    if (taskCollectionModel.taskStartedDate != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [dateFormatter stringFromDate:taskCollectionModel.taskStartedDate];
        if (dateStr.length != 0) {
            CGFloat collectionDetailInfoX = self.collectionTitleF.origin.x;
            CGFloat collectionDetailInfoY = CGRectGetMaxY(self.collectionTitleF) + COLLECTIONCELLMINORMARGINY;
            CGSize detailInfoLabelSize = [dateStr sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:COLLECTIONCELLDETAILINFOLABELOFSIZE]}];
            self.collectionDetailedInfoF = CGRectMake(collectionDetailInfoX, collectionDetailInfoY, detailInfoLabelSize.width, detailInfoLabelSize.height);
        }
        
        //Row Height
        if (dateStr.length != 0) {
            self.collectionRowHegiht = CGRectGetMaxY(self.collectionDetailedInfoF) + COLLECTIONCELLMARGINY;
        }else{
            self.collectionRowHegiht = CGRectGetMaxY(self.collectionTitleF) + COLLECTIONCELLMARGINY;
        }
    }
}

@end
