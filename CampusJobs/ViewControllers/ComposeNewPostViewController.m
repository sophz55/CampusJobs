//
//  ComposeNewPostViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "ComposeNewPostViewController.h"
#import "Post.h"
#import "JobLocationMapViewController.h"
#import "FeedViewController.h"
#import "SegueConstants.h"
#import "Utils.h"

@interface ComposeNewPostViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *editLocationButton;
@property (weak, nonatomic) IBOutlet UITextView *summaryView;
@property (assign, nonatomic) BOOL usesPlaceholderText;
@end

@implementation ComposeNewPostViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefinesPresentationContext:YES];
    self.summaryView.delegate = self;
    
    [self configureIntialView];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.usesPlaceholderText) {
        textView.text = @"";
        self.summaryView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    self.usesPlaceholderText = NO;
}

#pragma mark - Custom Configurations

- (void)configureIntialView {
    if (self.post) {
        [self configureWithExistingPost];
    } else {
        [self configureForNewPost];
    }
}

- (void)configureWithExistingPost {
    self.enteredTitle.text = self.post.title;
    
    self.summaryView.text = self.post.summary;
    if (![self.summaryView.text isEqualToString:@""]) {
        self.summaryView.textColor = [UIColor blackColor];
        self.usesPlaceholderText = NO;
    } else {
        self.summaryView.text = @"Add a description...";
        self.summaryView.textColor = [UIColor lightGrayColor];
        self.usesPlaceholderText = YES;
    }
    
    self.savedLocation = self.post.location;
    self.savedLocationAddress = self.post.locationAddress;
    if (self.savedLocationAddress && ![self.savedLocationAddress isEqualToString:@""]) {
        self.locationAddressLabel.text = self.savedLocationAddress;
        [self.editLocationButton setTitle:@"Edit Your Location" forState:UIControlStateNormal];
    } else {
        self.locationAddressLabel.text = @"Please set a location for your task...";
        [self.editLocationButton setTitle:@"Pin Point Your Location" forState:UIControlStateNormal];
    }
    
    [self.postButton setTitle:@"Update" forState:UIControlStateNormal];
}

- (void)configureForNewPost {
    self.summaryView.text = @"Add a description...";
    self.summaryView.textColor = [UIColor lightGrayColor];
    self.usesPlaceholderText = YES;
    
    self.locationAddressLabel.text = @"Please set a location for your task...";
    [self.editLocationButton setTitle:@"Pin Point Your Location" forState:UIControlStateNormal];

    [self.postButton setTitle:@"Post" forState:UIControlStateNormal];
}

//Uses a geocoder to convert the longitude and latitude of the pinned annotation into a readable address for the user
- (void)getAddressFromCoordinate:(PFGeoPoint *)geoPointLocation{
    CLGeocoder * geocoder=[[CLGeocoder alloc]init];
    CLLocation * location=[[CLLocation alloc]init];
    location = [location initWithLatitude:geoPointLocation.latitude longitude:geoPointLocation.longitude];
    //calls the reverse method of the geocoder
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray * placemarks, NSError * error){
        if(error==nil & placemarks.count>0){
            CLPlacemark * placemark=[placemarks firstObject];
            //formats the location label
            self.locationAddressLabel.text= [NSString stringWithFormat:@" %@ %@, %@, %@, %@" ,placemark.subThoroughfare, placemark.thoroughfare, placemark.locality,placemark.administrativeArea,placemark.postalCode];
            [self.editLocationButton setTitle:@"Edit Your Location" forState:UIControlStateNormal];
        }
        self.savedLocationAddress = self.locationAddressLabel.text;
    }];
}

#pragma mark - IBAction

- (IBAction)didTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
- (IBAction)didTapPostButton:(id)sender {
    if (self.usesPlaceholderText) {
        self.summaryView.text = @"";
    }
    if (!self.post) {
        [Post postJob:self.enteredTitle.text withSummary:self.summaryView.text withLocation:self.savedLocation withLocationAddress:self.savedLocationAddress
           withImages:nil withDate:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error){
               if (succeeded) {
                   [self performSegueWithIdentifier:composePostToFeedSegue sender:nil];
               } else{
                   NSLog(@"%@", error.localizedDescription);
               }
           }];
    } else {
        self.post.title = self.enteredTitle.text;
        self.post.summary = self.summaryView.text;
        self.post.location = self.savedLocation;
        self.post.locationAddress = self.savedLocationAddress;
        
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.delegate reloadDetails];
            } else {
                [Utils callAlertWithTitle:@"Error Saving Changes" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
            }
        }];
    }
}
    
- (IBAction)tapGesture:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}
    
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:composePostToMapSegue]){
        JobLocationMapViewController * jobViewController=[segue destinationViewController];
        jobViewController.prevPost=self;
    }
}

@end
