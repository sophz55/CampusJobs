//
//  LoginViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "Utils.h"
#import "SegueConstants.h"
#import <ChameleonFramework/Chameleon.h>
#import "Colors.h"


@interface LoginViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *usernameField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGradient];
    // Do any additional setup after loading the view.
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
            [Utils callAlertWithTitle:@"Login Failed!" alertMessage:[NSString stringWithFormat:@"%@",error.localizedDescription] viewController:self];
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
