//
//  Alert.h
//  CampusJobs
//
//  Created by Sophia Zheng on 8/1/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@protocol AlertDelegate

- (void) confirmationAlertHandler:(BOOL)response;

@end

@interface Alert : NSObject

@property (strong, nonatomic) UIViewController <AlertDelegate> *delegate;

+ (void)callAlertWithTitle:(NSString *)title alertMessage:(NSString *)message viewController:(UIViewController *)controller;

+ (void)callConfirmationWithTitle:(NSString *)title confirmationMessage:(NSString *)message yesActionTitle:(NSString *)yesTitle noActionTitle:(NSString *)noTitle viewController:(UIViewController<AlertDelegate> *)controller;

@end
