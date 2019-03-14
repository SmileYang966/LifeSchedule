//
//  AboutUsScreenViewController.m
//  LifeSchedule
//
//  Created by Evan Yang on 2018/12/3.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "AboutUsScreenViewController.h"

@interface AboutUsScreenViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *iconView;
@property(nonatomic,strong) UITableView *aboutTableView;

@end

@implementation AboutUsScreenViewController

- (instancetype)init{
    if (self=[super init]) {
        self.view.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

-(UIView *)iconView{
    if (_iconView == NULL) {
        _iconView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,200)];
        _iconView.backgroundColor = UIColor.brownColor;
        [self.view addSubview:_iconView];
    }
    return _iconView;
}

- (UITableView *)aboutTableView{
    if (_aboutTableView == NULL) {
        CGRect aboutTableViewFrame = CGRectMake(0,CGRectGetMaxY(self.iconView.frame),self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.iconView.frame));
        _aboutTableView = [[UITableView alloc]initWithFrame:aboutTableViewFrame style:UITableViewStyleGrouped];
        _aboutTableView.delegate = self;
        _aboutTableView.dataSource = self;
        [self.view addSubview:_aboutTableView];
    }
    return _aboutTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self aboutTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CELLID = @"aboutTableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (cell == NULL) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELLID];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"版本";
            cell.detailTextLabel.text = @"V0.01";
            break;
          
        case 1:
            cell.textLabel.text = @"邮箱";
            cell.detailTextLabel.text = @"evanyang966@163.com";
            break;
    }

    return cell;
}

@end
