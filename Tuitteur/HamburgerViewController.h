//
//  HamburgerViewController.h
//  Tuitteur
//
//  Created by Florent Bonomo on 11/12/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationViewController.h"
#import "MenuViewController.h"

@interface HamburgerViewController : UIViewController

@property (nonatomic, strong) NavigationViewController *menuViewController;
@property (nonatomic, strong) NavigationViewController *contentViewController;

- (void)open;
- (void)close;
- (void)toggle;

@end
