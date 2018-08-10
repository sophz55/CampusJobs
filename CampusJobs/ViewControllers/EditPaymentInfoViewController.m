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
#import "StringConstants.h"
#import "AppScheme.h"
#import "Colors.h"
#import "MapViewController.h"

@interface EditPaymentInfoViewController ()
@property (weak, nonatomic) IBOutlet MDCTextField *nameField;
@property (weak, nonatomic) IBOutlet MDCTextField *cardNumberField;
@property (weak, nonatomic) IBOutlet MDCTextField *expDateField;
@property (weak, nonatomic) IBOutlet MDCTextField *securityCodeField;
@property (weak, nonatomic) IBOutlet MDCTextField *addressLine1Field;
@property (weak, nonatomic) IBOutlet MDCTextField *addressLine2Field;
@property (weak, nonatomic) IBOutlet MDCTextField *zipcodeField;
@property (weak, nonatomic) IBOutlet MDCTextField *cityField;
@property (weak, nonatomic) IBOutlet MDCTextField *stateField;
@property (strong, nonatomic) MDCTextInputControllerUnderline *nameFieldController;
@property (strong, nonatomic) MDCTextInputControllerUnderline *cardNumberFieldController;
@property (strong, nonatomic) MDCTextInputControllerUnderline *expDateFieldController;
@property (strong, nonatomic) MDCTextInputControllerUnderline *securityCodeFieldController;
@property (strong, nonatomic) IBOutlet MDCTextInputControllerUnderline *addressLine1FieldController;
@property (strong, nonatomic) IBOutlet MDCTextInputControllerUnderline *addressLine2FieldController;
@property (strong, nonatomic) IBOutlet MDCTextInputControllerUnderline *zipcodeFieldController;
@property (strong, nonatomic) IBOutlet MDCTextInputControllerUnderline *stateFieldController;
@property (strong, nonatomic) IBOutlet MDCTextInputControllerUnderline *cityFieldController;
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
    self.user = [PFUser currentUser];
    [self populateFieldsWithExistingInformation];
    [self configureNavigationBar];
    [self configureAllButtonsAndTextFields];
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
        [self configureButtonsNewCard];
    } else {
        [self setTitle:@"EDIT PAYMENT INFORMATION"];
        [self.saveButton setTitle:@"Update" forState:UIControlStateNormal];
        self.skipButton.hidden = YES;
        [self configureButtonsEditing];
    }
}
- (void)populateFieldsWithExistingInformation {
    if (self.user[paymentCard]) {
        Card *card = self.user[paymentCard];
        [card fetchIfNeededInBackgroundWithBlock:^(PFObject *fetchedCard, NSError *error) {
            if (fetchedCard) {
                self.nameField.text = card.billingName;
                self.cardNumberField.text = card.cardNumber;
                self.expDateField.text = card.expDate;
                self.securityCodeField.text = card.securityCode;
                self.addressLine1Field.text = card.addressLine1;
                self.addressLine2Field.text = card.addressLine2;
                self.zipcodeField.text = card.zipcode;
                self.cityField.text = card.city;
                self.stateField.text = card.state;
            }
        }];
    } else {
        self.nameField.text = self.user[fullName];
    }
}

//initializes all text field controllers
- (void)configureTextFieldControllers{
    self.nameFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.nameField];
    self.nameFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.nameField];
    self.cardNumberFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.cardNumberField];
    self.expDateFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.expDateField];
    self.securityCodeFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.securityCodeField];
    self.addressLine1FieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.addressLine1Field];
    self.addressLine2FieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.addressLine2Field];
    self.zipcodeFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.zipcodeField];
    self.stateFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.stateField];
    self.cityFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.cityField];
}

