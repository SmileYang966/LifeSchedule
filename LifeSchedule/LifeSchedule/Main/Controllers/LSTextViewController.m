//
//  LSTextViewController.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/2/18.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "LSTextViewController.h"
#import "TaskCollectionModel.h"

@interface LSTextViewController ()
@property(nonatomic,strong) UITextView *textView;
@end

@implementation LSTextViewController

- (instancetype)init{
    if (self=[super init]) {
        self.view = [[UIView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        self.view.backgroundColor = UIColor.blueColor;
        
        self.textView = [[UITextView alloc]initWithFrame:self.view.bounds];
        self.textView.font = [UIFont systemFontOfSize:20.0f];
        [self.view addSubview:self.textView];
        
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setTaskModel:(TaskCollectionModel *)taskModel{
    _taskModel = taskModel;
    self.navigationItem.title = taskModel.taskDetailedInfo;
    self.textView.text = taskModel.taskTitle;
}

@end
