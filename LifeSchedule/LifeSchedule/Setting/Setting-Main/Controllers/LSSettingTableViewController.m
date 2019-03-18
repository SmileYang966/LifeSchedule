//
//  LSSettingTableViewController.m
//  LifeSchedule
//
//  Created by 杨善成 on 26/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "LSSettingTableViewController.h"
#import "LSSettingSectionModel.h"
#import "LSArrowSettingCellModel.h"
#import "LSSwitcherSettingCellModel.h"
#import "LSSettingPreferenceViewController.h"
#import "SecurityAndDataTableViewController.h"
#import "AboutUsScreenViewController.h"
#import "FeedbackViewController.h"
#import "ConfigurationViewController.h"

@interface LSSettingTableViewController ()

@property(nonatomic,strong)NSArray *settingItemsList;

@end

@implementation LSSettingTableViewController


- (NSArray *)settingItemsList{
    if (_settingItemsList == NULL) {
        //section 0
        LSSettingSectionModel *section0 = [[LSSettingSectionModel alloc]init];
        LSSettingCellModel *themesModel = [LSArrowSettingCellModel LSSettingCellModelWithTitle:@"配置" iconWithName:@"IDInfo" destClass:[ConfigurationViewController class]];
        LSSettingCellModel *advancedOptionsModel = [LSArrowSettingCellModel LSSettingCellModelWithTitle:@"高级选项" iconWithName:@"MoreUpdate" destClass:[LSSettingPreferenceViewController class]];
        NSArray *group0 =  @[themesModel,advancedOptionsModel];
        section0.sectionItems = group0;
        
        //section 2
        LSSettingSectionModel *section2 = [[LSSettingSectionModel alloc]init];
        LSSettingCellModel *helpCenterModel = [LSArrowSettingCellModel LSSettingCellModelWithTitle:@"帮助中心" iconWithName:@"MoreHelp" destClass:[LSSettingPreferenceViewController class]];
        LSSettingCellModel *feedbackAndAdviceModel = [LSArrowSettingCellModel LSSettingCellModelWithTitle:@"反馈与建议" iconWithName:@"sound_Effect" destClass:[FeedbackViewController class]];
        LSSettingCellModel *aboutModel = [LSArrowSettingCellModel LSSettingCellModelWithTitle:@"关于" iconWithName:@"MoreAbout" destClass:[AboutUsScreenViewController class]];
        LSSettingCellModel *shareModel = [LSArrowSettingCellModel LSSettingCellModelWithTitle:@"推荐给好友" iconWithName:@"MoreShare" destClass:[LSSettingPreferenceViewController class]];
        NSArray *group2 = @[helpCenterModel,feedbackAndAdviceModel,aboutModel,shareModel];
        section2.sectionItems = group2;
        
        //添加group0、group1以及group2到这个dataList数组中去
        _settingItemsList = @[section0,section2];
    }
    return _settingItemsList;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataList = self.settingItemsList;
}

@end
