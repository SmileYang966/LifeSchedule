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
@end


@implementation TaskCollectionTableViewCell


#pragma mark-Lazy loading

- (UIButton *)taskcheckBoxSelected{
    if (_taskcheckBoxSelected == NULL) {
        _taskcheckBoxSelected = [[UIButton alloc]initWithFrame:CGRectMake(0,0,32,32)];
        [self addSubview:_taskcheckBoxSelected];
    }
    return _taskcheckBoxSelected;
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

-(void)setTaskCollectionFrame:(TaskCollectionFrame *)taskCollectionFrame{
    _taskCollectionFrame = taskCollectionFrame;
    TaskCollectionModel *model = taskCollectionFrame.taskCollectionModel;
    
    if (model.isCompleted) {
        //Completed
        [_taskcheckBoxSelected setBackgroundImage:[UIImage imageNamed:@"checkboxSelected"] forState:UIControlStateNormal];
    }else {
        //Not completed
        [_taskcheckBoxSelected setBackgroundImage:[UIImage imageNamed:@"checkboxNonSelected"] forState:UIControlStateNormal];
    }
    
    //CheckBox
    self.taskcheckBoxSelected.frame = taskCollectionFrame.checkBoxF;
    
    //ContentLabel
    self.contentLabel.frame = taskCollectionFrame.collectionTitleF;
    self.contentLabel.text = model.taskTitle;
    
    //detailed info
    self.additionalDetailInfo.frame = taskCollectionFrame.collectionDetailedInfoF;
    self.additionalDetailInfo.text = model.taskDetailedInfo;
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
