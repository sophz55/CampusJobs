//
//  JobLocationMapViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/23/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "JobLocationMapViewController.h"
#import <MapKit/MapKit.h>
#import "ComposeNewPostViewController.h"
#import <MaterialComponents/MaterialAppBar.h>
#import "Format.h"
#import "Alert.h"

@interface JobLocationMapViewController () <MKMapViewDelegate, UIGestureRecognizerDelegate>{
    CLLocationCoordinate2D selectedUserCoordinate;
    CLLocationCoordinate2D retrievedLocation;
}
@property (strong, nonatomic) MDCAppBar *appBar;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (nonatomic,assign) NSInteger * zoomToUserLocation;
@end

@implementation JobLocationMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.jobPostingMapView setShowsUserLocation:YES];
    [self.jobPostingMapView setDelegate:self];
    self.jobPostingMapView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPin:)];
    [self.jobPostingMapView addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
    selectedUserCoordinate = kCLLocationCoordinate2DInvalid;
    [self.jobPostingMapView removeAnnotations:self.jobPostingMapView.annotations];

    [self editSavedLocation:self.prevPost.savedLocation];
    [self configureTopNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    self.zoomToUserLocation=0;
}

- (void)configureTopNavigationBar {
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    [self.appBar addSubviewsToParent];
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didTapCancelButton:)];
    [Format formatBarButton:self.cancelButton];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    self.saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(didTapSaveButton:)];
    [Format formatBarButton:self.saveButton];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    
    [Format formatAppBar:self.appBar withTitle:@"ADD LOCATION"];
}

//automatically style status bar
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.appBar.headerViewController;
}

//Will check if the user already has a previously saved location (and it will reappear on the map)
- (void)editSavedLocation:(PFGeoPoint *)enteredPoint{
    if(!(enteredPoint==nil)){
        retrievedLocation.latitude=enteredPoint.latitude;
        retrievedLocation.longitude=enteredPoint.longitude;
        MKPointAnnotation *existingAnnotation=[[MKPointAnnotation alloc]init];
        existingAnnotation.coordinate=retrievedLocation;
        [self.jobPostingMapView addAnnotation:existingAnnotation];
    }
}

//Will only auto-zoom into user's location once
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation*)userLocation {
    if(self.zoomToUserLocation==0){
        [self.jobPostingMapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(.09f, .09f)) animated:YES];
        self.zoomToUserLocation++;
    }
}

//Action method for when user double taps desired location (adds pin)
- (IBAction)addPin:(UITapGestureRecognizer *)sender {
    [self.jobPostingMapView removeAnnotations:self.jobPostingMapView.annotations];
    
    CGPoint chosenLocation = [sender locationInView:self.jobPostingMapView];
    selectedUserCoordinate = [self.jobPostingMapView convertPoint:chosenLocation toCoordinateFromView:self.jobPostingMapView];
    [self addSelectedAnnotationHelper:&(selectedUserCoordinate)];
}

//Places an annotation at the user's desired coordinate (Helper method)
- (void)addSelectedAnnotationHelper:(CLLocationCoordinate2D *)coordinate{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate=selectedUserCoordinate;
    [self.jobPostingMapView addAnnotation:annotation];
}

//saves the user's desired post location to Parse
- (IBAction)didTapSaveButton:(id)sender {
    ComposeNewPostViewController * composedPost=(ComposeNewPostViewController *)[self presentingViewController];
    
    NSLog(@"%lu",self.jobPostingMapView.annotations.count);
    if (self.jobPostingMapView.annotations.count == 0) {
        //displays alert if user tries to save without selecting a location
        [Alert callAlertWithTitle:@"Error" alertMessage:@"Please pin a location before saving." viewController:self];
    } else if (self.prevPost.savedLocation && !CLLocationCoordinate2DIsValid(selectedUserCoordinate)){
        //saves already existing location if user hasn't selected a new one
        composedPost.savedLocation=self.prevPost.savedLocation;
        [self dismissViewControllerAnimated:YES completion:nil];
        [composedPost getAddressFromCoordinate:self.prevPost.savedLocation];
    } else {
        //saves desired location and will display on ComposeNewPostViewController
        PFGeoPoint * locationCoordGeoPoint =[PFGeoPoint geoPointWithLatitude:selectedUserCoordinate.latitude longitude:selectedUserCoordinate.longitude];
        composedPost.savedLocation=locationCoordGeoPoint;
        [self dismissViewControllerAnimated:YES completion:nil];
        [composedPost getAddressFromCoordinate:composedPost.savedLocation];
    }
}

//dismisses view without saving
- (IBAction)didTapCancelButton:(id)sender {
    [self.jobPostingMapView removeAnnotations:self.jobPostingMapView.annotations];
    [self dismissViewControllerAnimated:YES completion:nil];
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
