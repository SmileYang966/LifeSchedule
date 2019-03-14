//
//  SettingViewController.m
//  LifeSchedule
//
//  Created by 杨善成 on 8/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "LSBaseTableViewController.h"
#import "LSSettingCellModel.h"
#import "LSSettingTableViewCell.h"
#import "LSSettingSectionModel.h"
#import "LSArrowSettingCellModel.h"
#import "LSSwitcherSettingCellModel.h"

#import "LSSettingPreferenceViewController.h"

//typedef enum{
//    Arrow = 0,
//    Switcher
//}CellRightView;

@interface LSBaseTableViewController ()

@end

@implementation LSBaseTableViewController



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
    LSSettingSectionModel *sectionModel = self.dataList[section];
    return sectionModel.sectionItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSSettingTableViewCell *cell = [LSSettingTableViewCell getSettingCell];
    LSSettingSectionModel *sectionModel = self.dataList[indexPath.section];
    LSSettingCellModel *model = sectionModel.sectionItems[indexPath.row];
    if ([model isKindOfClass:[LSArrowSettingCellModel class]]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if([model isKindOfClass:[LSSwitcherSettingCellModel class]]){
        cell.accessoryView = [[UISwitch alloc]init];
    }
    cell.cellModel = model;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LSSettingSectionModel *sectionModel = self.dataList[indexPath.section];
    LSSettingCellModel *cellModel = sectionModel.sectionItems[indexPath.row];
    if ([cellModel isKindOfClass:[LSArrowSettingCellModel class]]) {
        LSArrowSettingCellModel *arrowCellModel = (LSArrowSettingCellModel *)cellModel;
        Class destClass = arrowCellModel.destClass;
         UIViewController *vc = [[destClass alloc]init];
        vc.title = arrowCellModel.title;
        [self.navigationController pushViewController:vc animated:true];
    }
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
