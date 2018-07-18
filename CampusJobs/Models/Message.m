//
//  Message.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "Message.h"

@implementation Message

@dynamic text;
@dynamic time;
@dynamic sender;
@dynamic receiver;

// conforming to subclassing protocol
+ (nonnull NSString *) parseClassName{
    return @"Message";
}

@end
