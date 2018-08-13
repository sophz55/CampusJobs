//
//  SegueConstants.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/26/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "SegueConstants.h"

@implementation SegueConstants

#pragma mark - login/sign up segues
NSString *const loginToFeedSegue = @"loginToFeedSegue";
NSString *const signUpToAddCardSegue = @"signUpToAddCardSegue";
NSString *const addCardToMapSegue = @"addCardToMapSegue";
NSString *const mapToFeedSegue = @"mapToTabBarSegue";
NSString *const backToProfileSegue = @"backToProfileSegue";

#pragma mark - feed segues
NSString *const feedToComposePostSegue = @"composeNewPostSegue";
NSString *const nearbyPostingsToSearchSegue = @"nearbyPostingsToSearchSegue";
NSString *const yourPostingsToSearchSegue = @"yourPostingsToSearchSegue";
NSString *const nearbyPostingsToPostDetailsSegue = @"cellToPostDetailsSegue";
NSString *const yourPostingsToPostDetailsSegue = @"yourPostingsToDetailSegue";
NSString *const postDetailsToMessageSegue = @"chatSegue";
NSString *const postDetailsToEditPostSegue = @"postDetailsToEditPostSegue";
NSString *const postDetailsToMapSegue = @"detailsToMapSegue";

#pragma mark - compose post segues
NSString *const composePostToFeedSegue = @"backToPersonalFeedSegue";
NSString *const composePostToMapSegue = @"composeToMapSegue";

#pragma mark - conversation segues
NSString *const messagesToSuggestPriceSegue = @"suggestPriceModalSegue";
NSString *const messagesToPostDetailsSegue = @"messageToPostSegue";
NSString *const messagesToJobCompletedSegue = @"messagesToJobCompletedSegue";
NSString *const conversationsToMessagesSegue = @"conversationsToDetailSegue";
NSString *const jobCompletedToTabBarSegue = @"jobCompletedToTabBarSegue";

#pragma mark - user profile segues
NSString *const profileToLogoutSegue = @"logoutSegue";

@end
