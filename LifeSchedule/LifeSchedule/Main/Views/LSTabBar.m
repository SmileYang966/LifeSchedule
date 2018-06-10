//
//  LSTabBar.m
//  LifeSchedule
//
//  Created by 杨善成 on 11/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "LSTabBar.h"

@implementation LSTabBar

-(instancetype)init{
    if (self = [super init]) {
        
        //1. Add all the subViews
        
    }
    return self;
}


-(void)addSubButtons{
    for (int i=0; i<4; i++) {
        UIButton *button = [[UIButton alloc]init];
        [self addSubview:button];
    }
}

//设置4个button的frames
- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (UIButton *button in self.subviews) {
        
    }
}

@end
