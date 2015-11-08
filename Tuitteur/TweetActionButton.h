//
//  TweetActionButton.h
//  Tuitteur
//
//  Created by Florent Bonomo on 11/7/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetActionButton : UIButton

@property (nonatomic, assign) BOOL isOn;

- (void)update;

@end
