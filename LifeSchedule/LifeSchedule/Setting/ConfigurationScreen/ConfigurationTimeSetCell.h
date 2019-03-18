//
//  ConfigurationTimeSetCell.h
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/18.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConfigurationTimeSetModel;

NS_ASSUME_NONNULL_BEGIN

@protocol ConfigurationTimeSetCellDelegate <NSObject>

@required
-(void)timeSetClickedWithCategory:(TimeCategory)category;

@end


@interface ConfigurationTimeSetCell : UITableViewCell

@property(nonatomic,strong)ConfigurationTimeSetModel *timeSetModel;

+(instancetype)timeSetCell;
@property(nonatomic,weak) id<ConfigurationTimeSetCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
