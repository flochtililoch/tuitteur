//
//  UIColor+TwitterColors.h
//  Tuitteur
//
//  Created by Florent Bonomo on 11/9/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TwitterColors)

+ (UIColor *)twitterAccentColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)twitterAccentColor;
+ (UIColor *)twitterActionButtonColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)twitterActionButtonColor;
+ (UIColor *)twitterActionButtonOnColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)twitterActionButtonOnColor;
+ (UIColor *)twitterLikeActionButtonOnColor;
+ (UIColor *)twitterLikeActionButtonOnColorWithAlpha:(CGFloat)alpha;

@end
