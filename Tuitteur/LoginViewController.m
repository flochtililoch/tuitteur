//
//  LoginViewController.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/3/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onLogin:(id)sender {
    [User loginWithCompletion:^(User *user, NSError *error) {
        NSLog(@"User: %@", user.name);
    }];
}

- (void)onLogin {
    [User loginWithCompletion:^(User *user, NSError *error) {
        NSLog(@"User: %@", user.name);
    }];
}

@end
