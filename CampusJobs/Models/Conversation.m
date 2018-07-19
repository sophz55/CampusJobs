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

+ (id)createNewConversationWithPost:(Post *)post withSeeker:(PFUser *)seeker withCompletion:(PFBooleanResultBlock _Nullable)completion {
    Conversation *newConversation = [Conversation new];
    newConversation.post = post;
    newConversation.messages = [[NSMutableArray alloc] init];
    newConversation.seeker = seeker;
    [newConversation saveInBackgroundWithBlock: completion];
    return newConversation;
}

- (void)addToConversationWithMessage:(Message *)message withCompletion:(PFBooleanResultBlock _Nullable)completion {
    NSLog(@"is this happening");
    [self.messages addObject:message];
    [self saveInBackgroundWithBlock:completion];
}

@end
