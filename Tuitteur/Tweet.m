//
//  Tweet.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/3/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

@interface Tweet ()

- (void)getWithCompletion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)deleteWithCompletion:(void (^)(Tweet *tweet, NSError *error))completion;

@end

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.identifier = [dictionary[@"id_str"] integerValue];
        self.createdAt = [[self class] formatDateWithString:dictionary[@"created_at"]];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        self.liked = [dictionary[@"favorited"] boolValue];
        self.likesCount = [dictionary[@"favourites_count"] integerValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.retweetsCount = [dictionary[@"retweet_count"] integerValue];

        NSDictionary *retweetedStatus = dictionary[@"retweeted_status"];
        if (retweetedStatus != nil) {
            self.retweetedFromTweet = [[Tweet alloc] initWithDictionary:retweetedStatus];
        }
        
        NSDictionary *currentUserRetweet = dictionary[@"current_user_retweet"];
        if (currentUserRetweet != nil) {
            self.userRetweetId = [currentUserRetweet[@"id_str"] integerValue];
        }
    }
    
    return self;
}

- (void)like {
    self.liked = YES;
    self.likesCount ++;
}

- (void)unlike {
    self.liked = NO;
    self.likesCount --;
}

- (void)toggleLike {
    if (self.liked) {
        [[TwitterClient sharedInstance] deleteFavoriteWithTweetId:self.identifier errorHandler:^(NSArray *responseObject, NSError *error) {
            [self like];
        }];
        [self unlike];
    } else {
        [[TwitterClient sharedInstance] createFavoriteWithTweetId:self.identifier errorHandler:^(NSArray *responseObject, NSError *error) {
            [self unlike];
        }];
        [self like];
    }
}

- (void)retweet {
    self.retweeted = YES;
    self.retweetsCount ++;
}

- (void)unretweet {
    self.retweeted = NO;
    self.retweetsCount --;
}

- (void)toggleRetweetWithCompletion:(void (^)(Tweet *tweet, NSError *error))completion {
    if (!self.retweeted) {
        [[TwitterClient sharedInstance] createRetweetWithTweetId:self.identifier completion:^(NSDictionary *responseObject, NSError *error) {
            if (error != nil) {
                [self unretweet];
            }
            
            Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
            if (completion != nil) {
                completion(tweet, error);
            }
        }];
        [self retweet];
        
    } else {
        Tweet *originalTweet = self.retweetedFromTweet ? self.retweetedFromTweet : self;
        [originalTweet getWithCompletion:^(Tweet *tweet, NSError *error) {
            [tweet deleteWithCompletion:^(Tweet *tweet, NSError *error) {
                if (error != nil) {
                    [self retweet];
                }
                if (completion != nil) {
                    completion(tweet, error);
                }
            }];
        }];
        [self unretweet];
    }
}

- (void)getWithCompletion:(void (^)(Tweet *tweet, NSError *error))completion {
    [[TwitterClient sharedInstance] getTweetWithTweetId:self.identifier completion:^(NSDictionary *responseObject, NSError *error) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, error);
    }];
}

- (void)deleteWithCompletion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSInteger deleteTweetId = ([User currentUser].identifier == self.user.identifier) ? self.identifier : self.userRetweetId;
    [[TwitterClient sharedInstance] deleteTweetWithTweetId:deleteTweetId completion:^(NSDictionary *responseObject, NSError *error) {
        if(error != nil) {
            completion(nil, error);
        } else {
            Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
            completion(tweet, error);
        }
    }];
}

+ (void)indexWithCompletion:(void (^)(NSArray *tweets, NSError *error))completion {
    [[TwitterClient sharedInstance] getTweets:^(NSArray *responseObject, NSError *error) {
        NSMutableArray *tweets = [NSMutableArray array];
        for (NSDictionary *tweetDictionary in responseObject) {
            [tweets addObject:[[Tweet alloc] initWithDictionary:tweetDictionary]];
        }
        completion(tweets, error);
    }];
}

+ (NSDate *)formatDateWithString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
    return [formatter dateFromString:dateString];
}

@end
