//
//  TweetViewController.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/6/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+FadeIn.h"
#import "TweetActionButton.h"
#import "TweetLikeButton.h"

@interface TweetViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet TweetLikeButton *likeButton;
@property (weak, nonatomic) IBOutlet TweetActionButton *retweetButton;
@property (weak, nonatomic) IBOutlet TweetActionButton *replyButton;

@end


#pragma - UIViewController

@implementation TweetViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tweet";
    
    self.userNameLabel.text = _tweet.user.name;
    self.userScreenNameLabel.text = _tweet.user.screenName;
    [self.userProfileImage fadeInWithUrl:_tweet.user.profileImageUrl errorImage:nil placeholderImage:nil];
    self.tweetLabel.text = _tweet.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.createdAtLabel.text = [dateFormatter stringFromDate:_tweet.createdAt];

    [self updateRetweet];
    [self updateLike];
    [self.replyButton update];
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
