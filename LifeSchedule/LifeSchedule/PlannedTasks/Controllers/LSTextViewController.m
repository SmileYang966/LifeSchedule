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

@interface LSTextViewController ()<UITextViewDelegate>

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
        self.textView.returnKeyType = UIReturnKeyDone;
        [self.view addSubview:self.textView];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(backAndSaveData)];
    }
    return self;
}

- (NSManagedObjectContext *)managedObjContext{
    if (_managedObjContext == NULL) {
        _managedObjContext = [CoreDataManager sharedManager].dBContext;
    }
    return _managedObjContext;
}

-(void)backAndSaveData{
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

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self backAndSaveData];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
