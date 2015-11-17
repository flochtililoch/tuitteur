//
//  MenuViewController.m
//  Tuitteur
//
//  Created by Florent Bonomo on 11/12/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "MenuViewController.h"
#import "HamburgerViewController.h"
#import "TuitteurViewController.h"
#import "HomeViewController.h"
#import "ProfileDetailsViewController.h"
#import "ComposeViewController.h"
#import "MenuCell.h"
#import "UIImageView+FadeIn.h"
#import "UIColor+TwitterColors.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate, TuitteurViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIImageView *profileView;
@property (strong, nonatomic) NavigationViewController *nvcHome;
@property (strong, nonatomic) NavigationViewController *nvcMentions;
@property (strong, nonatomic) NavigationViewController *nvcProfile;
@property (strong, nonatomic) NavigationViewController *nvcCompose;

@end

@implementation MenuViewController


#pragma - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Navigation
    self.navigationController.navigationBar.barTintColor = [UIColor twitterAccentColorWithAlpha:.1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logout"]
                                                               landscapeImagePhone:nil
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onLogout)];
    [self.navigationController.navigationBar addSubview:self.profileView];

    self.tableView.alwaysBounceVertical = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor twitterAccentColor];

    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil]
         forCellReuseIdentifier:@"menuCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileMenuCell" bundle:nil]
         forCellReuseIdentifier:@"profileMenuCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 125.0;

    [self initHomeViewController];
    [self initMentionsViewController];
    [self initProfileViewController];
    [self initComposeViewController];
    
    self.viewControllers = @[self.nvcProfile, self.nvcHome, self.nvcMentions, self.nvcCompose];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showViewController:self.nvcHome];
}


#pragma - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    ((MenuCell *)cell).label.text = @[@"Profile", @"Home", @"Mentions", @"New Tweet", @"Sign Out"][indexPath.row];

    return cell;
}


#pragma - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showViewController:self.viewControllers[indexPath.row]];
}


#pragma - TuitteurViewControllerDelegate

- (void)setupNavigationForViewController:(UIViewController *)vc {
    vc.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title"]];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger"]
                                                             landscapeImagePhone:nil
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self.hamburgerViewController
                                                                          action:@selector(toggle)];
}


#pragma - Private

- (void)showViewController:(NavigationViewController *)viewController {
    HamburgerViewController *hamburgerViewController = (HamburgerViewController *)self.hamburgerViewController;
    hamburgerViewController.contentViewController = viewController;
}

- (void)showProfileViewController {
    [self showViewController:self.nvcProfile];
}

- (void)onLogout {
    [[User currentUser] logout];
}

- (UIImageView *)profileView {
    if (!_profileView) {
        _profileView = [[UIImageView alloc] initWithFrame:CGRectMake(82, 0, 35, 35)];
        _profileView.layer.cornerRadius = 5;
        _profileView.layer.borderWidth = 1;
        _profileView.layer.borderColor = [UIColor whiteColor].CGColor;
        _profileView.clipsToBounds = YES;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(showProfileViewController)];
        [_profileView addGestureRecognizer:tapRecognizer];
        _profileView.userInteractionEnabled = YES;
        [_profileView fadeInWithUrl:[User currentUser].profileImageUrl errorImage:nil placeholderImage:nil];
    }
    return _profileView;
}


#pragma - View Controllers

- (void)initHomeViewController {
    self.nvcHome = [[NavigationViewController alloc] init];
    HomeViewController *vcHome = [[HomeViewController alloc] init];
    vcHome.delegate = self;
    [self.nvcHome setViewControllers:[NSArray arrayWithObject:vcHome]];
}

- (void)initMentionsViewController {
    self.nvcMentions = [[NavigationViewController alloc] init];
    HomeViewController *vcMentions = [[HomeViewController alloc] init];
    vcMentions.delegate = self;
    vcMentions.isMentionsTimeline = YES;
    [self.nvcMentions setViewControllers:[NSArray arrayWithObject:vcMentions]];
}

- (void)initProfileViewController {
    self.nvcProfile = [[NavigationViewController alloc] init];
    ProfileDetailsViewController *vcProfile = [[ProfileDetailsViewController alloc] init];
    vcProfile.user = [User currentUser];
    vcProfile.delegate = self;
    [self.nvcProfile setViewControllers:[NSArray arrayWithObject:vcProfile]];
}


- (void)initComposeViewController {
    self.nvcCompose = [[NavigationViewController alloc] init];
    ComposeViewController *vcCompose = [[ComposeViewController alloc] init];
    vcCompose.delegate = self;
    [self.nvcCompose setViewControllers:[NSArray arrayWithObject:vcCompose]];
}

@end
