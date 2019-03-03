//
//  CalendarViewController.m
//  LifeSchedule
//
//  Created by 杨善成 on 8/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarCollectionViewCell.h"
#import "CalendarHeaderView.h"
#import "PublicHolidayDay.h"
#import "CalendarTableViewCell.h"
#import "TimeActivity+CoreDataClass.h"
#import "TaskCollectionGroupModel.h"
#import "TaskCollectionFrame.h"
#import "TaskCollectionGroupModel.h"
#import "TaskCollectionModel.h"
#import "TaskCollectionTableViewCell.h"

#define CURRENTMONTH    @"currentMonth"
#define NEXTMONTH       @"nextMonth"
#define LASTMONTH       @"lastMonth"

#define     CalendarCollectionViewItemSizeWidthOrHeight     38.0f

@interface CalendarViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,TaskCollectionTableViewCellDelegate>

/*1.Defined a scrollView on the top half*/
@property(nonatomic,strong) UIScrollView *calendarScrollView;

/*2.Defined a view on the bottom half*/
@property(nonatomic,strong) UIView *scheduleView;

/*3.Header View for the calendar*/
@property(nonatomic,strong)UIView *headerView;

/*4.Defined a tableView to save the schedule for the current day*/
@property(nonatomic,strong)UITableView *dailyScheduledTableView;

@property(nonatomic,strong)CalendarCollectionViewCell *tempSavedCollectionViewCell;

/*4.Define three UICollectionviews*/
@property(nonatomic,strong) UICollectionView *currentCollectionView;
@property(nonatomic,strong) UICollectionView *previousCollectionView;
@property(nonatomic,strong) UICollectionView *nextCollectionView;

/*5.Defined the size*/
@property(nonatomic,assign) int collectionViewItemMarginX;
@property(nonatomic,assign) CGFloat collectionViewSizeHeight;


/*Data part*/
@property(nonatomic,strong) NSMutableDictionary *totalDict;
@property(nonatomic,strong) NSMutableArray *publicHolidayList;
@property(nonatomic,strong) NSMutableDictionary *publicHolidayDictM;

/*
 * currentCalendarDate => Just care its year and month
 * currentSelectedDate => Care its year、month and the specific day
 */
@property(nonatomic,strong) NSDate *currentCalendarDate;
@property(nonatomic,strong) NSNumber *currentSelectedMonthDay;
@property(nonatomic,assign) NSInteger currentDayIndex;


/*Core data part*/
@property(nonatomic,strong) NSManagedObjectContext *managedObjContext;
@property(nonatomic,strong) NSArray *calendarActivities;

/*New activity button*/
@property(nonatomic,strong) UIButton *addNewActivityButton;
@property(nonatomic,strong) UITextField *hiddenTf;
@property(nonatomic,strong) UIView *keyboardTopAccessoryView;
@property(nonatomic,strong) UITextField *inputNewActTf;

/*Activity related database*/
@property(nonatomic,strong) NSMutableArray *ongoingTasks;
@property(nonatomic,strong) NSMutableArray *completedTasks;
@property(nonatomic,strong) NSDate *calendarSelectedDate;

@end

@implementation CalendarViewController

#pragma mark -Lazy loading

- (NSMutableDictionary *)totalDict{
    if (_totalDict == NULL) {
        _totalDict = [NSMutableDictionary dictionary];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
        NSDate *firstDateOfMonthDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        NSArray *currentDataArrayM = [self getMonthDaysByDate:firstDateOfMonthDate];
        [_totalDict setObject:currentDataArrayM forKey:CURRENTMONTH];
        
        NSDate *previousMonthDate = [self getPreviousOrNextDateFromDate:firstDateOfMonthDate WithMonth:-1];
        NSArray *previousDataArrayM = [self getMonthDaysByDate:previousMonthDate];
        [_totalDict setObject:previousDataArrayM forKey:LASTMONTH];
        
        NSDate *nextMonthDate = [self getPreviousOrNextDateFromDate:firstDateOfMonthDate WithMonth:1];
        NSArray *nextDataArrayM = [self getMonthDaysByDate:nextMonthDate];
        [_totalDict setObject:nextDataArrayM forKey:NEXTMONTH];
        
        self.currentCalendarDate = firstDateOfMonthDate;
        
        //Send the request to get the json data and filled the holiday info to the holidayDict;
        [self getTheHolidayInfoWithYear:components.year];
        /*若切换后发现当前的月份是12月份或者是1月份，那就得准备请求下一年或者上一年的节日信息*/
        [self requestHolidaysInTheNextOrPreviousYear:components];
    }
    return _totalDict;
}

