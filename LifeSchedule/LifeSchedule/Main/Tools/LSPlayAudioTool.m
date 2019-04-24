//
//  LSPlayAudioTool.m
//  LifeSchedule
//
//  Created by Evan Yang on 2019/4/24.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import "LSPlayAudioTool.h"
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@implementation LSPlayAudioTool

+(void)playAudioWithAudioName:(NSString *)audioName audioType:(NSString *)audioType{
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:audioName ofType:audioType];
    NSURL *soundURL = [NSURL URLWithString:soundFile];
    SystemSoundID sounderID = 0;
    @try {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(soundURL), &sounderID);
        AudioServicesPlaySystemSound(sounderID);
    } @catch (NSException *exception) {
        NSLog(@"Play the audio failed with exception=%@",exception.userInfo);
    } @finally {
        NSLog(@"Play the auido end");
    }
}

@end
