//
//  LSPlayAudioTool.h
//  LifeSchedule
//
//  Created by Evan Yang on 2019/4/24.
//  Copyright © 2019 EvanYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSPlayAudioTool : NSObject

+(void)playAudioWithAudioName:(NSString *)audioName audioType:(NSString *)audioType;

@end

NS_ASSUME_NONNULL_END
