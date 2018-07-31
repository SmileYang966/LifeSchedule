//
//  PlannedTasksViewController.m
//  LifeSchedule
//
//  Created by 杨善成 on 8/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "PlannedTasksViewController.h"
#import "TaskCollectionTableViewCell.h"
#import "TaskCollectionModel.h"
#import "TaskCollectionGroupModel.h"
#import "TaskCollectionFrame.h"

@interface PlannedTasksViewController ()
@property(nonatomic,strong) NSMutableArray *totalList;
@end

@implementation PlannedTasksViewController

- (NSMutableArray *)totalList{
    if (_totalList == NULL) {
        
        _totalList = [NSMutableArray array];
        
        //Group 0 - Planned tasks
        TaskCollectionGroupModel *plannedTasksGroup = [[TaskCollectionGroupModel alloc]init];
        TaskCollectionFrame *collectionF0 = [[TaskCollectionFrame alloc]init];
        TaskCollectionModel *plannedTaskGroupItem0 = [TaskCollectionModel createCollectionTaskModelWithTitle:@"准备去做收集箱主界面" taskDetailInfo:@"7月29号，下午3:00"];
        collectionF0.taskCollectionModel = plannedTaskGroupItem0;
        
        TaskCollectionFrame *collectionF1 = [[TaskCollectionFrame alloc]init];
        TaskCollectionModel *plannedTaskGroupItem1 = [TaskCollectionModel createCollectionTaskModelWithTitle:@"晚上和同事们一起去健身房" taskDetailInfo:@""];
        collectionF1.taskCollectionModel = plannedTaskGroupItem1;
        
        TaskCollectionFrame *collectionF2 = [[TaskCollectionFrame alloc]init];
        TaskCollectionModel *plannedTaskGroupItem2 = [TaskCollectionModel createCollectionTaskModelWithTitle:@"买菜烧晚饭啦" taskDetailInfo:@"7月29号，下午6:00"];
        collectionF2.taskCollectionModel = plannedTaskGroupItem2;
        plannedTasksGroup.TaskCollectionItems = @[collectionF0,collectionF1,collectionF2];
        
        
        //Group 1 - Completed tasks
        TaskCollectionGroupModel *completedTasksGroup = [[TaskCollectionGroupModel alloc]init];
        TaskCollectionFrame *collectionF3 = [[TaskCollectionFrame alloc]init];
        TaskCollectionModel *completedTaskGroupItem0 = [TaskCollectionModel createCollectionTaskModelWithTitle:@"继续做界面设计" taskDetailInfo:@""];
        collectionF3.taskCollectionModel = completedTaskGroupItem0;
        
        TaskCollectionFrame *collectionF4 = [[TaskCollectionFrame alloc]init];
        TaskCollectionModel *completedTaskGroupItem1 = [TaskCollectionModel createCollectionTaskModelWithTitle:@"吃晚饭" taskDetailInfo:@"7月30号，下午3:00"];
        collectionF4.taskCollectionModel = completedTaskGroupItem1;
        completedTasksGroup.TaskCollectionItems = @[collectionF3,collectionF4];
        
        [_totalList addObjectsFromArray:@[plannedTasksGroup,completedTasksGroup]];
    }
    return _totalList;
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
    return self.totalList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TaskCollectionGroupModel *group = self.totalList[section];
    return group.TaskCollectionItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"CELLID";
    TaskCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==NULL) {
        cell = [[TaskCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    TaskCollectionGroupModel *group = self.totalList[indexPath.section];
    TaskCollectionFrame *itemFrame = group.TaskCollectionItems[indexPath.row];
    cell.taskCollectionFrame = itemFrame;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskCollectionGroupModel *group = self.totalList[indexPath.section];
    TaskCollectionFrame *itemFrame = group.TaskCollectionItems[indexPath.row];
    return itemFrame.collectionRowHegiht;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"已完成";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

@end
