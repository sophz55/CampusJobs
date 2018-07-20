//
//  NearbyPostCell.h
//  CampusJobs
//
//  Created by Sophia Khezri on 7/17/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface NearbyPostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDateLabel;
@property (strong, nonatomic) Post * post;

-(void) setNearbyPost:(Post *)post;

@end
