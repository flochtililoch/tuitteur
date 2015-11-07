//
//  TweetViewController.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/6/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+FadeIn.h"

@interface TweetViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;

@end


#pragma - UIViewController

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tweet";
    
    self.userNameLabel.text = _tweet.user.name;
    self.userScreenNameLabel.text = _tweet.user.screenName;
    [self.userProfileImage fadeInWithUrl:_tweet.user.profileImageUrl errorImage:nil placeholderImage:nil];
    self.tweetLabel.text = _tweet.text;
    
    NSString *retweetsCountString = @"0";
    if (_tweet.retweetsCount > 0) {
        retweetsCountString = [_tweet.retweetsCount stringValue];
    }
    self.retweetsCountLabel.text = retweetsCountString;

    NSString *favoritesCountString = @"0";
    if (_tweet.favoritesCount > 0) {
        favoritesCountString = [_tweet.favoritesCount stringValue];
    }
    self.favoritesCountLabel.text = favoritesCountString;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.createdAtLabel.text = [dateFormatter stringFromDate:_tweet.createdAt];
}

@end
