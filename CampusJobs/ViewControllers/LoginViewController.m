//
//  LoginViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "Alert.h"
#import "SegueConstants.h"
#import <MaterialComponents/MaterialTextFields.h>
#import <MaterialComponents/MaterialButtons.h>
#import <MaterialComponents/MaterialTextFields+ColorThemer.h>
#import <MaterialComponents/MaterialButtons+ColorThemer.h>
#import <MaterialComponents/MaterialAppBar.h>
#import "AppScheme.h"
#import "Format.h"
#import "Colors.h"
#import "StringConstants.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MDCTextField *usernameField;
@property (weak, nonatomic) IBOutlet MDCTextField *passwordField;
@property (strong, nonatomic) MDCTextInputControllerFilled *usernameFieldController;
@property (strong, nonatomic) MDCTextInputControllerFilled *passwordFieldController;

@property (weak, nonatomic) IBOutlet MDCRaisedButton *loginButton;
@property (weak, nonatomic) IBOutlet MDCFlatButton *signUpButton;
@property (weak, nonatomic) IBOutlet MDCButton *forgotPasswordButton;

@property (strong, nonatomic) MDCAppBar *appBar;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIView *signUpView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameFieldController = [[MDCTextInputControllerFilled alloc] initWithTextInput:self.usernameField];
    self.passwordFieldController = [[MDCTextInputControllerFilled alloc] initWithTextInput:self.passwordField];
    
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
    UIColor *textColor = [UIColor whiteColor];
    
    self.titleLabel.textColor = textColor;
    
    [Format formatTextFieldController:self.usernameFieldController withNormalColor:[UIColor whiteColor]];
    self.usernameField.textColor = textColor;
    
    [Format formatTextFieldController:self.passwordFieldController withNormalColor:[UIColor whiteColor]];
    self.passwordField.textColor = textColor;
    
    [Format formatRaisedButton:self.loginButton];
    
    [Format formatFlatButton:self.forgotPasswordButton];
    [self.forgotPasswordButton setTitleColor:[Colors secondaryGreyLighterColor] forState:UIControlStateNormal];
    
    self.accountLabel.textColor = [UIColor whiteColor];
    [Format formatFlatButton:self.signUpButton];
    [self.signUpButton setTitleColor:[Colors primaryOrangeColor] forState:UIControlStateNormal];
}

- (void)formatTypography {
    id<MDCTypographyScheming> typographyScheme = [[AppScheme sharedInstance] typographyScheme];
     UIFont * robotoCondensed=[UIFont fontWithName:@"RobotoCondensed-Regular" size:18];
    
    self.titleLabel.font = typographyScheme.headline2;
    self.titleLabel.text = [self.titleLabel.text uppercaseString];
    
    self.usernameField.placeholderLabel.font = typographyScheme.subtitle1;
    self.usernameField.placeholder = @"USERNAME";
    self.usernameField.font=robotoCondensed;
    
    self.passwordField.placeholderLabel.font = typographyScheme.subtitle1;
    self.passwordField.placeholder = @"PASSWORD";
     self.passwordField.font=robotoCondensed;
    
    [self.forgotPasswordButton setTitleFont:[UIFont fontWithName:lightItalicFontName size:16] forState:UIControlStateNormal];
    [self.forgotPasswordButton sizeToFit];
    
    self.accountLabel.font = typographyScheme.body1;
}

- (void)configureLayout {
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(0, 100, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    [Format centerHorizontalView:self.titleLabel inView:self.view];
    
    CGFloat textFieldWidth = 300;
    CGFloat textFieldHeight = 50;
    CGFloat cornerRadius = 5;
    
    CGFloat topTextFieldOriginY = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 30;
    CGFloat verticalSpace = textFieldHeight + 20;
    
    self.usernameField.frame = CGRectMake(0, topTextFieldOriginY, textFieldWidth, textFieldHeight);
    self.usernameField.layer.cornerRadius = cornerRadius;
    [Format centerHorizontalView:self.usernameField inView:self.view];
    
    self.passwordField.frame = CGRectMake(self.usernameField.frame.origin.x, topTextFieldOriginY + verticalSpace, textFieldWidth, textFieldHeight);
    self.passwordField.layer.cornerRadius = cornerRadius;
    
    self.loginButton.frame = CGRectMake(0, topTextFieldOriginY + 2 * verticalSpace, textFieldWidth, textFieldHeight);
    [Format centerHorizontalView:self.loginButton inView:self.view];
    
    self.forgotPasswordButton.frame = CGRectMake(0, self.loginButton.frame.origin.y + self.loginButton.frame.size.height + 10, self.forgotPasswordButton.frame.size.width, self.forgotPasswordButton.frame.size.height);
    [Format centerHorizontalView:self.forgotPasswordButton inView:self.view];
    
    CGFloat verticalInset = 24;
    [self.accountLabel sizeToFit];
    [self.signUpButton sizeToFit];
    self.signUpButton.frame = CGRectMake(0, self.view.frame.size.height - self.signUpButton.frame.size.height - verticalInset, self.signUpButton.frame.size.width, self.signUpButton.frame.size.height);
    [Format centerHorizontalView:self.signUpButton inView:self.view];
    self.accountLabel.frame = CGRectMake(0, self.signUpButton.frame.origin.y - self.accountLabel.frame.size.height - 8, self.accountLabel.frame.size.width, self.accountLabel.frame.size.height);
    [Format centerHorizontalView:self.accountLabel inView:self.view];
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [Alert callAlertWithTitle:@"Login Failed" alertMessage:[NSString stringWithFormat:@"%@",error.localizedDescription] viewController:self];
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:loginToFeedSegue sender:nil];
        }
    }];
}

- (IBAction)tapGesture:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
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
