//
//  ProfileDetailsViewController.h
//  Tuitteur
//
//  Created by Florent Bonomo on 11/11/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuitteurViewController.h"
#import "User.h"

@interface ProfileDetailsViewController : TuitteurViewController

@property (nonatomic, strong) User *user;

@end
