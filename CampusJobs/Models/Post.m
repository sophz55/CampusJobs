//
//  Post.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "Post.h"
#import "Conversation.h"
#import "Alert.h"

@implementation Post

@dynamic title;
@dynamic summary;
@dynamic price;
@dynamic author;
@dynamic taker;
@dynamic conversation;
@dynamic completedDate;
@dynamic postStatus; // 0 if open, 1 if job is taken, 2 if job is closed
@dynamic photoFiles; //array of PFFiles
@dynamic location;
@dynamic locationAddress;

// conforming to subclassing protocol
+ (nonnull NSString *) parseClassName{
    return @"Post";
}

// Posts job
+ (void) postJob: (NSString * _Nullable)title withSummary:(NSString * _Nullable)summary withLocation:(PFGeoPoint * _Nullable)postLocation withLocationAddress:(NSString *_Nullable)locationAddress withImages:(NSArray * _Nullable)images withDate:(NSDate *)date withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Post *newPost = [Post new];
    newPost.title = title;
    newPost.summary = summary;
    newPost.price = nil;
    newPost.author = [PFUser currentUser];
    newPost.taker = nil;
    newPost.conversation = nil;
    newPost.completedDate = date;
    newPost.postStatus = OPEN;
    newPost.location=postLocation;
    newPost.photoFiles = [NSMutableArray array];
    newPost.locationAddress=locationAddress;
    for (id image in images) {
        [newPost.photoFiles addObject:[self getPFFileFromImage:image]];
    }
    
    [newPost saveInBackgroundWithBlock: completion];
}

+ (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFile fileWithName:@"image.png" data:imageData];
}

- (void)acceptJobWithPrice:(NSNumber *)price withTaker:(PFUser *)taker withConversation:(PFObject *)conversation withCompletion:(PFBooleanResultBlock _Nullable)completion {
    self.conversation = conversation;
    self.price = price;
    self.taker = taker;
    self.postStatus = IN_PROGRESS;
    [self saveInBackgroundWithBlock:^(BOOL didAcceptJob, NSError *error) {
        if (didAcceptJob) {
            PFUser *user = [PFUser currentUser];
            PFUser *otherUser;
            if ([user.objectId isEqualToString:self.taker.objectId]) {
                otherUser = self.author;
            } else {
                otherUser = self.taker;
            }
            
            [(Conversation *)conversation addToConversationWithSystemMessageWithText:[NSString stringWithFormat:@"%@ accepted the price $%@. This job is now in progress - please coordinate how you would like to proceed!", user.username, price] withSender:user withReceiver:otherUser withCompletion:completion];
        }
    }];
}

- (void)cancelJobWithConversation:(PFObject *)conversation withCompletion:(PFBooleanResultBlock _Nullable)completion {
    self.price = nil;
    self.taker = nil;
    self.conversation = nil;
    self.postStatus = OPEN;
    [self saveInBackgroundWithBlock:^(BOOL didCancelJob, NSError *error) {
        if (didCancelJob) {
            PFUser *user = [PFUser currentUser];
            PFUser *otherUser;
            if ([user.objectId isEqualToString:self.taker.objectId]) {
                otherUser = self.author;
            } else {
                otherUser = self.taker;
            }
            
            [(Conversation *)conversation addToConversationWithSystemMessageWithText:[NSString stringWithFormat:@"%@ canceled the job. Please coordinate further to proceed!", user.username] withSender:user withReceiver:otherUser withCompletion:completion];
        }
    }];
}

- (void)completeJobWithCompletion:(PFBooleanResultBlock _Nullable)completion{
    self.postStatus = CLOSED;
    [self saveInBackgroundWithBlock:completion];
    
    // TO DO: complete payment
}

- (void)deletePostAndConversationsWithCompletion:(PFBooleanResultBlock _Nullable)completion {
    [Conversation deleteAllWithPost:self withCompletion:^(BOOL didDeleteConversations, NSError *error){
        if (didDeleteConversations) {
            [self deleteInBackgroundWithBlock:completion];
        }
    }];
}



@end
