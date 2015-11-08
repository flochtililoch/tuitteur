//
//  AppDelegate.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/3/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "AppDelegate.h"
#import "NavigationViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "TwitterClient.h"
#import "User.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserDidChange)  name:kCurrentUserDidChangeNotification object:nil];
    [self currentUserDidChange];

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)currentUserDidChange {

    if ([User currentUser] != nil) {
        UINavigationController *nvc = [[NavigationViewController alloc] init];
        self.window.rootViewController = nvc;
        [nvc setViewControllers:[NSArray arrayWithObject:[[HomeViewController alloc] init]]];
    } else {
        self.window.rootViewController = [[LoginViewController alloc] init];
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([url.host isEqual: @"oauth"]) {
        // TODO: maybe move this to a class method on User ?
        [[TwitterClient sharedInstance] completeAuthWithQueryString:url.query];
    }
    return YES;
}

@end
