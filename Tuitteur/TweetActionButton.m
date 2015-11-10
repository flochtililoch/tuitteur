//
//  TweetActionButton.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/7/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TweetActionButton.h"
#import "UIColor+TwitterColors.h"

@implementation TweetActionButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self update];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(70.0, -150.0, 5.0, 5.0)];
        [self setTitle:@"Your text" forState:UIControlStateNormal];
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

+ (UIColor *)color {
    return [UIColor twitterActionButtonColor];
}

+ (UIColor *)pressedColor {
    return [UIColor twitterActionButtonColorWithAlpha:.5];
}

+ (UIColor *)onColor {
    return [UIColor twitterActionButtonOnColor];
}

+ (UIColor *)onPressedColor {
    return [UIColor twitterActionButtonOnColorWithAlpha:.5];
}

@end
