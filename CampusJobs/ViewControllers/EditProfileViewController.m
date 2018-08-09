//
//  EditProfileViewController.m
//  CampusJobs
//
//  Created by Sophia Zheng on 8/3/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "EditProfileViewController.h"
#import <MaterialComponents/MaterialAppBar.h>
#import <MaterialComponents/MaterialTextFields.h>
#import "Format.h"
#import "Alert.h"
#import <Parse/Parse.h>
#import "Colors.h"
#import "StringConstants.h"
#import "AppScheme.h"
#import "MaterialTextFields+ColorThemer.h"

@interface EditProfileViewController () <UITextFieldDelegate>

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) MDCAppBar *appBar;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet MDCTextField *nameField;
@property (weak, nonatomic) IBOutlet MDCTextField *usernameField;
@property (weak, nonatomic) IBOutlet MDCTextField *emailField;
@property (weak, nonatomic) IBOutlet MDCTextField *passwordField;
@property (strong, nonatomic) MDCTextInputControllerUnderline *nameFieldController;
@property (strong, nonatomic) MDCTextInputControllerUnderline *usernameFieldController;
@property (strong, nonatomic) MDCTextInputControllerUnderline *emailFieldController;
@property (strong, nonatomic) MDCTextInputControllerUnderline *passwordFieldController;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    [self configureNavigationBar];
    [self configureTextFieldControllers];
    [self configureTextFields];
    [self populateFieldsWithExistingInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)populateFieldsWithExistingInformation {
    self.nameField.text = self.user[fullName];
    self.usernameField.text = self.user.username;
    self.emailField.text = self.user.email;
    self.passwordField.text = self.user.password;
}

//initializes all text field controllers
- (void)configureTextFieldControllers{
    self.nameFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.nameField];
    self.usernameFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.usernameField];
    self.emailFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.emailField];
    self.passwordFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.passwordField];
}

- (void)configureNavigationBar {
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    [self.appBar addSubviewsToParent];
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didTapCancelButton:)];
    [Format formatBarButton:self.cancelButton];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    self.saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(didTapSaveButton:)];
    [Format formatBarButton:self.saveButton];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    
    [Format formatAppBar:self.appBar withTitle:@"YOUR PROFILE"];
}

//automatically style status bar
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.appBar.headerViewController;
}

- (IBAction)didTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSaveButton:(id)sender {
    self.user[fullName] = self.nameField.text;
    self.user.username = self.usernameField.text;
    self.user.email = self.emailField.text;
    self.user.password = self.passwordField.text;
    [self.user saveInBackgroundWithBlock:^(BOOL didSaveUser, NSError *error) {
        if (didSaveUser) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [Alert callAlertWithTitle:@"Error Updating Profile" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
        }
    }];
}

- (IBAction)didTapAway:(id)sender {
    [self.view endEditing:YES];
}

//formats font within text fields
- (void)formatTextFieldTypography{
    UIFont * robotoCondensed=[UIFont fontWithName:@"RobotoCondensed-Regular" size:18];
    UIFont * robotoBold=[UIFont fontWithName:@"RobotoCondensed-Bold" size:18];
    //name field
    self.nameField.placeholderLabel.text = @"FULL NAME";
    self.nameField.placeholderLabel.font=robotoBold;
    self.nameFieldController.inlinePlaceholderFont=robotoBold;
    self.nameField.font=robotoCondensed;
    
    //username field
    self.usernameField.placeholderLabel.text=@"USERNAME";
    self.usernameField.placeholderLabel.font=robotoBold;
    self.usernameFieldController.inlinePlaceholderFont=robotoBold;
    self.usernameField.font=robotoCondensed;
    
    //email field
    self.emailField.placeholderLabel.text=@"EMAIL";
    self.emailField.placeholderLabel.font=robotoBold;
    self.emailFieldController.inlinePlaceholderFont=robotoBold;
    self.emailField.font=robotoCondensed;
    
    //password field
    self.passwordField.placeholderLabel.text=@"PASSWORD";
    self.passwordField.placeholderLabel.font=robotoBold;
    self.passwordFieldController.inlinePlaceholderFont=robotoBold;
    self.passwordField.font=robotoCondensed;
}

//formats color scheme within text fields and main background
- (void)formatTextFieldColors{
    id<MDCColorScheming> colorScheme = [AppScheme sharedInstance].colorScheme;
    self.view.backgroundColor=[Colors secondaryGreyLighterColor];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.nameFieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.usernameFieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.emailFieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.passwordFieldController];
}
//formats full text field with frame, color, and font
- (void)configureTextFields{
    [self formatTextFieldTypography];
    [self formatTextFieldColors];
    
    CGFloat textFieldWidth = 320;
    CGFloat textFieldHeight = 50;
    CGFloat textFieldOriginX = (self.view.frame.size.width - textFieldWidth)/2;
    CGFloat textFieldOriginY = 140;
    CGFloat verticalSpace = textFieldHeight + 25;
    
    self.nameField.frame=CGRectMake(textFieldOriginX, textFieldOriginY, textFieldWidth, textFieldHeight);
    self.usernameField.frame=CGRectMake(textFieldOriginX, textFieldOriginY+verticalSpace, textFieldWidth, textFieldHeight);
    self.emailField.frame=CGRectMake(textFieldOriginX, textFieldOriginY+(verticalSpace*2), textFieldWidth, textFieldHeight);
    self.passwordField.frame=CGRectMake(textFieldOriginX, textFieldOriginY+(verticalSpace*3), textFieldWidth, textFieldHeight);
    
    [self.nameField sizeToFit];
    [self.usernameField sizeToFit];
    [self.emailField sizeToFit];
    [self.passwordField sizeToFit];
}

@end
