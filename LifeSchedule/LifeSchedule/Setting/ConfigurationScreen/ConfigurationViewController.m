//
//  ConfigurationViewController.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/18.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "ConfigurationTimeSetCell.h"
#import "ConfigurationTimeSetModel.h"
#import "Setting+CoreDataClass.h"

@interface ConfigurationViewController ()<ConfigurationTimeSetCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) NSArray *totalData;
@property(nonatomic,strong) NSArray *dataArray;

/*DB part*/
@property(nonatomic,strong) NSManagedObjectContext *managedObjContext;

@end

@implementation ConfigurationViewController

- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

- (NSManagedObjectContext *)managedObjContext{
    if (_managedObjContext == NULL) {
        _managedObjContext = [CoreDataManager sharedManager].dBContext;
    }
    return _managedObjContext;
}

- (NSArray *)totalData{
    if (_totalData == NULL) {
        NSMutableArray *arrayM = [NSMutableArray array];
        
        Setting *workTimeSetting = [self querySettingObjectWithKeyName:@"workTime"];
        Setting *breakTimeSetting = [self querySettingObjectWithKeyName:@"breakTime"];
        
        ConfigurationTimeSetModel *model1 = [ConfigurationTimeSetModel CreateConfigurationTimeSetModelWithTitle:@"工作时间" matchedValue:[NSString stringWithFormat:@"%@分钟",workTimeSetting.settingValue] category:WorkingTime];
        ConfigurationTimeSetModel *model2 = [ConfigurationTimeSetModel CreateConfigurationTimeSetModelWithTitle:@"休息时间" matchedValue:[NSString stringWithFormat:@"%@分钟",breakTimeSetting.settingValue] category:BreakTime];
        [arrayM addObject:model1];
        [arrayM addObject:model2];
        
        _totalData = arrayM;
    }
    return _totalData;
}

-(Setting *)querySettingObjectWithKeyName:(NSString *)settingKeyName{
    NSError *error = NULL;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Setting"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"settingKeyName=%@",settingKeyName];
    fetchRequest.predicate = predicate;
    return [[self.managedObjContext executeFetchRequest:fetchRequest error:&error] firstObject];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConfigurationTimeSetCell *timeSetCell = [ConfigurationTimeSetCell timeSetCell];
    timeSetCell.timeSetModel = self.totalData[indexPath.row];
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
        NSLog(@"recordedMinutes=%ld",recordedMinutes);
        NSString *updatedTimeSetValue = [NSString stringWithFormat:@"%ld分钟",recordedMinutes];
        [self updateTimeSetValue:updatedTimeSetValue withTimeCategory:category];
        
        
        Setting *settingItem = NULL;
        NSError *error = NULL;
        if (category == WorkingTime) {
            settingItem = [self querySettingObjectWithKeyName:@"workTime"];
        }else if(category == BreakTime){
            settingItem = [self querySettingObjectWithKeyName:@"breakTime"];
        }
        settingItem.settingValue = [NSString stringWithFormat:@"%ld",recordedMinutes];
        
        //Any changes need to be updated to the db
        if ([self.managedObjContext hasChanges]) {
            [self.managedObjContext save:&error];
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    [arrayM addObjectsFromArray:@[@15,@30,@45,@60]];
    self.dataArray = arrayM;
}

-(void)updateTimeSetValue:(NSString *)updatedValue withTimeCategory:(TimeCategory)timeCategory{
    NSMutableArray *updatedArrayM = [NSMutableArray array];
    for (ConfigurationTimeSetModel *timeSetModel in self.totalData) {
        if (timeSetModel.timeCategory == timeCategory) {
            timeSetModel.configItemValue = updatedValue;
        }
        [updatedArrayM addObject:timeSetModel];
    }
    self.totalData = updatedArrayM;
    [self.tableView reloadData];
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
}

@end
