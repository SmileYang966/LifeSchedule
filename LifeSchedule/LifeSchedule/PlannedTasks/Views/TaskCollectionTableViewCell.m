//
//  TaskCollectionTableViewCell.m
//  LifeSchedule
//
//  Created by Evan Yang on 2018/7/29.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "TaskCollectionTableViewCell.h"
#import "TaskCollectionModel.h"
#import "TaskCollectionFrame.h"

@interface TaskCollectionTableViewCell()

@property(nonatomic,strong) UIButton *taskcheckBoxSelected;
@property(nonatomic,strong) UILabel *contentLabel;

/*Some additonal info like the task's planned time,and some icons*/
@property(nonatomic,strong) UILabel *additionalDetailInfo;

/*Show the info of '星期几'*/
@property(nonatomic,strong) UILabel *workDayDesc;
@end


@implementation TaskCollectionTableViewCell


#pragma mark-Lazy loading

- (UIButton *)taskcheckBoxSelected{
    if (_taskcheckBoxSelected == NULL) {
        _taskcheckBoxSelected = [[UIButton alloc]initWithFrame:CGRectMake(0,0,32,32)];
        [_taskcheckBoxSelected addTarget:self action:@selector(taskcheckBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_taskcheckBoxSelected];
    }
    return _taskcheckBoxSelected;
}

- (void)taskcheckBoxClicked:(UIButton *)taskcheckBoxButton{
    if ([self.delegate respondsToSelector:@selector(taskCollectionTableViewCell:selectedIndex:)]) {
        [self.delegate taskCollectionTableViewCell:self selectedIndex:self.cellIndex];
    }
}

- (UILabel *)contentLabel{
    if (_contentLabel == NULL) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:COLLECTIONCELLTITLELABELFONTOFSIZE];
        _contentLabel.textColor = [UIColor blackColor];
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UILabel *)additionalDetailInfo{
    if (_additionalDetailInfo == NULL) {
        _additionalDetailInfo = [[UILabel alloc]init];
        _additionalDetailInfo.font = [UIFont systemFontOfSize:COLLECTIONCELLDETAILINFOLABELOFSIZE];
        _additionalDetailInfo.textColor = [UIColor redColor];
        [self addSubview:_additionalDetailInfo];
    }
    return _additionalDetailInfo;
}

- (UILabel *)workDayDesc{
    if (_workDayDesc == NULL) {
        _workDayDesc = [[UILabel alloc]init];
        _workDayDesc.font = [UIFont systemFontOfSize:COLLECTIONCELLDETAILINFOLABELOFSIZE];
        _workDayDesc.textColor = [UIColor redColor];
        [self addSubview:_workDayDesc];
    }
    return _workDayDesc;
}

#pragma mark-Initalization
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initalization
        self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60.0f);
        [self taskcheckBoxSelected];
        [self contentLabel];
        [self additionalDetailInfo];
        [self workDayDesc];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSLog(@"self.frame=%@,self.bounds =%@",NSStringFromCGRect(self.frame),NSStringFromCGRect(self.bounds));
    }
    return self;
}


#pragma mark Set Method

-(void)setTaskCollectionFrame:(TaskCollectionFrame *)taskCollectionFrame{
    _taskCollectionFrame = taskCollectionFrame;
    TaskCollectionModel *model = taskCollectionFrame.taskCollectionModel;
    
    if (model.isCompleted) {
        //Completed
        [_taskcheckBoxSelected setImage:[UIImage imageNamed:@"check-box-lightGray-selected"] forState:UIControlStateNormal];
    }else {
        //Not completed
        [_taskcheckBoxSelected setImage:[UIImage imageNamed:@"check-box-lightGray-unselected"] forState:UIControlStateNormal];
    }
    
    //CheckBox
    self.taskcheckBoxSelected.frame = taskCollectionFrame.checkBoxF;
//    self.taskcheckBoxSelected.backgroundColor = UIColor.redColor;
    
    //ContentLabel
    self.contentLabel.frame = taskCollectionFrame.collectionTitleF;
    
    NSString *contentStr = model.taskTitle;
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    self.contentLabel.text = contentStr;
    
    //detailed info
    self.additionalDetailInfo.frame = taskCollectionFrame.collectionDetailedInfoF;
    
    /*Convert the date to the string*/
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:model.taskStartedDate];
    self.additionalDetailInfo.text = dateStr;
    
    /* Work day description */
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:model.taskStartedDate];
    NSInteger index = [comps weekday];
    NSString *dayDesc = WeekDayStringArray[index-1];
    self.workDayDesc.frame = CGRectMake(CGRectGetMaxX(self.additionalDetailInfo.frame) + 2.0f, self.additionalDetailInfo.frame.origin.y, 50.0f, self.additionalDetailInfo.frame.size.height);
    self.workDayDesc.text = dayDesc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
