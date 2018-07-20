//
//  Post.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic title;
@dynamic summary;
@dynamic price;
@dynamic author;
@dynamic taker;
@dynamic completedDate;
@dynamic status; // 0 if open, 1 if job is taken, 2 if job is finished
@dynamic photoFiles; //array of PFFiles
@dynamic location;

// conforming to subclassing protocol
+ (nonnull NSString *) parseClassName{
    return @"Post";
}

// Posts job
+ (void) postJob: (NSString * _Nullable)title withSummary:(NSString * _Nullable)summary withLocation:(NSString * _Nullable)location withImages:(NSArray * _Nullable)images withDate:(NSDate *)date withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Post *newPost = [Post new];
    
    newPost.title = title;
    newPost.summary = summary;
    newPost.price = nil;
    newPost.author = [PFUser currentUser];
    newPost.taker = nil;
    newPost.completedDate = date;
    newPost.status = 0; // 0 if open, 1 if job is taken, 2 if job is finished
    
    newPost.photoFiles = [NSMutableArray array];
    for (id image in images) {
        [newPost.photoFiles addObject:[self getPFFileFromImage:image]];
    }
    
    NSLog (@"%@", newPost);
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

@end
