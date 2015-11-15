//
//  User.h
//  Tuitteur
//
//  Created by Florent Bonomo on 11/3/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kCurrentUserDidChangeNotification;

@interface User : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSURL *profileImageUrl;
@property (nonatomic, strong) NSURL *profileBannerUrl;
@property (nonatomic, assign) BOOL verified;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSString *displayUrl;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSNumber *followersCount;
@property (nonatomic, strong) NSNumber *followingCount;
@property (nonatomic, strong) NSNumber *tweetsCount;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)logout;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;
+ (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;

@end
