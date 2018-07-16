//
//  Post.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Post : PFObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) PFUser *author;
@property (strong, nonatomic) PFUser *taker;
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) NSNumber *status; // 0 if open, 1 if job is taken, 2 if job is finished

@property (strong, nonatomic) NSMutableArray *photoFiles; //array of PFFiles
@property (strong, nonatomic) NSString *location;

@end
