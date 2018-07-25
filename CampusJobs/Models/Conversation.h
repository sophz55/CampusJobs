//
//  Conversation.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Post.h"
#import "Message.h"

typedef void (^CompletionBlock)(PFObject *result, NSError *error);

@interface Conversation : PFObject <PFSubclassing>

@property(strong, nonatomic) NSMutableArray *messages;
@property(strong, nonatomic) Post *post;
@property(strong, nonatomic) PFUser *seeker; // author PFUser stored in post

+ (void)createNewConversationWithPost:(Post *)post withSeeker:(PFUser *)seeker withCompletion:(CompletionBlock)completion;

- (void)addToConversationWithMessageText:(NSString *)text withSender:(PFUser *)sender withReceiver:(PFUser *)receiver withCompletion:(PFBooleanResultBlock _Nullable)completion;

- (void)addToConversationWithSystemMessageWithText:(NSString *)text withSender:(PFUser *)sender withReceiver:(PFUser *)receiver withCompletion:(PFBooleanResultBlock _Nullable)completion;

- (void)addToConversationWithSystemMessageWithPrice:(int)price withText:(NSString *)text withSender:(PFUser *)sender withReceiver:(PFUser *)receiver withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end
