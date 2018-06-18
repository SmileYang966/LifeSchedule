//
//  SettingViewController.m
//  LifeSchedule
//
//  Created by 杨善成 on 8/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "SettingViewController.h"
#import "LSSettingCellModel.h"
#import "LSSettingTableViewCell.h"


//typedef enum{
//    Arrow = 0,
//    Switcher
//}CellRightView;

@interface SettingViewController ()

@property(nonatomic,strong)NSArray *dataList;

@end

@implementation SettingViewController

/*
 * +(instancetype)LSSettingCellModelWithTitle:(NSString *)title iconWithName:(NSString *)iconName rightView:(CellRightView) rightView;
 */

- (NSArray *)dataList{
    if (_dataList == NULL) {
       
        //Group 0
        LSSettingCellModel *themesModel = [LSSettingCellModel LSSettingCellModelWithTitle:@"主题" iconWithName:@"IDInfo" rightView:Arrow];
        LSSettingCellModel *tagListModel = [LSSettingCellModel LSSettingCellModelWithTitle:@"智能清单和标签" iconWithName:@"MoreHelp" rightView:Arrow];
        LSSettingCellModel *preferenceModel = [LSSettingCellModel LSSettingCellModelWithTitle:@"偏好设置" iconWithName:@"MoreUpdate" rightView:Arrow];
        LSSettingCellModel *securityAndDataModel = [LSSettingCellModel LSSettingCellModelWithTitle:@"安全与数据" iconWithName:@"IDInfo" rightView:Switcher];
        LSSettingCellModel *advancedOptionsModel = [LSSettingCellModel LSSettingCellModelWithTitle:@"高级选项" iconWithName:@"MoreUpdate" rightView:Arrow];
        LSSettingCellModel *tomatoesTimerModel = [LSSettingCellModel LSSettingCellModelWithTitle:@"番茄计时" iconWithName:@"IDInfo" rightView:Switcher];
        NSArray *group0 =  @[themesModel,tagListModel,preferenceModel,securityAndDataModel,advancedOptionsModel,tomatoesTimerModel];
        
        //Group 1
        LSSettingCellModel *weChatPublic = [LSSettingCellModel LSSettingCellModelWithTitle:@"玩转微信公众号" iconWithName:@"MoreMessage" rightView:Arrow];
        NSArray *group1 = @[weChatPublic];
        
        //Group 2
        LSSettingCellModel *helpCenterModel = [LSSettingCellModel LSSettingCellModelWithTitle:@"帮助中心" iconWithName:@"MoreHelp" rightView:Arrow];
        LSSettingCellModel *feedbackAndAdviceModel = [LSSettingCellModel LSSettingCellModelWithTitle:@"反馈与建议" iconWithName:@"sound_Effect" rightView:Arrow];
        LSSettingCellModel *aboutModel = [LSSettingCellModel LSSettingCellModelWithTitle:@"关于" iconWithName:@"MoreAbout" rightView:Arrow];
        LSSettingCellModel *shareModel = [LSSettingCellModel LSSettingCellModelWithTitle:@"推荐给好友" iconWithName:@"MoreShare" rightView:Arrow];
        NSArray *group2 = @[helpCenterModel,feedbackAndAdviceModel,aboutModel,shareModel];
        
        //添加group0、group1以及group2到这个dataList数组中去
        _dataList = @[group0,group1,group2];
    }
    return _dataList;
}


- (instancetype)init{
    if (self = [super init]) {
        self = [self initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *group = self.dataList[section];
    return group.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LSSettingTableViewCell *cell = [LSSettingTableViewCell getSettingCell];
    
    NSArray *groupItem = self.dataList[indexPath.section];
    LSSettingCellModel *model = groupItem[indexPath.row];
    
    cell.cellModel = model;
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20.0)];
    footerView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.8];
    return footerView;
}

/*很遗憾的是，我们必须加上下面这两段看上去没有任何作用的代码，他们的height是0，如果不写的话，会调用系统默认设定的sectionHeader以及viewForHeaderInSection*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerSectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
    headerSectionView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.8];
    return headerSectionView;
}

@end