- (NSManagedObjectContext *)managedObjContext{
    if (_managedObjContext == NULL) {
        _managedObjContext = [CoreDataManager sharedManager].dBContext;
    }
    return _managedObjContext;
}

-(NSURL *)applicationDocumentsDirectory
{
    //获取沙盒路径下documents文件夹的路径(类似于search)
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSMutableArray *)publicHolidayList{
    if (_publicHolidayList == NULL) {
        _publicHolidayList = [NSMutableArray array];
    }
    return _publicHolidayList;
}

- (NSMutableDictionary *)publicHolidayDictM{
    if (_publicHolidayDictM == NULL) {
        _publicHolidayDictM = [NSMutableDictionary dictionary];
    }
    return _publicHolidayDictM;
}

- (UIView *)headerView{
    if (_headerView == NULL) {
        _headerView = [[CalendarHeaderView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 30.0f)];
        [self.view addSubview:_headerView];
    }
    return _headerView;
}

- (UIScrollView *)calendarScrollView{
    if (_calendarScrollView == NULL) {
        _calendarScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), self.view.bounds.size.width, self.currentCollectionView.bounds.size.height)];
        _calendarScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 3, 0);
        _calendarScrollView.pagingEnabled = true;
        _calendarScrollView.bounces = false;
        _calendarScrollView.delegate = self;
        _calendarScrollView.showsHorizontalScrollIndicator = false;
        [self.view addSubview:_calendarScrollView];
    }
    return _calendarScrollView;
}

- (UIView *)scheduleView{
    if (_scheduleView == NULL) {
        _scheduleView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.calendarScrollView.frame),self.view.bounds.size.width,self.view.bounds.size.height-CGRectGetMaxY(self.calendarScrollView.frame))];
        _scheduleView.backgroundColor = UIColor.redColor;
        [self.view addSubview:_scheduleView];
    }
    return _scheduleView;
}

- (UITableView *)dailyScheduledTableView{
    if (_dailyScheduledTableView == NULL) {
        _dailyScheduledTableView = [[UITableView alloc]initWithFrame:self.scheduleView.bounds];
        _dailyScheduledTableView.dataSource = self;
        _dailyScheduledTableView.delegate = self;
        [self.scheduleView addSubview:_dailyScheduledTableView];
    }
    return _dailyScheduledTableView;
}

/*Three collection views to save the data*/
- (UICollectionView *)currentCollectionView{
    if (_currentCollectionView == NULL) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = self.collectionViewItemMarginX;
        layout.sectionHeadersPinToVisibleBounds = true;
        layout.itemSize = CGSizeMake(CalendarCollectionViewItemSizeWidthOrHeight, CalendarCollectionViewItemSizeWidthOrHeight);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        
    
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*1, 0, self.view.bounds.size.width, self.collectionViewSizeHeight) collectionViewLayout:layout];
        collectionView.backgroundColor = UIColor.whiteColor;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[CalendarCollectionViewCell class] forCellWithReuseIdentifier:CURRENTMONTH];
        collectionView.tag = 1;
        _currentCollectionView = collectionView;
    }
    return _currentCollectionView;
}

