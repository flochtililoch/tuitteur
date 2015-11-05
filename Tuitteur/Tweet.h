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

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSNumber *retweetsCount;
@property (nonatomic, strong) NSNumber *favoritesCount;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (void)timelineWithCompletion:(void (^)(NSArray *tweets, NSError *error))completion;

@end
