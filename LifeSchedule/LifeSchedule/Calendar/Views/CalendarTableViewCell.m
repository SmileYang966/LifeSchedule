//
//  CalendarTableViewCell.m
//  LifeSchedule
//
//  Created by Evan Yang on 2018/12/25.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "CalendarTableViewCell.h"

@interface CalendarTableViewCell()

@property(nonatomic,strong) UIButton *selectedButton;
@property(nonatomic,strong) UILabel *titleDescriptionLabel;
@property(nonatomic,strong) UILabel *detailDescriptionLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *inboxLabel;

@property(nonatomic,assign) CGFloat marginX;
@property(nonatomic,assign) CGFloat marginY;

@end

@implementation CalendarTableViewCell

- (UIButton *)selectedButton{
    if (_selectedButton == NULL) {
        _selectedButton = [[UIButton alloc]init];
        [_selectedButton setBackgroundImage:[UIImage imageNamed:@"checkboxNonSelected"] forState:UIControlStateNormal];
        [self addSubview:_selectedButton];
    }
    return _selectedButton;
}

- (UILabel *)titleDescriptionLabel{
    if (_titleDescriptionLabel == NULL) {
        _titleDescriptionLabel = [[UILabel alloc]init];
        _titleDescriptionLabel.text = @"健身1个半小时";
        _titleDescriptionLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:_titleDescriptionLabel];
    }
    return _titleDescriptionLabel;
}

- (UILabel *)detailDescriptionLabel{
    if (_detailDescriptionLabel == NULL) {
        _detailDescriptionLabel = [[UILabel alloc]init];
        [self addSubview:_detailDescriptionLabel];
    }
    return _detailDescriptionLabel;
}

- (UILabel *)timeLabel{
    if (_timeLabel == NULL) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text=@"今天";
        _timeLabel.textColor = UIColor.grayColor;
        _timeLabel.font = [UIFont systemFontOfSize:11.0f];
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)inboxLabel{
    if (_inboxLabel == NULL) {
        _inboxLabel = [[UILabel alloc]init];
        _inboxLabel.text = @"收集箱";
        _inboxLabel.textColor = UIColor.grayColor;
        _inboxLabel.font = [UIFont systemFontOfSize:11.0f];
        [self addSubview:_inboxLabel];
    }
    return _inboxLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.marginX = 20.0f;
        self.marginY = 10.0f;
        [self selectedButton];
        [self titleDescriptionLabel];
        [self detailDescriptionLabel];
        [self timeLabel];
        [self inboxLabel];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    /* 1. The position of the selected button */
    CGFloat selectedBtnX = 20.0f;
    CGFloat selectedBtnY = 20.0f;
    CGFloat selectedBtnWidth = 20.0f;
    CGFloat selectedBtnHeight = 20.0f;
    self.selectedButton.frame = CGRectMake(selectedBtnX, selectedBtnY, selectedBtnWidth, selectedBtnHeight);
    
    /*2. The position of the titleDescription label */
    CGFloat titleDescLabelX = CGRectGetMaxX(self.selectedButton.frame) + self.marginX;
    CGFloat titleDescLabelY = self.selectedButton.frame.origin.y;
    CGFloat titleDescLabelWidth = self.frame.size.width - titleDescLabelX;
    CGFloat titleDescLabelHeight = self.selectedButton.frame.size.height;
    self.titleDescriptionLabel.frame = CGRectMake(titleDescLabelX, titleDescLabelY, titleDescLabelWidth, titleDescLabelHeight);
    
    /*3. The position of the time label */
    CGFloat timeLabelX = self.titleDescriptionLabel.frame.origin.x;
    CGFloat timeLabelY = CGRectGetMaxY(self.titleDescriptionLabel.frame) + self.marginY;
    CGFloat timeLabelWidth = 100.0f;
    CGFloat timeLabelHeight = 15.0f;
    self.timeLabel.frame = CGRectMake(timeLabelX, timeLabelY, timeLabelWidth, timeLabelHeight);
    
    /*4. The position of the inbox label */
    CGFloat inboxLabelWidth = 40.0f;
    CGFloat inboxLabelHeight = 15.0f;
    CGFloat inboxLabelX = self.bounds.size.width - self.marginX - inboxLabelWidth;
    CGFloat inboxLabelY = self.timeLabel.frame.origin.y;
    self.inboxLabel.frame = CGRectMake(inboxLabelX, inboxLabelY, inboxLabelWidth, inboxLabelHeight);
}


@end
