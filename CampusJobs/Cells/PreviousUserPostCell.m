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
    if(previousPost.status==0){
        self.statusLabel.text=@"Open Job";
        self.takerLabel.hidden=YES;
    } else if(previousPost.status.intValue==1){
        self.statusLabel.text=@"Price Confirmed, Transaction In Progress";
        self.takerLabel.hidden=NO;
        self.takerLabel.text=previousPost.taker.username;
    } else{
        self.statusLabel.text=@"Transaction Completed";
        self.takerLabel.hidden=NO;
        self.takerLabel.text=previousPost.taker.username;
    }
    //Converting from NSDate to NSString (MM-dd-yyyy)
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
//    if(previousPost.status.intValue==2){
//        self.dateLabel.hidden=NO;
//        self.dateLabel.text=[formatter stringFromDate:previousPost.completedDate];
//    } else{
//        self.dateLabel.hidden=YES;
//    }
    
    
}

@end
