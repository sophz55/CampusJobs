//
//  AddViewController.h
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/24/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *Name;
@property (weak, nonatomic) IBOutlet UITextField *Email;

@property (weak, nonatomic) IBOutlet UITextField *Address;



@property (strong) NSManagedObjectModel *device;


- (IBAction)DismissKeyboard:(id)sender;

- (IBAction)SaveData:(id)sender;

@end
