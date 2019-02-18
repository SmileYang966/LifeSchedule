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

@end

@implementation LSTextViewController

- (instancetype)init{
    if (self=[super init]) {
        self.view = [[UIView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        self.view.backgroundColor = UIColor.blueColor;
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
}

@end
