//
//  Utils.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/26/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void)callAlertWithTitle:(NSString *)title alertMessage:(NSString *)message viewController:(UIViewController *)controller {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
    }];
    [alert addAction:okAction];
    
    [controller presentViewController:alert animated:YES completion:^{}];
}

+ (void)animateView:(UIView *)view withDistance:(CGFloat)distance up:(BOOL)up {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    [UIView setAnimationBeginsFromCurrentState:TRUE];
    if (up) {
        distance *= -1;
    }
    
    view.frame = CGRectOffset(view.frame, 0, distance);
    
    [UIView commitAnimations];
}

+ (void)showButton:(UIButton *)button {
    [button setEnabled:YES];
    [button setTintColor:nil];
}

+ (void)hideButton:(UIButton *)button {
    [button setEnabled:NO];
    [button setTintColor:[UIColor clearColor]];
}

+ (void)showBarButton:(UIBarButtonItem *)button {
    [button setEnabled:YES];
    [button setTintColor:nil];
}

+ (void)hideBarButton:(UIBarButtonItem *)button {
    [button setEnabled:NO];
    [button setTintColor:[UIColor clearColor]];
}

@end
