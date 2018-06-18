//
//  LSSettingCellModel.h
//  LifeSchedule
//
//  Created by 杨善成 on 17/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LSSettingCellModel : NSObject

@property(nonatomic,copy) NSString *iconName;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *detailDesc;
@property(nonatomic,assign) CellRightView cellRightView;

+(instancetype)LSSettingCellModelWithTitle:(NSString *)title iconWithName:(NSString *)iconName rightView:(CellRightView) cellRightView;

@end
