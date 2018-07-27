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
    self.post=previousPost;
    self.previousPostTitleLabel.text=previousPost.title;
    if(previousPost.postStatus==OPEN){
        self.statusLabel.text=@"Status: Open Job";
        self.takerLabel.hidden=YES;
    } else if(previousPost.postStatus==IN_PROGRESS){
        self.statusLabel.text=@"Status: Price Confirmed, Transaction In Progress";
        self.takerLabel.hidden=NO;
        self.takerLabel.text=[NSString stringWithFormat:@"Taken by: %@", previousPost.taker.username];
    } else{
        self.statusLabel.text=@"Status: Transaction Completed";
        self.takerLabel.hidden=NO;
        self.takerLabel.text=[NSString stringWithFormat:@"Taken by: %@", previousPost.taker.username];
    }
    
}

@end
