//
//  CoreDataManager.h
//  LifeSchedule
//
//  Created by Evan Yang on 2019/1/6.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataManager : NSObject

+(CoreDataManager *)sharedManager;

/*Can not build well if they use the below way to create the instance*/
/*
+ (instancetype) new __attribute__((unavailable("The CoreDataManager could be instantiated only by using the coreDataSharedManager")));
- (id)copy __attribute__((unavailable("The CoreDataManager could be instantiated only by using the coreDataSharedManager")));
- (id)mutableCopy __attribute__((unavailable("The CoreDataManager could be instantiated only by using the coreDataSharedManager")));
*/

@property(nonatomic,strong) NSManagedObjectContext *dBContext;
 
@end

NS_ASSUME_NONNULL_END
