//
//  LSSettingSectionModel.h
//  LifeSchedule
//
//  Created by 杨善成 on 18/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSSettingSectionModel : NSObject

@property(nonatomic,copy) NSString *sectionHeaderTitle;
@property(nonatomic,strong) NSArray *sectionItems;
@property(nonatomic,copy) NSString *sectionFooterTitle;

@end
