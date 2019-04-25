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
#import "LSSettingPreferenceViewController.h"

@interface LSSettingTableViewController ()

@property(nonatomic,strong)NSArray *settingItemsList;

@end

@implementation LSSettingTableViewController


- (NSArray *)settingItemsList{
    if (_settingItemsList == NULL) {
        //section 0
        LSSettingSectionModel *section0 = [[LSSettingSectionModel alloc]init];
        LSSettingCellModel *themesModel = [LSArrowSettingCellModel LSSettingCellModelWithTitle:@"配置" iconWithName:@"config" destClass:[ConfigurationViewController class]];
        LSSettingCellModel *advancedOptionsModel = [LSArrowSettingCellModel LSSettingCellModelWithTitle:@"偏好设置" iconWithName:@"preference" destClass:[LSSettingPreferenceViewController class]];
        LSSettingCellModel *aboutModel = [LSArrowSettingCellModel LSSettingCellModelWithTitle:@"关于" iconWithName:@"about" destClass:[AboutUsScreenViewController class]];
        NSArray *group0 =  @[themesModel,advancedOptionsModel,aboutModel];
        section0.sectionItems = group0;
        
        //section 2
        /*
        LSSettingSectionModel *section2 = [[LSSettingSectionModel alloc]init];
        LSSettingCellModel *helpCenterModel = [LSArrowSettingCellModel LSSettingCellModelWithTitle:@"帮助中心" iconWithName:@"MoreHelp" destClass:[LSSettingPreferenceViewController class]];
        LSSettingCellModel *feedbackAndAdviceModel = [LSArrowSettingCellModel LSSettingCellModelWithTitle:@"反馈与建议" iconWithName:@"feedback" destClass:[FeedbackViewController class]];
        LSSettingCellModel *shareModel = [LSArrowSettingCellModel LSSettingCellModelWithTitle:@"推荐给好友" iconWithName:@"MoreShare" destClass:[LSSettingPreferenceViewController class]];
        NSArray *group2 = @[feedbackAndAdviceModel];
        section2.sectionItems = group2;
         */
        
        //添加group0、group1以及group2到这个dataList数组中去
        _settingItemsList = @[section0];
    }
    return _settingItemsList;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataList = self.settingItemsList;
    
    self.view.backgroundColor = AppMajorTintColor;    
}

@end
