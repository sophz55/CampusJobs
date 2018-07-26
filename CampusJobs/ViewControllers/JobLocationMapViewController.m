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


@interface JobLocationMapViewController () <MKMapViewDelegate, UIGestureRecognizerDelegate>{
    CLLocationCoordinate2D selectedUserCoordinate;
    CLLocationCoordinate2D retrievedLocation;
}
@end

@implementation JobLocationMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.jobPostingMapView setShowsUserLocation:YES];
    [self.jobPostingMapView setDelegate:self];
    self.jobPostingMapView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPin:)];
    [self.jobPostingMapView addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
    [self editSavedLocation:self.prevPost.savedLocation];

    
}
- (void)editSavedLocation:(PFGeoPoint *)enteredPoint{
    if(!(enteredPoint==nil)){
        NSLog(@"%f", enteredPoint.latitude);
        retrievedLocation.latitude=enteredPoint.latitude;
        retrievedLocation.longitude=enteredPoint.longitude;
        MKPointAnnotation *existingAnnotation=[[MKPointAnnotation alloc]init];
        existingAnnotation.coordinate=retrievedLocation;
        [self.jobPostingMapView addAnnotation:existingAnnotation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation*)userLocation {
    [self.jobPostingMapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(.09f, .09f)) animated:YES];
}

//Action method for when user double taps desired location (adds pin)
- (IBAction)addPin:(UITapGestureRecognizer *)sender {
    if(self.jobPostingMapView.annotations.count > 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot select more than one job location." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alert show];
    } else{
        CGPoint chosenLocation = [sender locationInView:self.jobPostingMapView];
        selectedUserCoordinate=[self.jobPostingMapView convertPoint:chosenLocation toCoordinateFromView:self.jobPostingMapView];
        [self addSelectedAnnotationHelper:&(selectedUserCoordinate)];
    }
}

//Places an annotation at the user's desired coordinate (Helper method)
- (void)addSelectedAnnotationHelper:(CLLocationCoordinate2D *)coordinate{
    MKPointAnnotation *annotation=[[MKPointAnnotation alloc]init];
    annotation.coordinate=selectedUserCoordinate;
    [self.jobPostingMapView addAnnotation:annotation];
}

//saves the user's desired post location to Parse
- (IBAction)didTapSaveButton {
    if(self.jobPostingMapView.annotations.count==1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please pin a location before saving." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alert show];
    } else{
        UINavigationController * navController=(UINavigationController *)[self presentingViewController];
        ComposeNewPostViewController * composedPost=(ComposeNewPostViewController *)[navController topViewController];
        PFGeoPoint * locationCoordGeoPoint =[PFGeoPoint geoPointWithLatitude:selectedUserCoordinate.latitude longitude:selectedUserCoordinate.longitude];
        composedPost.savedLocation=locationCoordGeoPoint;
        [self dismissViewControllerAnimated:YES completion:nil];
        [composedPost getAddressFromCoordinate:composedPost.savedLocation];
    }
}

- (IBAction)didTapClearButton:(id)sender {
    [self.jobPostingMapView removeAnnotations:self.jobPostingMapView.annotations];
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