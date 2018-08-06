//
//  SignUpViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "SignUpViewController.h"
#import "Alert.h"
#import "SegueConstants.h"
#import "Card.h"
#import "EditPaymentInfoViewController.h"
#import <MaterialComponents/MaterialButtons.h>
#import <MaterialComponents/MaterialTextFields.h>
#import <MaterialComponents/MaterialButtons+ColorThemer.h>
#import <MaterialComponents/MaterialTextFields+ColorThemer.h>
#import <MaterialComponents/MaterialButtons+TypographyThemer.h>
#import <MaterialComponents/MaterialTextFields+TypographyThemer.h>
#import "AppScheme.h"
#import "Format.h"

@interface SignUpViewController () <EditPaymentDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MDCTextField *nameField;
@property (weak, nonatomic) IBOutlet MDCTextField *emailField;
@property (weak, nonatomic) IBOutlet MDCTextField *usernameField;
@property (weak, nonatomic) IBOutlet MDCTextField *passwordField;

@property (strong, nonatomic) MDCTextInputControllerUnderline *nameFieldController;
@property (strong, nonatomic) MDCTextInputControllerUnderline *emailFieldController;
@property (strong, nonatomic) MDCTextInputControllerUnderline *usernameFieldController;
@property (strong, nonatomic) MDCTextInputControllerUnderline *passwordFieldController;

@property (weak, nonatomic) IBOutlet MDCRaisedButton *signUpButton;
@property (weak, nonatomic) IBOutlet MDCFlatButton *signInButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self formatColors];
    // Do any additional setup after loading the view.
    
    [self configureFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureFields {
    
    CGFloat textFieldWidth = 300;
    CGFloat textFieldHeight = 50;
    CGFloat textFieldOriginX = (self.view.frame.size.width - textFieldWidth)/2;
    
    CGFloat topTextFieldOriginY = 170;
    CGFloat verticalSpace = textFieldHeight + 20;
    
    self.nameField.frame = CGRectMake(textFieldOriginX, topTextFieldOriginY, textFieldWidth, textFieldHeight);
    self.nameFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.nameField];
    
    self.emailField.frame = CGRectMake(textFieldOriginX, topTextFieldOriginY + verticalSpace, textFieldWidth, textFieldHeight);
    self.emailFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.emailField];
    
    self.usernameField.frame = CGRectMake(textFieldOriginX, topTextFieldOriginY + 2 * verticalSpace, textFieldWidth, textFieldHeight);
    self.usernameFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.usernameField];
    
    self.passwordField.frame = CGRectMake(textFieldOriginX, topTextFieldOriginY + 3 * verticalSpace, textFieldWidth, textFieldHeight);
    self.passwordFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.passwordField];
    
}

- (void)formatColors {
    [Format addBlueGradientToView:self.view];
    
    id<MDCColorScheming> colorScheme = [AppScheme sharedInstance].colorScheme;
    self.titleLabel.textColor = colorScheme.onSurfaceColor;
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.nameFieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.emailFieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.usernameFieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.passwordFieldController];
    [MDCTextButtonColorThemer applySemanticColorScheme:colorScheme
                                              toButton:self.signInButton];
    [MDCContainedButtonColorThemer applySemanticColorScheme:colorScheme
                                                   toButton:self.signUpButton];
}


- (IBAction)didTapSignUp:(id)sender {
    [self registerUser];
}

- (void)registerUser {
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    newUser[@"name"] = self.nameField.text;
    newUser[@"address"] = @"";
    newUser[@"profileImageFile"] = [self getPFFileFromImage:[UIImage imageNamed:@"image_placeholder"]];
    newUser[@"venmoHandle"] = @"";
    newUser[@"rating"] = @5; // out of five stars
    newUser[@"numberJobsCompleted"] = @0; // number of jobs completed as job taker
    // user also has a key @"card", of class Card, that saves credit/debit card info
    
    if (![newUser.email isEqual:@""] && ![newUser[@"name"] isEqual:@""] && ![newUser.username isEqual:@""] && ![newUser.password isEqual:@""]) {
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                [Alert callAlertWithTitle:@"Error" alertMessage:[NSString stringWithFormat:@"%@",error.localizedDescription] viewController:self];
            } else {
                [self performSegueWithIdentifier:signUpToAddCardSegue sender:nil];
            }
        }];
    } else {
        [Alert callAlertWithTitle:@"Cannot Sign Up" alertMessage:@"No fields can be blank" viewController:self];
    }
}

- (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFile fileWithName:@"image.png" data:imageData];
}

- (IBAction)tapGesture:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:signUpToAddCardSegue]) {
        EditPaymentInfoViewController *editPaymentController = [segue destinationViewController];
        editPaymentController.delegate = self;
    }
}

@end
