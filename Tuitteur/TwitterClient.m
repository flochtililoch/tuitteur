//
//  TwitterClient.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/3/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TwitterClient.h"

NSString * const kTuitteurOauthUrl = @"tuitteur://oauth";

NSString * const kTwitterApiBaseUrl = @"https://api.twitter.com";
NSString * const kTwitterOauthRequestTokenPath = @"oauth/request_token";
NSString * const kTwitterOauthAccessTokenPath = @"oauth/access_token";
NSString * const kTwitterOauthAuthorizeUrlString = @"https://api.twitter.com/oauth/authorize?oauth_token=%@";

NSString * const kTwitterUserPath = @"1.1/account/verify_credentials.json";
NSString * const kTwitterTimelinePath = @"1.1/statuses/home_timeline.json";


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
                               [self GET:kTwitterUserPath
                              parameters:nil
                                 success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                     self.loginCompletion(responseObject, nil);
                                 }
                                 failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                     self.loginCompletion(nil, error);
                                 }];
                           } failure:^(NSError *error) {
                               self.loginCompletion(nil, error);
                           }];
}

- (void)timelineWithParams:(NSArray *)params completion:(void (^)(NSArray *responseObject, NSError *error))completion {
    [self GET:kTwitterTimelinePath
   parameters:nil
      success:^(AFHTTPRequestOperation * operation, NSArray *responseObject) {
          completion(responseObject, nil);
      } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
          completion(nil, error);
      }];
}

@end
