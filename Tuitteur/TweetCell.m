//
//  TweetCell.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/4/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TweetCell.h"
#import "RetweetedView.h"
#import "TweetActionButton.h"
#import "UIImageView+FadeIn.h"
#import "UIColor+TwitterColors.h"
#import "NSDate+DateTools.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet RetweetedView *retweetedView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetedViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *actionsView;

@end

@implementation TweetCell

- (void)awakeFromNib {
    self.userProfileImage.layer.cornerRadius = 5;
    self.userProfileImage.clipsToBounds = YES;

    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor twitterAccentColorWithAlpha:.1];
    [self setSelectedBackgroundView:bgColorView];
    
    // http://stackoverflow.com/questions/19124922/uicollectionview-adding-single-tap-gesture-recognizer-to-supplementary-view
    UITapGestureRecognizer *userProfileImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserProfileImageTap:)];
    userProfileImageTap.delaysTouchesBegan = YES;
    userProfileImageTap.numberOfTapsRequired = 1;
    [self.userProfileImage addGestureRecognizer:userProfileImageTap];
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    if (self.tweet.retweetedFromTweet != nil) {
        tweet = tweet.retweetedFromTweet;
    }
    
    self.userNameLabel.text = tweet.user.name;
    self.userScreenNameLabel.text = tweet.user.screenName;
    [self.userProfileImage fadeInWithUrl:tweet.user.profileImageUrl errorImage:nil placeholderImage:nil];
    self.tweetLabel.text = tweet.text;
    self.createdAtLabel.text = _tweet.createdAt.shortTimeAgoSinceNow;
    [self renderActionsView];
    [self renderRetweetedView];
}

- (void)renderRetweetedView {
    if ([self.retweetedView.subviews count]) {
        // http://stackoverflow.com/questions/11889243/what-is-the-best-way-to-remove-all-subviews-from-you-self-view
        [self.retweetedView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if (!self.tweet.retweetedFromTweet) {
        self.retweetedViewHeightConstraint.constant = 0.0f;
        return;
    }

    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"RetweetedView"
                                                   owner:[[RetweetedView alloc] init]
                                                 options:nil];
    RetweetedView *view = [views objectAtIndex:0];
    view.tweet = self.tweet;
    view.frame = self.retweetedView.frame;
    [self.retweetedView addSubview:view];
    self.retweetedViewHeightConstraint.constant = 16.0f;
}

- (void)renderActionsView {
    if ([self.actionsView.subviews count]) {
        // http://stackoverflow.com/questions/11889243/what-is-the-best-way-to-remove-all-subviews-from-you-self-view
        [self.actionsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }

    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TweetActionsView"
                                                   owner:[[TweetActionsView alloc] init]
                                                 options:nil];
    TweetActionsView *view = [views objectAtIndex:0];
    view.delegate = self.delegate;
    view.tweet = self.tweet;
    [self.actionsView addSubview:view];
}

- (IBAction)onUserProfileImageTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(profilePictureWasTappedForUser:)]) {
        User *user = self.tweet.user;
        if (self.tweet.retweetedFromTweet != nil) {
            user = self.tweet.retweetedFromTweet.user;
        }
        [self.delegate profilePictureWasTappedForUser:user];
    }
}


@end
