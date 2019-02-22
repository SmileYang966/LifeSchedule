//
//  CalendarCollectionViewCell.h
//  LifeSchedule
//
//  Created by Evan Yang on 2018/12/22.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalendarCollectionViewCell : UICollectionViewCell
@property(nonatomic,assign) NSInteger dayNo;
@property(nonatomic,assign) bool hiddenSelectedView;
@property(nonatomic,copy) NSString *holidayDesc;
@property(nonatomic,assign) bool isInactiveStatus;

-(void)clearTextsOncell;
@end

NS_ASSUME_NONNULL_END
