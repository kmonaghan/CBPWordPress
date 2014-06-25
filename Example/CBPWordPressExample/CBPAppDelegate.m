//
//  CBPAppDelegate.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 29/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <GooglePlus/GooglePlus.h>

#import "CBPAppDelegate.h"

#import "CBPHomeViewController.h"
#import "CBPWordPressAPIClient.h"

@interface CBPAppDelegate()
@property (nonatomic) CBPHomeViewController *viewController;
@end

@implementation CBPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [CBPWordPressAPIClient rootURI:@"http://broadsheet.ie"];
                                                           
    self.viewController = [CBPHomeViewController new];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];

    //[GPPSignIn sharedInstance].clientID = @"864709573863-rr1na3aqu5embrr4fc15dkp5i8g7fmdm.apps.googleusercontent.com";
    
    [self firstTime:application];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // handle Google+ Sign In callback URL
    return [[GPPSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self.viewController backgroundUpdateWithCompletionHandler:completionHandler];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark -
- (void)firstTime:(UIApplication *)application
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:CBPFirstTime]) {
        return;
    }

    [application setMinimumBackgroundFetchInterval:CBPBacgroundFetchInterval];
    [defaults setBool:YES forKey:CBPBackgroundUpdate];
    
    [self setupNotification];
    
    [defaults setBool:YES forKey:CBPFirstTime];
    
    [defaults synchronize];
}

- (void)setupNotification
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:CBPLocationNotifcation]) {
        return;
    }
    
    NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:84600];
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDateComponents *dateComps = [calendar components: NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:tomorrow];
    [dateComps setHour:8];
    [dateComps setMinute:15];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    
    UILocalNotification *localnotifcation = [UILocalNotification new];
    
    if (!localnotifcation) {
        return;
    }
    
    NSLog(@"itemDate: %@", [itemDate description]);
    localnotifcation.fireDate = itemDate;
    localnotifcation.timeZone = [NSTimeZone defaultTimeZone];
    localnotifcation.repeatInterval = NSCalendarUnitWeekday;
    
    localnotifcation.alertBody = NSLocalizedString(@"Catch up on all the news that doesn't matter.", nil);
    localnotifcation.alertAction = NSLocalizedString(@"Read More", nil);
    
    localnotifcation.soundName = UILocalNotificationDefaultSoundName;
    localnotifcation.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localnotifcation];
    
    [dateComps setHour:17];
    [dateComps setMinute:45];
    itemDate = [calendar dateFromComponents:dateComps];
    localnotifcation.fireDate = itemDate;

    [[UIApplication sharedApplication] scheduleLocalNotification:localnotifcation];

    [defaults setBool:YES forKey:CBPLocationNotifcation];
    [defaults setBool:YES forKey:CBPDailyReminder];
    
    [defaults synchronize];
}

@end
