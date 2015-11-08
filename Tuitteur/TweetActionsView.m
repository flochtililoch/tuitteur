//
//  TweetActionsView.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/7/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TweetActionsView.h"
#import "TweetActionButton.h"
#import "TweetLikeButton.h"

@interface TweetActionsView ()

@property (weak, nonatomic) IBOutlet UILabel *retweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet TweetActionButton *replyButton;
@property (weak, nonatomic) IBOutlet TweetActionButton *retweetButton;
@property (weak, nonatomic) IBOutlet TweetLikeButton *likeButton;

@end

@implementation TweetActionsView

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    [self updateRetweets];
    [self updateLikes];
    [self.replyButton update];
}

- (IBAction)onReplyButton:(id)sender {
    [self.delegate replyToTweet:self.tweet];
}

- (IBAction)onRetweetButton:(id)sender {
    [self.tweet toggleRetweetWithCompletion:nil];
    [self updateRetweets];
}

- (IBAction)onLikeButton:(id)sender {
    [self.tweet toggleLike];
    [self updateLikes];
}

- (void)updateLikes {
    NSString *likesCountString = @"0";
    if (!self.hideCountLabels) {
        self.likesCountLabel.hidden = NO;
        if (_tweet.likesCount > 0) {
            likesCountString = [NSString stringWithFormat:@"%ld", (long)_tweet.likesCount];
        }
        self.likesCountLabel.text = likesCountString;
    } else {
        self.likesCountLabel.hidden = YES;
    }
    self.likeButton.isOn = self.tweet.liked;
    [self.likeButton update];
    self.likesCountLabel.textColor = self.likeButton.tintColor;
    if ([self.delegate respondsToSelector:@selector(updateLikes:)]) {
        [self.delegate updateLikes];
    }
}

- (void)updateRetweets {
    NSString *retweetsCountString = @"0";
    if (!self.hideCountLabels) {
        self.retweetsCountLabel.hidden = NO;
        if (_tweet.retweetsCount > 0) {
            retweetsCountString = [NSString stringWithFormat:@"%ld", (long)_tweet.retweetsCount];
        }
        self.retweetsCountLabel.text = retweetsCountString;
    } else {
        self.retweetsCountLabel.hidden = YES;
    }
    self.retweetButton.isOn = self.tweet.retweeted;
    self.retweetButton.enabled = ![self.tweet isOwnedByCurrentUser];
    [self.retweetButton update];
    self.retweetsCountLabel.textColor = self.retweetButton.tintColor;
    if ([self.delegate respondsToSelector:@selector(updateRetweets:)]) {
        [self.delegate updateRetweets];
    }
}

@end
