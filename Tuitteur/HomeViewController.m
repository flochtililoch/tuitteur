//
//  HomeViewController.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/3/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "HomeViewController.h"
#import "NavigationViewController.h"
#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "TweetActionsView.h"
#import "TweetCell.h"
#import "User.h"
#import "Tweet.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ComposeTweetDelegate, TweetActionsDelegate, TweetViewControllerDelegate>

// IBOutlets
@property (nonatomic, weak) IBOutlet UITableView *tableView;

// UI
@property (strong, nonatomic) UIRefreshControl *refreshControl;

// State
@property (nonatomic, strong) NSArray *tweets;

@end

@implementation HomeViewController


#pragma - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Delegates
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // Navigation
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logout"]
                                                               landscapeImagePhone:nil
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onLogout)];
    
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
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"tweetCell"];
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
    if (actualPosition >= contentHeight) {
// TODO: Restrict # of search per scroll
//        [self fetchOlderTweetsThan:[self.tweets lastObject]];
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

- (void)replyToTweet:(Tweet *)tweet {
    [self presentComposeTweetViewWithTweet:[Tweet factory] inResponseToTweet:tweet];
}


#pragma - User Actions

// http://www.appcoda.com/pull-to-refresh-uitableview-empty/
// http://stackoverflow.com/a/12502450/237637
- (UIRefreshControl *)refreshControl {
    if(!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        _refreshControl.backgroundColor = [UIColor colorWithRed:0.33 green:0.67 blue:0.93 alpha:.1];
        _refreshControl.tintColor = [UIColor colorWithRed:0.33 green:0.67 blue:0.93 alpha:1];
        [_tableView addSubview:_refreshControl];
    }
    return _refreshControl;
}

- (void)onLogout {
    [[User currentUser] logout];
}

- (void)onCompose {
    [self presentComposeTweetViewWithTweet:[Tweet factory]];
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
    [self.refreshControl beginRefreshing];
    [Tweet indexWithCompletion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)fetchOlderTweetsThan:(Tweet *)tweet {
    [self.refreshControl beginRefreshing];
    [Tweet indexForOlderThan:(Tweet *)tweet completion:^(NSArray *tweets, NSError *error) {
        self.tweets = [self.tweets arrayByAddingObjectsFromArray:tweets];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)fetchNewerTweetsThan:(Tweet *)tweet {
    [self.refreshControl beginRefreshing];
    [Tweet indexForNewerThan:(Tweet *)tweet completion:^(NSArray *tweets, NSError *error) {
        self.tweets = [self.tweets arrayByAddingObjectsFromArray:tweets];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
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
