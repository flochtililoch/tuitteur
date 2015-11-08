//
//  TweetCell.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/4/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TweetCell.h"
#import "TweetActionButton.h"
#import "TweetLikeButton.h"
#import "UIImageView+FadeIn.h"
#import "NSDate+DateTools.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet TweetActionButton *replyButton;
@property (weak, nonatomic) IBOutlet TweetActionButton *retweetButton;
@property (weak, nonatomic) IBOutlet TweetLikeButton *likeButton;

@end

@implementation TweetCell

- (void)awakeFromNib {
    self.userProfileImage.layer.cornerRadius = 5;
    self.userProfileImage.clipsToBounds = YES;
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    self.userNameLabel.text = _tweet.user.name;
    self.userScreenNameLabel.text = _tweet.user.screenName;
    [self.userProfileImage fadeInWithUrl:_tweet.user.profileImageUrl errorImage:nil placeholderImage:nil];
    self.tweetLabel.text = _tweet.text;
    self.retweetsCountLabel.text = [NSString stringWithFormat:@"%ld", (long)_tweet.retweetsCount];
    self.likesCountLabel.text = [NSString stringWithFormat:@"%ld", (long)_tweet.likesCount];
    self.createdAtLabel.text = _tweet.createdAt.shortTimeAgoSinceNow;
    
    [self updateRetweet];
    [self updateLike];
    [self.replyButton update];

}

- (IBAction)onReplyButton:(id)sender {
}

- (IBAction)onRetweetButton:(id)sender {
    [self.tweet toggleRetweetWithCompletion:nil];
    [self updateRetweet];
}

- (IBAction)onLikeButton:(id)sender {
    [self.tweet toggleLike];
    [self updateLike];
}

- (void)updateLike {
    NSString *likesCountString = @"0";
    if (_tweet.likesCount > 0) {
        likesCountString = [NSString stringWithFormat:@"%ld", (long)_tweet.likesCount];
    }
    self.likesCountLabel.text = likesCountString;
    
    self.likeButton.isOn = self.tweet.liked;
    [self.likeButton update];
}

- (void)updateRetweet {
    NSString *retweetsCountString = @"0";
    if (_tweet.retweetsCount > 0) {
        retweetsCountString = [NSString stringWithFormat:@"%ld", (long)_tweet.retweetsCount];
    }
    self.retweetsCountLabel.text = retweetsCountString;
    
    self.retweetButton.isOn = self.tweet.retweeted;
    [self.retweetButton update];
}


@end
