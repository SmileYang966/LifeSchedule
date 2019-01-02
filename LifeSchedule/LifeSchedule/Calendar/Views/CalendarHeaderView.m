//
//  CalendarHeaderView.m
//  IOS_UICollectionView_Calendar
//
//  Created by Evan Yang on 2018/8/26.
//  Copyright © 2018 Evan. All rights reserved.
//

#import "CalendarHeaderView.h"

@interface CalendarHeaderView()

@property(nonatomic,strong) NSArray *titles;

@end

@implementation CalendarHeaderView

- (NSArray *)titles{
    return @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i=0; i<7; i++) {
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.text = self.titles[i];
            titleLabel.textColor = UIColor.blackColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            CGFloat width = frame.size.width / 7.0;
            CGFloat height = frame.size.height - 1;
            CGFloat x = width * i;
            CGFloat y = 0;
            titleLabel.frame = CGRectMake(x, y, width, height);
            [self addSubview:titleLabel];
        }
        
        UILabel *separateLine = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        separateLine.backgroundColor = UIColor.lightGrayColor;
        [self addSubview:separateLine];
    }
    return self;
}

@end
