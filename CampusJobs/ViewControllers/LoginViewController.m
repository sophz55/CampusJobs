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

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MDCTextField *usernameField;
@property (weak, nonatomic) IBOutlet MDCTextField *passwordField;
@property (strong, nonatomic) MDCTextInputControllerUnderline *usernameFieldController;
@property (strong, nonatomic) MDCTextInputControllerUnderline *passwordFieldController;

@property (weak, nonatomic) IBOutlet MDCRaisedButton *loginButton;
@property (weak, nonatomic) IBOutlet MDCFlatButton *signUpButton;

@property (strong, nonatomic) MDCAppBar *appBar;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIView *signUpView;

@end

@implementation LoginViewController

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
                                toTextInputController:self.usernameFieldController];
    self.usernameField.textColor = [UIColor whiteColor];
    self.usernameFieldController.inlinePlaceholderColor = [UIColor whiteColor];

    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.passwordFieldController];
    self.passwordField.textColor = [UIColor whiteColor];
    self.passwordFieldController.inlinePlaceholderColor = [UIColor whiteColor];

    [Format formatRaisedButton:self.loginButton];
    
    self.accountLabel.textColor = [UIColor whiteColor];
    [Format formatFlatButton:self.signUpButton];
    [self.signUpButton setTitleColor:[Colors primaryOrangeColor] forState:UIControlStateNormal];
}

- (void)formatTypography {
    id<MDCTypographyScheming> typographyScheme = [[AppScheme sharedInstance] typographyScheme];
    
    self.titleLabel.font = typographyScheme.headline2;
    self.titleLabel.text = [self.titleLabel.text uppercaseString];
    
    self.usernameField.placeholderLabel.font = typographyScheme.subtitle1;
    self.usernameFieldController.inlinePlaceholderFont = self.usernameField.placeholderLabel.font;
    self.usernameField.placeholderLabel.text = @"USERNAME";
    
    self.passwordField.placeholderLabel.font = typographyScheme.subtitle1;
    self.passwordFieldController.inlinePlaceholderFont = self.passwordField.placeholderLabel.font;
    self.passwordField.placeholderLabel.text = @"PASSWORD";
    
    self.accountLabel.font = typographyScheme.body1;
}

- (void)configureLayout {
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(0, 100, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    [Format centerHorizontalView:self.titleLabel inView:self.view];
    
    CGFloat textFieldWidth = 300;
    CGFloat textFieldHeight = 50;
    
    CGFloat topTextFieldOriginY = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10;
    CGFloat verticalSpace = textFieldHeight + 20;
    
    self.usernameField.frame = CGRectMake(0, topTextFieldOriginY, textFieldWidth, textFieldHeight);
    [Format centerHorizontalView:self.usernameField inView:self.view];
    self.usernameFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.usernameField];
    
    self.passwordField.frame = CGRectMake(self.usernameField.frame.origin.x, topTextFieldOriginY + verticalSpace, textFieldWidth, textFieldHeight);
    self.passwordFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.passwordField];
    
    [Format centerHorizontalView:self.signUpButton inView:self.view];
    
    CGFloat space = 8;
    CGFloat verticalInset = 24;
    CGFloat height = self.accountLabel.frame.size.height;
    self.signUpView.backgroundColor = [UIColor clearColor];
    [self.accountLabel sizeToFit];
    [self.signUpButton sizeToFit];
    self.signUpView.frame = CGRectMake(0, self.view.frame.size.height - height - verticalInset, self.accountLabel.frame.size.width + space + self.signUpButton.frame.size.width, height);
    [Format centerHorizontalView:self.signUpView inView:self.view];
    self.accountLabel.frame = CGRectMake(0, 0, self.accountLabel.frame.size.width, self.signUpView.frame.size.height);
    self.signUpButton.frame = CGRectMake(self.signUpView.frame.size.width - self.signUpButton.frame.size.width, 0, self.signUpButton.frame.size.width, self.signUpView.frame.size.height);
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
            [Alert callAlertWithTitle:@"Login Failed!" alertMessage:[NSString stringWithFormat:@"%@",error.localizedDescription] viewController:self];
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
