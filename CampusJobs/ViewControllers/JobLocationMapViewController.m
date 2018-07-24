//
//  JobLocationMapViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/23/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "JobLocationMapViewController.h"
#import <MapKit/MapKit.h>


@interface JobLocationMapViewController () <MKMapViewDelegate, UIGestureRecognizerDelegate>{
    CLLocationCoordinate2D selectedUserCoordinate;
}


@end

@implementation JobLocationMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.jobPostingMapView setShowsUserLocation:YES];
    [self.jobPostingMapView setDelegate:self];
    
    //Creating a gesture recognizer
    UILongPressGestureRecognizer * userPressGesture= [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(getCoordinateFromUserTouch:)];
    [userPressGesture setNumberOfTouchesRequired:1];
    [self.jobPostingMapView addGestureRecognizer:userPressGesture];
}
  //Places an annotation at the user's desired coordinate
- (void)addSelectedAnnotation:(CLLocationCoordinate2D *)coordinate{
    MKPointAnnotation *annotation=[[MKPointAnnotation alloc]init];
    annotation.coordinate=selectedUserCoordinate;
    [self.jobPostingMapView addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation*)userLocation {
    [self.jobPostingMapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(.09f, .09f)) animated:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

   //Converts the users touch to a specific coordinate
- (void)getCoordinateFromUserTouch:(UILongPressGestureRecognizer *)userTouch{
    if(userTouch.state==UIGestureRecognizerStateBegan){
        CGPoint chosenLocation = [userTouch locationInView:self.jobPostingMapView];
        selectedUserCoordinate=[self.jobPostingMapView convertPoint:chosenLocation toCoordinateFromView:self.jobPostingMapView];
    }
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
