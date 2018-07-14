//
//  LSSettingTableViewCell.m
//  LifeSchedule
//
//  Created by 杨善成 on 17/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "LSSettingTableViewCell.h"
#import "LSSettingCellModel.h"

@implementation LSSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //设置cell选中的样式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellModel:(LSSettingCellModel *)cellModel{
    
    _cellModel = cellModel;
    
    self.imgView.image = [UIImage imageNamed:cellModel.iconName];
    self.cellTitle.text = cellModel.title;
}

+(instancetype)getSettingCell{
    return [[[NSBundle mainBundle]loadNibNamed:@"LSSettingTableViewCell" owner:self options:nil]lastObject];
}


@end
