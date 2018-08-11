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
#import "Colors.h"
#import "MaterialTextFields+ColorThemer.h"
#import <MaterialComponents/MaterialButtons.h>
#import "MaterialButtons+ColorThemer.h"
#import "AppScheme.h"
#import <MapKit/MapKit.h>
#import "StringConstants.h"
#import <Masonry.h>

@interface ComposeNewPostViewController () <UITextViewDelegate, UITextFieldDelegate>{
    CLLocationCoordinate2D savedLocationCoordinate;
}
@property (weak, nonatomic) IBOutlet MDCRaisedButton *editLocationButton;
@property (weak, nonatomic) IBOutlet MDCButton *useCurrentLocationButton;
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
    self.view.backgroundColor=[Colors secondaryGreyLighterColor];
    [self configureColors];
    [self configureButtons];
    [self configureLayout];
    self.useCurrentLocationButton.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    if (!self.savedLocation || [self.savedLocation isEqual:[PFUser currentUser][currentLocation]]) {
        self.savedLocation = [PFUser currentUser][currentLocation];
        self.useCurrentLocationButton.hidden = YES;
    } else {
        self.useCurrentLocationButton.hidden = NO;
    }
    
    [self formatMap];
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
    [self configureTopNavigationBar];
    [self configureTextFields];
    if (self.post) {
        [self configureWithExistingPost];
    } else {
        [self configureForNewPost];
    }
}

- (void)configureTopNavigationBar {
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    [self.appBar addSubviewsToParent];
    self.cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapCancelButton:)];
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
    
    //format title text field
    UIFont * robotoCondensed=[UIFont fontWithName:regularFontName size:18];
    UIFont * robotoBold=[UIFont fontWithName:boldFontName size:18];
    self.titleTextField.textView.delegate = self;
    self.titleTextField.placeholder = @"TITLE";
    self.titleTextField.textView.frame = CGRectMake(textFieldOriginX, topTextFieldOriginY, textFieldWidth, textFieldHeight);
    [self.titleTextField sizeToFit];
    self.titleTextFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.titleTextField];
    self.titleTextFieldController.inlinePlaceholderFont=robotoBold;
    self.titleTextField.font=robotoCondensed;
    
    //format description text field
    self.descriptionTextField.textView.delegate = self;
    self.descriptionTextField.placeholder = @"DESCRIPTION";
    self.descriptionTextField.textView.frame = CGRectMake(textFieldOriginX, topTextFieldOriginY + verticalSpace, textFieldWidth, textFieldHeight);
    [self.descriptionTextField sizeToFit];
    self.descriptionTextFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.descriptionTextField];
    self.descriptionTextFieldController.inlinePlaceholderFont=robotoBold;
    self.descriptionTextField.font=robotoCondensed;
}

- (void)configureWithExistingPost {
    self.titleTextField.text = self.post.title;
    self.descriptionTextField.text = self.post.summary;
    self.savedLocation = self.post.location;
    self.savedLocationAddress = self.post.locationAddress;
    [self formatMap];
    if (self.savedLocationAddress && ![self.savedLocationAddress isEqualToString:@""]) {
        self.locationAddressLabel.text = self.savedLocationAddress;
        self.useCurrentLocationButton.hidden = NO;
    } else {
        self.locationAddressLabel.text = @"Using your current location.";
        self.useCurrentLocationButton.hidden = YES;
    }
    [Format formatAppBar:self.appBar withTitle:@"Your Posting"];

    [self.postButton setTitle:@"Update"];
    [Format formatBarButton:self.postButton];
    self.navigationItem.rightBarButtonItem = self.postButton;
}

//automatically style status bar
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.appBar.headerViewController;
}

- (void)configureForNewPost {
    self.locationAddressLabel.text = @"Using your current location.";
    [self.postButton setTitle:@"Post"];
}

- (void)configureColors{
    id<MDCColorScheming> colorScheme = [AppScheme sharedInstance].colorScheme;
    
    //Button color
    [Format formatRaisedButton:self.editLocationButton];
    [Format formatFlatButton:self.useCurrentLocationButton];
    
    //text field colors
    self.titleTextField.textColor = colorScheme.onSurfaceColor;
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.titleTextFieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.descriptionTextFieldController];
}

- (void)configureButtons {
    [self.editLocationButton setTitle:@"EDIT POST LOCATION" forState:UIControlStateNormal];
    [self.editLocationButton sizeToFit];
    
    [self.useCurrentLocationButton setTitle:@"USE CURRENT LOCATION" forState:UIControlStateNormal];
    [self.useCurrentLocationButton setTitleFont:[UIFont fontWithName:lightItalicFontName size:14] forState:UIControlStateNormal];
    [self.useCurrentLocationButton sizeToFit];
}

- (void)configureLayout {
    [self.useCurrentLocationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.editLocationButton.mas_bottom).with.offset(4);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
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
            self.locationAddressLabel.text= [NSString stringWithFormat:@"%@ %@, %@, %@, %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.locality,placemark.administrativeArea,placemark.postalCode];
        }
        self.savedLocationAddress = self.locationAddressLabel.text;
    }];
}
#pragma mark - Helper Method

- (void)formatMap{
    [self.postMapView setShowsUserLocation:YES];
    
    //rounded edges
    self.postMapView.layer.cornerRadius=5.0;
    self.postMapView.layer.borderColor=[[Colors primaryBlueColor]CGColor];
    self.postMapView.layer.borderWidth=1.0;
    
    //add shadow
    self.postMapView.layer.shadowOffset=CGSizeMake(0, 0);
    self.postMapView.layer.shadowOpacity=0.7;
    self.postMapView.layer.shadowRadius=1.0;
    self.postMapView.clipsToBounds = false;
    self.postMapView.layer.shadowColor=[[UIColor blackColor]CGColor];
    
    //add pinned annotation
    savedLocationCoordinate.latitude=self.savedLocation.latitude;
    savedLocationCoordinate.longitude=self.savedLocation.longitude;
    [self.postMapView setRegion:MKCoordinateRegionMake(savedLocationCoordinate, MKCoordinateSpanMake(.09f, .09f)) animated:YES];
    MKPointAnnotation *annotation=[[MKPointAnnotation alloc]init];
    annotation.coordinate=savedLocationCoordinate;
    [self.postMapView addAnnotation:annotation];
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

- (IBAction)didTapUseCurrentLocationButton:(id)sender {
    self.savedLocation = [PFUser currentUser][@"currentLocation"];
    [self.postMapView removeAnnotations:self.postMapView.annotations];
    [self formatMap];
    self.locationAddressLabel.text = @"Using your current location.";
    self.useCurrentLocationButton.hidden = YES;
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
        jobViewController.prevPost = self;
    }
}

@end
