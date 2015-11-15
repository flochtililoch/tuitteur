//
//  ProfileViewController.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/11/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+FadeIn.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isVerifiedImageView;
@property (weak, nonatomic) IBOutlet UILabel *tweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UIView *urlWrapperView;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Profile Images
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.layer.borderWidth = 5;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.clipsToBounds = YES;
    [self.profileImageView fadeInWithUrl:self.user.profileImageUrl
                              errorImage:nil placeholderImage:nil];
    [self.backgroundImageView fadeInWithUrl:self.user.profileBannerUrl errorImage:nil placeholderImage:nil];
    
    // Profile Details
    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = self.user.screenName;
    self.isVerifiedImageView.hidden = !self.user.verified;
    self.taglineLabel.text = self.user.tagline;
    [self.urlButton setTitle:self.user.displayUrl forState:UIControlStateNormal];
    self.followersCountLabel.text = [[self class] numberWithShortcut:self.user.followersCount];
    self.followingCountLabel.text = [[self class] numberWithShortcut:self.user.followingCount];
    self.tweetsCountLabel.text = [[self class] numberWithShortcut:self.user.tweetsCount];
}

- (IBAction)onUrlButtonTap:(id)sender {
    [[UIApplication sharedApplication] openURL:self.user.url];
}

+ (NSString*)numberWithShortcut:(NSNumber*)number {
    unsigned long long value = [number longLongValue];
    NSUInteger index = 0;
    double dvalue = (double)value;
    NSArray *suffix = @[@"", @"K", @"M", @"B", @"T", @"P", @"E"];
    while ((value /= 1000) && ++index) dvalue /= 1000;
    NSString *numberStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:dvalue]
                                                           numberStyle:NSNumberFormatterNoStyle];
    NSString *svalue = [NSString stringWithFormat:@"%@%@",numberStr, [suffix objectAtIndex:index]];
    
    return svalue;
}

@end
