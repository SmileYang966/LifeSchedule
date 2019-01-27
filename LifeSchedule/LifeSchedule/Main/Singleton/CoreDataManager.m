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
    if (_sharedManager == nil) {
        return  [super allocWithZone:zone];
    }
    return [CoreDataManager sharedManager];
}

+ (instancetype)new{
    if (_sharedManager == nil) {
        return  [super new];
    }
    return [CoreDataManager sharedManager];
}

-(id)copyWithZone:(NSZone *)zone{
    return [CoreDataManager sharedManager];
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return [CoreDataManager sharedManager];
}

+(CoreDataManager *)sharedManager{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        if (_sharedManager == nil) {
            _sharedManager = [[CoreDataManager alloc]init];
            //create the initalized context data
            [_sharedManager initData];
        }
    });
    return _sharedManager;
}

-(void)initData{
    //1.创建模型对象
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LifeScheduleDb" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    
    //2.创建持久化助理
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    
    //3.数据库的名称和路径
    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlPath = [docStr stringByAppendingPathComponent:@"lifeSchedule.sqlite"];
    NSURL *url = [NSURL fileURLWithPath:sqlPath];
    
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    
    //4.创建上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //5.关联持久化助理
    [context setPersistentStoreCoordinator:store];
    
    _dBContext = context;
}

@end
