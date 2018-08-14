//
//  PreviousUserPostCell.h
//  CampusJobs
//
//  Created by Sophia Khezri on 7/17/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface PreviousUserPostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *previousPostTitleLabel;
@property (strong, nonatomic) Post * post;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *takerLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

-(void)setPreviousPost:(Post *)previousPost;

@end