- (UICollectionView *)previousCollectionView{
    if (_previousCollectionView == NULL) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = self.collectionViewItemMarginX;
        layout.sectionHeadersPinToVisibleBounds = true;
        layout.itemSize = CGSizeMake(CalendarCollectionViewItemSizeWidthOrHeight, CalendarCollectionViewItemSizeWidthOrHeight);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.collectionViewSizeHeight) collectionViewLayout:layout];
        collectionView.backgroundColor = UIColor.whiteColor;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[CalendarCollectionViewCell class] forCellWithReuseIdentifier:LASTMONTH];
        collectionView.tag = 0;
        _previousCollectionView = collectionView;
    }
    return _previousCollectionView;
}

- (UICollectionView *)nextCollectionView{
    if (_nextCollectionView == NULL) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = self.collectionViewItemMarginX;
        layout.sectionHeadersPinToVisibleBounds = true;
        layout.itemSize = CGSizeMake(CalendarCollectionViewItemSizeWidthOrHeight, CalendarCollectionViewItemSizeWidthOrHeight);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*2, 0, self.view.bounds.size.width, self.collectionViewSizeHeight) collectionViewLayout:layout];
        collectionView.backgroundColor = UIColor.whiteColor;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[CalendarCollectionViewCell class] forCellWithReuseIdentifier:NEXTMONTH];
        collectionView.tag = 2;
        _nextCollectionView = collectionView;
    }
    return _nextCollectionView;
}

/*Add new activity button*/
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

/*用于UITextField以及相应的keyboardTopAccessoryView*/
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
        _keyboardTopAccessoryView.layer.borderWidth = 0.7;
        _keyboardTopAccessoryView.layer.borderColor = [UIColor orangeColor].CGColor;
        
        UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(_keyboardTopAccessoryView.bounds.size.width-60-12, 4, 60, 45)];
        [sendBtn setTitle:@"Go" forState:UIControlStateNormal];
        [sendBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendNewActivity:) forControlEvents:UIControlEventTouchUpInside];
        [_keyboardTopAccessoryView addSubview:sendBtn];
        
        UITextField *inputTf = [[UITextField alloc]init];
        inputTf.frame = CGRectMake(10, 4, _keyboardTopAccessoryView.bounds.size.width-72-10, 45);
        inputTf.placeholder = @"请输入新的任务";
        inputTf.layer.cornerRadius = 5;
        inputTf.layer.masksToBounds = YES;
        [_keyboardTopAccessoryView addSubview:inputTf];
        
        self.inputNewActTf = inputTf;
    }
    return _keyboardTopAccessoryView;
}

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

#pragma mark -Data Process

-(void)refreshData{
    /*CoreData - Try to load the data from local db*/
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TimeActivity"];
    [request setReturnsObjectsAsFaults:NO];
    request.resultType = NSManagedObjectResultType;
    
    /*创建筛选条件,所选中的日期*/
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    components.day = [self.currentSelectedMonthDay integerValue];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSDate *minDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    NSDate *maxDate = [[NSCalendar currentCalendar] dateFromComponents:components];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"plannedBeginDate >= %@ AND plannedBeginDate <= %@",minDate,maxDate];
    [request setPredicate:predicate];
    
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

#pragma mark -Event clicked

-(void)addNewActivityButtonClicked:(UIButton *)addNewActivityButton{
    [self.hiddenTf becomeFirstResponder];
}

