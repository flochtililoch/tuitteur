//
//  ComposeViewController.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/7/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "ComposeViewController.h"
#import "User.h"
#import "UIImageView+FadeIn.h"

@interface ComposeViewController () <UITextViewDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tweetTextView.delegate = self;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Navigation
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onCancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.originalTweet == nil ?@"Tweet" : @"Reply"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onTweet)];
    User *currentUser = [User currentUser];
    self.userNameLabel.text = currentUser.name;
    self.userScreenNameLabel.text = currentUser.screenName;
    [self.userProfileImage fadeInWithUrl:currentUser.profileImageUrl errorImage:nil placeholderImage:nil];
    self.userProfileImage.layer.cornerRadius = 5;
    self.userProfileImage.clipsToBounds = YES;
    
    [self updateCharCount];
    
    NSString *defaultText = @"";
    if (self.originalTweet != nil) {
        defaultText = [NSString stringWithFormat:@"%@ ", self.originalTweet.user.screenName];
    }
    
    self.tweetTextView.text = defaultText;
    [self.tweetTextView becomeFirstResponder];
}

- (void)updateCharCount {
    self.title = [NSString stringWithFormat:@"%ld", ([Tweet maxLength] - self.tweet.text.length)];
}

- (void)onCancel {
    [self leave];
}

- (void)onTweet {
    [self.tweet createWithCompletion:^(Tweet *tweet, NSError *error) {
        if([self.delegate respondsToSelector:@selector(tweetSubmitted:)]) {
            [self.delegate tweetSubmitted:tweet];
        }
    }];
    [self leave];
}

- (void)leave {
    [self.tweetTextView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma - UITextFieldDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // http://stackoverflow.com/questions/433337/set-the-maximum-character-length-of-a-uitextfield
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textView.text.length) {
        return NO;
    }
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return newLength <= [Tweet maxLength];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.tweet.text = textView.text;
    [self updateCharCount];
}

@end
