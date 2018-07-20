//
//  FeedViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "FeedViewController.h"
#import "Parse.h"

@interface FeedViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *yourPostingsContainer;
@property (weak, nonatomic) IBOutlet UIView *nearbyPostingsContainer;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        [self performSegueWithIdentifier:@"logoutSegue" sender:nil];
    }];
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
