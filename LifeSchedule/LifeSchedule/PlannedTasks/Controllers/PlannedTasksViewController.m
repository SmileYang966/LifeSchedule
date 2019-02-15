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
#import "TimeActivity+CoreDataProperties.h"

@interface PlannedTasksViewController ()

@property(nonatomic,strong) UIButton *addNewActivityButton;

/*Prepare the dataSource*/
@property(nonatomic,strong) NSMutableArray *ongoingTasks;
@property(nonatomic,strong) NSMutableArray *completedTasks;

@property(nonatomic,strong) NSManagedObjectContext *managedObjContext;

/*A new activity textfield*/
@property(nonatomic,strong) UIView *createNewActivityView;
@property(nonatomic,strong) UITextField *inputedNewTf;

@end

@implementation PlannedTasksViewController

- (NSMutableArray *)ongoingTasks{
    if (_ongoingTasks == NULL) {
        _ongoingTasks = [NSMutableArray array];
    }
    return _ongoingTasks;
}

- (NSMutableArray *)completedTasks{
    if (_completedTasks == NULL) {
        _completedTasks = [NSMutableArray array];
        /*
        TaskCollectionFrame *collectionF3 = [[TaskCollectionFrame alloc]init];
        TaskCollectionModel *completedTaskGroupItem0 = [TaskCollectionModel createCollectionTaskModelWithTitle:@"继续做界面设计" taskDetailInfo:@""];
        collectionF3.taskCollectionModel = completedTaskGroupItem0;
        
        TaskCollectionFrame *collectionF4 = [[TaskCollectionFrame alloc]init];
        TaskCollectionModel *completedTaskGroupItem1 = [TaskCollectionModel createCollectionTaskModelWithTitle:@"吃晚饭" taskDetailInfo:@"7月30号，下午3:00"];
        collectionF4.taskCollectionModel = completedTaskGroupItem1;
        
        TaskCollectionFrame *collectionF5 = [[TaskCollectionFrame alloc]init];
        TaskCollectionModel *completedTaskGroupItem2 = [TaskCollectionModel createCollectionTaskModelWithTitle:@"看电影" taskDetailInfo:@"7月31号，下午5:00"];
        collectionF5.taskCollectionModel = completedTaskGroupItem2;
        
        [_completedTasks addObjectsFromArray:@[collectionF3,collectionF4,collectionF5]];
         */
    }
    return _completedTasks;
}

- (instancetype)init{
    if (self = [super init]) {
        self = [self initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}

- (UIButton *)addNewActivityButton{
    if (_addNewActivityButton == NULL) {
        _addNewActivityButton = [[UIButton alloc]init];
        CGFloat addNewActivityButtonWidth = 48.0f;
        CGFloat addNewActivityButtonHeight = 48.0f;
        CGFloat addNewActivityButtonX = UIScreen.mainScreen.bounds.size.width - addNewActivityButtonWidth-20;
        CGFloat addNewActivityButtonY = UIScreen.mainScreen.bounds.size.height - addNewActivityButtonHeight - self.tabBarController.tabBar.frame.size.height-20;
        _addNewActivityButton.frame = CGRectMake(addNewActivityButtonX, addNewActivityButtonY, addNewActivityButtonWidth, addNewActivityButtonHeight);
        [_addNewActivityButton setBackgroundImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
        _addNewActivityButton.layer.masksToBounds = YES;
        
        [_addNewActivityButton addTarget:self action:@selector(addNewActivityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addNewActivityButton;
}

- (NSManagedObjectContext *)managedObjContext{
    if (_managedObjContext == NULL) {
        _managedObjContext = [CoreDataManager sharedManager].dBContext;
    }
    return _managedObjContext;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.addNewActivityButton];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.addNewActivityButton removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initOperations];
    
    //2.Initalize the data
    [self refreshData];
}

#pragma mark Reload data
-(void)refreshData{
    /*CoreData - Try to load the data from local db*/
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TimeActivity"];
    [request setReturnsObjectsAsFaults:NO];
    request.resultType = NSManagedObjectResultType;
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"isActivityCompleted=%d",1];
//    [request setPredicate:pre];
    NSArray *timeActivityDbArray = [self.managedObjContext executeFetchRequest:request error:nil];
    
    NSMutableArray *ongoingActivityarrayM = [NSMutableArray array];
    NSMutableArray *completedActivityArrayM = [NSMutableArray array];
    for (TimeActivity *act in timeActivityDbArray) {
        NSString *activityDesc = act.activityDescription;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [dateFormatter stringFromDate:act.plannedBeginDate];
        NSLog(@"activityDesc=%@,dateStr=%@",activityDesc,dateStr);
        
        TaskCollectionFrame *collectionF = [[TaskCollectionFrame alloc]init];
        TaskCollectionModel *plannedTaskGroupItem = [TaskCollectionModel createCollectionTaskModelWithTitle:activityDesc taskDetailInfo:dateStr];
        plannedTaskGroupItem.isCompleted = act.isActivityCompleted;
        collectionF.taskCollectionModel = plannedTaskGroupItem;
        
        if (!act.isActivityCompleted) {
            [ongoingActivityarrayM addObject:collectionF];
        }else{
            [completedActivityArrayM addObject:collectionF];
        }
    }
    self.ongoingTasks = ongoingActivityarrayM;
    self.completedTasks = completedActivityArrayM;
}


#pragma mark Event Clicked
-(void)addNewActivityButtonClicked:(UIButton *)button{
    [self.inputedNewTf becomeFirstResponder];
}

#pragma mark Initalizations
-(void)initOperations{
    /*1.Initalize the keyboard top view*/
    [self createKeyboardTopView];
    
    /*2.Hide the keyboard*/
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked:)];
    [self.view addGestureRecognizer:tapGr];
}

-(void)createKeyboardTopView{
    UIView *keyBoardTopView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 50.0f)];
    keyBoardTopView.backgroundColor = [UIColor whiteColor];
    keyBoardTopView.layer.borderWidth = 0.7;
    keyBoardTopView.layer.borderColor = [UIColor orangeColor].CGColor;
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(keyBoardTopView.bounds.size.width-60-12, 4, 60, 45)];
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    [sendBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendNewActivity:) forControlEvents:UIControlEventTouchUpInside];
    [keyBoardTopView addSubview:sendBtn];
    
    UITextField *inputTf = [[UITextField alloc]init];
    inputTf.frame = CGRectMake(10, 4, keyBoardTopView.bounds.size.width-72-10, 45);
    inputTf.placeholder = @"请输入新的Activity";
    inputTf.layer.cornerRadius = 5;
    inputTf.layer.masksToBounds = YES;
    [keyBoardTopView addSubview:inputTf];
    self.inputedNewTf = inputTf;
    self.createNewActivityView = keyBoardTopView;
    [self.view addSubview:keyBoardTopView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)tapClicked:(UITapGestureRecognizer *)tapGr{
    [self.view endEditing:YES];
}