-(void)sendNewActivity:(UIButton *)sendNewActivityButton{
    // 1. Record the text of inputNewActTf
    NSString *recordNewActText = self.inputNewActTf.text;
    
    // 2. 隐藏keyboard
    [self resignResponderForAllTextFields];
    
    // 3. 弹出UIAlertController
    UIAlertController *alertController = [[UIAlertController alloc]init];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    CGRect datePickerFrame = datePicker.frame;
    datePickerFrame.origin.y += 35.0f;
    datePicker.frame = datePickerFrame;
    
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [alertController.view addSubview:datePicker];
    
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"请选择活动时间\n\n\n\n\n\n\n\n\n\n\n"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,7)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0,7)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //1.Get the activity description
        //2.Get the activity start date
        NSDate *selectedDate = datePicker.date;
        /* User selected the assigned day as the activity date*/
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:selectedDate];
        components.day = [self.currentSelectedMonthDay integerValue];
        selectedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        //3.save the data to the db
        [self saveActivityWithDesc:recordNewActText plannedBeginDate:selectedDate isActivityCompleted:NO];
        
        //4.Clear the inputNewActTf
        self.inputNewActTf.text = @"";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)saveActivityWithDesc:(NSString *)activityDesc plannedBeginDate:(NSDate *)beginDate isActivityCompleted:(BOOL)isCompleted{
    TimeActivity *act = [NSEntityDescription insertNewObjectForEntityForName:@"TimeActivity" inManagedObjectContext:self.managedObjContext];
    act.activityDescription = activityDesc;
    act.plannedBeginDate = beginDate;
    act.isActivityCompleted = isCompleted;
    
    NSError *error;
    if([self.managedObjContext save:&error])
    {
        //After save the data successfully, refresh the data
        [self refreshData];
        [self.dailyScheduledTableView reloadData];
    }
}

-(void)resignResponderForAllTextFields{
    /*Used for the inputActiviy*/
    [self.inputNewActTf resignFirstResponder];
    /*Used for the hiddenTextField*/
    [self.view endEditing:YES];
}

- (void)refreshedData{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TimeActivity"];
    [request setReturnsObjectsAsFaults:NO];
    request.resultType = NSManagedObjectResultType;
    
    NSError *error = NULL;
    NSArray *timeActivityArray = [self.managedObjContext executeFetchRequest:request error:&error];
    for (TimeActivity *act in timeActivityArray) {
        
    }
}

#pragma mark -Basic operations for view

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.collectionViewItemMarginX = (int)((self.view.bounds.size.width - CalendarCollectionViewItemSizeWidthOrHeight * 7) / 6.0f);
    CGFloat collectionViewItemMarginY = 5.0f;
    self.collectionViewSizeHeight = CalendarCollectionViewItemSizeWidthOrHeight*6 + collectionViewItemMarginY*5;
    self.dailyScheduledTableView.rowHeight = 120.0f;
    
    /*将三个UICollectionView加入到scrollView当中*/
    [self.calendarScrollView addSubview:self.previousCollectionView];
    [self.calendarScrollView addSubview:self.nextCollectionView];
    [self.calendarScrollView addSubview:self.currentCollectionView];
    
    //Set the initalized contentOffset
    [self.calendarScrollView setContentOffset:CGPointMake(self.view.bounds.size.width, 0) animated:false];
    
    //Get the currentDayIndex in a calendar month(42 Items in a calendar)
    NSDate *dt = [NSDate date];
    NSDateComponents *comp = [self getNSDateComponentsByDate:dt];
    self.currentDayIndex = [self getCurrentDayIndexInMonth:comp];
    self.navigationItem.title = [NSString stringWithFormat:@"%ld年%ld月",comp.year,comp.month];
    self.currentSelectedMonthDay = [NSNumber numberWithInteger:comp.day];
    [self initOperations];
    
    
     NSURL *url = [self applicationDocumentsDirectory];
     NSLog(@"url path =%@",url.absoluteString);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.addNewActivityButton];
    
    [self refreshData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.addNewActivityButton removeFromSuperview];
}

-(void)initOperations{
    /*1.Hide the keyboard*/
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked:)];
//    [self.view addGestureRecognizer:tapGr];
    /*2.Add two notifications related to the keyboard*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)tapClicked:(UITapGestureRecognizer *)tap{
    [self resignResponderForAllTextFields];
}

/*显示键盘*/
- (void)keyBoardWillShow:(NSNotification *)notification{
    /*When the keyboard show on the screen, we will let the another textField(used for enter acitvity) become the first responder */
    [self.inputNewActTf becomeFirstResponder];
}

