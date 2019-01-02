//
//  PublicHolidayDay.m
//  Ios-ScrollView+CollectionView
//
//  Created by Evan Yang on 2018/11/24.
//  Copyright © 2018 Evan. All rights reserved.
//

#import "PublicHolidayDay.h"

@implementation PublicHolidayDay

+(instancetype)initWithDict:(NSDictionary *)holidayDict{
    PublicHolidayDay *holiday = [[PublicHolidayDay alloc]init];
    holiday.holidayDate = holidayDict[@"startday"];
    holiday.holidayDayDesc = holidayDict[@"name"];
    return holiday;
}

@end
