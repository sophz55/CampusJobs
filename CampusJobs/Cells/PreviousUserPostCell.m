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
    if(previousPost.postStatus==openStatus){
        self.statusLabel.text=@"Open Job";
        self.takerLabel.hidden=YES;
    } else if(previousPost.postStatus==inProgress){
        self.statusLabel.text=@"Price Confirmed, Transaction In Progress";
        self.takerLabel.hidden=NO;
        self.takerLabel.text=previousPost.taker.username;
    } else{
        self.statusLabel.text=@"Transaction Completed";
        self.takerLabel.hidden=NO;
        self.takerLabel.text=previousPost.taker.username;
    }
    
}

@end
