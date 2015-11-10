//
//  TweetViewController.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/6/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TweetViewController.h"
#import "NavigationViewController.h"
#import "ComposeViewController.h"
#import "UIImageView+FadeIn.h"
#import "TweetActionButton.h"
#import "TweetLikeButton.h"
#import "TweetActionsView.h"
#import "RetweetedView.h"

@interface TweetViewController () <TweetActionsDelegate, ComposeTweetDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UIView *actionsView;
@property (weak, nonatomic) IBOutlet RetweetedView *retweetedView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetViewHeightConstraint;

@end


#pragma - UIViewController

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(replyToTweet)];
    
    [self updateTweet];
    [self renderActionsView];
    [self renderRetweetedView];
    [self updateRetweets];
    [self updateLikes];
}


#pragma - TweetActionsDelegate

- (void)shouldReplyToTweet:(Tweet *)tweet {
    Tweet *responseTweet = [Tweet factory];
    responseTweet.user = [User currentUser];
    [self presentComposeTweetViewWithTweet:responseTweet inResponseToTweet:tweet];
}


#pragma - ComposeTweetDelegate

- (void)tweetSubmitted:(Tweet *)tweet {
    [self.delegate viewController:self didSubmitTweet:tweet];
}


#pragma - Private

- (void)replyToTweet {
    [self shouldReplyToTweet:self.tweet];
}

- (void)updateTweet {
    Tweet *tweet = self.tweet;
    if (tweet.retweetedFromTweet != nil) {
        tweet = tweet.retweetedFromTweet;
    }
    
    self.userNameLabel.text = tweet.user.name;
    self.userScreenNameLabel.text = tweet.user.screenName;
    [self.userProfileImage fadeInWithUrl:tweet.user.profileImageUrl errorImage:nil placeholderImage:nil];
    self.userProfileImage.layer.cornerRadius = 5;
    self.userProfileImage.clipsToBounds = YES;
    self.tweetLabel.text = tweet.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.createdAtLabel.text = [dateFormatter stringFromDate:tweet.createdAt];
}

- (void)renderActionsView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TweetActionsView"
                                                   owner:[[TweetActionsView alloc] init]
                                                 options:nil];
    TweetActionsView *view = [views objectAtIndex:0];

    view.delegate = self;
    view.hideCountLabels = YES;
    view.tweet = self.tweet;
    [self.actionsView addSubview:view];
}

- (void)renderRetweetedView {
    if (!self.tweet.retweetedFromTweet) {
        self.retweetViewHeightConstraint.constant = 0.0f;
        return;
    }
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"RetweetedView"
                                                   owner:[[RetweetedView alloc] init]
                                                 options:nil];
    RetweetedView *view = [views objectAtIndex:0];
    view.tweet = self.tweet;
    [self.retweetedView addSubview:view];
}

- (void)updateRetweets {
    NSString *retweetsCountString = @"0";
    if (_tweet.retweetsCount > 0) {
        retweetsCountString = [NSString stringWithFormat:@"%ld", (long)_tweet.retweetsCount];
    }
    self.retweetsCountLabel.text = retweetsCountString;
}

- (void)updateLikes {
    NSString *likesCountString = @"0";
    if (_tweet.likesCount > 0) {
        likesCountString = [NSString stringWithFormat:@"%ld", (long)_tweet.likesCount];
    }
    self.likesCountLabel.text = likesCountString;
}

- (void)presentComposeTweetViewWithTweet:(Tweet *)tweet inResponseToTweet:(Tweet *)originalTweet {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self;
    vc.tweet = tweet;
    vc.originalTweet = originalTweet;
    NavigationViewController *nvc = [[NavigationViewController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
