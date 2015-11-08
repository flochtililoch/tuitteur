//
//  TwitterClient.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/3/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TwitterClient.h"

NSString * const kTuitteurOauthUrl = @"tuitteur://oauth";

NSString * const kTwitterOauthRequestTokenPath = @"oauth/request_token";
NSString * const kTwitterOauthAccessTokenPath = @"oauth/access_token";
NSString * const kTwitterOauthAuthorizeUrlString = @"https://api.twitter.com/oauth/authorize?oauth_token=%@";

NSString * const kTwitterApiBaseUrl = @"https://api.twitter.com";
NSString * const kTwitterApiUserShowUrl = @"1.1/account/verify_credentials.json";
NSString * const kTwitterApiTweetIndexUrl = @"1.1/statuses/home_timeline.json";
NSString * const kTwitterApiTweetCreateUrl = @"1.1/statuses/update.json";
NSString * const kTwitterApiTweetShowUrl = @"1.1/statuses/show/%ld.json?include_my_retweet=1";
NSString * const kTwitterApiTweetDestroyUrl = @"1.1/statuses/destroy/%ld.json";
NSString * const kTwitterApiRetweetCreateUrl = @"1.1/statuses/retweet/%ld.json";
NSString * const kTwitterApiFavoriteCreateUrl = @"/1.1/favorites/create.json";
NSString * const kTwitterApiFavoriteDestroyUrl = @"/1.1/favorites/destroy.json";


@interface TwitterClient ()

@property (nonatomic, strong) void (^loginCompletion)(NSDictionary *responseObject, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"configuration" ofType:@"plist"];
            NSDictionary *configuration = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
            NSString *twitterApiConsumerKey = configuration[@"TwitterAPI"][@"ConsumerKey"];
            NSString *twitterApiConsumerSecret = configuration[@"TwitterAPI"][@"ConsumerSecret"];

            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterApiBaseUrl]
                                                  consumerKey:twitterApiConsumerKey
                                               consumerSecret:twitterApiConsumerSecret];
        }
    });
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(NSDictionary *responseObject, NSError *error))completion {
    self.loginCompletion = completion;
    [self fetchRequestTokenWithPath:kTwitterOauthRequestTokenPath
                             method:@"GET"
                        callbackURL:[NSURL URLWithString:kTuitteurOauthUrl]
                              scope:nil
                            success:^(BDBOAuth1Credential *requestToken) {
                                NSURL *authUrl = [NSURL URLWithString:[NSString stringWithFormat:kTwitterOauthAuthorizeUrlString, requestToken.token]];
                                [[UIApplication sharedApplication] openURL:authUrl];
                            } failure:^(NSError *error) {
                                self.loginCompletion(nil, error);
                            }];
}

- (void)completeAuthWithQueryString:(NSString *)query {
    [self fetchAccessTokenWithPath:kTwitterOauthAccessTokenPath
                            method:@"POST"
                      requestToken:[BDBOAuth1Credential credentialWithQueryString:query]
                           success:^(BDBOAuth1Credential *accessToken) {
                               [self.requestSerializer saveAccessToken:accessToken];
                               [self GET:kTwitterApiUserShowUrl
                              parameters:nil
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     self.loginCompletion(responseObject, nil);
                                 }
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     self.loginCompletion(nil, error);
                                 }];
                           } failure:^(NSError *error) {
                               self.loginCompletion(nil, error);
                           }];
}

- (void)getTweetsWithParams:(NSDictionary *)params completion:(void (^)(NSArray *responseObject, NSError *error))completion {
    [self GET:kTwitterApiTweetIndexUrl
   parameters:params
      success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
          completion(responseObject, nil);
      } failure:^(AFHTTPRequestOperation *operation, NSError * error) {
          completion(nil, error);
      }];
}

- (void)createTweetWithText:(NSString *)text completion:(void (^)(NSDictionary *responseObject, NSError *error))completion {
    [self createTweetWithText:text
            inResponseToTweet:0
                   completion:completion];
}

- (void)createTweetWithText:(NSString *)text inResponseToTweet:(NSInteger)identifier completion:(void (^)(NSDictionary *responseObject, NSError *error))completion {
    NSMutableDictionary *parameters = [@{@"status": text} mutableCopy];
    
    if (identifier > 0) {
        parameters[@"in_reply_to_status_id"] = @(identifier);
    }

    [self POST:kTwitterApiTweetCreateUrl
    parameters:parameters
       success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
           completion(responseObject, nil);
       } failure:^(AFHTTPRequestOperation *operation, NSError * error) {
           completion(nil, error);
       }];
}

- (void)getTweetWithTweetId:(NSInteger)identifier completion:(void (^)(NSDictionary *responseObject, NSError *error))completion {
    [self GET:[NSString stringWithFormat:kTwitterApiTweetShowUrl, (long)identifier]
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
          completion(responseObject, nil);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          completion(nil, error);
      }];
}

- (void)deleteTweetWithTweetId:(NSInteger)identifier completion:(void (^)(NSDictionary *responseObject, NSError *error))completion {
    [self GET:[NSString stringWithFormat:kTwitterApiTweetDestroyUrl, (long)identifier]
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
          completion(responseObject, nil);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          completion(nil, error);
      }];
}

- (void)createRetweetWithTweetId:(NSInteger)identifier completion:(void (^)(NSDictionary *responseObject, NSError *error)) completion {
    [self POST:[NSString stringWithFormat:kTwitterApiRetweetCreateUrl, (long)identifier]
    parameters:nil
       success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
           completion(responseObject, nil);
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           completion(nil, error);
       }];

}

- (void)createFavoriteWithTweetId:(NSInteger)identifier errorHandler:(void (^)(NSArray *responseObject, NSError *error))errorHandler {
    [self POST:kTwitterApiFavoriteCreateUrl
    parameters:@{@"id":@(identifier)}
       success:nil
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          errorHandler(nil, error);
      }];
}

- (void)deleteFavoriteWithTweetId:(NSInteger)identifier errorHandler:(void (^)(NSArray *responseObject, NSError *error))errorHandler {
    [self POST:kTwitterApiFavoriteDestroyUrl
    parameters:@{@"id":@(identifier)}
       success:nil
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           errorHandler(nil, error);
       }];
}

@end
