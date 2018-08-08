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
#import <MaterialComponents/MaterialAppBar.h>
#import "AppScheme.h"
#import "Format.h"
#import "Colors.h"

@interface SignUpViewController () <EditPaymentDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
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
@property (weak, nonatomic) IBOutlet UIView *signInView;

@property (strong, nonatomic) MDCAppBar *appBar;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self formatColors];
    [self formatTypography];
    [self configureLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//automatically style status bar
- (UIViewController *)childViewControllerForStatusBarStyle {
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    self.appBar.headerViewController.headerView.backgroundColor = [Colors primaryBlueDarkColor];
    return self.appBar.headerViewController;
}

- (void)formatColors {
    [Format addBlueGradientToView:self.view];
    
    id<MDCColorScheming> colorScheme = [AppScheme sharedInstance].colorScheme;
    self.titleLabel.textColor = [UIColor whiteColor];
    
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.nameFieldController];
    self.nameField.textColor = [UIColor whiteColor];
    self.nameField.placeholderLabel.textColor = [UIColor whiteColor];
    
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.emailFieldController];
    self.emailField.textColor = [UIColor whiteColor];
    self.emailField.placeholderLabel.textColor = [UIColor whiteColor];
    
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.usernameFieldController];
    self.usernameField.textColor = [UIColor whiteColor];
    self.usernameField.placeholderLabel.textColor = [UIColor whiteColor];
    
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.passwordFieldController];
    self.passwordField.textColor = [UIColor whiteColor];
    self.passwordField.placeholderLabel.textColor = [UIColor whiteColor];
    
    [Format formatRaisedButton:self.signUpButton];
    
    self.accountLabel.textColor = [UIColor whiteColor];
    [Format formatFlatButton:self.signInButton];
    [self.signInButton setTitleColor:[Colors primaryOrangeColor] forState:UIControlStateNormal];
}

- (void)formatTypography {
    id<MDCTypographyScheming> typographyScheme = [AppScheme sharedInstance].typographyScheme;
    
    self.titleLabel.font = typographyScheme.headline2;
    self.titleLabel.text = [self.titleLabel.text uppercaseString];
    
    self.nameField.font = typographyScheme.subtitle1;
    self.nameField.placeholderLabel.text = @"FULL NAME";
    
    self.emailField.font = typographyScheme.subtitle1;
    self.emailField.placeholderLabel.text = @"EMAIL";
    
    self.usernameField.font = typographyScheme.subtitle1;
    self.usernameField.placeholderLabel.text = @"USERNAME";
    
    self.passwordField.font = typographyScheme.subtitle1;
    self.passwordField.placeholderLabel.text = @"PASSWORD";
    
    self.accountLabel.font = typographyScheme.body1;
}

- (void)configureLayout {
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(0, 100, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    [Format centerHorizontalView:self.titleLabel inView:self.view];
    
    CGFloat textFieldWidth = 300;
    CGFloat textFieldHeight = 50;
    
    CGFloat topTextFieldOriginY = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    CGFloat verticalSpace = textFieldHeight + 20;
    
    self.nameField.frame = CGRectMake(0, topTextFieldOriginY, textFieldWidth, textFieldHeight);
    [Format centerHorizontalView:self.nameField inView:self.view];
    self.nameFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.nameField];
    
    self.emailField.frame = CGRectMake(self.nameField.frame.origin.x, topTextFieldOriginY + verticalSpace, textFieldWidth, textFieldHeight);
    self.emailFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.emailField];
    
    self.usernameField.frame = CGRectMake(self.nameField.frame.origin.x, topTextFieldOriginY + 2 * verticalSpace, textFieldWidth, textFieldHeight);
    self.usernameFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.usernameField];
    
    self.passwordField.frame = CGRectMake(self.nameField.frame.origin.x, topTextFieldOriginY + 3 * verticalSpace, textFieldWidth, textFieldHeight);
    self.passwordFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.passwordField];
    
    [Format centerHorizontalView:self.signUpButton inView:self.view];
    
    CGFloat space = 8;
    CGFloat verticalInset = 24;
    CGFloat height = self.accountLabel.frame.size.height;
    self.signInView.backgroundColor = [UIColor clearColor];
    [self.accountLabel sizeToFit];
    [self.signInButton sizeToFit];
    self.signInView.frame = CGRectMake(0, self.view.frame.size.height - height - verticalInset, self.accountLabel.frame.size.width + space + self.signInButton.frame.size.width, height);
    [Format centerHorizontalView:self.signInView inView:self.view];
    self.accountLabel.frame = CGRectMake(0, 0, self.accountLabel.frame.size.width, self.signInView.frame.size.height);
    self.signInButton.frame = CGRectMake(self.signInView.frame.size.width - self.signInButton.frame.size.width, 0, self.signInButton.frame.size.width, self.signInView.frame.size.height);
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
