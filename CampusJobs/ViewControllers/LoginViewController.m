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
#import <ChameleonFramework/Chameleon.h>
#import <MaterialComponents/MaterialTextFields.h>
#import <MaterialComponents/MaterialButtons.h>
#import <MaterialComponents/MaterialTextFields+ColorThemer.h>
#import <MaterialComponents/MaterialButtons+ColorThemer.h>
#import "AppScheme.h"
#import "Colors.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MDCTextField *usernameField;
@property (weak, nonatomic) IBOutlet MDCTextField *passwordField;
@property (strong, nonatomic) MDCTextInputControllerFilled *usernameFieldController;
@property (strong, nonatomic) MDCTextInputControllerFilled *passwordFieldController;

@property (weak, nonatomic) IBOutlet MDCRaisedButton *loginButton;
@property (weak, nonatomic) IBOutlet MDCFlatButton *signUpButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGradient];
    // Do any additional setup after loading the view.
    
    [self configureTextFields];
}

- (void)configureTextFields {
    CGFloat textFieldWidth = 300;
    CGFloat textFieldHeight = 50;
    CGFloat textFieldOriginX = (self.view.frame.size.width - textFieldWidth)/2;
    CGFloat topTextFieldOriginY = 250;
    CGFloat verticalSpace = textFieldHeight + 20;
    
    self.usernameField.frame = CGRectMake(textFieldOriginX, topTextFieldOriginY, textFieldWidth, textFieldHeight);
    self.usernameField.delegate = self;
    self.usernameFieldController = [[MDCTextInputControllerFilled alloc] initWithTextInput:self.usernameField];
    
    self.passwordField.frame = CGRectMake(textFieldOriginX, topTextFieldOriginY + verticalSpace, textFieldWidth, textFieldHeight);
    self.passwordField.delegate = self;
    self.passwordFieldController = [[MDCTextInputControllerFilled alloc] initWithTextInput:self.passwordField];
    
    id<MDCColorScheming> colorScheme = [AppScheme sharedInstance].colorScheme;
    self.titleLabel.textColor = colorScheme.onSurfaceColor;
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.usernameFieldController];
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:self.passwordFieldController];
    [MDCContainedButtonColorThemer applySemanticColorScheme:colorScheme
                                              toButton:self.loginButton];
    [MDCTextButtonColorThemer applySemanticColorScheme:colorScheme
                                                   toButton:self.signUpButton];
    
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}

- (void)addGradient{
    NSMutableArray *colors = [NSMutableArray array];
    [colors addObject:[Colors primaryBlueLightColor]];
    [colors addObject:[Colors primaryBlueColor]];
    [colors addObject:[Colors primaryBlueDarkColor]];
    self.view.backgroundColor=[UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.view.frame andColors:colors];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
