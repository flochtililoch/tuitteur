//
//  TweetCell.h
//  Tuitteur
//
//  Created by Florent Bonomo on 11/4/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TweetActionsView.h"

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, assign) id<TweetActionsDelegate> delegate;

@end
