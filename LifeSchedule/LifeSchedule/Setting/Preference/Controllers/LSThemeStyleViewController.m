//
//  LSThemeStyleViewController.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/3/20.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "LSThemeStyleViewController.h"

@interface LSThemeStyleViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSArray *allColorsData;
@property(nonatomic,strong) UIColor *finalSelectedColor;

@end

static NSString *collectionCellReuseId = @"collectionCellID";
CGFloat cellMargin = 10.0f;

@implementation LSThemeStyleViewController

- (NSArray *)allColorsData{
    if (_allColorsData == NULL) {
        NSMutableArray *arrayM = [NSMutableArray array];
        [arrayM addObject:[UIColor redColor]];
        [arrayM addObject:[UIColor blueColor]];
        [arrayM addObject:[UIColor orangeColor]];
        [arrayM addObject:[UIColor yellowColor]];
        [arrayM addObject:[UIColor brownColor]];
        _allColorsData = arrayM;
    }
    return _allColorsData;
}

- (UICollectionView *)collectionView{
    if (_collectionView == NULL) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemWidth = (int)((self.view.bounds.size.width - 4 * cellMargin) / 3.0f) * 1.0f;
        CGFloat itemHeight = 150.0f;
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        
        CGFloat collectionViewX = cellMargin;
        CGFloat collectionViewY = cellMargin;
        CGFloat collectionViewWidth = self.view.bounds.size.width - 2*collectionViewX;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(collectionViewX, collectionViewY+Height_TopBar,collectionViewWidth,self.view.bounds.size.height) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionCellReuseId];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.collectionView.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"恢复" style:UIBarButtonItemStylePlain target:self action:@selector(recoverClicked:)];
}

-(void)recoverClicked:(UIBarButtonItem *)barButtonItem{
    /*Remove the selected theme's index in the Preference*/
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"SelectedThemeIndex"];
    
    NSDictionary *userDict = @{@"Color" : UIColor.whiteColor};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ThemeChangedNotification" object:nil userInfo:userDict];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellReuseId forIndexPath:indexPath];
    UIColor *bgColor = TotalColorsData[indexPath.row];
    cell.backgroundColor = bgColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIColor *color = TotalColorsData[indexPath.row];
    NSDictionary *userDict = @{@"Color" : color};
    
    /*Save the selected theme's index in the Preference*/
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:indexPath.row forKey:@"SelectedThemeIndex"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ThemeChangedNotification" object:nil userInfo:userDict];
    self.finalSelectedColor = color;
}

@end
