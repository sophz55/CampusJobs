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
@property (weak, nonatomic) IBOutlet UILabel *desiredRadiusLabel;
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) CLLocation * userLocation;
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
    //set user location
    self.userLocation=self.locationManager.location;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)didTapNextButton:(id)sender {
    [self performSegueWithIdentifier:@"mapToTabBarSegue" sender:nil];
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation*)userLocation {
    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(.09f, .09f)) animated:YES];
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(nonnull id<MKOverlay>)overlay{
    MKCircleRenderer * circleRenderer=[[MKCircleRenderer alloc]initWithOverlay:overlay];
    circleRenderer.strokeColor=[UIColor grayColor];
    circleRenderer.fillColor=[UIColor grayColor];
    circleRenderer.alpha=.5f;
    return circleRenderer;
}
- (IBAction)slideBarValueChanged:(id)sender {
    self.desiredRadiusLabel.text=[NSString stringWithFormat:@"%f",self.radiusSliderBar.value];
    [self createBoundaryWithRadius:self.radiusSliderBar.value];
}
- (void)createBoundaryWithRadius:(float)radius{
    [self.mapView removeOverlays: self.mapView.overlays];
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.userLocation.coordinate radius:(self.radiusSliderBar.value) * 1609.34];
    [self.mapView addOverlay:circle];
    //Zoom out or in depending on the selected radius
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.userLocation.coordinate, (radius*1609.34)*3, (radius*1609.34)*3);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    self.mapView.showsUserLocation = YES;
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
