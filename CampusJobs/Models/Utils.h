//
//  Utils.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/26/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Utils : NSObject

+ (void)callAlertWithTitle:(NSString *)title alertMessage:(NSString *)message viewController:(UIViewController *)controller;

+ (void)animateView:(UIView *)view withDistance:(CGFloat)distance up:(BOOL)up;

+ (void)showButton:(UIButton *)button;
+ (void)hideButton:(UIButton *)button;

+ (void)showBarButton:(UIBarButtonItem *)button;
+ (void)hideBarButton:(UIBarButtonItem *)button;


@end
