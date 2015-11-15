//
//  ComposeViewController.h
//  Tuitteur
//
//  Created by Florent Bonomo on 11/7/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuitteurViewController.h"
#import "Tweet.h"

@protocol ComposeTweetDelegate <NSObject>

- (void)tweetSubmitted:(Tweet *)tweet;

@end

@interface ComposeViewController : TuitteurViewController

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, strong) Tweet *originalTweet;
@property (nonatomic, assign) id<ComposeTweetDelegate, TuitteurViewControllerDelegate> delegate;

@end
