//
//  NSLayoutConstraintHairline.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/6/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "NSLayoutConstraintHairline.h"

@implementation NSLayoutConstraintHairline

-(void)awakeFromNib
{
    [super awakeFromNib];
    if ( self.constant == 1 ) self.constant = 1/[UIScreen mainScreen].scale;
}

@end