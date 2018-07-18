//
//  Conversation.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "Conversation.h"

@implementation Conversation

@dynamic messages;
@dynamic post;
@dynamic seeker;

// conforming to subclassing protocol
+ (nonnull NSString *) parseClassName{
    return @"Conversation";
}

@end
