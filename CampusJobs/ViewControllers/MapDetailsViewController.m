//
//  MapDetailsViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/26/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "MapDetailsViewController.h"
#import <MapKit/MapKit.h>
#import <MaterialComponents/MaterialAppBar.h>
#import "Format.h"

@interface MapDetailsViewController (){
    CLLocationCoordinate2D geoPointToCoord;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MDCAppBar *appBar;
@property (strong, nonatomic) UIBarButtonItem *backButton;

@end

@implementation MapDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    geoPointToCoord.latitude=self.post.location.latitude;
    geoPointToCoord.longitude=self.post.location.longitude;
    [self.mapView setRegion:MKCoordinateRegionMake(geoPointToCoord, MKCoordinateSpanMake(.09f, .09f)) animated:YES];
    MKPointAnnotation *annotation=[[MKPointAnnotation alloc]init];
    annotation.coordinate=geoPointToCoord;
    [self.mapView addAnnotation:annotation];
    // Do any additional setup after loading the view.
    
    [self configureNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureNavigationBar {
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    [self.appBar addSubviewsToParent];
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]  style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton:)];
    self.navigationItem.leftBarButtonItem = self.backButton;
    
    [Format formatAppBar:self.appBar withTitle:@"POST LOCATION"];
}

- (IBAction)didTapBackButton:(id)sender {
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
