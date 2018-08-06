//
//  NearbyPostCell.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/17/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "NearbyPostCell.h"
#import "Parse.h"
#import "Utils.h"
#import "DateTools.h"

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
    
    PFGeoPoint * postGeoPoint=post[@"location"];
    PFGeoPoint * userGeoPoint=post.author[@"currentLocation"];
    //Call Utils method to calculate distance between post location and user
    double miles=[Utils calculateDistance:postGeoPoint betweenUserandPost:userGeoPoint];
    self.postDistanceLabel.text=[NSString stringWithFormat:@"%.2f",miles];
    
    //Format the date (date the post was posted on)
    NSDateFormatter * formatter= [[NSDateFormatter alloc] init];
    formatter.dateFormat=@"E MMM d HH:mm:ss Z y";
    formatter.dateStyle= NSDateFormatterShortStyle;
    formatter.timeStyle= NSDateFormatterNoStyle;
    NSDate * createdAt= post.createdAt;
    NSString * timeAgo= [NSDate shortTimeAgoSinceDate:createdAt];
    self.postDateLabel.text= timeAgo;
    
}


@end
