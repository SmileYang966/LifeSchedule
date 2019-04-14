//
//  AppDelegate.m
//  LifeSchedule
//
//  Created by 杨善成 on 6/6/2018.
//  Copyright © 2018 EvanYang. All rights reserved.
//

#import "AppDelegate.h"
#import "LSMainTabBarViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <AVFoundation/AVFoundation.h>
#import "LaunchViewController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    LSMainTabBarViewController *mainTabBarController = [[LSMainTabBarViewController alloc]init];
    
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstTimeToEnterTheScreen"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTimeToEnterTheScreen"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstTimeToEnterTheScreen"];
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[LaunchViewController alloc]init]];
    }else{
        self.window.rootViewController = mainTabBarController;
    }
    
    [self.window makeKeyWindow];
    
    //Register local Push Notification
    [self registerAPN];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//Register local Push Notification
-(void)registerAPN{
    
    //1. Regiater the NotificationCenter
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionSound  completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
    }];
    
    //Remove all delived notification(Delived but have not been deleted from notification center)
    [center removeAllDeliveredNotifications];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSLog(@"-----willPresentNotification-----");
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSLog(@"-----didReceiveNotificationResponse-----");
    //1. Process special logic
    
    
    //2. After the logic was processed,just remove the penging notification
    UNNotificationRequest *notiRequest = response.notification.request;
    UNNotificationTrigger *trigger = notiRequest.trigger;
    if (notiRequest != nil) {
        NSString *notificationID = [notiRequest.identifier stringByTrimmingCharactersInSet:[NSMutableCharacterSet whitespaceCharacterSet]];
        if (notificationID.length != 0 && !trigger.repeats) {
            [center removePendingNotificationRequestsWithIdentifiers:@[notificationID]];
        }
    }
    
    //3. Need to call the completionHandler as the apple spec asked.
    completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    NSLog(@"----openSettingsForNotification----");
}

@end
