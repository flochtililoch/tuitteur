//
//  TweetCell.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/4/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+FadeIn.h"
#import "NSDate+DateTools.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;

@end

@implementation TweetCell

- (void)awakeFromNib {
    self.userProfileImage.layer.cornerRadius = 5;
    self.userProfileImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    self.userNameLabel.text = _tweet.user.name;
    self.userScreenNameLabel.text = _tweet.user.screenName;
    [self.userProfileImage fadeInWithUrl:_tweet.user.profileImageUrl errorImage:nil placeholderImage:nil];
    self.tweetLabel.text = _tweet.text;
    self.retweetsCountLabel.text = [_tweet.retweetsCount stringValue];
    self.favoritesCountLabel.text = [_tweet.favoritesCount stringValue];
    self.createdAtLabel.text = _tweet.createdAt.shortTimeAgoSinceNow;
}

@end
