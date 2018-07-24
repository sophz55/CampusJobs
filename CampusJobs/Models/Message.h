//
//  Message.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

typedef void (^CompletionBlock)(PFObject *result, NSError *error);

@interface Message : PFObject <PFSubclassing>

@property(strong, nonatomic) NSString *text;
@property(strong, nonatomic) PFUser *sender;
@property(strong, nonatomic) PFUser *receiver;
@property(assign, nonatomic) int suggestedPrice;

+ (void)createMessageWithText:(NSString *)text withSender:(PFUser *)sender withReceiver:(PFUser *)receiver withCompletion:(CompletionBlock)completion;

+ (void)createMessageWithPrice:(int)suggestedPrice withText:(NSString *)text withSender:(PFUser *)sender withReceiver:(PFUser *)receiver withCompletion:(CompletionBlock)completion;

@end
