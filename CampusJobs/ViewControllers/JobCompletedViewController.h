//
//  JobCompletedViewController.h
//  CampusJobs
//
//  Created by Sophia Zheng on 8/9/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Post.h"

@interface JobCompletedViewController : UIViewController

@property (strong, nonatomic) PFUser *otherUser;
@property (strong, nonatomic) Post *post;

@end
