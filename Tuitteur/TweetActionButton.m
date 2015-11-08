//
//  TweetActionButton.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/7/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TweetActionButton.h"

@implementation TweetActionButton

- (id)init {
    self = [super init];
    if (self) {
        [self update];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];

    if (highlighted) {
        self.tintColor = self.isOn ? [self class].onPressedColor : [self class].pressedColor;
    } else {
        [self update];
    }
}

- (void)update {
    self.tintColor = self.isOn ? [self class].onColor : [self class].color;
}

+ (UIColor *)inactiveColor {
    return [UIColor colorWithRed:0.67 green:0.72 blue:0.76 alpha:.3];
}

+ (UIColor *)color {
    return [UIColor colorWithRed:0.67 green:0.72 blue:0.76 alpha:1.0];
}

+ (UIColor *)pressedColor {
    return [UIColor colorWithRed:0.67 green:0.72 blue:0.76 alpha:.5];
}

+ (UIColor *)onColor {
    return [UIColor colorWithRed:0.10 green:0.81 blue:0.53 alpha:1.0];
}

+ (UIColor *)onPressedColor {
    return [UIColor colorWithRed:0.10 green:0.81 blue:0.53 alpha:.5];
}

@end
