//
//  UIImageView+FadeIn.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/4/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "UIImageView+FadeIn.h"

@implementation UIImageView (FadeIn)

- (void)fadeInWithUrl:(NSURL *)url
             errorImage:(UIImage *)errorImage
       placeholderImage:(UIImage *)placeholderImage {
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    void (^imageFadeIn)(NSURLRequest *request , NSHTTPURLResponse *response , id image) = ^void(NSURLRequest *request, NSHTTPURLResponse *response, id image) {
        if ([image class] != [UIImage class]) {
            image = errorImage;
        }
        [self setImage:image];
        if(response != nil) {
            self.alpha = 0;
            [UIView beginAnimations:@"fade in" context:nil];
            [UIView setAnimationDuration:.5];
            self.alpha = 1.0;
            [UIView commitAnimations];
        }
    };
    
    [self setImageWithURLRequest:request
                placeholderImage:placeholderImage
                         success:imageFadeIn
                         failure:imageFadeIn];
}

@end
