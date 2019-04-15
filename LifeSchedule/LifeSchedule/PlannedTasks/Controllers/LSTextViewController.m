//
//  LSTextViewController.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/2/18.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "LSTextViewController.h"
#import "TaskCollectionModel.h"
#import "TimeActivity+CoreDataProperties.h"

@interface LSTextViewController ()<UITextViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong) UITextView *textView;

@property(nonatomic,strong) NSManagedObjectContext *managedObjContext;

@end

@implementation LSTextViewController

- (instancetype)init{
    if (self=[super init]) {
        self.view = [[UIView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        self.view.backgroundColor = UIColor.blueColor;
        
        self.textView = [[UITextView alloc]initWithFrame:self.view.bounds];
        self.textView.delegate = self;
        self.textView.font = [UIFont systemFontOfSize:20.0f];
        self.textView.returnKeyType = UIReturnKeyNext;
        [self.view addSubview:self.textView];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(backAndSaveData)];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClicked:)];
    }
    return self;
}

- (NSManagedObjectContext *)managedObjContext{
    if (_managedObjContext == NULL) {
        _managedObjContext = [CoreDataManager sharedManager].dBContext;
    }
    return _managedObjContext;
}

-(void)backButtonClicked:(UIBarButtonItem *)barButtonItem{
    
    [self.textView resignFirstResponder];
    
    //Original navigationItem title
    NSString *originalNavigationItemTitle = self.taskModel.taskTitle;
    
    //After changed
    NSString *changedTitle = self.textView.text;
    
    //Compare the two string
    if ([originalNavigationItemTitle compare:changedTitle] != kCFCompareEqualTo) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"是否需要保存最新的修改？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self backAndSaveData];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)backAndSaveData{
    [self.textView resignFirstResponder];
    
    // Before press back button, we saved the description again
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TimeActivity"];
    [request setReturnsObjectsAsFaults:NO];
    request.resultType = NSManagedObjectResultType;
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"plannedBeginDate=%@ && activityDescription=%@",_taskModel.taskStartedDate,_taskModel.taskTitle];
    [request setPredicate:pre];
    
    NSArray *timeActivityDbArray = [self.managedObjContext executeFetchRequest:request error:nil];
    for (TimeActivity *act in timeActivityDbArray) {
        act.activityDescription = self.textView.text;
    }
    NSError *error;
    if([self.managedObjContext save:&error])
    {
        NSLog(@"Update the database successfully");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setTaskModel:(TaskCollectionModel *)taskModel{
    _taskModel = taskModel;
    
    //Detail info
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:taskModel.taskStartedDate];
    self.navigationItem.title = dateStr;
    self.textView.text = taskModel.taskTitle;
}

#pragma mark - UIGestureRecognizerDelegate
//这个方法是在手势将要激活前调用：返回YES允许右滑手势的激活，返回NO不允许右滑手势的激活
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }else{
        return YES;
    }
}

@end
