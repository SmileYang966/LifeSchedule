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
#import "LSTextViewController.h"

@interface PlannedTasksViewController ()<TaskCollectionTableViewCellDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong) UIButton *addNewActivityButton;

/*Prepare the dataSource*/
@property(nonatomic,strong) NSMutableArray *ongoingTasks;
@property(nonatomic,strong) NSMutableArray *completedTasks;

@property(nonatomic,strong) NSManagedObjectContext *managedObjContext;

/*New Method*/
@property(nonatomic,strong) UITextField *hiddenTf;

@property(nonatomic,strong) UIView *keyboardTopAccessoryView;
@property(nonatomic,strong) UITextField *inputNewActTf;

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
        _addNewActivityButton.alpha = 0.7f;
        [_addNewActivityButton addTarget:self action:@selector(addNewActivityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addNewActivityButton;
}

- (UITextField *)hiddenTf{
    if (_hiddenTf == NULL) {
        _hiddenTf = [UITextField new];
        UIView *accessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
        accessoryView.backgroundColor = UIColor.redColor;
        _hiddenTf.inputAccessoryView = self.keyboardTopAccessoryView;
        [self.view addSubview:_hiddenTf];
    }
    return _hiddenTf;
}

- (UIView *)keyboardTopAccessoryView{
    if (_keyboardTopAccessoryView == NULL) {
        _keyboardTopAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50.0f)];
        _keyboardTopAccessoryView.backgroundColor = [UIColor whiteColor];
        _keyboardTopAccessoryView.layer.borderWidth = 0.8f;
        _keyboardTopAccessoryView.layer.borderColor = [UIColor colorWithRed:65/255.0 green:149/255.0 blue:213/255.0 alpha:1.0f].CGColor;
        
        UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(_keyboardTopAccessoryView.bounds.size.width-60, 2.5, 60, 45)];
        [sendBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendNewActivity:) forControlEvents:UIControlEventTouchUpInside];
        [sendBtn setImage:[UIImage imageNamed:@"send_64px.png"] forState:UIControlStateNormal];
        [_keyboardTopAccessoryView addSubview:sendBtn];
        
        UITextField *inputTf = [[UITextField alloc]init];
        inputTf.frame = CGRectMake(10, 2.5, _keyboardTopAccessoryView.bounds.size.width-60-10, 45);
        inputTf.placeholder = @"请输入新的任务";
        inputTf.layer.cornerRadius = 5;
        inputTf.layer.masksToBounds = YES;
        [_keyboardTopAccessoryView addSubview:inputTf];
        
        self.inputNewActTf = inputTf;
    }
    return _keyboardTopAccessoryView;
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
    
    
    //Refresh the data
    [self refreshData];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.addNewActivityButton removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initOperations];
    
    NSURL *url = [self applicationDocumentsDirectory];
    NSLog(@"url=%@",url.absoluteString);
}

