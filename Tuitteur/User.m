//
//  User.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/3/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const kCurrentUserDidChangeNotification = @"UserDidLoginNotification";

@interface User ()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.identifier = [dictionary[@"id_str"] integerValue];
        self.name = dictionary[@"name"];
        self.screenName = [@"@" stringByAppendingString:dictionary[@"screen_name"]];
        self.profileImageUrl = [NSURL URLWithString:dictionary[@"profile_image_url"]];
        self.profileBannerUrl = [NSURL URLWithString:dictionary[@"profile_banner_url"]];
        self.verified = [dictionary[@"verified"] boolValue];
        self.tagline = dictionary[@"description"];
        self.displayUrl = dictionary[@"entities"][@"url"][@"urls"][0][@"display_url"];
        self.url = [NSURL URLWithString: dictionary[@"entities"][@"url"][@"urls"][0][@"expanded_url"]];
        self.followersCount = dictionary[@"followers_count"];
        self.followingCount = dictionary[@"friends_count"];
        self.tweetsCount = dictionary[@"statuses_count"];
    }
    
    return self;
}

- (void)logout {
    [[self class] setCurrentUser:nil];
    [[[TwitterClient sharedInstance] requestSerializer] removeAccessToken];
}

static User * _currentUser = nil;

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:(User *)user {
    _currentUser = user;
    
    NSData *data;
    if (_currentUser != nil) {
        data = [NSJSONSerialization dataWithJSONObject:user.dictionary options:NSJSONWritingPrettyPrinted error:nil];
    } else {
        data = nil;
    }
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentUserDidChangeNotification object:nil];
}

+ (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    [[self currentUser] logout];
    [[TwitterClient sharedInstance] loginWithCompletion:^(NSDictionary *responseObject, NSError *error) {
        User *user = [[User alloc] initWithDictionary:responseObject];
        [[self class] setCurrentUser:user];
    }];
}

@end
