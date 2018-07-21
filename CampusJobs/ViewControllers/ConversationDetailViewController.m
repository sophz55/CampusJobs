//
//  ConversationDetailViewController.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/18/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "ConversationDetailViewController.h"
#import "MessageTableViewCell.h"
#import "SuggestPriceViewController.h"
#import "Message.h"
#import "Helper.h"

@interface ConversationDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) PFUser *user;

@end

@implementation ConversationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.user = [PFUser currentUser];
    
    self.messagesTableView.delegate = self;
    self.messagesTableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.messagesTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversation.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    
    [cell configureCellWithMessage:self.conversation.messages[indexPath.row]];
    
    
    return cell;
}

- (IBAction)didTapSuggestPriceButton:(id)sender {
    [self performSegueWithIdentifier:@"suggestPriceModalSegue" sender:nil];
}

- (IBAction)didTapBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapAway:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)didTapSendMessage:(id)sender {
    [Message createMessageWithText:self.messageTextField.text withSender:self.user withReceiver:self.otherUser withCompletion:^(PFObject *createdMessage, NSError *error) {
        if (createdMessage) {
            [self.conversation addToConversationWithMessage:(Message *)createdMessage withCompletion:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    self.messageTextField.text = @"";
                    [self.messagesTableView reloadData];
                } else {
                    [Helper callAlertWithTitle:@"Error sending message" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
                }
            }];
        } else {
            [Helper callAlertWithTitle:@"Error sending message" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"suggestPriceModalSegue"]) {
        SuggestPriceViewController *suggestPriceController = [segue destinationViewController];
        suggestPriceController.conversation = self.conversation;
        suggestPriceController.otherUser = self.otherUser;
    }
}

@end