-(NSURL *)applicationDocumentsDirectory
{
    //获取沙盒路径下documents文件夹的路径(类似于search)
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark Reload data
-(void)refreshData{
    /*CoreData - Try to load the data from local db*/
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TimeActivity"];
    [request setReturnsObjectsAsFaults:NO];
    request.resultType = NSManagedObjectResultType;
    
    //创建排序描述器
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"plannedBeginDate" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSArray *timeActivityDbArray = [self.managedObjContext executeFetchRequest:request error:nil];
    
    NSMutableArray *ongoingActivityarrayM = [NSMutableArray array];
    NSMutableArray *completedActivityArrayM = [NSMutableArray array];
    for (TimeActivity *act in timeActivityDbArray) {
        NSString *activityDesc = act.activityDescription;
        TaskCollectionFrame *collectionF = [[TaskCollectionFrame alloc]init];
        TaskCollectionModel *plannedTaskGroupItem = [TaskCollectionModel createCollectionTaskModelWithTitle:activityDesc taskStartedDate:act.plannedBeginDate];
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
    /* To show the keyboard, we let the hiddenTf become the first responder */
    [self.hiddenTf becomeFirstResponder];
}

-(BOOL)isBlankString:(NSString *)string{
    if (string==nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(void)sendNewActivity:(UIButton *)button{
    /*1.Check if the inputNewActTf is empty*/
    if ([self isBlankString:self.inputNewActTf.text]) {
        UIAlertController *warnController = [UIAlertController alertControllerWithTitle:@"Error" message:@"任务描述不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [warnController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:warnController animated:YES completion:nil];
        return;
    }
    
    /*2.Record the inputNewActTf's text and it will be used later*/
    NSString *newActivityDesc = self.inputNewActTf.text;
    
    /*3.All TextFields Lose the first responder , as the UIDatePicker will be the first responder*/
    [self resignResponderForAllTextFields];
    
    UIAlertController *alertController = [[UIAlertController alloc]init];
    UIDatePicker *datePicker = [UIDatePicker new];
    NSLog(@"datePicker new = %@",NSStringFromCGRect(datePicker.frame));
    
    CGFloat marginx = (self.view.bounds.size.width - datePicker.bounds.size.width) * 0.5f - 10.0f;
    CGRect datePickerFrame = datePicker.frame;
    datePickerFrame.origin.y += 35.0f;
    datePickerFrame.origin.x += marginx;
    datePicker.frame = datePickerFrame;
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [alertController.view addSubview:datePicker];
    
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"请选择活动时间\n\n\n\n\n\n\n\n\n\n\n"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,7)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0,7)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        /*1.Get the selected date*/
        NSDate *selectedDate = datePicker.date;
        
        /*2.Get the activity description*/
        NSString *activityDesc = newActivityDesc;
        
        //3.Save the activity description and relative date
        [self saveActivityWithDesc:activityDesc plannedBeginDate:selectedDate isActivityCompleted:false];
        
        //4.Clear the text for this textField
        self.inputNewActTf.text = @"";
        
        //5. To do list : Order the activity by the date
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
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

- (void)tapClicked:(UITapGestureRecognizer *)tapGr{
    [self resignResponderForAllTextFields];
}

#pragma mark Initalizations
-(void)initOperations{
    /*1.Hide the keyboard*/
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked:)];
    tapGr.delegate = self;
    [self.view addGestureRecognizer:tapGr];
    /*2.Add two notifications related to the keyboard*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/*显示键盘*/
- (void)keyBoardWillShow:(NSNotification *)notification{
    /*When the keyboard show on the screen, we will let the another textField(used for enter acitvity) become the first responder */
    [self.inputNewActTf becomeFirstResponder];
}

/*隐藏键盘*/
-(void)keyBoardWillHide:(NSNotification *)notification{
}

#pragma mark Delegate for tableView
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
        cell.delegate = self;
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
    cell.cellIndex = indexPath;
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

/* Just found the didSelectRowAtIndexPath can not work normally
 * Reason : We added the UITapGestureRecognizer on the current view , there are some
 * conflicts between the gesture and the didSelectRowAtIndexPath function
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskCollectionFrame *itemFrame = NULL;
    switch (indexPath.section) {
        case 0:
            itemFrame = self.ongoingTasks[indexPath.row];
            break;
            
        case 1:
            itemFrame = self.completedTasks[indexPath.row];
            break;
    }
    
    LSTextViewController *plannedActDetailVC = [[LSTextViewController alloc]init];
    plannedActDetailVC.taskModel = itemFrame.taskCollectionModel;
    [self.navigationController pushViewController:plannedActDetailVC animated:true];
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
        
        //创建排序描述器
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"plannedBeginDate" ascending:YES];
        [deleteRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
        
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

/*When user start to dragging the tableView, it will end endEditing.*/
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self resignResponderForAllTextFields];
}

-(void)resignResponderForAllTextFields{
    /*Used for the inputActiviy*/
    [self.inputNewActTf resignFirstResponder];
    /*Used for the hiddenTextField*/
    [self.view endEditing:YES];
}

#pragma mark Delegate for the TaskCollectionTableViewCell
- (void)taskCollectionTableViewCell:(TaskCollectionTableViewCell *)cell selectedIndex:(NSIndexPath *)cellIndex{
    //Update the data
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TimeActivity"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"isActivityCompleted=%d",cellIndex.section==0 ? 0 : 1];
    [request setPredicate:pre];
    
    //创建排序描述器
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"plannedBeginDate" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSArray *timeActivityDbArray = [self.managedObjContext executeFetchRequest:request error:nil];
    TimeActivity *act = timeActivityDbArray[cellIndex.row];
    act.isActivityCompleted = !act.isActivityCompleted;
    NSLog(@"act.ISComplete=%d",act.isActivityCompleted);
    NSError *error = nil;
    [self.managedObjContext save:&error];
    
    /*After changed the completed status , we should put the cell to the suitable section*/
    [self refreshData];
    [self.tableView reloadData];
}

#pragma mark Delegate for the gestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

@end
