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
@dynamic sender;
@dynamic receiver;
@dynamic suggestedPrice;
@dynamic isSystemMessage;

// conforming to subclassing protocol
+ (nonnull NSString *) parseClassName{
    return @"Message";
}

+ (void)createMessageWithText:(NSString *)text withSender:(PFUser *)sender withReceiver:(PFUser *)receiver withCompletion:(CompletionBlock)completion {
    Message *newMessage = [Message new];
    newMessage.text = text;
    newMessage.sender = sender;
    newMessage.receiver = receiver;
    newMessage.isSystemMessage = NO;
    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(newMessage, nil);
    }];
}

+ (void)createMessageWithPrice:(int)suggestedPrice withText:(NSString *)text withSender:(PFUser *)sender withReceiver:(PFUser *)receiver withCompletion:(CompletionBlock)completion {
    Message *newMessage = [Message new];
    newMessage.text = text;
    newMessage.sender = sender;
    newMessage.receiver = receiver;
    newMessage.suggestedPrice = suggestedPrice;
    newMessage.isSystemMessage = YES;
    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(newMessage, nil);
    }];
}

@end
