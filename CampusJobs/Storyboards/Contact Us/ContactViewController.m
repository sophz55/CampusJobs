//
//  ContactViewController.m
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/29/18.
//  Copyright © 2018 So What. All rights reserved.
//


#import "ContactViewController.h"
//#import "MapPin.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    
    CLLocationCoordinate2D location;
    
    location.latitude = 51.50161024921944;
    location.longitude = -0.14074087142944336;
    
    region.span = span;
    region.center = location;
    
    [self.mapView setRegion:region animated:YES];
    
    MapPin *ann = [[MapPin alloc] init];
    ann.coordinate = location;
    [self.mapView addAnnotation:ann];*/
    
//    self.button1.layer.cornerRadius = 5;
//    self.button2.layer.cornerRadius = 5;
//    self.button3.layer.cornerRadius = 5;
//    self.button4.layer.cornerRadius = 5;
//    
    [[self navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)directions:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://maps.apple.com/maps?daddr=51.50161024921944,-0.14074087142944336"] options:@{} completionHandler:nil];
    
}

- (IBAction)callUs:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:123456789"] options:@{} completionHandler:nil];
}
    
@end
    



