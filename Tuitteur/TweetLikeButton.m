//
//  TweetLikeButton.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/7/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TweetLikeButton.h"
#import "UIColor+TwitterColors.h"

@implementation TweetLikeButton

+ (UIColor *)onColor {
    return [UIColor twitterLikeActionButtonOnColor];
}

+ (UIColor *)onPressedColor {
    return [UIColor twitterLikeActionButtonOnColorWithAlpha:.5];
}

@end
