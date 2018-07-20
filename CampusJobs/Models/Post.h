//
//  Post.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Helper.h"

@interface Post : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) PFUser *author;
@property (strong, nonatomic) PFUser *taker;
@property (strong, nonatomic) NSDate *completedDate;
@property (assign, nonatomic) NSNumber *status; // 0 if open, 1 if job is taken, 2 if job is finished

@property (strong, nonatomic) NSMutableArray *photoFiles; //array of PFFiles
@property (strong, nonatomic) NSString *location;

+ (void) postJob: (NSString * _Nullable)title withSummary:(NSString * _Nullable)summary withLocation:(NSString * _Nullable)location withImages:(NSArray * _Nullable)images withDate:(NSDate *)date withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
