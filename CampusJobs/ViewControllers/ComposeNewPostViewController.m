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

@interface ComposeNewPostViewController () <UITextViewDelegate, UITextFieldDelegate>{
    CLLocationCoordinate2D savedLocationCoordinate;
}
@property (weak, nonatomic) IBOutlet MDCRaisedButton *editLocationButton;
@property (weak, nonatomic) IBOutlet MDCMultilineTextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet MDCMultilineTextField *titleTextField;

@property (strong, nonatomic) MDCTextInputControllerUnderline *titleTextFieldController;
@property (strong, nonatomic) MDCTextInputControllerUnderline *descriptionTextFieldController;

@property (strong, nonatomic) MDCAppBar *appBar;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *postButton;

@property (weak, nonatomic) IBOutlet MKMapView *postMapView;

@end

@implementation ComposeNewPostViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefinesPresentationContext:YES];
    [self configureIntialView];
    self.view.backgroundColor=[Colors secondaryGreyLighterColor];
    [self configureColors];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.savedLocation) {
        [self.postMapView setHidden:NO];
        [self formatExistingMap];
    } else {
        [self.postMapView setHidden:YES];
    }
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
    
    //format title text field
    UIFont * robotoCondensed=[UIFont fontWithName:@"RobotoCondensed-Regular" size:18];
    UIFont * robotoBold=[UIFont fontWithName:@"RobotoCondensed-Bold" size:18];
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
    [self.postMapView setHidden:NO];
    [self formatExistingMap];
    if (self.savedLocationAddress && ![self.savedLocationAddress isEqualToString:@""]) {
        self.locationAddressLabel.text = self.savedLocationAddress;
        [self.editLocationButton setTitle:@"EDIT POST LOCATION" forState:UIControlStateNormal];
    } else {
        self.locationAddressLabel.text = @"Please set a location for your task";
        [self.editLocationButton setTitle:@"PIN POST LOCATION" forState:UIControlStateNormal];
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
    self.locationAddressLabel.text = @"Please set a location for your task";
    [self.editLocationButton setTitle:@"PIN POST LOCATION" forState:UIControlStateNormal];
    self.postMapView.hidden=YES;
    [self.postButton setTitle:@"Post"];
}

- (void)configureColors{
    id<MDCColorScheming> colorScheme = [AppScheme sharedInstance].colorScheme;
    //Button color
    [MDCContainedButtonColorThemer applySemanticColorScheme:colorScheme
                                                   toButton:self.editLocationButton];
    //text field colors
    self.titleTextField.textColor = colorScheme.onSurfaceColor;
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.titleTextFieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.descriptionTextFieldController];
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
            [self.editLocationButton setTitle:@"Edit Post Location" forState:UIControlStateNormal];
        }
        self.savedLocationAddress = self.locationAddressLabel.text;
    }];
}
#pragma mark - Helper Method

- (void)formatExistingMap{
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
