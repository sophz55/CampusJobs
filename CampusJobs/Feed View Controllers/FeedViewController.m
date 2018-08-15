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
#import "YourPostingsViewController.h"

@interface FeedViewController ()
@property(nonatomic, strong) MDCAppBar *appBar;
@property (weak, nonatomic) IBOutlet UIView *yourPostingsContainer;
@property (weak, nonatomic) IBOutlet UIView *nearbyPostingsContainer;
@property (strong, nonatomic) UIBarButtonItem *filterButton;
@property (strong, nonatomic) UIBarButtonItem *composeButton;
@property (strong, nonatomic) NearbyPostingsViewController *nearbyPostingsViewController;
@property (strong, nonatomic) YourPostingsViewController *yourPostingsViewController;

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
    
    self.filterButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapFilterButton:)];
    [Format formatBarButton:self.filterButton];
    self.navigationItem.leftBarButtonItem = self.filterButton;
    
    self.composeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapComposeButton:)];
    [Format formatBarButton:self.composeButton];
    self.navigationItem.rightBarButtonItem = self.composeButton;
    
    [Format formatAppBar:self.appBar withTitle:@"SEIZE"];
    self.view.backgroundColor = self.appBar.headerViewController.view.backgroundColor;
}

- (void)configureLayout {
    CGFloat inset = 8;
    CGFloat appBarInset = 4;
    
    [self.segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:regularFontName size:14]} forState:UIControlStateNormal];
    self.segmentedControl.frame = CGRectMake(inset, self.appBar.headerViewController.view.frame.origin.y + self.appBar.headerViewController.view.frame.size.height - appBarInset, self.view.frame.size.width - 2 * inset, 30);
    [self.view bringSubviewToFront:self.segmentedControl];
    self.segmentedControl.tintColor = [UIColor whiteColor];
    self.segmentedControl.backgroundColor = self.view.backgroundColor;
    
    CGFloat containerOriginY = self.segmentedControl.frame.origin.y + self.segmentedControl.frame.size.height + inset;
    CGFloat tabBarHeight = 63;
    
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

- (IBAction)didTapFilterButton:(id)sender {
}

- (IBAction)didTapComposeButton:(id)sender {
    [self performSegueWithIdentifier:feedToComposePostSegue sender:nil];
}

/*
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
 */

@end
