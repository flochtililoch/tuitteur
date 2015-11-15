//
//  HomeViewController.h
//  Tuitteur
//
//  Created by Florent Bonomo on 11/3/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuitteurViewController.h"

@interface HomeViewController : TuitteurViewController

@property (nonatomic, assign) id<TuitteurViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isMentionsTimeline;

@end