//Configures the frame of payment buttons when an account is first created
- (void)configureButtonsNewCard{
    CGFloat cancelButtonOriginX=self.cardNumberField.frame.origin.x;
    CGFloat cancelButtonOriginY=self.cancelButton.frame.origin.y;
    CGFloat cancelButtonWidth=(self.cardNumberField.frame.size.width)/3-5;
    CGFloat cancelButtonHeight=self.cancelButton.frame.size.height;
    CGFloat skipButtonOriginX=cancelButtonOriginX+cancelButtonWidth+10;
    CGFloat skipButtonOriginY=self.skipButton.frame.origin.y;
    CGFloat skipButtonWidth=cancelButtonWidth;
    CGFloat skipButtonHeight=cancelButtonHeight;
    CGFloat saveButtonOriginX=skipButtonWidth+skipButtonOriginX+10;
    CGFloat saveButtonOriginY=skipButtonOriginY;
    CGFloat saveButtonWidth=cancelButtonWidth;
    CGFloat saveButtonHeight=cancelButtonHeight;
    
    self.cancelButton.frame=CGRectMake(cancelButtonOriginX,cancelButtonOriginY,cancelButtonWidth, cancelButtonHeight);
    self.skipButton.frame=CGRectMake(skipButtonOriginX, skipButtonOriginY,skipButtonWidth, skipButtonHeight);
    self.saveButton.frame=CGRectMake(saveButtonOriginX, saveButtonOriginY, saveButtonWidth, saveButtonHeight);
}

//Configures the frame of buttons when payment info is being edited
- (void)configureButtonsEditing{
    CGFloat cancelButtonWidth=(self.view.frame.size.width/2)-60;
    CGFloat cancelButtonOriginY=self.cancelButton.frame.origin.y;
    CGFloat cancelButtonHeight=self.cancelButton.frame.size.height;
    CGFloat saveButtonOriginY=self.saveButton.frame.origin.y;
    CGFloat saveButtonHeight=self.saveButton.frame.size.height;
    
    self.cancelButton.frame=CGRectMake(50,cancelButtonOriginY, cancelButtonWidth, cancelButtonHeight);
    self.saveButton.frame=CGRectMake(80+cancelButtonWidth, saveButtonOriginY, cancelButtonWidth, saveButtonHeight);
}

//initialize button fonts
- (void)configureButtonTypography{
    [self.saveButton setTitleFont:[UIFont fontWithName:@"RobotoCondensed-Bold" size:12] forState:UIControlStateNormal];
    [self.skipButton setTitleFont:[UIFont fontWithName:@"RobotoCondensed-Bold" size:12] forState:UIControlStateNormal];
    [self.cancelButton setTitleFont:[UIFont fontWithName:@"RobotoCondensed-Bold" size:12] forState:UIControlStateNormal];
}

- (void)configureNavigationBar {
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    [self.appBar addSubviewsToParent];
    [Format formatAppBar:self.appBar withTitle:@""];
}

//automatically style status bar
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.appBar.headerViewController;
}

//formats font within text fields
- (void)formatTextFieldTypography{
    UIFont * robotoCondensed=[UIFont fontWithName:@"RobotoCondensed-Regular" size:16];
    UIFont * robotoBold=[UIFont fontWithName:@"RobotoCondensed-Bold" size:16];
    
    //name field
    self.nameField.placeholderLabel.text = @"CARDHOLDER NAME";
    self.nameField.placeholderLabel.font=robotoBold;
    self.nameFieldController.inlinePlaceholderFont=robotoBold;
    self.nameField.font=robotoCondensed;
    
    //card number field
    self.cardNumberField.placeholderLabel.text=@"CARD NUMBER";
    self.cardNumberField.placeholderLabel.font=robotoBold;
    self.cardNumberFieldController.inlinePlaceholderFont=robotoBold;
    self.cardNumberField.font=robotoCondensed;
    
    //expiration date field
    self.expDateField.placeholderLabel.text=@"EXP. DATE";
    self.expDateField.placeholderLabel.font=robotoBold;
    self.expDateFieldController.inlinePlaceholderFont=robotoBold;
    self.expDateField.font=robotoCondensed;
    
    //security code field
    self.securityCodeField.placeholderLabel.text=@"CVV";
    self.securityCodeField.placeholderLabel.font=robotoBold;
    self.securityCodeFieldController.inlinePlaceholderFont=robotoBold;
    self.securityCodeField.font=robotoCondensed;
    
    //address 1 field
    self.addressLine1Field.placeholderLabel.text=@"ADDRESS 1";
    self.addressLine1Field.placeholderLabel.font=robotoBold;
    self.addressLine1FieldController.inlinePlaceholderFont=robotoBold;
    self.addressLine1Field.font=robotoCondensed;
    
    //address 2 field
    self.addressLine2Field.placeholderLabel.text=@"ADDRESS 2";
    self.addressLine2Field.placeholderLabel.font=robotoBold;
    self.addressLine2FieldController.inlinePlaceholderFont=robotoBold;
    self.addressLine2Field.font=robotoCondensed;
    
    //zipcode
    self.zipcodeField.placeholderLabel.text=@"ZIPCODE";
    self.zipcodeField.placeholderLabel.font=robotoBold;
    self.zipcodeFieldController.inlinePlaceholderFont=robotoBold;
    self.zipcodeField.font=robotoCondensed;
    
    //state
    self.stateField.placeholderLabel.text=@"STATE";
    self.stateField.placeholderLabel.font=robotoBold;
    self.stateFieldController.inlinePlaceholderFont=robotoBold;
    self.stateField.font=robotoCondensed;
    
    //city
    self.cityField.placeholderLabel.text=@"CITY";
    self.cityField.placeholderLabel.font=robotoBold;
    self.cityFieldController.inlinePlaceholderFont=robotoBold;
    self.cityField.font=robotoCondensed;
}

