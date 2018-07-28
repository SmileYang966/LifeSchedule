//
//  LSAudioPlayTool.m
//  LifeSchedule
//
//  Created by Evan Yang on 2018/7/24.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "LSAudioPlayTool.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation LSAudioPlayTool

+(void)playAudioWithPath:(NSString *)audioPath finishedAudioPlay:(void(^)(void))inCompletionBlock{
    
    CFURLRef audioURL = (__bridge CFURLRef _Nonnull)[NSURL fileURLWithPath:audioPath];
    SystemSoundID soundId = 0;
    if (audioURL) {
        OSStatus error = AudioServicesCreateSystemSoundID(audioURL, &soundId);
        //判断是否有错误
        if (error != kAudioServicesNoError) {
            NSLog(@"%d",(int)error);
        }
    }
    
    AudioServicesPlayAlertSoundWithCompletion(soundId,inCompletionBlock);
}

@end
