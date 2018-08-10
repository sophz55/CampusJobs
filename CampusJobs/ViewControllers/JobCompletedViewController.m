//
//  JobCompletedViewController.m
//  CampusJobs
//
//  Created by Sophia Zheng on 8/9/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "JobCompletedViewController.h"
#import <RateView/RateView.h>
#import <MaterialComponents/MaterialAppBar.h>
#import <ParseUI/ParseUI.h>
#import "Colors.h"
#import "Format.h"
#import "NSDate+DateTools.h"
#import "SegueConstants.h"

@interface JobCompletedViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *takerProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) RateView *rateView;
@property (strong, nonatomic) MDCAppBar *appBar;
@property (weak, nonatomic) IBOutlet MDCButton *nextButton;

@end

@implementation JobCompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureTopNavigationBar];
    [self configureRateView];
    [self configureLayout];
    [self populateViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureTopNavigationBar {
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    [self.appBar addSubviewsToParent];

    [Format formatAppBar:self.appBar withTitle:@"JOB COMPLETED"];
}

- (void)populateViews {
    [Format formatProfilePictureForUser:self.otherUser withView:self.takerProfileImageView];
    self.usernameLabel.text = [NSString stringWithFormat:@"%@",self.otherUser.username];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *completedAtDate = self.post.completedDate;
    
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    self.completedDateLabel.text = [formatter stringFromDate:completedAtDate];
    
    self.priceLabel.text = [NSString stringWithFormat:@"$%@", self.post.price];
}

- (void)configureRateView {
    self.rateView = [RateView rateViewWithRating:3.5f];
    self.rateView.canRate = YES;
    self.rateView.step = 1;
    self.rateView.starNormalColor = [Colors secondaryGreyLightColor];
    self.rateView.starFillColor = [Colors primaryOrangeColor];
    [self.view addSubview:self.rateView];
}

- (void) configureLayout {
    self.takerProfileImageView.frame = CGRectMake(0, 120, 100, 100);
    [Format centerHorizontalView:self.takerProfileImageView inView:self.view];
    
    self.usernameLabel.frame = CGRectMake(0, 240, 100, 30);
    [Format centerHorizontalView:self.usernameLabel inView:self.view];
    
    self.completedDateLabel.frame = CGRectMake(0, 280, 100, 30);
    [Format centerHorizontalView:self.completedDateLabel inView:self.view];
    
    self.priceLabel.frame = CGRectMake(0, 320, 100, 30);
    [Format centerHorizontalView:self.priceLabel inView:self.view];
    
    self.rateView.frame = CGRectMake(0, 360, self.rateView.frame.size.width, self.rateView.frame.size.height);
    [Format centerHorizontalView:self.rateView inView:self.view];
    
    self.nextButton.frame = CGRectMake(0, 420, 100, 30);
    [Format centerHorizontalView:self.nextButton inView:self.view];
}

- (IBAction)didTapNextButton:(id)sender {
    [self performSegueWithIdentifier:jobCompletedToTabBarSegue sender:nil];
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
