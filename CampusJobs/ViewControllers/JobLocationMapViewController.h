//
//  JobLocationMapViewController.h
//  CampusJobs
//
//  Created by Sophia Khezri on 7/23/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface JobLocationMapViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *jobPostingMapView;
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) CLLocation * userLocation;

@end
