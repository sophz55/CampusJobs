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

@interface FeedViewController ()
@property(nonatomic, strong) MDCAppBar *appBar;
@property (weak, nonatomic) IBOutlet UIView *yourPostingsContainer;
@property (weak, nonatomic) IBOutlet UIView *nearbyPostingsContainer;
@property (strong, nonatomic) UIBarButtonItem *logoutButton;
@property (strong, nonatomic) UIBarButtonItem *composeButton;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    [self.appBar addSubviewsToParent];
    
    self.logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(didTapLogoutButton:)];
    [Format formatBarButton:self.logoutButton];
    self.navigationItem.leftBarButtonItem = self.logoutButton;
    [Format formatAppBar:self.appBar withTitle:@"SEIZE"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentedControlIndexChanged:(id)sender {
    UISegmentedControl * segment= sender;
    switch(segment.selectedSegmentIndex) {
        case 0:
            self.yourPostingsContainer.hidden=NO;
            break;
        case 1:
            self.yourPostingsContainer.hidden=YES;
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
