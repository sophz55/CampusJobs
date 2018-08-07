//
//  ComposeNewPostViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "ComposeNewPostViewController.h"
#import <MaterialTextFields.h>
#import "Post.h"
#import "JobLocationMapViewController.h"
#import "FeedViewController.h"
#import "SegueConstants.h"
#import "Alert.h"
#import <MaterialComponents/MaterialAppBar.h>
#import "Format.h"

@interface ComposeNewPostViewController () <UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *editLocationButton;
@property (weak, nonatomic) IBOutlet MDCMultilineTextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet MDCMultilineTextField *titleTextField;

@property (strong, nonatomic) MDCTextInputControllerUnderline *titleTextFieldController;
@property (strong, nonatomic) MDCTextInputControllerUnderline *descriptionTextFieldController;

@property (strong, nonatomic) MDCAppBar *appBar;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *postButton;
@end

@implementation ComposeNewPostViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefinesPresentationContext:YES];
    [self configureIntialView];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView sizeToFit];
    if ([textView isEqual:self.titleTextField.textView]) {
        [self.titleTextField sizeToFit];
    } else if ([textView isEqual:self.descriptionTextField.textView]) {
        [self.descriptionTextField sizeToFit];
    }
}

#pragma mark - Custom Configurations

- (void)configureIntialView {
    [self configureNavigationBar];
    [self configureTextFields];
    if (self.post) {
        [self configureWithExistingPost];
    } else {
        [self configureForNewPost];
    }
}

- (void)configureNavigationBar {
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    [self.appBar addSubviewsToParent];
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didTapCancelButton:)];
    [Format formatBarButton:self.cancelButton];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    self.postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(didTapPostButton:)];
    [Format formatBarButton:self.postButton];
    self.navigationItem.rightBarButtonItem = self.postButton;
    
    [Format formatAppBar:self.appBar withTitle:@"NEW POST"];
}

- (void)configureTextFields {
    CGFloat textFieldWidth = 350;
    CGFloat textFieldHeight = 50;
    CGFloat textFieldOriginX = (self.view.frame.size.width - textFieldWidth)/2;
    
    CGFloat topTextFieldOriginY = 80;
    CGFloat verticalSpace = textFieldHeight + 20;
    
    
    self.titleTextField.textView.delegate = self;
    self.titleTextField.placeholder = @"Title";
    self.titleTextField.textView.frame = CGRectMake(textFieldOriginX, topTextFieldOriginY, textFieldWidth, textFieldHeight);
    [self.titleTextField sizeToFit];
    self.titleTextFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.titleTextField];
    
    self.descriptionTextField.textView.delegate = self;
    self.descriptionTextField.placeholder = @"Description";
    self.descriptionTextField.textView.frame = CGRectMake(textFieldOriginX, topTextFieldOriginY + verticalSpace, textFieldWidth, textFieldHeight);
    [self.descriptionTextField sizeToFit];
    self.descriptionTextFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.descriptionTextField];
}

- (void)configureWithExistingPost {
    self.titleTextField.text = self.post.title;
    
    self.descriptionTextField.text = self.post.summary;
    
    self.savedLocation = self.post.location;
    self.savedLocationAddress = self.post.locationAddress;
    if (self.savedLocationAddress && ![self.savedLocationAddress isEqualToString:@""]) {
        self.locationAddressLabel.text = self.savedLocationAddress;
        [self.editLocationButton setTitle:@"Edit Your Location" forState:UIControlStateNormal];
    } else {
        self.locationAddressLabel.text = @"Please set a location for your task...";
        [self.editLocationButton setTitle:@"Pin Point Your Location" forState:UIControlStateNormal];
    }
    
    [Format formatAppBar:self.appBar withTitle:@"Your Posting"];
    [self.postButton setTitle:@"Update"];
    [Format formatBarButton:self.postButton];
    self.navigationItem.rightBarButtonItem = self.postButton;
}

- (void)configureForNewPost {
    self.locationAddressLabel.text = @"Please set a location for your task...";
    [self.editLocationButton setTitle:@"Pin Point Your Location" forState:UIControlStateNormal];

    [self.postButton setTitle:@"Post"];
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
    if (!self.post) {
        [Post postJob:self.titleTextField.text withSummary:self.descriptionTextField.text withLocation:self.savedLocation withLocationAddress:self.savedLocationAddress
           withImages:nil withDate:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error){
               if (succeeded) {
                   [self performSegueWithIdentifier:composePostToFeedSegue sender:nil];
               } else{
                   NSLog(@"%@", error.localizedDescription);
               }
           }];
    } else {
        self.post.title = self.titleTextField.text;
        self.post.summary = self.descriptionTextField.text;
        self.post.location = self.savedLocation;
        self.post.locationAddress = self.savedLocationAddress;
        
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.delegate reloadDetails];
            } else {
                [Alert callAlertWithTitle:@"Error Saving Changes" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
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
