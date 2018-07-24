
//
//  PhotoViewController.h
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/24/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface PhotoViewController : UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    UIImagePickerController *picker;
    UIImage *image;
    
    SLComposeViewController *composer;
    
}





@property (weak, nonatomic) IBOutlet UITextField *TextField;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
- (IBAction)TakePhoto:(id)sender;
- (IBAction)LoadLibrary:(id)sender;

- (IBAction)Facebook:(id)sender;

- (IBAction)Twitter:(id)sender;

- (IBAction)DismissKeyboard:(id)sender;


@end
