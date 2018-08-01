//
//  ProfileViewController.m
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/23/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)DismissKeyboard:(id)sender {
    
    [self resignFirstResponder];
    self.NameLabel.text = self.NameTextField.text;
    
    
    self.EmailLabel.text = self.EmailTextField.text;
    
    
    self.AddressLabel.text = self.Address.text;
    
}
- (IBAction)DismissKeyboardEmail:(id)sender {
}
- (IBAction)DismissKeyboardAddress:(id)sender {
}
- (IBAction)Save:(id)sender {
    
    NSString *saveNameLabel = self.NameLabel.text;
    
    NSString *saveEmailLabel = self.EmailLabel.text;
    
    
    NSString *saveAddressLabel = self.AddressLabel.text;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:saveNameLabel forKey:@"savedstring"];
    [defaults setObject:saveEmailLabel forKey:@"savedstring"];
    [defaults setObject:saveAddressLabel forKey:@"savedstring"];
    [defaults synchronize];
    
}

- (IBAction)Refresh:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loadstring = [defaults objectForKey:@"savedstring"];
    
    [self.NameLabel setText:loadstring];
    
    [self.EmailLabel setText:loadstring];
    
    [self.AddressLabel setText:loadstring];
    
    

     }
- (IBAction)Name:(id)sender {
}

//- (IBAction)Name:(id)sender {
//}
@end
