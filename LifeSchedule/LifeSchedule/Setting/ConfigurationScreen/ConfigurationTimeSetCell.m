//
//  ConfigurationTimeSetCell.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/18.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "ConfigurationTimeSetCell.h"

@interface ConfigurationTimeSetCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeSetButton;
@property (nonatomic,assign) TimeCategory timeCategory;

@end

@implementation ConfigurationTimeSetCell

- (IBAction)setTimeClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(timeSetClickedWithCategory:)]) {
        [self.delegate timeSetClickedWithCategory:self.timeCategory];
    }
}

+(instancetype)timeSetCellWithTitle:(NSString *)title timeCategory:(TimeCategory)category{
    ConfigurationTimeSetCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ConfigurationTimeSetCell" owner:self options:nil] lastObject];
    cell.timeLabel.text = title;
    cell.timeCategory = category;
    return cell;
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

@end
