//
//  PreviousUserPostCell.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/17/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "PreviousUserPostCell.h"
#import <MaterialComponents/MaterialTextFields+TypographyThemer.h>
#import "DateTools.h"
#import "AppScheme.h"

@implementation PreviousUserPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)setPreviousPost:(Post *)previousPost{
    self.post=previousPost;
     id<MDCTypographyScheming> typographyScheme = [AppScheme sharedInstance].typographyScheme;
    
    //set fonts
    self.previousPostTitleLabel.font=typographyScheme.overline;
    self.statusLabel.font=typographyScheme.subtitle1;
    self.dateLabel.font=typographyScheme.subtitle1;

    //set text for each field
    self.previousPostTitleLabel.text=[previousPost.title uppercaseString];
    if(previousPost.postStatus==OPEN){
        self.statusLabel.text=@"Open Job";
        self.takerLabel.hidden=YES;
    } else if(previousPost.postStatus==IN_PROGRESS){
        self.statusLabel.text=@"Price Confirmed, Transaction In Progress";
        self.takerLabel.hidden=NO;
        self.takerLabel.text=[NSString stringWithFormat:@"Taken by: %@", previousPost.taker.username];
    } else{
        self.statusLabel.text=@"Transaction Completed";
        self.takerLabel.hidden=NO;
        self.takerLabel.text=[NSString stringWithFormat:@"Completed by: %@", previousPost.taker.username];
    }
    
    //Format the date (date the post was posted on)
    NSDateFormatter * formatter= [[NSDateFormatter alloc] init];
    formatter.dateFormat=@"E MMM d HH:mm:ss Z y";
    formatter.dateStyle= NSDateFormatterShortStyle;
    formatter.timeStyle= NSDateFormatterNoStyle;
    NSDate * createdAt= self.post.createdAt;
    NSString * timeAgo= [NSDate shortTimeAgoSinceDate:createdAt];
    self.dateLabel.text= timeAgo;
}

@end
