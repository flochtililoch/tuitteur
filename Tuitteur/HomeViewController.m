//
//  HomeViewController.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/3/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "HomeViewController.h"
#import "TweetViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TweetCell.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

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
    self.navigationItem.title = @"Home";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onLogout)];
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


#pragma - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}


#pragma - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetViewController *vc = [[TweetViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[self navigationController] pushViewController:vc animated:YES];
}


#pragma - User Actions

// http://www.appcoda.com/pull-to-refresh-uitableview-empty/
// http://stackoverflow.com/a/12502450/237637
- (UIRefreshControl *)refreshControl {
    if(!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        _refreshControl.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _refreshControl.tintColor = [UIColor darkGrayColor];
        [_tableView addSubview:_refreshControl];
    }
    return _refreshControl;
}

- (void)onLogout {
    [[User currentUser] logout];
}


#pragma - Private

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

@end
