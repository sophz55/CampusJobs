//
//  MapViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/19/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISlider *radiusSliderBar;
@property (strong, nonatomic) CLLocationManager * locationManager;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setDelegate:self];
    
    //must ask user permission to use their location
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [self.locationManager requestWhenInUseAuthorization];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)didTapNextButton:(id)sender {
    [self performSegueWithIdentifier:@"mapToTabBarSegue" sender:nil];
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation*)userLocation {
    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(.11f, .11f)) animated:YES];
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:userLocation.coordinate radius:1500];
    [self.mapView addOverlay:circle];
}
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(nonnull id<MKOverlay>)overlay{
    MKCircleRenderer * circleRenderer=[[MKCircleRenderer alloc]initWithOverlay:overlay];
    circleRenderer.strokeColor=[UIColor grayColor];
    circleRenderer.fillColor=[UIColor grayColor];
    circleRenderer.alpha=.04f;
    return circleRenderer;
    
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
