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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)logout;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;
+ (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;

@end
