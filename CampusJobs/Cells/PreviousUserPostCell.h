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
@property (weak, nonatomic) IBOutlet UILabel *completedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedOnLabel;
@property (strong, nonatomic) Post * previousPost;

-(void)setPreviousPost:(Post *)previousPost;

@end
