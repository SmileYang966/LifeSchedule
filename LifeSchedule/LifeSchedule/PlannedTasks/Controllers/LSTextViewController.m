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

@interface LSTextViewController ()

@property(nonatomic,strong) UITextView *textView;

@property(nonatomic,strong) NSManagedObjectContext *managedObjContext;

@end

@implementation LSTextViewController

- (instancetype)init{
    if (self=[super init]) {
        self.view = [[UIView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        self.view.backgroundColor = UIColor.blueColor;
        
        self.textView = [[UITextView alloc]initWithFrame:self.view.bounds];
        self.textView.font = [UIFont systemFontOfSize:20.0f];
        [self.view addSubview:self.textView];
        
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setTaskModel:(TaskCollectionModel *)taskModel{
    _taskModel = taskModel;
    
    //Detail info
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:taskModel.taskStartedDate];
    self.navigationItem.title = dateStr;
    self.textView.text = taskModel.taskTitle;
}

@end
