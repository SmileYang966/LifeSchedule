//
//  CoreDataManager.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/1/6.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "CoreDataManager.h"



@implementation CoreDataManager

static CoreDataManager * _sharedManager;


+(id)allocWithZone:(struct _NSZone *)zone{
    //第一次alloc和init的时候，就会调用super的方法
    if (_sharedManager == nil) {
        return  [super allocWithZone:zone];
    }
    return [CoreDataManager coreDataSharedManager];
}

-(id)copyWithZone:(NSZone *)zone{
    return [CoreDataManager coreDataSharedManager];
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return [CoreDataManager coreDataSharedManager];
}

+(CoreDataManager *)coreDataSharedManager{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        if (_sharedManager == nil) {
            _sharedManager = [[CoreDataManager alloc]init];
        }
    });
    return _sharedManager;
}

@end
