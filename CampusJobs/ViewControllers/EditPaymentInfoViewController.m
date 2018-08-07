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
#import "Alert.h"
#import "SegueConstants.h"
#import "SignUpViewController.h"
#import <MaterialComponents/MaterialTextFields.h>
#import <MaterialComponents/MaterialButtons.h>
#import <MaterialComponents/MaterialTextFields+ColorThemer.h>
#import <MaterialComponents/MaterialButtons+ColorThemer.h>
#import <MaterialComponents/MaterialAppBar.h>
#import "Format.h"
#import "AppScheme.h"

@interface EditPaymentInfoViewController ()
@property (weak, nonatomic) IBOutlet MDCTextField *nameField;
@property (weak, nonatomic) IBOutlet MDCTextField *cardNumberField;
@property (weak, nonatomic) IBOutlet MDCTextField *expDateField;
@property (weak, nonatomic) IBOutlet MDCTextField *securityCodeField;
@property (weak, nonatomic) IBOutlet MDCTextField *addressLine1Field;
@property (weak, nonatomic) IBOutlet MDCTextField *addressLine2Field;
@property (weak, nonatomic) IBOutlet MDCTextField *zipcodeField;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *securityCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) MDCAppBar *appBar;

@property (weak, nonatomic) IBOutlet MDCRaisedButton *saveButton;
@property (weak, nonatomic) IBOutlet MDCRaisedButton *skipButton;
@property (weak, nonatomic) IBOutlet MDCRaisedButton *cancelButton;

@end

@implementation EditPaymentInfoViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [PFUser currentUser];
    [self populateFieldsWithExistingInformation];
    [self configureNavigationBar];
    [self formatColors];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configureViewByDelegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initial Configurations

- (void)configureViewByDelegate {
    if ([self.delegate isKindOfClass:[SignUpViewController class]]) {
        [self setTitle:@"Add a Payment Card"];
        [self.saveButton setTitle:@"Add Card" forState:UIControlStateNormal];
        self.skipButton.hidden = NO;
    } else {
        [self setTitle:@"Edit Debit or Credit Card Information"];
        [self.saveButton setTitle:@"Update" forState:UIControlStateNormal];
        self.skipButton.hidden = YES;
    }
    
    [self.cancelButton sizeToFit];
    [self.skipButton sizeToFit];
    [self.saveButton sizeToFit];
}

- (void)populateFieldsWithExistingInformation {
    if (self.user[@"card"]) {
        Card *card = self.user[@"card"];
        [card fetchIfNeededInBackgroundWithBlock:^(PFObject *fetchedCard, NSError *error) {
            if (fetchedCard) {
                self.nameField.text = card.billingName;
                self.cardNumberField.text = card.cardNumber;
                self.expDateField.text = card.expDate;
                self.securityCodeField.text = card.securityCode;
                self.addressLine1Field.text = card.addressLine1;
                self.addressLine2Field.text = card.addressLine2;
                self.zipcodeField.text = card.cityStateZip;
            }
        }];
    } else {
        self.nameField.text = self.user[@"name"];
    }
}

- (void)configureNavigationBar {
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    [self.appBar addSubviewsToParent];
    
    [Format formatAppBar:self.appBar withTitle:@""];
}

- (void)formatColors {
    [Format addGreyGradientToView:self.view];
    
    id<MDCColorScheming> colorScheme = [AppScheme sharedInstance].colorScheme;
    [MDCContainedButtonColorThemer applySemanticColorScheme:colorScheme toButton:self.cancelButton];
    [MDCContainedButtonColorThemer applySemanticColorScheme:colorScheme toButton:self.skipButton];
    [MDCContainedButtonColorThemer applySemanticColorScheme:colorScheme toButton:self.saveButton];
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
                        if ([self.delegate isKindOfClass:[SignUpViewController class]]) {
                            [self performSegueWithIdentifier:addCardToMapSegue sender:nil];
                        } else {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                    } else {
                        [Alert callAlertWithTitle:@"Error saving card to user" alertMessage:[NSString stringWithFormat:@"%@", errorSavingUser] viewController:self];
                    }
                }];
            } else {
                [Alert callAlertWithTitle:@"Error saving card" alertMessage:[NSString stringWithFormat:@"%@", errorSavingCard] viewController:self];
            }
        }];
    } else {
        [Alert callAlertWithTitle:@"Could not save card info" alertMessage:@"Some required fields are blank!" viewController:self];
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
