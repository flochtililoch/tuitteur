//
//  UIImageView+FadeIn.h
//  Tuitteur
//
//  Created by Florent Bonomo on 11/4/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface UIImageView (FadeIn)

- (void)fadeInWithUrl:(NSURL *)url
           errorImage:(UIImage *)errorImage
     placeholderImage:(UIImage *)placeholderImage;

@end
