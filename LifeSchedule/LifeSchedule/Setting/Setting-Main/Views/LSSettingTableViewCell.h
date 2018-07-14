//
//  LSSettingTableViewCell.h
//  LifeSchedule
//
//  Created by 杨善成 on 17/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSSettingCellModel;

@interface LSSettingTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;


@property(nonatomic,strong)LSSettingCellModel *cellModel;

+(instancetype)getSettingCell;

@end
