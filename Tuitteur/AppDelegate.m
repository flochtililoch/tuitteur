//
//  AppDelegate.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/3/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "AppDelegate.h"
#import "HamburgerViewController.h"
#import "MenuViewController.h"
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
        HamburgerViewController *hamburgerViewController = [[HamburgerViewController alloc] init];

        MenuViewController *vcMenu = [[MenuViewController alloc] init];
        vcMenu.hamburgerViewController = hamburgerViewController;
        NavigationViewController *nvcMenu = [[NavigationViewController alloc] init];
        [nvcMenu setViewControllers:[NSArray arrayWithObject:vcMenu]];
        
        hamburgerViewController.menuViewController = nvcMenu;
        
        self.window.rootViewController = hamburgerViewController;
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
