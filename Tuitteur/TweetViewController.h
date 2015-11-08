//
//  TweetViewController.h
//  Tuitteur
//
//  Created by Florent Bonomo on 11/6/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetViewController;

@protocol TweetViewControllerDelegate <NSObject>

- (void)viewController:(TweetViewController *)viewController didSubmitTweet:(Tweet *)tweet;

@end

@interface TweetViewController : UIViewController

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, assign) id<TweetViewControllerDelegate> delegate;

@end
