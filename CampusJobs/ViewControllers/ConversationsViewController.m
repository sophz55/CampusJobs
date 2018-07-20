//
//  ConversationsViewController.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/17/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "ConversationsViewController.h"
#import "ConversationTableViewCell.h"
#import "ConversationDetailViewController.h"
#import "Conversation.h"

@interface ConversationsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *conversationsTableView;
@property (strong, nonatomic) NSMutableArray *conversations;
@property (assign, nonatomic) int queryLimit; // number of conversations to load

@end

@implementation ConversationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.conversationsTableView.delegate = self;
    self.conversationsTableView.dataSource = self;
    
    [self fetchConversations];
}

- (void)fetchConversations {
    PFQuery *userIsSeekerQuery = [PFQuery queryWithClassName:@"Conversation"];
    [userIsSeekerQuery whereKey:@"seeker" equalTo:[PFUser currentUser]];
    userIsSeekerQuery.limit = self.queryLimit;
    
    [userIsSeekerQuery findObjectsInBackgroundWithBlock:^(NSArray *conversations, NSError *error) {
        if (conversations != nil) {
            self.conversations = [[NSMutableArray alloc] initWithArray:conversations];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"post.author = %@", [PFUser currentUser]];
    PFQuery *userIsAuthorQuery = [PFQuery queryWithClassName:@"Conversation" predicate:predicate];
    userIsAuthorQuery.limit = self.queryLimit;
    
    [userIsAuthorQuery findObjectsInBackgroundWithBlock:^(NSArray *conversations, NSError *error) {
        if (conversations != nil) {
            [self.conversations addObjectsFromArray:conversations];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    PFQuery *userConversationsQuery = [PFQuery orQueryWithSubqueries:@[userIsSeekerQuery, userIsAuthorQuery]];
    [userConversationsQuery orderByDescending:@"createdAt"];
    
    [self.conversationsTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversationCell" forIndexPath:indexPath];
    
    Conversation *conversation = self.conversations[indexPath.row];
    
    [cell configureCellWithConversation:conversation];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"conversationsToDetailSegue"]) {
        ConversationTableViewCell *cell = sender;
        ConversationDetailViewController *conversationDetailController = [segue destinationViewController];
        conversationDetailController.otherUser = cell.otherUser;
        conversationDetailController.conversation = cell.conversation;
    }
}

@end
