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
#import "Masonry.h"
#import "StringConstants.h"

@interface JobCompletedViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *takerProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) RateView *rateView;
@property (strong, nonatomic) MDCAppBar *appBar;
@property (weak, nonatomic) IBOutlet MDCButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@end

@implementation JobCompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTopNavigationBar];
    [self formatViews];
    [self populateViews];
    [self configureLayout];
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
    self.usernameLabel.text = [NSString stringWithFormat:@"%@",self.otherUser.username];
    
    self.completedDateLabel.text = self.post.completedDateString;
    
    self.priceLabel.text = [NSString stringWithFormat:@"Completed for $%@", self.post.price];
}

- (void)formatViews {
    UIFont *font = [UIFont fontWithName:regularFontName size:20];
    
    self.usernameLabel.font = font;
    self.completedDateLabel.font = self.usernameLabel.font;
    self.priceLabel.font = self.usernameLabel.font;
    self.rateLabel.font = self.usernameLabel.font;
    
    [self.usernameLabel sizeToFit];
    [self.completedDateLabel sizeToFit];
    [self.priceLabel sizeToFit];
    [self.rateLabel sizeToFit];
    
    [self configureRateView];
    
    [Format formatRaisedButton:self.nextButton];
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
    
    CGFloat verticalSpacing = 10;
    CGFloat sectionSpacing = 4 * verticalSpacing;
    
    CGFloat width = 120;
    self.takerProfileImageView.frame = CGRectMake(0, 0, width, width);
    [self.takerProfileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appBar.headerViewController.view.mas_bottom).with.offset(sectionSpacing);
        id diameter = @120;
        make.width.equalTo(diameter);
        make.height.equalTo(diameter);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [Format formatProfilePictureForUser:self.otherUser withView:self.takerProfileImageView];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.takerProfileImageView.mas_bottom).with.offset(verticalSpacing);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.completedDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameLabel.mas_bottom).with.offset(verticalSpacing);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.completedDateLabel.mas_bottom).with.offset(verticalSpacing);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).with.offset(sectionSpacing);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.rateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rateLabel.mas_bottom).with.offset(verticalSpacing);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rateView.mas_bottom).with.offset(sectionSpacing);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
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
