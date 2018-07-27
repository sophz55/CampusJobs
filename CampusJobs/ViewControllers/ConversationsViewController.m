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
#import "Utils.h"
#import "SegueConstants.h"

@interface ConversationsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *conversationsTableView;
@property (strong, nonatomic) NSMutableArray *conversations;
@property (assign, nonatomic) int queryLimit; // number of conversations to load
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ConversationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.queryLimit = 20;
    
    self.conversationsTableView.delegate = self;
    self.conversationsTableView.dataSource = self;
    
    self.conversationsTableView.rowHeight = 100;
    
    self.conversations = [[NSMutableArray alloc] init];
    
    [self configureRefreshControl];
}

- (void)configureRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchConversations) forControlEvents:UIControlEventValueChanged];
    [self.conversationsTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fetchConversations];
}

- (void)fetchConversations {
    PFQuery *userIsSeekerQuery = [self createUserIsSeekerQuery];
    PFQuery *userIsAuthorQuery = [self createUserIsAuthorQuery];
    
    PFQuery *userConversationsQuery = [PFQuery orQueryWithSubqueries:@[userIsSeekerQuery, userIsAuthorQuery]];
    [userConversationsQuery includeKey:@"messages"];
    [userConversationsQuery includeKey:@"post"];
    [userConversationsQuery includeKey:@"post.author.username"];
    [userConversationsQuery includeKey:@"seeker"];
    [userConversationsQuery includeKey:@"seeker.username"];
    userConversationsQuery.limit = self.queryLimit;
    [userConversationsQuery orderByDescending:@"createdAt"];
    
    [userConversationsQuery findObjectsInBackgroundWithBlock:^(NSArray *conversations, NSError *error) {
        if (error != nil) {
            [Utils callAlertWithTitle:@"Error fetching conversations" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
        } else {
            self.conversations = [[NSMutableArray alloc] initWithArray:conversations];
            [self.conversationsTableView reloadData];
            [self.refreshControl endRefreshing];
        }
    }];
}

- (id)createUserIsSeekerQuery {
    PFQuery *userIsSeekerQuery = [PFQuery queryWithClassName:@"Conversation"];
    [userIsSeekerQuery whereKey:@"seeker" equalTo:[PFUser currentUser]];
    
    return userIsSeekerQuery;
}

- (id)createUserIsAuthorQuery {
    PFQuery *postsQuery = [PFQuery queryWithClassName:@"Post"];
    [postsQuery includeKey:@"author"];
    [postsQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    
    PFQuery *userIsAuthorQuery = [PFQuery queryWithClassName:@"Conversation"];
    [userIsAuthorQuery whereKey:@"post" matchesQuery:postsQuery];
    
    return userIsAuthorQuery;
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
    if ([segue.identifier isEqualToString:conversationsToMessagesSegue]) {
        ConversationTableViewCell *cell = sender;
        UINavigationController *conversationNavigationController = [segue destinationViewController];
        ConversationDetailViewController *conversationDetailController = (ConversationDetailViewController *)[conversationNavigationController topViewController];
        conversationDetailController.otherUser = cell.otherUser;
        conversationDetailController.conversation = cell.conversation;
    }
}

@end
