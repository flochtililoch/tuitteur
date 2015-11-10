//
//  TweetActionsView.h
//  Tuitteur
//
//  Created by Florent Bonomo on 11/7/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetActionsDelegate <NSObject>

- (void)shouldReplyToTweet:(Tweet*)tweet;

@optional

- (void)updateRetweets;
- (void)updateLikes;

@end

@interface TweetActionsView : UIView

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, assign) id<TweetActionsDelegate> delegate;
@property (nonatomic, assign) BOOL hideCountLabels;

@end
