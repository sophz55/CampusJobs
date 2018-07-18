//
//  PreviousUserPostCell.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/17/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "PreviousUserPostCell.h"

@implementation PreviousUserPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPreviousPost:(Post *)previousPost{
    _previousPost=previousPost;
    self.previousPostTitleLabel.text=previousPost.title;
    self.completedByLabel.text=previousPost.taker.username;
    //Converting from NSDate to NSString (MM-dd-yyyy)
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    self.completedOnLabel.text=[formatter stringFromDate:previousPost.completedDate];
    
}

@end
