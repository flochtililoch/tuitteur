//
//  Tweet.h
//  Tuitteur
//
//  Created by Florent Bonomo on 11/3/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) NSInteger likesCount;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, assign) NSInteger retweetsCount;
@property (nonatomic, strong) Tweet *retweetedFromTweet;
@property (nonatomic, assign) NSInteger userRetweetId;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)toggleLike;
- (void)toggleRetweetWithCompletion:(void (^)(Tweet *tweet, NSError *error))completion;

+ (void)indexWithCompletion:(void (^)(NSArray *tweets, NSError *error))completion;

@end
