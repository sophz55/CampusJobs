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
#import <Masonry.h>

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
    
    //initialize fonts for labels
    self.postTitleLabel.font=[UIFont fontWithName:@"RobotoCondensed-Bold" size:18];
    self.postUserLabel.font=[UIFont fontWithName:@"RobotoCondensed-Regular" size:16];
    self.postDescriptionLabel.font=[UIFont fontWithName:@"RobotoCondensed-LightItalic" size:16];
    self.postDistanceLabel.font=[UIFont fontWithName: @"RobotoCondensed-Regular" size:20];
    self.milesLabel.font=[UIFont fontWithName: @"RobotoCondensed-Regular" size:16];

    PFGeoPoint * postGeoPoint=post[@"location"];
    PFGeoPoint * userGeoPoint=[PFUser currentUser][@"currentLocation"];
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
    CGFloat imageWidth = 45;
    self.profilePicture.frame = CGRectMake(0, 0, imageWidth, imageWidth);
    [Format formatProfilePictureForUser:post.author withView:self.profilePicture];
    
    [self configureLayout];
}

- (void)configureLayout {
    CGFloat verticalInset = 17;
    CGFloat horizontalInset = 10;
    CGFloat cellWidth = self.layer.frame.size.width;
    CGFloat cellHeight = self.layer.frame.size.height;
    
    [self.profilePicture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(verticalInset));
        make.left.equalTo(@(verticalInset));
        CGFloat imageWidth = 45;
        make.width.equalTo(@(imageWidth));
        make.height.equalTo(@(imageWidth));
    }];

    [self.postTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profilePicture.mas_top);
        make.left.equalTo(self.profilePicture.mas_right).with.offset(8);
    }];
    
    [self.postUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.postTitleLabel.mas_bottom).with.offset(2);
        make.left.equalTo(self.postTitleLabel.mas_left);
    }];
    
    [self.postDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profilePicture.mas_bottom).with.offset(6);
        make.left.equalTo(self.profilePicture.mas_left);
        make.width.lessThanOrEqualTo(@290);
    }];
    
    self.separatorView.frame = CGRectMake(cellWidth - 60, 10, 1, cellHeight - 10);
    
    CGFloat centerY = (cellHeight + verticalInset)/2;
    CGFloat labelOriginX = self.separatorView.frame.origin.x + self.separatorView.frame.size.width;
    CGFloat labelHeight = self.postDistanceLabel.frame.size.height;
    self.postDistanceLabel.frame = CGRectMake(labelOriginX, centerY - labelHeight, cellWidth - labelOriginX - horizontalInset, labelHeight);
    self.postDistanceLabel.textAlignment = NSTextAlignmentCenter;
    
    self.milesLabel.frame = CGRectMake(labelOriginX + 1, centerY, self.postDistanceLabel.frame.size.width, self.milesLabel.frame.size.height);
}

@end