/*隐藏键盘*/
-(void)keyBoardWillHide:(NSNotification *)notification{
}

#pragma mark -UICollectionView Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *keyArray = @[LASTMONTH,CURRENTMONTH,NEXTMONTH];
    NSString *KeyStr = keyArray[collectionView.tag];
    
    CalendarCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:KeyStr forIndexPath:indexPath];
    [cell clearTextsOncell];
    
    NSArray *daysArray = [self.totalDict objectForKey:KeyStr];
    NSNumber *dayNumber = (NSNumber *)daysArray[indexPath.row];
    cell.dayNo  = [dayNumber integerValue];
    cell.hiddenSelectedView = true;
    cell.isInactiveStatus = false;
    
    //To do : 需要得到有效dayNo的具体日期，当它满足holiday day的条件时，需要去对这个cell做一些额外的处理
    //可以得到当前日历的日期,只有大约0才是有效的
    if ([dayNumber integerValue]>0) {
        //获取当前的日期
        NSDate *currentDate;
        if ([KeyStr isEqualToString:CURRENTMONTH]) {
            currentDate = self.currentCalendarDate;
        }
        
        if ([KeyStr isEqualToString:NEXTMONTH]) {
            currentDate = [self getPreviousOrNextDateFromDate:self.currentCalendarDate WithMonth:1];
        }
        
        if ([KeyStr isEqualToString:LASTMONTH]) {
            currentDate = [self getPreviousOrNextDateFromDate:self.currentCalendarDate WithMonth:-1];
        }
        
        //这里需要做一下判断，对于不在当月的日子，需要改变字体的颜色为浅灰色
        //IndexPath的row一共有42个才对,Index是从0到41为止
        int dayIndexInCurrentMonth = [self isDayIndexInCurrentMonthWithDate:currentDate dayIndex:(int)indexPath.row];
        if(dayIndexInCurrentMonth != 1)
            cell.isInactiveStatus = true;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        NSInteger year = [components year];
        NSInteger month = [components month];
        NSString *dayKey = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,[dayNumber integerValue]];
        NSString *holidayDesc = [self.publicHolidayDictM objectForKey:dayKey];
        if (holidayDesc != NULL && dayIndexInCurrentMonth == 1) {
            cell.holidayDesc = holidayDesc;
        }
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    NSDate *firstDateOfMonthDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSTimeInterval interval = [firstDateOfMonthDate timeIntervalSinceDate:self.currentCalendarDate];
    
    //Current day will set the black circle background
    //必须满足以下3个条件
    /*
     * 1. 当前的cell必须是当天的
     * 2. 确保当前日历是显示的当月
     * 3. 确保当前是CurrentMonth标记范围内的
     */
    if (indexPath.row == self.currentDayIndex && interval==0.0f && [KeyStr isEqualToString:CURRENTMONTH]) {
        cell.hiddenSelectedView = false;
        /*确保当前保存的cell是默认当天选中的cell*/
        self.tempSavedCollectionViewCell = cell;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    int selectedIndex = [self isDayIndexInCurrentMonthWithDate:self.currentCalendarDate dayIndex:(int)indexPath.row];
    NSArray *monthDays = [self getMonthDaysByDate:self.currentCalendarDate];
    NSNumber *monthDay = monthDays[indexPath.row];
    
    if(selectedIndex == 0)
    {
        //向左偏移到上一月 selectedIndex==0
        [self.calendarScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self scrollTheCalendarToLeft:false];
    }
    else if(selectedIndex == 1)
    {
        //当月 selectedIndex==1
        NSLog(@"current Date = %@",self.currentCalendarDate);
        self.currentSelectedMonthDay = monthDay;
    }
    else{
        //向右偏移到下一月 selectedIndex==2
        [self.calendarScrollView setContentOffset:CGPointMake(self.view.bounds.size.width * 2, 0) animated:YES];
        [self scrollTheCalendarToLeft:true];
    }
    
    // Clear the background color
    if (self.tempSavedCollectionViewCell != NULL) {
        self.tempSavedCollectionViewCell.backgroundColor = UIColor.clearColor;
        self.tempSavedCollectionViewCell.hiddenSelectedView = true;
    }
    
    CalendarCollectionViewCell *cell =(CalendarCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.hiddenSelectedView = false;
    
    switch (collectionView.tag) {
        case 0:
            NSLog(@"indexPath=%@",indexPath);
            break;
            
        case 1:
            NSLog(@"indexPath=%@",indexPath);
            break;
            
        default:
            NSLog(@"default-indexPath=%@",indexPath);
            break;
    }
    
    self.tempSavedCollectionViewCell = cell;
    NSLog(@"After clicked - contentOffset=%@",NSStringFromCGPoint(self.calendarScrollView.contentOffset));
    
    [self refreshData];
    [self.dailyScheduledTableView reloadData];
}

#pragma mark -UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self resignResponderForAllTextFields];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[self.dailyScheduledTableView class]])
        return;
    
    NSLog(@"----CGPoint=%@----frame111=%f",NSStringFromCGPoint(scrollView.contentOffset),CGRectGetWidth(scrollView.frame));
    if (scrollView.contentOffset.x > self.calendarScrollView.bounds.size.width) {
        NSLog(@"向左滑动");
        [self scrollTheCalendarToLeft:true];
    }else if(scrollView.contentOffset.x < self.calendarScrollView.bounds.size.width) {
        NSLog(@"向右滑动");
        [self scrollTheCalendarToLeft:false];
    }
    
    self.calendarScrollView.contentOffset = CGPointMake(self.calendarScrollView.bounds.size.width, 0);
}

