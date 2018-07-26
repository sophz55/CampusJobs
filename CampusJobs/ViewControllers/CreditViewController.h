//
//  CreditViewController.h
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/24/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *CardNumber;
@property (weak, nonatomic) IBOutlet UITextField *Expiration;
@property (weak, nonatomic) IBOutlet UITextField *Security;
@property (weak, nonatomic) IBOutlet UITextField *BillingCode;


@property (strong) NSManagedObjectModel *device;


- (IBAction)DismissKeyboard:(id)sender;


- (IBAction)SaveData:(id)sender;





@end