- (void)formatColors {
    self.view.backgroundColor=[Colors secondaryGreyLighterColor];
    id<MDCColorScheming> colorScheme = [AppScheme sharedInstance].colorScheme;
    [MDCContainedButtonColorThemer applySemanticColorScheme:colorScheme toButton:self.cancelButton];
    [MDCContainedButtonColorThemer applySemanticColorScheme:colorScheme toButton:self.skipButton];
    [MDCContainedButtonColorThemer applySemanticColorScheme:colorScheme toButton:self.saveButton];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.nameFieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.cardNumberFieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.expDateFieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.securityCodeFieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.addressLine1FieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.addressLine2FieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.zipcodeFieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.stateFieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.cityFieldController];
}

//merges all configurations regarding style,font,and color of text fields and buttons
- (void)configureAllButtonsAndTextFields{
    [self configureTextFieldControllers];
    [self formatTextFieldTypography];
    [self configureButtonTypography];
    [self formatColors];
}

#pragma mark - IBAction

- (IBAction)didTapAway:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)didTapSaveButton:(id)sender {
    Card *card;
    if (self.user[paymentCard]) {
        card = self.user[paymentCard];
    } else {
        card = [[Card alloc] init];
    }
    card.billingName = self.nameField.text;
    card.cardNumber = self.cardNumberField.text;
    card.expDate = self.expDateField.text;
    card.securityCode = self.securityCodeField.text;
    card.addressLine1 = self.addressLine1Field.text;
    card.addressLine2 = self.addressLine2Field.text;
    card.zipcode = self.zipcodeField.text;
    card.state = self.stateField.text;
    card.city = self.cityField.text;
    
    if (![self.nameField.text isEqualToString:@""] && ![self.cardNumberField.text isEqualToString:@""] && ![self.expDateField.text isEqualToString:@""] && ![self.securityCodeField.text isEqualToString:@""] && ![self.addressLine1Field.text isEqualToString:@""] && ![self.zipcodeField.text isEqualToString:@""]){
        [card saveInBackgroundWithBlock:^(BOOL didSaveCard, NSError *errorSavingCard) {
            if (didSaveCard) {
                if (!self.user[paymentCard]) {
                    self.user[paymentCard] = card;
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
        [Alert callAlertWithTitle:@"Could not save card info" alertMessage:@"Some required fields are blank." viewController:self];
    }
}

- (IBAction)didTapSkipButton:(id)sender {
    [self performSegueWithIdentifier:addCardToMapSegue sender:nil];
}

- (IBAction)didTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:addCardToMapSegue]) {
        MapViewController *mapvc = [segue destinationViewController];
        mapvc.vc = self;
    }
}
@end
