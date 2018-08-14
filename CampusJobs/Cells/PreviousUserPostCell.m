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
#import "StringConstants.h"
#import "Masonry.h"

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
    
    //set fonts
    self.previousPostTitleLabel.font=[UIFont fontWithName:boldFontName size:18];
    self.statusLabel.font=[UIFont fontWithName:boldFontName size:14];
    self.takerLabel.font=[UIFont fontWithName:lightFontName size:15];
    self.dateLabel.font=[UIFont fontWithName:lightFontName size:16];
    
    //set text for each field
    self.previousPostTitleLabel.text=[previousPost.title uppercaseString];
    if ([previousPost.title isEqualToString:@""]) {
        self.previousPostTitleLabel.text = @"UNTITLED POST";
    }
    if(previousPost.postStatus == OPEN){
        self.statusLabel.text = @"OPEN";
        self.takerLabel.hidden = NO;
        self.takerLabel.text = @"";
    } else if(previousPost.postStatus == IN_PROGRESS){
        self.statusLabel.text = @"IN PROGRESS";
        self.takerLabel.hidden = NO;
        self.takerLabel.text = [NSString stringWithFormat:@"Taken by: %@", previousPost.taker.username];
    } else{
        self.statusLabel.text = @"COMPLETED";
        self.takerLabel.hidden = NO;
        self.takerLabel.text = [NSString stringWithFormat:@"Completed by: %@", previousPost.taker.username];
    }
    
    //Format the date (date the post was posted on)
    NSDateFormatter * formatter= [[NSDateFormatter alloc] init];
    formatter.dateFormat=@"E MMM d HH:mm:ss Z y";
    formatter.dateStyle= NSDateFormatterShortStyle;
    formatter.timeStyle= NSDateFormatterNoStyle;
    NSDate * createdAt= self.post.createdAt;
    NSString * timeAgo= [NSDate shortTimeAgoSinceDate:createdAt];
    self.dateLabel.text= timeAgo;
    
    [self configureLayout];
}

- (void)configureLayout {
    CGFloat verticalInset = 15;
    CGFloat horizontalInset = 10;
    CGFloat verticalSpace = 2;
    CGFloat cellWidth = self.layer.frame.size.width;
    CGFloat cellHeight = self.layer.frame.size.height;
    
    [self.previousPostTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(verticalInset));
        make.left.equalTo(@(20));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.previousPostTitleLabel.mas_bottom).with.offset(verticalSpace);
        make.left.equalTo(self.previousPostTitleLabel.mas_left);
    }];
    
    [self.takerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).with.offset(verticalSpace);
        make.left.equalTo(self.dateLabel.mas_left);
    }];
    
    self.separatorView.frame = CGRectMake(cellWidth - 90, 10, 1, cellHeight - 10);
    CGFloat labelOriginX = self.separatorView.frame.origin.x + self.separatorView.frame.size.width;
    CGFloat labelHeight = self.statusLabel.frame.size.height;
    self.statusLabel.frame = CGRectMake(labelOriginX + 5, (cellHeight + verticalInset - labelHeight - 5)/2, cellWidth - horizontalInset - labelOriginX - 10, labelHeight);
}

@end
