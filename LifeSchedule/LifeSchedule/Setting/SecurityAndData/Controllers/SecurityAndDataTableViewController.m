//
//  SecurityAndDataTableViewController.m
//  LifeSchedule
//
//  Created by 杨善成 on 26/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "SecurityAndDataTableViewController.h"
#import "LSSwitcherSettingCellModel.h"
#import "LSArrowSettingCellModel.h"
#import "LSSettingCellModel.h"
#import "LSSettingSectionModel.h"

#import "LSSettingPreferenceViewController.h"

@interface SecurityAndDataTableViewController ()
@property(nonatomic,strong)NSArray *securityAndDataList;
@end

@implementation SecurityAndDataTableViewController

- (NSArray *)securityAndDataList{
    if (_securityAndDataList == NULL) {
        //Group 0
        LSSettingSectionModel *group0 = [[LSSettingSectionModel alloc]init];
        LSSettingCellModel *unlockModel = [LSArrowSettingCellModel LSSettingCellModelWithTitle:@"密码、指纹解锁" iconWithName:@"MoreUpdate" destClass:[LSSettingPreferenceViewController class]];
        group0.sectionItems = @[unlockModel];
        
        //Group 1
        LSSettingSectionModel *group1 = [[LSSettingSectionModel alloc]init];
        LSSettingCellModel *calendarModel = [LSArrowSettingCellModel LSSettingCellModelWithTitle:@"订阅日历" iconWithName:@"MoreUpdate" destClass:[LSSettingPreferenceViewController class]];
        LSSettingCellModel *listTaskModel = [LSArrowSettingCellModel LSSettingCellModelWithTitle:@"导入奇妙清单任务" iconWithName:@"MoreUpdate" destClass:[LSSettingPreferenceViewController class]];
        group1.sectionItems = @[calendarModel,listTaskModel];
        
        _securityAndDataList = @[group0,group1];
    }
    return _securityAndDataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataList = self.securityAndDataList;
}

@end
