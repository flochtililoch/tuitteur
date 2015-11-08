//
//  RetweetedView.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/8/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "RetweetedView.h"

@interface RetweetedView ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;

@end

@implementation RetweetedView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Workaround to force the UIImageView assign the tint color as specified in IB
    // http://stackoverflow.com/a/26042893/237637
    [self.retweetImageView tintColorDidChange];
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    if (tweet.retweetedFromTweet != nil) {
        self.usernameLabel.text = tweet.user.name;
    } else {
        self.hidden = YES;
    }
}

@end
