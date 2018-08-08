//
//  NameViewController.m
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/30/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "NameViewController.h"
#import "Parse.h"



@interface NameViewController ()


// make property
@property(weak,nonatomic)PFUser *user;



@end

@implementation NameViewController

- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
   
    
    /*self.Save.layer.cornerRadius = 5;
    self.FirstNameField.layer.cornerRadius = 5;
     */
    
    //assign current user
    self.user = [PFUser currentUser];
    
    //assign current user username to the textfield
    
    self.UsernameField.text = self.user.username;
    
    self.emailField.text = self.user.email;
    
    self.nameField.text=self.user.parseClassName;
    
    
    // newUser[@"name"] = self.nameField.text;
   /* newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;*/
    
    
    
    
    
    
    
    
    
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


- (IBAction)dismissKeyboard:(id)sender {
    
    [self resignFirstResponder];
    
}

- (IBAction)Save:(id)sender{
    
 
        /*
        [composer setMessageBody:[NSString stringWithFormat:@"Name: %@\nEmail: %@\n\nMessage: %@", self.FirstNameField.text, self.LastNameField.text, self.messageField.text] isHTML:NO];*/
    }
    


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]]. location == NSNotFound) {
        
        return YES;
        
    }
    
    [textView resignFirstResponder];
    
    return NO;
    
    
}







@end
