//
//  TwitterClient.h
//  Tuitteur
//
//  Created by Florent Bonomo on 11/3/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(NSDictionary *responseObject, NSError *error))completion;
- (void)completeAuthWithQueryString:(NSString *)query;

- (void)getTweetsWithParams:(NSDictionary *)params
                forMentions:(BOOL)isMentionsTimeline
                 completion:(void (^)(NSArray *responseObject, NSError *error))completion;
- (void)createTweetWithText:(NSString *)text
                 completion:(void (^)(NSDictionary *responseObject, NSError *error))completion;
- (void)createTweetWithText:(NSString *)text
          inResponseToTweet:(NSInteger)identifier
                 completion:(void (^)(NSDictionary *responseObject, NSError *error))completion;
- (void)getTweetWithTweetId:(NSInteger)identifier
                 completion:(void (^)(NSDictionary *responseObject, NSError *error))completion;
- (void)deleteTweetWithTweetId:(NSInteger)identifier
                    completion:(void (^)(NSDictionary *responseObject, NSError *error))completion;
- (void)createRetweetWithTweetId:(NSInteger)identifier
                      completion:(void (^)(NSDictionary *responseObject, NSError *error)) completion;

- (void)createFavoriteWithTweetId:(NSInteger)identifier
                     errorHandler:(void (^)(NSArray *responseObject, NSError *error))errorHandler;
- (void)deleteFavoriteWithTweetId:(NSInteger)identifier
                     errorHandler:(void (^)(NSArray *responseObject, NSError *error))errorHandler;

@end