-(void)saveActivityWithDesc:(NSString *)activityDesc plannedBeginDate:(NSDate *)beginDate isActivityCompleted:(BOOL)isCompleted{
    TimeActivity *act = [NSEntityDescription insertNewObjectForEntityForName:@"TimeActivity" inManagedObjectContext:self.managedObjContext];
    act.activityDescription = activityDesc;
    act.plannedBeginDate = beginDate;
    act.isActivityCompleted = isCompleted;
    
    NSError *error;
    if([self.managedObjContext save:&error])
    {
        [self refreshData];
        [self.tableView reloadData];
    }
}

-(void)sendNewActivity:(UIButton *)button{
    //1.Fetch the data from the textField and store to db
    NSString *newActivityDesc = self.inputedNewTf.text;
    NSDate *plannedDate = [NSDate date];
    
    // Save the Activity with the specific date
    [self saveActivityWithDesc:newActivityDesc plannedBeginDate:plannedDate isActivityCompleted:false];
    
    //2.Reload the db and show the latest info on the screen
    
    //3.Resign the first responder
    [self.view endEditing:YES];
    self.inputedNewTf.text = @"";
}

/*显示键盘*/
- (void)keyBoardWillShow:(NSNotification *)notification{
    //获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    //获取键盘高度
    CGRect keyBoardBounds = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    //获取键盘动画时间
    CGFloat animationTime = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    void (^animation)(void) = ^void(void){
        self.createNewActivityView.transform = CGAffineTransformMakeTranslation(0, -keyBoardHeight);
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    }else{
        animation();
    }
}

/*隐藏键盘*/
-(void)keyBoardWillHide:(NSNotification *)notification{
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        self.createNewActivityView.transform = CGAffineTransformIdentity;
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.ongoingTasks.count;
        
        case 1:
            return self.completedTasks.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"CELLID";
    TaskCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==NULL) {
        cell = [[TaskCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    TaskCollectionFrame *itemFrame = NULL;
    switch (indexPath.section) {
        case 0:
            itemFrame = self.ongoingTasks[indexPath.row];
            break;
        case 1:
            itemFrame = self.completedTasks[indexPath.row];
            break;
    }
    
    cell.taskCollectionFrame = itemFrame;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskCollectionFrame *itemFrame = NULL;
    switch (indexPath.section) {
        case 0:
            itemFrame = self.ongoingTasks[indexPath.row];
            break;
        case 1:
            itemFrame = self.completedTasks[indexPath.row];
            break;
    }
    
    return itemFrame.collectionRowHegiht;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"已完成";
    }
    return @"进行中";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc1 = [[UIViewController alloc]init];
    vc1.view.backgroundColor = UIColor.whiteColor;
    [self.navigationController pushViewController:vc1 animated:true];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //Delete operations
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSFetchRequest *deleteRequest = [NSFetchRequest fetchRequestWithEntityName:@"TimeActivity"];
        //添加查询条件，一个section是正在进行的，另一个section表示的是w已经完成的
        NSPredicate *pre = NULL;
        switch (indexPath.section) {
            case 0:
                //1. Activities are ongoing or planned
                pre = [NSPredicate predicateWithFormat:@"isActivityCompleted=%d",0];
                break;
            case 1:
                //2. Activities are completed
                pre = [NSPredicate predicateWithFormat:@"isActivityCompleted=%d",1];
                break;
        }
        deleteRequest.predicate = pre;
        
        //这边得到的要删除的Array是经过预先筛选过的
        NSArray *deleteArray = [self.managedObjContext executeFetchRequest:deleteRequest error:nil];
        TimeActivity *act = deleteArray[indexPath.row];
        [self.managedObjContext deleteObject:act];
        
        NSError *error = nil;
        if ([self.managedObjContext save:&error]) {
            NSLog(@"删除数据成功");
            [self refreshData];
            [self.tableView reloadData];
        }else{
            NSLog(@"删除数据失败,%@",error);
        }
    }
}

@end
