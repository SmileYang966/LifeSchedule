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
    CGFloat checkBoxY = COLLECTIONCELLMARGINY-5.0f;
    CGFloat checkBoxWidth = 48;
    CGFloat checkBoxHeight = 48;
    self.checkBoxF = CGRectMake(checkBoxX, checkBoxY, checkBoxWidth, checkBoxHeight);
    
    //Title
    CGFloat collectionTitleX = CGRectGetMaxX(self.checkBoxF) + COLLECTIONCELLMARGINX;
    CGFloat collectionTitleY = COLLECTIONCELLMARGINY;
    NSString *contentStr = taskCollectionModel.taskTitle;
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    CGSize titleLabelSize = [contentStr sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:COLLECTIONCELLTITLELABELFONTOFSIZE]}];
    CGFloat collectionTitleWidth = UIScreen.mainScreen.bounds.size.width - CGRectGetMaxX(self.checkBoxF) - COLLECTIONCELLMARGINX-5.0f;
    self.collectionTitleF = CGRectMake(collectionTitleX, collectionTitleY, collectionTitleWidth, titleLabelSize.height);
    
    //Detail info
    if (taskCollectionModel.taskStartedDate != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateStr = [dateFormatter stringFromDate:taskCollectionModel.taskStartedDate];
                
        if (dateStr.length != 0) {
            CGFloat collectionDetailInfoX = self.collectionTitleF.origin.x;
            CGFloat collectionDetailInfoY = CGRectGetMaxY(self.collectionTitleF) + COLLECTIONCELLMINORMARGINY;
            CGSize detailInfoLabelSize = [dateStr sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:COLLECTIONCELLDETAILINFOLABELOFSIZE]}];
            self.collectionDetailedInfoF = CGRectMake(collectionDetailInfoX, collectionDetailInfoY, 125.0f, detailInfoLabelSize.height);
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
