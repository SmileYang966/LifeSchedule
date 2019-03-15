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
        _iconView.backgroundColor = UIColor.clearColor;
        UIImage *img = [UIImage imageNamed:@"list.png"];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-img.size.width)*0.5f, (_iconView.bounds.size.height-img.size.height-64)*0.5 + 54 , img.size.width, img.size.height)];
        imgView.image = img;
        [_iconView addSubview:imgView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.origin.x-3, CGRectGetMaxY(imgView.frame)-10.0f, imgView.frame.size.width+20, 30.0f)];
//        label.font = [UIFont fontWithName:@"Cloudtype-JGjingxinkaiGB-Regular" size:23.0f];
        label.font = [UIFont fontWithName:@"IowanOldStyle-BoldItalic" size:21.0f];
        label.textColor = [UIColor colorWithRed:66/255.0 green:130/255.0 blue:210/255.0 alpha:1.0f];
        label.text = @"LifeSchedule";
        
        [self.view addSubview:_iconView];
        [self.view addSubview:label];
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
    
    /*Check the all supported fonts
    for (NSString *fontFamilyName in [UIFont familyNames]) {
        NSLog(@"fontFamilyName=%@",fontFamilyName);
        for (NSString *fontName in [UIFont fontNamesForFamilyName:fontFamilyName]) {
            NSLog(@"font:%@",fontName);
        }
        NSLog(@"-------------\n\n");
    }
    */
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
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
            cell.textLabel.text = @"作者";
            cell.detailTextLabel.text = @"Evan Yang";
            break;
        case 2:
            cell.textLabel.text = @"邮箱";
            cell.detailTextLabel.text = @"evanyang966@163.com";
            break;
    }

    return cell;
}

@end
