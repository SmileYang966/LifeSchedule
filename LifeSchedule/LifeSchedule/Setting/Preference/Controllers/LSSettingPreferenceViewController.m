//
//  LSSettingPreferenceViewController.m
//  LifeSchedule
//
//  Created by 杨善成 on 18/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "LSSettingPreferenceViewController.h"
#import "LSThemeStyleViewController.h"
#import "LSFontStyleViewController.h"

@interface LSSettingPreferenceViewController ()

@end

@implementation LSSettingPreferenceViewController

- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.view.backgroundColor = AppMajorTintColor;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"CELLID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == NULL) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"主题样式";
            break;
            
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *destVC = NULL;
    switch (indexPath.row) {
        case 0:
            destVC = [[LSThemeStyleViewController alloc]init];
            destVC.title = @"主题样式";
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:destVC animated:YES];
}

@end
