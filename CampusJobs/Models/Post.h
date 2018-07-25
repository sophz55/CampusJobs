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
#import <MapKit/MapKit.h>

/*
creating an enum type for the status
open: user has not officially accepted an offer from a taker
inProgress: price has been confirmed, but service and transaction have not been confirmed
finished: transaction has been confirmed
*/
typedef enum{
    openStatus=0, inProgress=1, finished=2
} status;

@interface Post : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) PFUser *author;
@property (strong, nonatomic) PFUser *taker;
@property (strong, nonatomic) NSDate *completedDate;
@property (assign, nonatomic) status postStatus;
 // 0 if open, 1 if job is taken, 2 if job is finished

@property (strong, nonatomic) NSMutableArray *photoFiles; //array of PFFiles

//saving the post location as an NSValue, but will be converted back to CLLocationCoordinate2D
@property (assign, nonatomic) PFGeoPoint * location;


+ (void) postJob: (NSString * _Nullable)title withSummary:(NSString * _Nullable)summary withLocation:(PFGeoPoint * _Nullable)location withImages:(NSArray * _Nullable)images withDate:(NSDate *)date withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
