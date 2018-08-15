//
//  Alert.m
//  CampusJobs
//
//  Created by Sophia Zheng on 8/1/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "Alert.h"

@implementation Alert

+ (void)callAlertWithTitle:(NSString *)title alertMessage:(NSString *)message viewController:(UIViewController *)controller {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
    }];
    [alert addAction:okAction];
    
    [controller presentViewController:alert animated:YES completion:^{}];
}

+ (void)callConfirmationWithTitle:(NSString *)title confirmationMessage:(NSString *)message yesActionTitle:(NSString *)yesTitle noActionTitle:(NSString *)noTitle viewController:(UIViewController<AlertDelegate> *)controller {
    Alert *helper = [Alert new];
    helper.delegate = controller;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create No action
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:noTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [helper confirmationAlertHandler:NO];
    }];
    [alert addAction:noAction];
    
    // create Yes action
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:yesTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [helper confirmationAlertHandler:YES];
    }];
    [alert addAction:yesAction];
    
    [controller presentViewController:alert animated:YES completion:^{}];
}

- (void)confirmationAlertHandler:(BOOL)response {
    [self.delegate confirmationAlertHandler:response];
}

@end
