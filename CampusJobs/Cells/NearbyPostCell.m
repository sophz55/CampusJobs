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
    self.postTitleLabel.font=typographyScheme.overline;
    self.postUserLabel.font=typographyScheme.headline6;
    self.postDescriptionLabel.font=typographyScheme.subtitle2;
    self.postDateLabel.font=typographyScheme.subtitle2;
    self.postDistanceLabel.font=typographyScheme.subtitle2;
    
    //initialize text for labels
    self.postUserLabel.text=post.author.username;
    self.postTitleLabel.text=[post.title uppercaseString];
    if ([post.title isEqualToString:@""]) {
        self.postTitleLabel.text = @"UNTITLED POST";
    }
    self.postDescriptionLabel.text=post.summary;
    
    PFGeoPoint * postGeoPoint=post[@"location"];
    PFGeoPoint * userGeoPoint=post.author[@"currentLocation"];
    //Call Utils method to calculate distance between post location and user
    double miles=[Utils calculateDistance:postGeoPoint betweenUserandPost:userGeoPoint];
    self.postDistanceLabel.text=[NSString stringWithFormat:@"%.1f miles",miles];
    [self.postDistanceLabel sizeToFit];
    
    //Format the date (date the post was posted on)
    NSDateFormatter * formatter= [[NSDateFormatter alloc] init];
    formatter.dateFormat=@"E MMM d HH:mm:ss Z y";
    formatter.dateStyle= NSDateFormatterShortStyle;
    formatter.timeStyle= NSDateFormatterNoStyle;
    NSDate * createdAt= post.createdAt;
    NSString * timeAgo= [NSDate shortTimeAgoSinceDate:createdAt];
    self.postDateLabel.text= timeAgo;
    
    //set profile picture
    self.profilePicture.layer.cornerRadius= self.profilePicture.frame.size.width / 2;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.file=post.author[@"profileImageFile"];
    self.profilePicture.layer.borderWidth=1.5;
    self.profilePicture.layer.borderColor=[[Colors primaryOrangeColor]CGColor];
}


@end
