//
//  PostDetailsViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "PostDetailsViewController.h"
#import "ConversationDetailViewController.h"
#import "Conversation.h"
#import "Utils.h"
#import "SegueConstants.h"
#import "MapDetailsViewController.h"
#import "ComposeNewPostViewController.h"

@interface PostDetailsViewController () <ComposePostDelegate, ConversationDetailDelegate>

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) Conversation *conversation;
@property (assign, nonatomic) BOOL userIsAuthor;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end

@implementation PostDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    self.userIsAuthor = [self.post.author.objectId isEqualToString:self.user.objectId];
    [self setDetailsPost:self.post];
    
    [self configureNavigatonBar];
    
    if (self.userIsAuthor || [self.parentVC isKindOfClass:[ConversationDetailViewController class]]) {
        [Utils hideButton:self.messageButton];
        [Utils showBarButton:self.editButton];
    } else {
        [Utils showButton:self.messageButton];
        [Utils hideBarButton:self.editButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate Methods

- (void)reloadDetails {
    [self setDetailsPost:self.post];
}

#pragma mark - Custom Configurations

- (void)setDetailsPost:(Post *)post{
    self.titleDetailsLabel.text=post.title;
    self.descriptionDetailsLabel.text=post.summary;
    [self.descriptionDetailsLabel sizeToFit];
    self.userDetailsLabel.text=post.author.username;
    self.locationDetailsLabel.text=post.locationAddress;
}

- (void)configureNavigatonBar {
    UILabel *navBarLabel = [[UILabel alloc] init];
    if (self.userIsAuthor) {
        navBarLabel.text = @"Your Posting";
    } else {
        navBarLabel.text = [NSString stringWithFormat:@"%@'s Posting", self.post.author.username];
    }
    self.navigationItem.titleView = navBarLabel;
}

#pragma mark - IBAction

- (IBAction)didTapBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapMessageButton:(id)sender {
    if (!self.userIsAuthor) {
        [self findConversation];
    }
}

- (IBAction)didTapEditButton:(id)sender {
    if (self.userIsAuthor) {
        [self performSegueWithIdentifier:postDetailsToEditPostSegue sender:nil];
    }
}

#pragma mark - Private Methods

- (void)findConversation {
    
    // create query to access "author" key within a conversation's post
    PFQuery *postsQuery = [PFQuery queryWithClassName:@"Post"];
    [postsQuery whereKey:@"author" equalTo:self.post.author];
    
    // create query for conversations with current user as seeker, post author as author, post as post
    PFQuery *conversationsQuery=[PFQuery queryWithClassName:@"Conversation"];
    [conversationsQuery includeKey:@"post"];
    [conversationsQuery whereKey:@"post" matchesQuery:postsQuery];
    [conversationsQuery whereKey:@"post" equalTo:self.post];
    
    [conversationsQuery includeKey: @"seeker"];
    [conversationsQuery whereKey:@"seeker" equalTo:self.user];
    
    [conversationsQuery includeKey: @"messages"];
    
    [conversationsQuery getFirstObjectInBackgroundWithBlock:^(NSObject *conversation, NSError*error){
        if (conversation) {
            self.conversation = (Conversation *)conversation;
            [self performSegueWithIdentifier:postDetailsToMessageSegue sender:nil];
        } else if (error.code == 101) { // if there are no conversations with these users and this post, create one
            [Conversation createNewConversationWithPost:self.post withSeeker:self.user withCompletion:^(PFObject *newConversation, NSError * _Nullable error){
                if (newConversation){
                    self.conversation = (Conversation *)newConversation;
                        [self performSegueWithIdentifier:postDetailsToMessageSegue sender:nil];
                } else {
                    [Utils callAlertWithTitle:@"Error Creating Conversation" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
                }
            }];
        } else {
            [Utils callAlertWithTitle:@"Error Fetching Conversation" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:postDetailsToMessageSegue]) {
        UINavigationController *conversationNavigationController = [segue destinationViewController];
        ConversationDetailViewController *conversationDetailController = (ConversationDetailViewController *)[conversationNavigationController topViewController];
        conversationDetailController.delegate = self;
        conversationDetailController.conversation = self.conversation;
        conversationDetailController.otherUser = self.post.author;
    } else if ([segue.identifier isEqualToString:postDetailsToMapSegue]) {
        // UINavigationController *detailsNavigationController = [segue destinationViewController];
        MapDetailsViewController *mapDetailsViewController = [segue destinationViewController];
        mapDetailsViewController.post=self.post;
    } else if ([segue.identifier isEqualToString:postDetailsToEditPostSegue]) {
        UINavigationController *navController = [segue destinationViewController];
        ComposeNewPostViewController *editPostViewController = (ComposeNewPostViewController *)[navController topViewController];
        editPostViewController.delegate = self;
        editPostViewController.post = self.post;
    }
}

@end
