//
//  ConversationDetailViewController.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/18/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "ConversationDetailViewController.h"
#import "MessageTableViewCell.h"
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
    NSLog (@"Other User: %@", self.otherUser.username);
    NSLog (@"Conversation: %@", self.conversation);
    
    self.user = [PFUser currentUser];
    
    self.messagesTableView.delegate = self;
    self.messagesTableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversation.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    
    [cell configureCellWithMessage:self.conversation.messages[indexPath.row]];
    
    return cell;
}

- (IBAction)didTapSendMessage:(id)sender {
    Message *newMessage = [Message createMessageWithText:self.messageTextField.text withSender:self.user withReceiver:self.otherUser];
    NSLog(@"%@", newMessage);
    [Conversation addToConversation:self.conversation withMessage:newMessage withCompletion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"sent message");
        }
        else {
            NSLog(@"%@", error.localizedDescription);
            [Helper callAlertWithTitle:@"Error sending message" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
        }
    }];
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
