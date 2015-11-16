//
//  AppDelegate.m
//  hoosright
//
//  Created by Rupam Chakraborty on 5/21/15.
//  Copyright (c) 2015 Brandoitte. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeVC.h"
#import "SWRevealViewController.h"
#import "RearViewController.h"
#import "NewsFeedVC.h"
#import "SearchVC.h"
#import "AVCamViewController.h"
#import "NotificationVC.h"

#import "CustomTabBarViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "MyProfileVC.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate ()<SWRevealViewControllerDelegate>
{
    UINavigationController *navController;
}
@property (strong, nonatomic) SWRevealViewController *viewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    
    [UIApplication sharedApplication].
    statusBarStyle = UIStatusBarStyleLightContent;  //make status bar white.
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];//navigation bar tin color
    
    
    
   // [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1 green:0.286 blue:0.255 alpha:1.0]];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    
    
    /*
     if ([[UIScreen mainScreen] bounds].size.height < 570) {
     
     
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationImage2"]forBarMetrics:UIBarMetricsDefault];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667)
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationImage1"]forBarMetrics:UIBarMetricsDefault];
    }
    
    else
    {
       [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationImage3"]forBarMetrics:UIBarMetricsDefault];
    }
     */
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navImage"]forBarMetrics:UIBarMetricsDefault];
     
     
    
    
    
    /*
     
     [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationImage1"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
     
     */

    
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"Loginstatus"];
    
    SWRevealViewController *revealController;
    
    
//    if ([savedValue isEqual:@"Login"]) {
    
       
        
       

        NewsFeedVC *NewsFeedVC_=[[NewsFeedVC alloc] initWithNibName:@"NewsFeedVC" bundle:nil];
        
        RearViewController *rearViewController = [[RearViewController alloc] init];
    
    NewsFeedVC_.from =@"Timeline";
        
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:NewsFeedVC_];
        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
        
        revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
        

        
        revealController.delegate = self;
        self.viewController = revealController;
        
        
    /*
    }
    else
    {
        
        
        NewsFeedVC *NewsFeedVC_ =[[NewsFeedVC alloc] initWithNibName:@"NewsFeedVC" bundle:nil];
       
        
        RearViewController *rearViewController = [[RearViewController alloc] init];
        
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:NewsFeedVC_];
        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
        
        revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
        revealController.delegate = self;
        //self.viewController = revealController;
        //self.window.rootViewController = self.viewController;
        
        
        
    }
    
    
    */
    
    
    NotificationVC *NotificationVC_ = [[NotificationVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:NotificationVC_];
    
    /*
     
     AVCamViewController *AVCamViewController_ = [[AVCamViewController alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:AVCamViewController_];
     
     */
    
    MyProfileVC *MyProfileVC_ = [[MyProfileVC alloc]init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:MyProfileVC_];
    
    NewsFeedVC_ = [[NewsFeedVC alloc]init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:NewsFeedVC_];
   
    
    
    CustomTabBarViewController * _CustomTabBarViewController = [[CustomTabBarViewController alloc] init];
    
    
        
        _CustomTabBarViewController.tabBarItems = [NSArray arrayWithObjects:
                                                   [NSDictionary dictionaryWithObjectsAndKeys:@"TabHome", @"image", revealController, @"viewController", nil],
                                                   
                                                   [NSDictionary dictionaryWithObjectsAndKeys:@"TabNoti2", @"image", nav, @"viewController", nil],
                                                   
                                                   [NSDictionary dictionaryWithObjectsAndKeys:@"TabCamera", @"image",nil, nil, nil],
                                                   
                                                   [NSDictionary dictionaryWithObjectsAndKeys:@"TabNoti1", @"image", nav2, @"viewController", nil],
                                                   
                                                   [NSDictionary dictionaryWithObjectsAndKeys:@"TabFev", @"image", nav3, @"viewController", nil], nil];
    
   

    [self.window makeKeyAndVisible];
    self.window.rootViewController = _CustomTabBarViewController;
    
    
    HomeVC *HomeVC_ = [[HomeVC alloc]init];
    UINavigationController *nav0 = [[UINavigationController alloc] initWithRootViewController:HomeVC_];
    
    if (![savedValue isEqual:@"Login"]) {
        
        [self.window.rootViewController presentViewController:nav0 animated:NO completion:nil];
       
        
    }
    
    
    
    
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
   // [FBSDKAppEvents activateApp];
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];

//    return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                          openURL:url
//                                                sourceApplication:sourceApplication
//                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.brandoitte.hoosright" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"hoosright" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"hoosright.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
