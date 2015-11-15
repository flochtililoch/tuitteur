//
//  MenuCell.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/12/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "MenuCell.h"
#import "UIColor+TwitterColors.h"

@implementation MenuCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor twitterAccentColor];
    UIView *bgColorView = [[UIView alloc] init];
    UIColor *selectionColor = [UIColor whiteColor];
    bgColorView.backgroundColor = [selectionColor colorWithAlphaComponent:.4];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
