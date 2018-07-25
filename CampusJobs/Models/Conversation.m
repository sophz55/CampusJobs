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

+ (void)createNewConversationWithPost:(Post *)post withSeeker:(PFUser *)seeker withCompletion:(CompletionBlock)completion {
    Conversation *newConversation = [Conversation new];
    newConversation.post = post;
    newConversation.messages = [[NSMutableArray alloc] init];
    newConversation.seeker = seeker;
    [newConversation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(newConversation, nil);
    }];
}

- (void)addToConversationWithMessageText:(NSString *)text withSender:(PFUser *)sender withReceiver:(PFUser *)receiver withCompletion:(PFBooleanResultBlock _Nullable)completion {
    [Message createMessageWithText:text withSender:sender withReceiver:receiver withCompletion:^(PFObject *createdMessage, NSError *error) {
        if (createdMessage) {
            [self addObject:createdMessage forKey:@"messages"];
            [self saveInBackgroundWithBlock:completion];
        }
    }];
}

- (void)addToConversationWithSystemMessageWithPrice:(int)price withText:(NSString *)text withSender:(PFUser *)sender withReceiver:(PFUser *)receiver withCompletion:(PFBooleanResultBlock _Nullable)completion {
    [Message createSystemMessageWithPrice:price withText:text withSender:sender withReceiver:receiver withCompletion:^(PFObject *createdMessage, NSError *error) {
        if (createdMessage) {
            [self addObject:createdMessage forKey:@"messages"];
            [self saveInBackgroundWithBlock:completion];
        }
    }];
}

- (void)addToConversationWithSystemMessageWithText:(NSString *)text withSender:(PFUser *)sender withReceiver:(PFUser *)receiver withCompletion:(PFBooleanResultBlock _Nullable)completion {
    [Message createSystemMessageWithText:text withSender:sender withReceiver:receiver withCompletion:^(PFObject *createdMessage, NSError *error) {
        if (createdMessage) {
            [self addObject:createdMessage forKey:@"messages"];
            [self saveInBackgroundWithBlock:completion];
        }
    }];
}

@end
