//
//  NavigationController.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/4/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "NavigationViewController.h"
#import "UINavigationBar+CustomHeight.h"
#import "UIColor+TwitterColors.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationBar setHeight:40.0f];
    self.navigationBar.tintColor = [UIColor twitterAccentColor];
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.translucent = NO;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

@end
