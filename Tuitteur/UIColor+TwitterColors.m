//
//  UIColor+TwitterColors.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/9/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "UIColor+TwitterColors.h"

@implementation UIColor (TwitterColors)

+ (UIColor *)twitterAccentColorWithAlpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:.33
                                     green:.67
                                      blue:.93
                                     alpha:alpha];
    return color;
}

+ (UIColor *)twitterAccentColor {
    return  [[self class] twitterAccentColorWithAlpha:1];
}

+ (UIColor *)twitterActionButtonColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.67
                           green:0.72
                            blue:0.76
                           alpha:alpha];
}

+ (UIColor *)twitterActionButtonColor {
    return [[self class] twitterActionButtonColorWithAlpha:1];
}

+ (UIColor *)twitterActionButtonOnColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.10
                           green:0.81
                            blue:0.53
                           alpha:alpha];
}

+ (UIColor *)twitterActionButtonOnColor {
    return [[self class] twitterActionButtonOnColorWithAlpha:1];
}

+ (UIColor *)twitterLikeActionButtonOnColor {
    return [[self class] twitterLikeActionButtonOnColorWithAlpha:1];
}

+ (UIColor *)twitterLikeActionButtonOnColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:0.91
                           green:0.11
                            blue:0.31
                           alpha:alpha];
}

@end
