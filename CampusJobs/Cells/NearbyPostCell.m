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

-(void)setPost:(Post *)post{
    _post=post;
    self.postUserLabel.text=post.author.username;
    self.postTitleLabel.text=post.title;
    self.postDescriptionLabel.text=post.summary;
    self.postDistanceLabel.text=post.location;
    //self.postDateLabel.text=post.date;
}


@end
