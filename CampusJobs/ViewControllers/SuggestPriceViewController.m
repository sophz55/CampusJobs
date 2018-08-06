//
//  SuggestPriceViewController.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/20/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "SuggestPriceViewController.h"
#import "Alert.h"
#import "ConversationDetailViewController.h"
#import <MaterialComponents/MaterialTextFields.h>
#import <MaterialComponents/MaterialButtons.h>

@interface SuggestPriceViewController ()

@property (weak, nonatomic) IBOutlet MDCTextField *suggestedPriceTextField;
@property (weak, nonatomic) IBOutlet MDCRaisedButton *cancelButton;
@property (weak, nonatomic) IBOutlet MDCRaisedButton *suggestButton;

@end

@implementation SuggestPriceViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.cancelButton sizeToFit];
    [self.suggestButton sizeToFit];
    self.delegate.showingSuggestViewController = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)didTapCancelButton:(id)sender {
    self.suggestedPriceTextField.text = @"";
    [self dismissViewControllerAnimated:YES completion:^{
        self.delegate.showingSuggestViewController = NO;
    }];
}

- (IBAction)didTapSuggestButton:(id)sender {
    __unsafe_unretained typeof(self) weakSelf = self;
    if (![self.suggestedPriceTextField.text isEqualToString:@""]) {
        [self.conversation addToConversationWithSystemMessageWithPrice:[self.suggestedPriceTextField.text intValue] withText:[NSString stringWithFormat:@"%@ has offered $%@.", [PFUser currentUser].username, self.suggestedPriceTextField.text] withSender:[PFUser currentUser] withReceiver:self.otherUser withCompletion:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                weakSelf.suggestedPriceTextField.text = @"";
                [weakSelf dismissViewControllerAnimated:YES completion: ^ {
                    weakSelf.delegate.showingSuggestViewController = NO;
                    [weakSelf.delegate reloadData];
                }];
            } else {
                [Alert callAlertWithTitle:@"Error sending message" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:weakSelf];
            }
        }];
    } else {
        [Alert callAlertWithTitle:@"Couldn't send price" alertMessage:@"Cannot have empty price field" viewController:self];
    }
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
