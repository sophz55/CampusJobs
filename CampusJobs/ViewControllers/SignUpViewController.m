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
#import "StringConstants.h"
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
    
    self.nameFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.nameField];
    self.emailFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.emailField];
    self.usernameFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.usernameField];
    self.passwordFieldController = [[MDCTextInputControllerUnderline alloc] initWithTextInput:self.passwordField];
    
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
    
    [Format formatTextFieldController:self.nameFieldController withNormalColor:textColor];
    self.nameField.textColor = textColor;
    
    [Format formatTextFieldController:self.emailFieldController withNormalColor:textColor];
    self.emailField.textColor = textColor;
    
    [Format formatTextFieldController:self.usernameFieldController withNormalColor:textColor];
    self.usernameField.textColor = textColor;
    
    [Format formatTextFieldController:self.passwordFieldController withNormalColor:textColor];
    self.passwordField.textColor = textColor;
    
    [Format formatRaisedButton:self.signUpButton];
    
    self.accountLabel.textColor = [UIColor whiteColor];
    [Format formatFlatButton:self.signInButton];
    [self.signInButton setTitleColor:[Colors primaryOrangeColor] forState:UIControlStateNormal];
}

- (void)formatTypography {
    id<MDCTypographyScheming> typographyScheme = [AppScheme sharedInstance].typographyScheme;
    UIFont *fontName = [UIFont fontWithName:boldFontName size:16];
    
    self.titleLabel.font = typographyScheme.headline2;
    self.titleLabel.text = [self.titleLabel.text uppercaseString];
    
    self.nameField.font = typographyScheme.subtitle1;
    self.nameField.placeholder = @"FULL NAME";
    self.nameFieldController.inlinePlaceholderFont = fontName;
    
    self.emailField.font = typographyScheme.subtitle1;
    self.emailField.placeholder = @"EMAIL";
    self.emailFieldController.inlinePlaceholderFont = fontName;
    
    self.usernameField.font = typographyScheme.subtitle1;
    self.usernameField.placeholder = @"USERNAME";
    self.usernameFieldController.inlinePlaceholderFont = fontName;
    
    self.passwordField.font = typographyScheme.subtitle1;
    self.passwordField.placeholder = @"PASSWORD";
    self.passwordFieldController.inlinePlaceholderFont = fontName;
    
    self.accountLabel.font = typographyScheme.body1;
}

- (void)configureLayout {
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(0, 80, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    [Format centerHorizontalView:self.titleLabel inView:self.view];
    
    CGFloat textFieldWidth = 300;
    CGFloat textFieldHeight = 50;
    
    CGFloat topTextFieldOriginY = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    CGFloat verticalSpace = textFieldHeight + 20;
    
    self.nameField.frame = CGRectMake(0, topTextFieldOriginY, textFieldWidth, textFieldHeight);
    [Format centerHorizontalView:self.nameField inView:self.view];
    
    self.emailField.frame = CGRectMake(self.nameField.frame.origin.x, topTextFieldOriginY + verticalSpace, textFieldWidth, textFieldHeight);
    self.usernameField.frame = CGRectMake(self.nameField.frame.origin.x, topTextFieldOriginY + 2 * verticalSpace, textFieldWidth, textFieldHeight);
    self.passwordField.frame = CGRectMake(self.nameField.frame.origin.x, topTextFieldOriginY + 3 * verticalSpace, textFieldWidth, textFieldHeight);
    
    self.signUpButton.frame = CGRectMake(0, topTextFieldOriginY + 4 * verticalSpace + 10, textFieldWidth, textFieldHeight);
    [Format centerHorizontalView:self.signUpButton inView:self.view];
    
    CGFloat verticalInset = 24;
    [self.accountLabel sizeToFit];
    [self.signInButton sizeToFit];
    self.signInButton.frame = CGRectMake(0, self.view.frame.size.height - self.signInButton.frame.size.height - verticalInset, self.signInButton.frame.size.width, self.signInButton.frame.size.height);
    [Format centerHorizontalView:self.signInButton inView:self.view];
    self.accountLabel.frame = CGRectMake(0, self.signInButton.frame.origin.y - self.accountLabel.frame.size.height - 8, self.accountLabel.frame.size.width, self.accountLabel.frame.size.height);
    [Format centerHorizontalView:self.accountLabel inView:self.view];
}


- (IBAction)didTapSignUp:(id)sender {
    [self registerUser];
}

- (void)registerUser {
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    newUser[fullName] = self.nameField.text;
    newUser[profileImageFile] = [self getPFFileFromImage:[UIImage imageNamed:@"image_placeholder"]];
    newUser[numberJobsCompleted] = @0; // number of jobs completed as job taker
    
    if (![newUser.email isEqual:@""] && ![newUser[fullName] isEqual:@""] && ![newUser.username isEqual:@""] && ![newUser.password isEqual:@""]) {
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                [Alert callAlertWithTitle:@"Error" alertMessage:[NSString stringWithFormat:@"%@",error.localizedDescription] viewController:self];
            } else {
                [self performSegueWithIdentifier:signUpToAddCardSegue sender:nil];
            }
        }];
    } else {
        [Alert callAlertWithTitle:@"Couldn't Sign Up" alertMessage:@"All fields are required!" viewController:self];
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
