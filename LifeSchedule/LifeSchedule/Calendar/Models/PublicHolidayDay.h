//
//  PublicHolidayDay.h
//  Ios-ScrollView+CollectionView
//
//  Created by Evan Yang on 2018/11/24.
//  Copyright © 2018 Evan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PublicHolidayDay : NSObject
@property(nonatomic,copy) NSString *holidayDate;
@property(nonatomic,copy) NSString *holidayDayDesc;

+(instancetype)initWithDict:(NSDictionary *)holidayDict;

@end

NS_ASSUME_NONNULL_END
