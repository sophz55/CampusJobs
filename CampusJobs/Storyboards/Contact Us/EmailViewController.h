//
//  EmailViewController.h
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/29/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailViewController : UIViewController
<UITextViewDelegate, UIPageViewControllerDelegate> {
    
    
    
    
}



@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextView *messageField;
@property (weak, nonatomic) IBOutlet UIButton *button;

- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)email:(id)sender;

@end
