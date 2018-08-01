//
//  MapViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/19/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "SegueConstants.h"

@interface MapViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISlider *radiusSliderBar;
@property (weak, nonatomic) IBOutlet UILabel *desiredRadiusLabel;
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) CLLocation * userLocation;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) PFUser * currentUser;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser=[PFUser currentUser];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setDelegate:self];
    [self askLocationPermission];
    //set user location
    self.userLocation=self.locationManager.location;
    //check if the user is editing their current selected radius
    [self checkEditing];
    [self setDefaultRadius];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//Set default radius to 1 mile
- (void)setDefaultRadius{
    self.desiredRadiusLabel.text=[NSString stringWithFormat:@"%.2f", self.radiusSliderBar.value];
    [self createBoundaryWithRadius:self.radiusSliderBar.value];
    [self.currentUser setValue:[NSNumber numberWithFloat:self.radiusSliderBar.value] forKey:@"desiredRadius"];
}

- (IBAction)didTapNextButton:(id)sender {
    self.currentUser[@"currentLocation"]=[PFGeoPoint geoPointWithLocation:self.userLocation];
    [self.currentUser setValue:[NSNumber numberWithFloat:self.radiusSliderBar.value] forKey:@"desiredRadius"];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(!succeeded){
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    if([self.nextButton.titleLabel.text isEqual:@"Save"]){
        [self performSegueWithIdentifier:backToProfileSegue sender:nil];
    } else{
        [self performSegueWithIdentifier:mapToFeedSegue sender:nil];
    }
}

//Will only auto-zoom into user's location once
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation*)userLocation {
    static dispatch_once_t useOnce;
    dispatch_once(&useOnce, ^{
        [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(.09f, .09f)) animated:YES];
    });
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(nonnull id<MKOverlay>)overlay{
    MKCircleRenderer * circleRenderer=[[MKCircleRenderer alloc]initWithOverlay:overlay];
    circleRenderer.strokeColor=[UIColor grayColor];
    circleRenderer.fillColor=[UIColor grayColor];
    circleRenderer.alpha=.5f;
    return circleRenderer;
}

- (IBAction)slideBarValueChanged:(id)sender {
    self.desiredRadiusLabel.text=[NSString stringWithFormat:@"%.2f",self.radiusSliderBar.value];
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

//check if the user has already set a radius and is now editing it
- (void)checkEditing{
    if(self.currentUser[@"desiredRadius"]){
        self.radiusSliderBar.value=[self.currentUser[@"desiredRadius"] floatValue];
        [self createBoundaryWithRadius:self.radiusSliderBar.value];
        self.desiredRadiusLabel.text=[NSString stringWithFormat:@"%.2f",self.radiusSliderBar.value];
        [self.nextButton setTitle:@"Save" forState:UIControlStateNormal];
    }
}

//Helper method to ask user to use their location
- (void)askLocationPermission{
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [self.locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:backToProfileSegue]){
        UITabBarController * tabBarController= [segue destinationViewController];
        tabBarController.selectedIndex=2;
    }
}

@end
