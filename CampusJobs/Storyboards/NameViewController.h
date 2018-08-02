//
//  NameViewController.h
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/30/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface NameViewController : UIViewController

<UITextViewDelegate, UIPageViewControllerDelegate> {
    
    
    
    
}


@property (weak, nonatomic) IBOutlet UITextField *UsernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *Save;

- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)Save:(id)sender;









@end
