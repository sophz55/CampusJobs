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
#import "Utils.h"
#import "SegueConstants.h"
#import "SignUpViewController.h"

@interface EditPaymentInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberField;
@property (weak, nonatomic) IBOutlet UITextField *expDateField;
@property (weak, nonatomic) IBOutlet UITextField *securityCodeField;
@property (weak, nonatomic) IBOutlet UITextField *addressLine1Field;
@property (weak, nonatomic) IBOutlet UITextField *addressLine2Field;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeField;
@property (strong, nonatomic) PFUser *user;

@property (weak, nonatomic) IBOutlet UILabel *pageTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@end

@implementation EditPaymentInfoViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [PFUser currentUser];
    [self populateFieldsWithExistingInformation];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configureViewByParent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initial Configurations

- (void)configureViewByParent {
    if ([self.presentingViewController isKindOfClass:[SignUpViewController class]]) {
        self.pageTitleLabel.text = [NSString stringWithFormat:@"Welcome, %@! Enter Payment Card Information", self.user.username];
        self.saveButton.titleLabel.text = @"Add Card";
        [Utils showButton:self.skipButton];
    } else {
        self.pageTitleLabel.text = @"Edit Debit or Credit Card Information";
        self.saveButton.titleLabel.text = @"Update";
        [Utils hideButton:self.skipButton];
    }
}

- (void)populateFieldsWithExistingInformation {
    if (self.user[@"card"]) {
        Card *card = self.user[@"card"];
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

#pragma mark - IBAction

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
    
    if (![self.nameField.text isEqualToString:@""] && ![self.cardNumberField.text isEqualToString:@""] && ![self.expDateField.text isEqualToString:@""] && ![self.securityCodeField.text isEqualToString:@""] && ![self.addressLine1Field.text isEqualToString:@""] && ![self.zipcodeField.text isEqualToString:@""]){
        [card saveInBackgroundWithBlock:^(BOOL didSaveCard, NSError *errorSavingCard) {
            if (didSaveCard) {
                if (!self.user[@"card"]) {
                    self.user[@"card"] = card;
                }
                [self.user saveInBackgroundWithBlock:^(BOOL didSaveUser, NSError *errorSavingUser) {
                    if (didSaveUser) {
                        if ([self.presentingViewController isKindOfClass:[SignUpViewController class]]) {
                            [self performSegueWithIdentifier:addCardToMapSegue sender:nil];
                        } else {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                    } else {
                        [Utils callAlertWithTitle:@"Error saving card to user" alertMessage:[NSString stringWithFormat:@"%@", errorSavingUser] viewController:self];
                    }
                }];
            } else {
                [Utils callAlertWithTitle:@"Error saving card" alertMessage:[NSString stringWithFormat:@"%@", errorSavingCard] viewController:self];
            }
        }];
    } else {
        [Utils callAlertWithTitle:@"Could not save card info" alertMessage:@"Some required fields are blank!" viewController:self];
    }
}

- (IBAction)didTapSkipButton:(id)sender {
    [self performSegueWithIdentifier:addCardToMapSegue sender:nil];
}

- (IBAction)didTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
