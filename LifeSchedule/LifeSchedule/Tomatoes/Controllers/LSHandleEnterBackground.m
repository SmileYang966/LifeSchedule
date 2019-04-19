//
//  LSHandleEnterBackground.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/4/18.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "LSHandleEnterBackground.h"

@implementation LSHandleEnterBackground

+(void)addObserverUsingBlock:(LSHandlerEnterBackgroundBlock)block{
    __block CFAbsoluteTime enterBackgroundTime;
    [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if (![note.object isKindOfClass:[UIApplication class]]) {
            enterBackgroundTime = CFAbsoluteTimeGetCurrent();
        }
    }];
    __block CFAbsoluteTime enterForegroundTime;
    [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if (![note.object isKindOfClass:[UIApplication class]]) {
            enterForegroundTime = CFAbsoluteTimeGetCurrent();
            block ? block(note,enterBackgroundTime,enterForegroundTime) : nil;
        }
    }];
}

+(void)removeObserver:(id)observer{
    if (!observer) {
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:UIApplicationWillEnterForegroundNotification object:nil];
}

@end
