//
//  FeedViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "FeedViewController.h"
#import "Parse.h"
#import "SegueConstants.h"
#import <MaterialComponents/MaterialAppBar.h>
#import <MaterialComponents/MaterialTypography.h>
#import "Format.h"
#import "StringConstants.h"
#import "NearbyPostingsViewController.h"

@interface FeedViewController ()
@property(nonatomic, strong) MDCAppBar *appBar;
@property (weak, nonatomic) IBOutlet UIView *yourPostingsContainer;
@property (weak, nonatomic) IBOutlet UIView *nearbyPostingsContainer;
@property (strong, nonatomic) UIBarButtonItem *logoutButton;
@property (strong, nonatomic) UIBarButtonItem *composeButton;
@property (strong, nonatomic) UIViewController *nearbyPostingsViewController;
@property (strong, nonatomic) UIViewController *yourPostingsViewController;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTopNavigationBar];
    [self configureLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//automatically style status bar
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.appBar.headerViewController;
}

- (void)configureTopNavigationBar {
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    [self.appBar addSubviewsToParent];
    
    self.logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(didTapLogoutButton:)];
    [Format formatBarButton:self.logoutButton];
    self.navigationItem.leftBarButtonItem = self.logoutButton;
    
    self.composeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapComposeButton:)];
    [Format formatBarButton:self.composeButton];
    self.navigationItem.rightBarButtonItem = self.composeButton;
    
    [Format formatAppBar:self.appBar withTitle:@"SEIZE"];
}

- (void)configureLayout {
    [self.segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:regularFontName size:14]} forState:UIControlStateNormal];
    self.segmentedControl.frame = CGRectMake(-10, self.appBar.headerViewController.view.frame.origin.y + self.appBar.headerViewController.view.frame.size.height, self.view.frame.size.width + 20, 30);
    self.segmentedControl.tintColor = self.appBar.headerViewController.view.backgroundColor;
    
    CGFloat containerOriginY = self.segmentedControl.frame.origin.y + self.segmentedControl.frame.size.height;
    CGFloat tabBarHeight = 75;
    
    self.nearbyPostingsContainer.frame = CGRectMake(0, containerOriginY + 55, self.view.frame.size.width, self.view.frame.size.height - containerOriginY - tabBarHeight);
    self.yourPostingsContainer.frame = self.nearbyPostingsContainer.frame;
    
    self.nearbyPostingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"nearbyPostings"];
    [self addChildViewController:self.nearbyPostingsViewController];
    [self.nearbyPostingsViewController.view setFrame:self.nearbyPostingsContainer.frame];
    [self.nearbyPostingsViewController didMoveToParentViewController:self];
    
    self.yourPostingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"yourPostings"];
    [self addChildViewController:self.yourPostingsViewController];
    [self.yourPostingsViewController.view setFrame:self.yourPostingsContainer.frame];
    [self.yourPostingsViewController didMoveToParentViewController:self];
}

- (IBAction)segmentedControlIndexChanged:(id)sender {
    UISegmentedControl * segment= sender;
    switch(segment.selectedSegmentIndex) {
        case 0:
            self.yourPostingsContainer.hidden=NO;
            self.nearbyPostingsContainer.hidden=YES;
            break;
        case 1:
            self.yourPostingsContainer.hidden=YES;
            self.nearbyPostingsContainer.hidden=NO;
            break;
        default:
            break;
    }
}

- (IBAction)didTapLogoutButton:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        [self performSegueWithIdentifier:feedToLogoutSegue sender:nil];
    }];
}

- (IBAction)didTapComposeButton:(id)sender {
    [self performSegueWithIdentifier:feedToComposePostSegue sender:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