/* called when setContentOffset/scrollRectVisible:animated: finishes */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.calendarScrollView.contentOffset = CGPointMake(self.calendarScrollView.bounds.size.width, 0);
}

#pragma mark -Integrated functions
-(NSDateComponents *)getNSDateComponentsByDate:(NSDate *)date{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    return [gregorian components:unitFlags fromDate:date];
}

-(NSInteger)getCurrentDayIndexInMonth:(NSDateComponents *)comp{
    NSDate *currentDate = [NSDate date];
    NSArray *currentDays = [self getMonthDaysByDate:currentDate];
    for (int i=0; i<42; i++) {
        /* It's necessary to check the if the current day index belong to the current month day or not the next or previous month day */
        if ([currentDays[i] integerValue] == comp.day && [self isDayIndexInCurrentMonthWithDate:currentDate dayIndex:i]==1) {
            return i;
        }
    }
    return 0;
}

/*Check当前给定的日期以及对应的dayIndex是否在这个区间内，如果不在，说明dayIndex可能会是上月或下月的日期*/
-(int)isDayIndexInCurrentMonthWithDate:(NSDate *)date dayIndex:(int)dayIndex{
    //得到当月一共多少天
    NSInteger daysOfCurrentMonth = [self getDaysByCurrentMonth:date];
    //得到当月的第一天
    NSInteger indexDay =  [self getFirstDayOfMonth:date];
    
    NSInteger startIndex = indexDay - 1;
    NSInteger endIndex = startIndex + daysOfCurrentMonth - 1;
    if (dayIndex>=startIndex && dayIndex<=endIndex)
        return 1;
    else if(dayIndex<startIndex)
        return 0;
    else
        return 2;
    return false;
}

-(NSArray *)getMonthDaysByDate:(NSDate *)date{
    //得到当月一共多少天
    NSInteger daysOfCurrentMonth = [self getDaysByCurrentMonth:date];
    //得到下月一共多少天
    NSDate *nextMonthDate = [self getPreviousOrNextDateFromDate:date WithMonth:1];
    NSInteger daysOfNextMonth = [self getDaysByCurrentMonth:nextMonthDate];
    
    //得到上月一共多少天
    NSDate *lastMonthDate = [self getPreviousOrNextDateFromDate:date WithMonth:-1];
    NSInteger daysOfLastMonth = [self getDaysByCurrentMonth:lastMonthDate];
    
    //得到当月第一天
    NSInteger indexDay =  [self getFirstDayOfMonth:date];
    NSArray *dateArrayM = [self GetCalendarForCurrentMonthDays:daysOfCurrentMonth FirstDayOfCurrentMonth:indexDay LatMonthDays:daysOfLastMonth];
    
    return dateArrayM;
}

