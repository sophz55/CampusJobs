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
#import <MaterialComponents/MaterialTextFields+TypographyThemer.h>
#import "AppScheme.h"
#import "Colors.h"
#import "Format.h"

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
    id<MDCTypographyScheming> typographyScheme = [AppScheme sharedInstance].typographyScheme;
    
    //initialize fonts for labels
    self.postTitleLabel.font=[UIFont fontWithName:@"RobotoCondensed-Bold" size:18];
    self.postUserLabel.font=[UIFont fontWithName:@"RobotoCondensed-Regular" size:16];
    self.postDescriptionLabel.font=[UIFont fontWithName:@"RobotoCondensed-LightItalic" size:16];
    self.postDateLabel.font=typographyScheme.subtitle2;
    self.postDistanceLabel.font=[UIFont fontWithName: @"RobotoCondensed-Regular" size:18];
    self.milesLabel.font=[UIFont fontWithName: @"RobotoCondensed-Regular" size:18];

    PFGeoPoint * postGeoPoint=post[@"location"];
    PFGeoPoint * userGeoPoint=post.author[@"currentLocation"];
    //Call Utils method to calculate distance between post location and user
    double miles=[Utils calculateDistance:postGeoPoint betweenUserandPost:userGeoPoint];
    self.postDistanceLabel.text=[NSString stringWithFormat:@"%.1f",miles];
    [self.postDistanceLabel sizeToFit];
    
    //Format the date (date the post was posted on)
    NSDateFormatter * formatter= [[NSDateFormatter alloc] init];
    formatter.dateFormat=@"E MMM d HH:mm:ss Z y";
    formatter.dateStyle= NSDateFormatterShortStyle;
    formatter.timeStyle= NSDateFormatterNoStyle;
    NSDate * createdAt= post.createdAt;
    NSString * timeAgo= [NSDate shortTimeAgoSinceDate:createdAt];
    
    //initialize text for labels
    self.milesLabel.text=@"mi.";
    self.postTitleLabel.text=[post.title uppercaseString];
    if ([post.title isEqualToString:@""]) {
        self.postTitleLabel.text = @"UNTITLED POST";
    }
    self.postDescriptionLabel.text=post.summary;
    self.postUserLabel.text=[NSString stringWithFormat:@"%@ | %@",post.author.username,timeAgo];
    
    //set profile picture
    self.profilePicture.layer.cornerRadius= self.profilePicture.frame.size.width / 2;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.file=post.author[@"profileImageFile"];
    [self.profilePicture loadInBackground];
    [Format formatProfilePictureForUser:post.author withView:self.profilePicture];
}

@end
