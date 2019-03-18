//
//  ConfigurationTimeSetCell.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/18.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "ConfigurationTimeSetCell.h"
#import "ConfigurationTimeSetModel.h"

@interface ConfigurationTimeSetCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeSetButton;
@property (weak, nonatomic) IBOutlet UILabel *timeSetValue;

@property (nonatomic,assign) TimeCategory timeCategory;

@end

@implementation ConfigurationTimeSetCell

- (IBAction)setTimeClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(timeSetClickedWithCategory:)]) {
        [self.delegate timeSetClickedWithCategory:self.timeCategory];
    }
}

+(instancetype)timeSetCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"ConfigurationTimeSetCell" owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.timeSetButton.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTimeSetModel:(ConfigurationTimeSetModel *)timeSetModel{
    _timeSetModel = timeSetModel;
    self.timeLabel.text = timeSetModel.configItemTitle;
    self.timeCategory = timeSetModel.timeCategory;
    self.timeSetValue.text = timeSetModel.configItemValue;
}

@end