/*根据日期得到日期当月一共有多少天*/
-(NSUInteger)getDaysByCurrentMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentCalendarDate = date;
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentCalendarDate];
    NSUInteger dayOfMonth = range.length;
    return dayOfMonth;
}

/*得到给定日期的第一天*/
-(NSInteger)getFirstDayOfMonth:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
    components.day = 1;
    NSDate *firstDateOfMonthDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSInteger dayOfWeek = [self getWeekdayByDate:firstDateOfMonthDate];
    return dayOfWeek;
}

/*输入当月一共多少天，并且当月的第一天是星期几，之后可以得到日历所需要的当月的所有数据*/
-(NSArray *)GetCalendarForCurrentMonthDays:(NSInteger)monthDays FirstDayOfCurrentMonth:(NSInteger)firstDayOfMonth LatMonthDays:(NSInteger)lastMonthDays{
    NSMutableArray *dateArrayM = [NSMutableArray array];
    NSNumber *iNumber;
    
    int currentMonthIndex = 0;
    int nextMonthIndex = 0;
    int firstDayOfPreviousMonthInCurrentMonth =(int)(lastMonthDays-(firstDayOfMonth-2));
    
    for (int i=0; i<=41; i++) {
        //这里可能需要分成三组
        //第一组: Index为0到First day之间(上个月的最后几天)
        if (i<=firstDayOfMonth-2) {
            iNumber = [NSNumber numberWithInt:firstDayOfPreviousMonthInCurrentMonth];
            firstDayOfPreviousMonthInCurrentMonth++;
        }
        //第二组: 实际显示的天数(这个月的实际日期)
        else if(i>firstDayOfMonth-2 && i<(firstDayOfMonth-1+monthDays)){
            iNumber = [NSNumber numberWithInt:currentMonthIndex+1];
            currentMonthIndex++;
        }
        //第三组: 最后剩余的天数(下个月的前几天)
        else{
            iNumber = [NSNumber numberWithInt:nextMonthIndex+1];
            nextMonthIndex++;
        }
        
        [dateArrayM addObject:iNumber];
    }
    return dateArrayM;
}

-(void)scrollTheCalendarToLeft:(BOOL)IsScrollToLeft{
    //Current date
    NSArray *previousCurrentMonth = [self.totalDict objectForKey:CURRENTMONTH];
    NSArray *previousLastMonth = [self.totalDict objectForKey:LASTMONTH];
    NSArray *previousnextMonth = [self.totalDict objectForKey:NEXTMONTH];
    
    NSArray *currentMonth;
    NSArray *lastMonth;
    NSArray *nextMonth;
    
    if (IsScrollToLeft){
        //左边滑动
        currentMonth = previousnextMonth;
        lastMonth = previousCurrentMonth;
        
        NSDate *nextDate = [self getPreviousOrNextDateFromDate:self.currentCalendarDate WithMonth:2];
        nextMonth = [self getMonthDaysByDate:nextDate];
        
        //重新设置current date
        self.currentCalendarDate = [self getPreviousOrNextDateFromDate:self.currentCalendarDate WithMonth:1];
    }else{
        //右边滑动
        currentMonth = previousLastMonth;
        nextMonth = previousCurrentMonth;
        
        NSDate *lastDate = [self getPreviousOrNextDateFromDate:self.currentCalendarDate WithMonth:-2];
        lastMonth = [self getMonthDaysByDate:lastDate];
        
        //重新设置current date
        self.currentCalendarDate = [self getPreviousOrNextDateFromDate:self.currentCalendarDate WithMonth:-1];
    }
    
    NSDateComponents *comp = [self getNSDateComponentsByDate:self.currentCalendarDate];
    self.currentDayIndex = [self getCurrentDayIndexInMonth:comp];
    self.navigationItem.title = [NSString stringWithFormat:@"%ld年%ld月",comp.year,comp.month];
    
    [self.totalDict setObject:currentMonth forKey:CURRENTMONTH];
    [self.totalDict setObject:lastMonth forKey:LASTMONTH];
    [self.totalDict setObject:nextMonth forKey:NEXTMONTH];
    
    [self.currentCollectionView reloadData];
    [self.nextCollectionView reloadData];
    [self.previousCollectionView reloadData];
    
    [self requestHolidaysInTheNextOrPreviousYear:comp];
}

