//
//  NearbyPostCell.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/17/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "NearbyPostCell.h"

@implementation NearbyPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setNearbyPost:(Post *)post{
    _post=post;
    self.postUserLabel.text=post.author;
    self.postTitleLabel.text=post.title;
    self.postDescriptionLabel.text=post.summary;
    self.postDistanceLabel.text=post.location;
    //Converting from NSDate to NSString (MM-dd-yyyy)
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    self.postDateLabel.text=[formatter stringFromDate:post.createdAt];
}


@end
