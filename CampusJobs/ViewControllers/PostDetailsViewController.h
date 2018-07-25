//
//  PostDetailsViewController.h
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Post.h"

@interface PostDetailsViewController : UIViewController
@property (strong, nonatomic) Post * post;
@property (weak, nonatomic) IBOutlet UILabel *titleDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionDetailsLabel;
@property (strong, nonatomic) UIViewController *parentVC;

-(void)setDetailsPost:(Post *)post;



@end
