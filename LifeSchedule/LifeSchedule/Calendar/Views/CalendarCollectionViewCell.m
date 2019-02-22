//
//  CalendarCollectionViewCell.m
//  LifeSchedule
//
//  Created by Evan Yang on 2018/12/22.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "CalendarCollectionViewCell.h"


@interface CalendarCollectionViewCell()

@property(nonatomic,strong) UIView *rectangleView;
@property(nonatomic,strong) UILabel *dayLabel;
@property(nonatomic,strong) UILabel *holidayDescLabel;
@property(nonatomic,strong) UIImage *cellViewBg;

@property(nonatomic,strong) UILabel *breakLabel;
@property(nonatomic,strong) UILabel *onDutyLabel;

@end

@implementation CalendarCollectionViewCell

/* 1.Generate all the elements which the cell used */
- (UIView *)rectangleView{
    if (_rectangleView == NULL) {
        _rectangleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//        _rectangleView.backgroundColor = UIColor.blueColor;
    }
    return _rectangleView;
}

- (UILabel *)dayLabel{
    if (_dayLabel == NULL) {
        _dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _dayLabel.layer.cornerRadius = 25.0f;
        _dayLabel.numberOfLines = 0;
        [self.rectangleView addSubview:_dayLabel];
    }
    return _dayLabel;
}

- (UILabel *)holidayDescLabel{
    if (_holidayDescLabel == NULL) {
        CGFloat maxY = CGRectGetMaxY(self.dayLabel.frame);
        _holidayDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 38, self.rectangleView.bounds.size.width, 10.0f)];
        _holidayDescLabel.font = [UIFont boldSystemFontOfSize:8.0f];
        _holidayDescLabel.textAlignment = NSTextAlignmentCenter;
        _holidayDescLabel.textColor = [UIColor colorWithRed:54/255.0 green:211/255.0 blue:160/255.0 alpha:1.0];
        [self.rectangleView addSubview:_holidayDescLabel];
    }
    return _holidayDescLabel;
}

- (UILabel *)breakLabel{
    if (_breakLabel == NULL) {
        _breakLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 14, 14)];
        _breakLabel.text = @"休";
        _breakLabel.textColor = UIColor.whiteColor;
        _breakLabel.backgroundColor = [UIColor colorWithRed:35/255.0 green:204/255.0 blue:146/255.0 alpha:1.0];
        _breakLabel.textAlignment = NSTextAlignmentCenter;
        _breakLabel.layer.cornerRadius  = 7.0f;
        _breakLabel.layer.masksToBounds = true;
        _breakLabel.adjustsFontSizeToFitWidth = true;
        _breakLabel.font = [UIFont boldSystemFontOfSize:8.0f];
        [self.rectangleView addSubview:_breakLabel];
    }
    return _breakLabel;
}

- (UILabel *)onDutyLabel{
    if (_onDutyLabel == NULL) {
        _onDutyLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 14, 14)];
        _onDutyLabel.text = @"班";
        _onDutyLabel.textColor = UIColor.whiteColor;
        _onDutyLabel.backgroundColor = [UIColor colorWithRed:253/255.0 green:54/255.0 blue:129/255.0 alpha:1.0];
        _onDutyLabel.textAlignment = NSTextAlignmentCenter;
        _onDutyLabel.layer.cornerRadius  = 7.0f;
        _onDutyLabel.layer.masksToBounds = true;
        _onDutyLabel.adjustsFontSizeToFitWidth = true;
        _onDutyLabel.font = [UIFont boldSystemFontOfSize:8.0f];
        [self.rectangleView addSubview:_onDutyLabel];
    }
    return _onDutyLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.rectangleView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDayNo:(NSInteger)dayNo{
    _dayNo = dayNo;
    
    if (dayNo == 0) return;
    self.dayLabel.numberOfLines = 0;
    
    NSString *dayNoStr = [NSString stringWithFormat:@"%ld",dayNo];
    self.dayLabel.textColor = [UIColor blackColor];
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.dayLabel.textColor = UIColor.blackColor;
    self.dayLabel.text = dayNoStr;
}

- (void)setHolidayDesc:(NSString *)holidayDesc{
    _holidayDesc = holidayDesc;
    self.holidayDescLabel.text = holidayDesc;
}

- (void)setHiddenSelectedView:(bool)hiddenSelectedView{
    if (hiddenSelectedView) {
        self.dayLabel.layer.backgroundColor = UIColor.clearColor.CGColor;
        self.dayLabel.textColor = UIColor.blackColor;
    }else{
        self.dayLabel.layer.backgroundColor = UIColor.blackColor.CGColor;
        self.dayLabel.textColor = UIColor.whiteColor;
    }
}

- (void)setIsInactiveStatus:(bool)isInactiveStatus{
    if (isInactiveStatus) {
        self.dayLabel.textColor = UIColor.lightGrayColor;
        self.dayLabel.alpha = 0.3f;
    }
}

-(void)clearTextsOncell{
    self.holidayDescLabel.text = @"";
    self.dayLabel.text = @"";
    self.dayLabel.alpha = 1.0f;
    self.dayLabel.textColor = UIColor.blackColor;
}

@end
