//
//  Message.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Message : PFObject <PFSubclassing>

@property(strong, nonatomic) NSString *text;
@property(strong, nonatomic) NSDate *time;
@property(strong, nonatomic) PFUser *sender;
@property(strong, nonatomic) PFUser *receiver;

@end
