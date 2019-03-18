//
//  ConfigurationViewController.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/18.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "ConfigurationTimeSetCell.h"

@interface ConfigurationViewController ()<ConfigurationTimeSetCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) NSArray *dataArray;

@end

@implementation ConfigurationViewController

- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title;
    ConfigurationTimeSetCell *timeSetCell = NULL;
    switch (indexPath.row) {
        case 0:
            timeSetCell = [ConfigurationTimeSetCell timeSetCellWithTitle:@"工作时间" timeCategory:WorkingTime];
            break;
       
        case 1:
            timeSetCell = [ConfigurationTimeSetCell timeSetCellWithTitle:@"休息时间" timeCategory:BreakTime];
            break;
            
        default:
            break;
    }
    timeSetCell.delegate = self;
    return timeSetCell;
}

- (void)timeSetClickedWithCategory:(TimeCategory)category{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSLog(@"cgrect==%@",NSStringFromCGRect(alertController.view.frame));
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 360, 200)];
    [self.view addSubview:self.pickerView];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    [alertController.view addSubview:self.pickerView];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger selectedIndex = [self.pickerView selectedRowInComponent:0];
        NSNumber *selectedTimeNum = self.dataArray[selectedIndex];
        NSInteger recordedMinutes = [selectedTimeNum integerValue];
        //Distinguish the workingTime or BreakTime
        
    }]];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    [arrayM addObjectsFromArray:@[@15,@30,@45,@60]];
    self.dataArray = arrayM;
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //Only have 1 column
    NSNumber *numberObj = self.dataArray[row];
    return [NSString stringWithFormat:@" %ld 分钟",[numberObj integerValue]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    int a = 10;
}



@end
