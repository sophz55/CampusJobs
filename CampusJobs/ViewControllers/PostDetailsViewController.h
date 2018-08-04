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

@protocol PostDetailsDelegate

- (void)reloadData;

@end

@interface PostDetailsViewController : UIViewController

@property (strong, nonatomic) UIViewController <PostDetailsDelegate> *delegate;
@property (strong, nonatomic) Post * post;

-(void)setDetailsPost:(Post *)post;


@end
