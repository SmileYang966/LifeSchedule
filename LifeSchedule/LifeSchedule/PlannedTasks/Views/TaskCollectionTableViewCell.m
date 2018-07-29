//
//  TaskCollectionTableViewCell.m
//  LifeSchedule
//
//  Created by Evan Yang on 2018/7/29.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "TaskCollectionTableViewCell.h"

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
        _contentLabel.text = @"晚上和同事们一起去健身房";
        _contentLabel.font = [UIFont systemFontOfSize:15.0f];
        _contentLabel.textColor = [UIColor blackColor];
        
        //Calucalated the string size by the provided the text
        CGSize size = [_contentLabel.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f]}];
        CGFloat contentLabelX = CGRectGetMaxX(self.taskcheckBoxSelected.frame) + 10;
        CGFloat contentLabelY = self.taskcheckBoxSelected.frame.origin.y;
        _contentLabel.frame = CGRectMake(contentLabelX, contentLabelY,size.width,size.height);
        [self.taskContentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UILabel *)additionalDetailInfo{
    if (_additionalDetailInfo == NULL) {
        _additionalDetailInfo = [[UILabel alloc]init];
        _additionalDetailInfo.text = @"今天，下午8:00";
        _additionalDetailInfo.font = [UIFont systemFontOfSize:12.0f];
        CGSize size = [_additionalDetailInfo.text sizeWithAttributes:@{NSFontAttributeName : _additionalDetailInfo.font}];
        CGFloat additionalDetailInfoX = self.contentLabel.frame.origin.x;
        CGFloat additionalDetailInfoY = CGRectGetMaxY(self.contentLabel.frame) + 5;
        _additionalDetailInfo.frame = CGRectMake(additionalDetailInfoX, additionalDetailInfoY, size.width, size.height);
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
