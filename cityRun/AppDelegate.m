//
//  AppDelegate.m
//  cityRun
//
//  Created by Basir Alam on 14/03/17.
//  Copyright © 2017 Basir. All rights reserved.
//

#import "AppDelegate.h"

@import GoogleMaps;

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 10, 10);
    UIImage *backArrowImage = [[UIImage imageNamed:@"arr"] imageWithAlignmentRectInsets:insets];
    
    [[UINavigationBar appearance] setBackIndicatorImage:backArrowImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backArrowImage];
    
    [GMSServices provideAPIKey:@"AIzaSyD0XDzIuhYrdIcXGXinc5Lsjd-av0BcaYM"];

    //PayPal id SetUp
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"",
                                                           PayPalEnvironmentSandbox : @"AYOVVpc3e5YNjbU7eiuu_cmhpfAcc-GAFjYj1qSBq0bRPH9kbqvgQYef3A0gvNXOZvdYNYJ6mHFpvXmZ"}];
    
    
    //Goto the particular screen of storyboard
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [self application:application didReceiveRemoteNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
        
    }
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }

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
    application.applicationIconBadgeNumber = 0;

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    
    //Format token as you need:
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSLog(@"deviceToken: %@", token);
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"deviceID"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)application:(UIApplication *)application

didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Failed to get token, error: %@", error);
    
}

- (void)application:(UIApplication *)application

didReceiveRemoteNotification:(NSDictionary *)userInfo

{
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  )
    {
        NSLog(@"Received notification: %@", userInfo);
        
        int page = [[[userInfo valueForKey:@"aps"]valueForKey:@"page"]intValue] ;
        
        NSLog(@"%d",page);
        
    }
    
}

@end
