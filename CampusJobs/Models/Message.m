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

// conforming to subclassing protocol
+ (nonnull NSString *) parseClassName{
    return @"Message";
}

+ (id)createMessageWithText:(NSString *)text withSender:(PFUser *)sender withReceiver:(PFUser *)receiver {
    Message *newMessage = [Message new];
    newMessage.text = text;
    newMessage.sender = sender;
    newMessage.receiver = receiver;
    
    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"saved message");
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    return newMessage;
}

@end
