//
//  TuitteurViewController.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/14/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TuitteurViewController.h"

@implementation TuitteurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
}

- (void)setupNavigation {
    if ([self.delegate respondsToSelector:@selector(setupNavigationForViewController:)]) {
        [self.delegate setupNavigationForViewController:self];
    }
}

@end
