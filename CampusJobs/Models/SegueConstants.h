//
//  SegueConstants.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/26/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SegueConstants : NSObject

#pragma mark - login/sign up segues
extern NSString *const loginToFeedSegue;
extern NSString *const signUpToAddCardSegue;
extern NSString *const addCardToMapSegue;
extern NSString *const mapToFeedSegue;
extern NSString *const backToProfileSegue;

#pragma mark - feed segues
extern NSString *const feedToLogoutSegue;
extern NSString *const nearbyPostingsToPostDetailsSegue;
extern NSString *const yourPostingsToComposePostSegue;
extern NSString *const yourPostingsToPostDetailsSegue;
extern NSString *const postDetailsToMessageSegue;
extern NSString *const postDetailsToEditPostSegue;
extern NSString *const postDetailsToMapSegue;

#pragma mark - compose post segues
extern NSString *const composePostToFeedSegue;
extern NSString *const composePostToMapSegue;

#pragma mark - conversation segues
extern NSString *const messagesToSuggestPriceSegue;
extern NSString *const messagesToPostDetailsSegue;
extern NSString *const conversationsToMessagesSegue;

#pragma mark - user profile segues

@end
