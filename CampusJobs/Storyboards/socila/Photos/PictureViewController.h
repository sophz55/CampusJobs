//
//  ViewController.m
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/29/18.
//  Copyright © 2018 So What. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    UIImagePickerController *picker;
    UIImage *image;
    
    SLComposeViewController *composer;
    
}

@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

- (IBAction)TakePhoto:(id)sender;
- (IBAction)LoadLibrary:(id)sender;

- (IBAction)Facebook:(id)sender;
- (IBAction)Twitter:(id)sender;

- (IBAction)DismissKeyboard:(id)sender;
@end

