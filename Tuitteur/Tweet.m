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

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.text = dictionary[@"text"];
        self.createdAt = [[self class] formatDateWithString:dictionary[@"created_at"]];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.retweetsCount = dictionary[@"retweet_count"];
        self.favoritesCount = dictionary[@"favourites_count"];
    }
    
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

+ (NSDate *)formatDateWithString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
    return [formatter dateFromString:dateString];
}

+ (void)timelineWithCompletion:(void (^)(NSArray *tweets, NSError *error))completion {
    [[TwitterClient sharedInstance] timelineWithParams:nil completion:^(NSArray *responseObject, NSError *error) {
        completion([Tweet tweetsWithArray:responseObject], error);
    }];
}

@end
