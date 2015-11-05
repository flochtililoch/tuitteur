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
- (void)timelineWithParams:(NSArray *)params completion:(void (^)(NSArray *responseObject, NSError *error))completion;

@end
