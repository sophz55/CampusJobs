//
//  NearbyPostCell.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/17/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "NearbyPostCell.h"
#import "Parse.h"

@implementation NearbyPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setNearbyPost:(Post *)post{
    _post=post;
    self.postUserLabel.text=post.author.username;
    self.postTitleLabel.text=post.title;
    self.postDescriptionLabel.text=post.summary;
    
    //Converting from PFGeoPoint to CLLocation to calculate distance between user location and post location
    PFGeoPoint * postGeoPoint=post[@"location"];
    CLLocation  * postLocation=[[CLLocation alloc]init];
    postLocation = [postLocation initWithLatitude:postGeoPoint.latitude longitude:postGeoPoint.longitude];
    PFGeoPoint * userGeoPoint=post.author[@"currentLocation"];
    CLLocation * userLocation=[[CLLocation alloc]init];
    userLocation = [userLocation initWithLatitude:userGeoPoint.latitude longitude:userGeoPoint.longitude];
    
    //Calculate distance and set distance label in cell
    CLLocationDistance distance = [userLocation getDistanceFrom:postLocation];
    double miles=distance/1609.34;
    NSNumber * doubleNum=[NSNumber numberWithDouble:miles];
    self.postDistanceLabel.text=[doubleNum stringValue];
    
}


@end
