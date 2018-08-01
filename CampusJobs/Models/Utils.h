//
//  Utils.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/26/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@protocol UtilsDelegate

- (void) confirmationAlertHandler:(BOOL)response;

@end

@interface Utils : NSObject

@property (strong, nonatomic) UIViewController <UtilsDelegate> *delegate;

+ (void)callAlertWithTitle:(NSString *)title alertMessage:(NSString *)message viewController:(UIViewController *)controller;

+ (void)callConfirmationWithTitle:(NSString *)title confirmationMessage:(NSString *)message yesActionTitle:(NSString *)yesTitle noActionTitle:(NSString *)noTitle viewController:(UIViewController<UtilsDelegate> *)controller;

+ (void)animateView:(UIView *)view withDistance:(CGFloat)distance up:(BOOL)up;

+ (double)calculateDistance:(PFGeoPoint *)postLocation betweenUserandPost:(PFGeoPoint *)userLocation;



@end
