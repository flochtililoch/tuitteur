//
//  HomeViewController.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/3/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "HomeViewController.h"
#import "UIColor+TwitterColors.h"
#import "NavigationViewController.h"
#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "ProfileViewController.h"
#import "TweetActionsView.h"
#import "TweetCell.h"
#import "User.h"
#import "Tweet.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ComposeTweetDelegate, TweetActionsDelegate, TweetViewControllerDelegate, TweetCellDelegate>

// IBOutlets
@property (nonatomic, weak) IBOutlet UITableView *tableView;

// UI
@property (strong, nonatomic) UIRefreshControl *refreshControl;

// State
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, assign) BOOL fetchingData;

@end

@implementation HomeViewController

@dynamic delegate;


#pragma - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Delegates
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // Navigation
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose"]
                                                                landscapeImagePhone:nil
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onCompose)];
    
    // Loading
    [self.refreshControl addTarget:self
                            action:@selector(fetchTweets)
                  forControlEvents:UIControlEventValueChanged];
    
    // Results
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil]
         forCellReuseIdentifier:@"tweetCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 125.0;
    [self fetchTweets];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


#pragma - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    cell.delegate = self;
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}


#pragma - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetViewController *vc = [[TweetViewController alloc] init];
    vc.delegate = self;
    vc.tweet = self.tweets[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[self navigationController] pushViewController:vc animated:YES];
}


#pragma - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat actualPosition = self.tableView.contentOffset.y;
    CGFloat contentHeight = self.tableView.contentSize.height - self.tableView.frame.size.height;
    if (!self.fetchingData // Only fetch once at a time
        && [self.tweets count] >= 15 // Only fetch if there's already some data on screen
        && actualPosition >= contentHeight) {
        self.fetchingData = YES;
        [self fetchOlderTweetsThan:[self.tweets lastObject]];
    }
}


#pragma - TweetViewControllerDelegate

- (void)viewController:(TweetViewController *)viewController didSubmitTweet:(Tweet *)tweet {
    [self addTweetToTimelineTop:tweet];
}


#pragma - ComposeTweetDelegate

- (void)tweetSubmitted:(Tweet *)tweet {
    [self addTweetToTimelineTop:tweet];
}


#pragma - TweetActionsDelegate

- (void)shouldReplyToTweet:(Tweet *)tweet {
    Tweet *responseTweet = [Tweet factory];
    responseTweet.user = [User currentUser];
    [self presentComposeTweetViewWithTweet:responseTweet inResponseToTweet:tweet];
}


#pragma - TweetCellDelegate

- (void)profilePictureWasTappedForUser:(User*)user {
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma - User Actions

// http://www.appcoda.com/pull-to-refresh-uitableview-empty/
// http://stackoverflow.com/a/12502450/237637
- (UIRefreshControl *)refreshControl {
    if(!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        _refreshControl.backgroundColor = [UIColor twitterAccentColorWithAlpha:.1];
        _refreshControl.tintColor = [UIColor twitterAccentColor];
        [_tableView addSubview:_refreshControl];
    }
    return _refreshControl;
}

- (void)onCompose {
    Tweet *newTweet = [Tweet factory];
    newTweet.user = [User currentUser];
    [self presentComposeTweetViewWithTweet:newTweet];
}


#pragma - Private

- (void)addTweetToTimelineTop:(Tweet *)tweet {
    self.tweets = [@[tweet] arrayByAddingObjectsFromArray:self.tweets];
    [self.tableView reloadData];
}

- (NSArray *)tweets {
    if (!_tweets) {
        _tweets = [NSArray array];
    }
    return _tweets;
}

- (void)fetchTweets {
    [self fetchTweetsNewerThan:nil olderThan:nil];
}

- (void)fetchOlderTweetsThan:(Tweet *)tweet {
    [self fetchTweetsNewerThan:nil olderThan:tweet];
}

- (void)fetchTweetsNewerThan:(Tweet *)newest olderThan:(Tweet *)oldest {
    self.fetchingData = YES;
    [self.refreshControl beginRefreshing];
    [Tweet indexForNewerThan:newest
                   olderThan:oldest
                 forMentions:self.isMentionsTimeline
                  completion:^(NSArray *tweets, NSError *error) {
                      // Reject 1st object of the array since already present from prev request.
                      if ([tweets count] > 1) {
                          self.tweets = [self.tweets arrayByAddingObjectsFromArray:[[tweets subarrayWithRange:NSMakeRange(1, [tweets count] - 1)] arrayByAddingObjectsFromArray:tweets]];
                      }
                      [self.refreshControl endRefreshing];
                      [self.tableView reloadData];
                      self.fetchingData = NO;
    }];
}

- (void)presentComposeTweetViewWithTweet:(Tweet *)tweet {
    [self presentComposeTweetViewWithTweet:tweet inResponseToTweet:nil];
}

- (void)presentComposeTweetViewWithTweet:(Tweet *)tweet inResponseToTweet:(Tweet *)originalTweet {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self;
    vc.tweet = tweet;
    vc.originalTweet = originalTweet;
    NavigationViewController *nvc = [[NavigationViewController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
