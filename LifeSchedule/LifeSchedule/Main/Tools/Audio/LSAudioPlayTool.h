//
//  LSAudioPlayTool.h
//  LifeSchedule
//
//  Created by Evan Yang on 2018/7/24.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSAudioPlayTool : NSObject

+(void)playAudioWithPath:(NSString *)audioPath finishedAudioPlay:(void(^)(void))inCompletionBlock;

@end
