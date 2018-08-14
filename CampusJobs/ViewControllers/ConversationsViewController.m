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
#import "Alert.h"
#import "SegueConstants.h"
#import <MaterialComponents/MaterialAppBar.h>
#import <MaterialComponents/MaterialAppBar+ColorThemer.h>
#import "AppScheme.h"
#import "Colors.h"
#import "Format.h"

@interface ConversationsViewController () <UITableViewDelegate, UITableViewDataSource, ConversationDetailDelegate>

@property (weak, nonatomic) IBOutlet UITableView *conversationsTableView;
@property (strong, nonatomic) NSMutableArray *conversations;
@property (assign, nonatomic) int queryLimit; // number of conversations to load
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) MDCAppBar *appBar;
@property (weak, nonatomic) IBOutlet UIView *noConversationsView;
@property (weak, nonatomic) IBOutlet UILabel *noConversationsLabel;

@end

@implementation ConversationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.queryLimit = 20;
    
    self.conversationsTableView.delegate = self;
    self.conversationsTableView.dataSource = self;
    
    self.conversationsTableView.rowHeight = 96;
    self.view.backgroundColor = [Colors secondaryGreyLighterColor];
    
    self.conversations = [[NSMutableArray alloc] init];
    
    self.noConversationsView.frame = self.view.bounds;
    [Format configurePlaceholderView:self.noConversationsView withLabel:self.noConversationsLabel];
    self.noConversationsLabel.text = @"LOADING MESSAGES...";
    
    [self configureTopNavigationBar];
    [self configureRefreshControl];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fetchConversations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureTopNavigationBar {
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    [self.appBar addSubviewsToParent];
    [Format formatAppBar:self.appBar withTitle:@"MESSAGES"];
}

//automatically style status bar
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.appBar.headerViewController;
}

- (void)configureRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchConversations) forControlEvents:UIControlEventValueChanged];
    [self.conversationsTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchConversations {
    PFQuery *userIsSeekerQuery = [self createUserIsSeekerQuery];
    PFQuery *userIsAuthorQuery = [self createUserIsAuthorQuery];
    
    PFQuery *userConversationsQuery = [PFQuery orQueryWithSubqueries:@[userIsSeekerQuery, userIsAuthorQuery]];
    [userConversationsQuery includeKey:@"messages"];
    [userConversationsQuery includeKey:@"post"];
    [userConversationsQuery includeKey:@"post.author.username"];
    [userConversationsQuery includeKey:@"post.author.profileImageFile"];
    [userConversationsQuery includeKey:@"post.taker"];
    [userConversationsQuery includeKey:@"seeker"];
    [userConversationsQuery includeKey:@"seeker.username"];
    [userConversationsQuery includeKey:@"seeker.profileImageFile"];
    [userConversationsQuery orderByDescending:@"createdAt"];
    userConversationsQuery.limit = self.queryLimit;
    
    [userConversationsQuery findObjectsInBackgroundWithBlock:^(NSArray *conversations, NSError *error) {
        if (error != nil) {
            [Alert callAlertWithTitle:@"Error fetching conversations" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
        } else {
            self.conversations = [[NSMutableArray alloc] init];
            for (Conversation *conversation in conversations) {
                if (conversation.messages.count > 0) {
                    [self.conversations addObject:conversation];
                }
            }
            [self.conversationsTableView reloadData];
            [self.refreshControl endRefreshing];
            if (self.conversations.count > 0) {
                self.noConversationsView.hidden = YES;
            } else {
                self.noConversationsView.hidden = NO;
                self.noConversationsLabel.text = @"You have no conversations. Click the \"MESSAGE\" button on a post from the feed tab to start chatting!";
                [self.noConversationsLabel setTextAlignment:NSTextAlignmentLeft];
            }
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:conversationsToMessagesSegue]) {
        ConversationTableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.conversationsTableView indexPathForCell:cell];
        [self.conversationsTableView deselectRowAtIndexPath:indexPath animated:YES];
        ConversationDetailViewController *conversationDetailController = [segue destinationViewController];
        conversationDetailController.delegate = self;
        conversationDetailController.otherUser = cell.otherUser;
        conversationDetailController.conversation = cell.conversation;
    }
}

@end
