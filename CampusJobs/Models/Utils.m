//
//  Utils.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/26/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void)animateView:(UIView *)view withDistance:(CGFloat)distance up:(BOOL)up {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    if (up) {
        distance *= -1;
    }
    
    view.frame = CGRectOffset(view.frame, 0, distance);
    
    [UIView commitAnimations];
}

//Calculating the distance between the location of a post and a user's location
+ (double)calculateDistance:(PFGeoPoint *)postGeoPoint betweenUserandPost:(PFGeoPoint *)userGeoPoint{
    //Convert postGeoPoint and userGeoPoint to CLLocation
    CLLocation  * postLocation=[[CLLocation alloc]init];
    postLocation = [postLocation initWithLatitude:postGeoPoint.latitude longitude:postGeoPoint.longitude];
    CLLocation * userLocation=[[CLLocation alloc]init];
    userLocation = [userLocation initWithLatitude:userGeoPoint.latitude longitude:userGeoPoint.longitude];
    
    //Calculate distance between the two points
    CLLocationDistance distance = [userLocation getDistanceFrom:postLocation];
    //convert from meters to miles
    double miles=distance/1609.34;
    
    return miles;
}

@end
