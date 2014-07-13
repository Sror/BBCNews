//
//  BBCAppDelegate.m
//  BBCNews
//
//  Created by Sergey Shulga on 7/9/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCAppDelegate.h"
#import "BBCFeedTableViewController.h"

@implementation BBCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BBCFeedTableViewController *feedController = [[BBCFeedTableViewController alloc] initWithNibName:nil bundle:nil];
    
    UINavigationController *navidationController = [[UINavigationController alloc] initWithRootViewController:feedController];
    
    self.window.rootViewController = navidationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[BBCCoreDataManager manager].managedObjectContext save:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application{
    [[BBCCoreDataManager manager].managedObjectContext save:nil];
}


@end
