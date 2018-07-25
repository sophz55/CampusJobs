//
//  SuggestPriceViewController.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/20/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "SuggestPriceViewController.h"
#import "Helper.h"
#import "ConversationDetailViewController.h"

@interface SuggestPriceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *suggestedPriceTextField;

@end

@implementation SuggestPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapCancelButton:(id)sender {
    self.suggestedPriceTextField.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSuggestButton:(id)sender {
    __unsafe_unretained typeof(self) weakSelf = self;
    if (![self.suggestedPriceTextField.text isEqualToString:@""]) {
        [self.conversation addToConversationWithMessagePrice:[self.suggestedPriceTextField.text intValue] withText:[NSString stringWithFormat:@"%@ has offered $%@.", [PFUser currentUser].username, self.suggestedPriceTextField.text] withSender:[PFUser currentUser] withReceiver:self.otherUser withCompletion:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                weakSelf.suggestedPriceTextField.text = @"";
                ConversationDetailViewController *vc = (ConversationDetailViewController *)[weakSelf presentingViewController];
                [weakSelf dismissViewControllerAnimated:YES completion: ^ {
                    [vc reloadData];
                }];
            } else {
                [Helper callAlertWithTitle:@"Error sending message" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:weakSelf];
            }
        }];
    } else {
        [Helper callAlertWithTitle:@"Couldn't send price" alertMessage:@"Cannot have empty price field" viewController:self];
    }
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

@end