/* 若切换后发现当前的月份是12月份或者是1月份，那就得准备请求下一年或者上一年的节日信息
 * 不过在这之前，需要先对
 */
-(void)requestHolidaysInTheNextOrPreviousYear:(NSDateComponents *)comp
{
    if (comp.month==12) {
        [self getTheHolidayInfoWithYear:comp.year+1.0f];
    }
    
    if (comp.month == 1) {
        [self getTheHolidayInfoWithYear:comp.year-1.0f];
    }
}

-(void)getTheHolidayInfoWithYear:(NSInteger)year{
    //1.创建NSURLSession对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlStr = @"https://sp0.baidu.com/8aQDcjqpAAV3otqbppnN2DJv/api.php";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    requestM.HTTPMethod = @"POST";
    
    NSString *bodyStr = [NSString stringWithFormat:@"query=%ld&resource_id=%d",year,6018];
    requestM.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:requestM completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        if (resp.statusCode == 200) {
            if (data != NULL) {
                /*服务器的通常是支持中文的，一般都是GBK的code，但是ios中通常使用的UTF-8编码，可以试一下下面的转化方式*/
                NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                NSString *dataStr = [[NSString alloc]initWithData:data encoding:encoding];
                
                NSData *data1 = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableLeaves error:&error];
                
                NSArray *allData = dict[@"data"];
                NSDictionary *firstData = allData.firstObject;
                NSArray *holidayData = [firstData objectForKey:@"holidaylist"];
                
                //得到holiday的数据后，开始字典转模型数据
                for (NSDictionary *holidayDict in holidayData) {
                    PublicHolidayDay *publicHoliday = [PublicHolidayDay initWithDict:holidayDict];
                    [self.publicHolidayList addObject:publicHoliday];
                }
                
                //Fill the holiday records to the current directory
                for (NSDictionary *holidayDict in holidayData) {
                    [self.publicHolidayDictM setObject:holidayDict[@"name"] forKey:holidayDict[@"startday"]];
                }
                
                
            }
        }
    }];
    
    //开始执行
    [task resume];
}

/*根据当前日期，得到下个月或上个月的日期*/
-(NSDate *)getPreviousOrNextDateFromDate:(NSDate *)date WithMonth:(NSInteger)month{
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setMonth:month];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate  = [calendar dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

/*1-7表示
 Sunday、1
 Monday、2
 Tuesday、3
 Wednesday、4
 Thursday、5
 Friday 6
 Saturday 7
 */
-(NSInteger)getWeekdayByDate:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:date];
    return [components weekday];
}

#pragma mark -UITableView Part

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int sectionCount = 0;
    if (self.ongoingTasks.count>0)
        sectionCount++;
    if (self.completedTasks.count>0)
        sectionCount++;
    
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.completedTasks.count;
    }
    return self.ongoingTasks.count;
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
    return 80.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"已完成";
    }
    return @"今天";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

-(void)taskCollectionTableViewCell:(TaskCollectionTableViewCell *)cell selectedIndex:(NSIndexPath *)cellIndex{
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
    [self.dailyScheduledTableView reloadData];
}

@end
