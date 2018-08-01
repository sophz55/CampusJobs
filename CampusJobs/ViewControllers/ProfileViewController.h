//
//  ProfileViewController.h
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/23/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

- (IBAction)Name:(id)sender;
- (IBAction)Name:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *NameTextField;
- (IBAction)DismissKeyboard:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;


@property (weak, nonatomic) IBOutlet UITextField *EmailTextField;
- (IBAction)DismissKeyboardEmail:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *EmailLabel;

@property (weak, nonatomic) IBOutlet UITextField *Address;

- (IBAction)DismissKeyboardAddress:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;

- (IBAction)Save:(id)sender;

- (IBAction)Refresh:(id)sender;




@end
