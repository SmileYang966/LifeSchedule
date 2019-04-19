//
//  LSHandleEnterBackground.h
//  LifeSchedule
//
//  Created by Evan Yang on 2019/4/18.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LSHandlerEnterBackgroundBlock)(NSNotification *note, CFAbsoluteTime enterBackgroundTime,CFAbsoluteTime enterForegroundTime);

@interface LSHandleEnterBackground : NSObject

+(void)addObserverUsingBlock:(LSHandlerEnterBackgroundBlock)block;
+(void)removeObserver:(id)observer;

@end

NS_ASSUME_NONNULL_END
