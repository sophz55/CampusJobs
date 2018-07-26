//
//  EditPaymentInfoViewController.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/26/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "EditPaymentInfoViewController.h"
#import <Parse/Parse.h>
#import "Card.h"
#import "Helper.h"

@interface EditPaymentInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberField;
@property (weak, nonatomic) IBOutlet UITextField *expDateField;
@property (weak, nonatomic) IBOutlet UITextField *securityCodeField;
@property (weak, nonatomic) IBOutlet UITextField *addressLine1Field;
@property (weak, nonatomic) IBOutlet UITextField *addressLine2Field;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeField;
@property (strong, nonatomic) PFUser *user;

@end

@implementation EditPaymentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [PFUser currentUser];
    [self populateFieldsWithExistingInformation];
}

- (void)populateFieldsWithExistingInformation {
    Card *card = self.user[@"card"];
    if (card) {
        self.nameField.text = card.billingName;
        self.cardNumberField.text = card.cardNumber;
        self.expDateField.text = card.expDate;
        self.securityCodeField.text = card.securityCode;
        self.addressLine1Field.text = card.addressLine1;
        self.addressLine2Field.text = card.addressLine2;
        self.zipcodeField.text = card.cityStateZip;
    } else {
        self.nameField.text = self.user[@"name"];
    }
}

- (IBAction)didTapAway:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)didTapSaveButton:(id)sender {
    Card *card;
    if (self.user[@"card"]) {
        card = self.user[@"card"];
    } else {
        card = [[Card alloc] init];
    }
    
    card.billingName = self.nameField.text;
    card.cardNumber = self.cardNumberField.text;
    card.expDate = self.expDateField.text;
    card.securityCode = self.securityCodeField.text;
    card.addressLine1 = self.addressLine1Field.text;
    card.addressLine2 = self.addressLine2Field.text;
    card.cityStateZip = self.zipcodeField.text;
    
    [card saveInBackgroundWithBlock:^(BOOL savedCard, NSError *errorSavingCard) {
        if (savedCard) {
            if (!self.user[@"card"]) {
                self.user[@"card"] = card;
            }
            [self.user saveInBackgroundWithBlock:^(BOOL savedUser, NSError *errorSavingUser) {
                if (savedUser) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [Helper callAlertWithTitle:@"Error saving card to user" alertMessage:[NSString stringWithFormat:@"%@", errorSavingUser] viewController:self];
                }
            }];
        } else {
            [Helper callAlertWithTitle:@"Error saving card" alertMessage:[NSString stringWithFormat:@"%@", errorSavingCard] viewController:self];
        }
    }];
}

- (IBAction)didTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
