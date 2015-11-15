//
//  TuitteurViewController.h
//  Tuitteur
//
//  Created by Florent Bonomo on 11/14/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TuitteurViewControllerDelegate <NSObject>

- (void)setupNavigationForViewController:(UIViewController *)vc;

@end

@interface TuitteurViewController : UIViewController

@property (nonatomic, assign) id<TuitteurViewControllerDelegate> delegate;

- (void)setupNavigation;

@end
