//
//  HamburgerViewController.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/12/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "HamburgerViewController.h"
#import "UIColor+TwitterColors.h"

const NSInteger kMenuWidth = 140;

@interface HamburgerViewController ()

@property (nonatomic, weak) IBOutlet UIView *menuView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeadingConstraint;
@property (nonatomic, assign) CGFloat originalLeftMargin;
@property (nonatomic, strong) UIView *overlayView;

@end

@implementation HamburgerViewController


#pragma - User Actions

- (IBAction)onContentViewPanGesture:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalLeftMargin = self.contentViewLeadingConstraint.constant;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat newXPosition = self.originalLeftMargin + translation.x;
        if (newXPosition > 0 && newXPosition <= kMenuWidth) {
            self.contentViewLeadingConstraint.constant = newXPosition;
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (velocity.x > 0) {
            [self open];
        } else {
            [self close];
        }
    }
}


#pragma - Private

- (void)open {
    // Overlay view is by default invisible thus does not block interaction
    // When the menu is open, the overlay view then fades in
    // and replaces interaction on underlying views with the close menu action
    [self.contentViewController.view addSubview:_overlayView];

    [UIView animateWithDuration:.3 animations:^{
        self.contentViewLeadingConstraint.constant = kMenuWidth;
        [self.overlayView setAlpha:.3];
        [self.view layoutIfNeeded];
    }];
}

- (void)close {
    [UIView animateWithDuration:.3 animations:^{
        self.contentViewLeadingConstraint.constant = 0;
        [self.overlayView setAlpha:0];
        [self.view layoutIfNeeded];
    }];
}

- (void)toggle {
    if (self.contentViewLeadingConstraint.constant == 0) {
        [self open];
    } else {
        [self close];
    }
}

- (void)setMenuViewController:(NavigationViewController *)navigationViewController {
    _menuViewController = navigationViewController;
    [self.view layoutIfNeeded];
    [self.menuView addSubview:navigationViewController.view];
}

- (void)setContentViewController:(NavigationViewController *)navigationViewController {
    _contentViewController = navigationViewController;
    [self.view layoutIfNeeded];
    [[[self.contentView subviews] firstObject] removeFromSuperview];
    [self.contentView addSubview:navigationViewController.view];
    [self close];
}

- (UIView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:self.contentViewController.view.frame];
        _overlayView.backgroundColor = [UIColor blackColor];
        [_overlayView setAlpha:0];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(close)];
        [_overlayView addGestureRecognizer:tapRecognizer];
    }
    return _overlayView;
}

@end
