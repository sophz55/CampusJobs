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

@interface EditProfileViewController ()

@property (strong, nonatomic) PFUser *user;

@property (strong, nonatomic) MDCAppBar *appBar;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *saveButton;

@property (weak, nonatomic) IBOutlet MDCTextField *nameField;
@property (weak, nonatomic) IBOutlet MDCTextField *usernameField;
@property (weak, nonatomic) IBOutlet MDCTextField *emailField;
@property (weak, nonatomic) IBOutlet MDCTextField *passwordField;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [PFUser currentUser];
    
    [self configureNavigationBar];
    [self populateFieldsWithExistingInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populateFieldsWithExistingInformation {
    self.nameField.text = self.user[@"name"];
    self.usernameField.text = self.user.username;
    self.emailField.text = self.user.email;
    self.passwordField.text = self.user.password;
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

- (IBAction)didTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSaveButton:(id)sender {
    self.user[@"name"] = self.nameField.text;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
