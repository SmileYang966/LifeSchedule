//
//  TaskCollectionTableViewCell.m
//  LifeSchedule
//
//  Created by Evan Yang on 2018/7/29.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "TaskCollectionTableViewCell.h"
#import "TaskCollectionModel.h"

#define TASKROWHEIGHT 60

@interface TaskCollectionTableViewCell()
@property(nonatomic,strong) UIView *taskContentView;

@property(nonatomic,strong) UIButton *taskcheckBoxSelected;
@property(nonatomic,strong) UILabel *contentLabel;

/*Some additonal info like the task's planned time,and some icons*/
@property(nonatomic,strong) UILabel *additionalDetailInfo;
@end


@implementation TaskCollectionTableViewCell


#pragma mark-Lazy loading
- (UIView *)taskContentView{
    if (_taskContentView == NULL) {
        _taskContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 8, self.bounds.size.width, 44)];
        [self.contentView addSubview:_taskContentView];
    }
    return _taskContentView;
}

- (UIButton *)taskcheckBoxSelected{
    if (_taskcheckBoxSelected == NULL) {
        _taskcheckBoxSelected = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_taskcheckBoxSelected setBackgroundImage:[UIImage imageNamed:@"checkboxNonSelected"] forState:UIControlStateNormal];
        CGFloat centerX = 30;
        CGFloat centerY = self.taskContentView.bounds.size.height*0.5;
        _taskcheckBoxSelected.center = CGPointMake(centerX, centerY);
        [self.taskContentView addSubview:_taskcheckBoxSelected];
    }
    return _taskcheckBoxSelected;
}

- (UILabel *)contentLabel{
    if (_contentLabel == NULL) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:15.0f];
        _contentLabel.textColor = [UIColor blackColor];
        [self.taskContentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UILabel *)additionalDetailInfo{
    if (_additionalDetailInfo == NULL) {
        _additionalDetailInfo = [[UILabel alloc]init];
        _additionalDetailInfo.font = [UIFont systemFontOfSize:12.0f];
        _additionalDetailInfo.textColor = [UIColor redColor];
        [self.taskContentView addSubview:_additionalDetailInfo];
    }
    return _additionalDetailInfo;
}

#pragma mark-Initalization
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initalization
        self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60.0f);
        [self taskcheckBoxSelected];
        [self contentLabel];
        [self additionalDetailInfo];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSLog(@"self.frame=%@,self.bounds =%@",NSStringFromCGRect(self.frame),NSStringFromCGRect(self.bounds));
    }
    return self;
}


#pragma mark Set Method
- (void)setTaskCollectionModel:(TaskCollectionModel *)taskCollectionModel{
    _taskCollectionModel = taskCollectionModel;
    
    //Fetch the value from Model and assign to the views
    
    //Calcualted the content label frame
    self.contentLabel.text = taskCollectionModel.taskTitle;
    CGSize contentLabelSize = [self.contentLabel.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f]}];
    CGFloat contentLabelX = CGRectGetMaxX(self.taskcheckBoxSelected.frame) + 10;
    CGFloat contentLabelY = self.taskcheckBoxSelected.frame.origin.y;
    self.contentLabel.frame = CGRectMake(contentLabelX, contentLabelY,contentLabelSize.width,contentLabelSize.height);
    
    taskCollectionModel.taskCellRowHeigth = TASKROWHEIGHT;
    
    //Calculated the detailInfo label frame
    if (taskCollectionModel.taskDetailedInfo.length!=0) {
        self.additionalDetailInfo.text = taskCollectionModel.taskDetailedInfo;
        CGSize detailTextSize = [self.additionalDetailInfo.text sizeWithAttributes:@{NSFontAttributeName : _additionalDetailInfo.font}];
        CGFloat additionalDetailInfoX = self.contentLabel.frame.origin.x;
        CGFloat additionalDetailInfoY = CGRectGetMaxY(self.contentLabel.frame) + 5;
        self.additionalDetailInfo.frame = CGRectMake(additionalDetailInfoX, additionalDetailInfoY, detailTextSize.width, detailTextSize.height);
        taskCollectionModel.taskCellRowHeigth = TASKROWHEIGHT + self.additionalDetailInfo.bounds.size.height;
    }
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
