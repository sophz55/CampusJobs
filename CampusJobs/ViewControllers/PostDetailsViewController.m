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
#import "Colors.h"
#import <ChameleonFramework/Chameleon.h>

@interface PostDetailsViewController () <ComposePostDelegate, ConversationDetailDelegate, UtilsDelegate>

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) Conversation *conversation;
@property (assign, nonatomic) BOOL userIsAuthor;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation PostDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    self.userIsAuthor = [self.post.author.objectId isEqualToString:self.user.objectId];
    [self formatColors];
    [self configureInitialView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate Methods

- (void)reloadDetails {
    [self setDetailsPost:self.post];
    [self configureInitialView];
}

- (void)confirmationAlertHandler:(BOOL)response {
    if (response) {
        if (self.post.postStatus == OPEN && self.userIsAuthor) {
            [self deletePost];
        } else if (self.post.postStatus == IN_PROGRESS) {
            [self cancelJob];
        }
    }
}

#pragma mark - Custom Configurations
- (void)configureInitialView {
    [self configureNavigatonBar];
    
    [self setDetailsPost:self.post];
    
    if (self.userIsAuthor) {
        [self configureAuthorView];
    } else {
        [self configureSeekerView];
    }
    
    if (self.post.postStatus == IN_PROGRESS && (self.userIsAuthor || [self.user.objectId isEqualToString:self.post.taker.objectId])) {
        [Utils showButton:self.cancelButton];
    } else {
        [Utils hideButton:self.cancelButton];
    }
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

- (void)configureAuthorView {
    [Utils showBarButton:self.editButton];
    
    if (self.post.postStatus == OPEN) {
        self.userDetailsLabel.text = [NSString stringWithFormat: @"This post is open!"];
        [Utils showButton:self.deleteButton];
    } else if (self.post.postStatus == IN_PROGRESS) {
        self.userDetailsLabel.text = [NSString stringWithFormat: @"In progress with user: %@", self.post.taker.username];
        [Utils hideButton:self.deleteButton];
    } else {
        self.userDetailsLabel.text = [NSString stringWithFormat: @"Completed by: %@", self.post.taker.username];
        [Utils hideButton:self.deleteButton];
    }
    
    if ([self.delegate isKindOfClass:[ConversationDetailViewController class]] || self.post.postStatus == OPEN) {
        [Utils hideButton:self.messageButton];
    } else {
        [Utils showButton:self.messageButton withText:[NSString stringWithFormat: @"Message %@", self.post.taker.username]];
    }
}

- (void)configureSeekerView {
    if ([self.delegate isKindOfClass:[ConversationDetailViewController class]]) {
        [Utils hideButton:self.messageButton];
    } else {
        [Utils showButton:self.messageButton withText:@"Message"];
    }
    
    [Utils hideBarButton:self.editButton];
    [Utils hideButton:self.deleteButton];
    
    self.userDetailsLabel.text = [NSString stringWithFormat: @"Author: %@", self.post.author.username];
}

- (void)setDetailsPost:(Post *)post{
    self.titleDetailsLabel.text=post.title;
    self.descriptionDetailsLabel.text=post.summary;
    [self.descriptionDetailsLabel sizeToFit];
    self.locationDetailsLabel.text=post.locationAddress;
}

#pragma mark - IBAction

- (IBAction)didTapBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapMessageButton:(id)sender {
    if (!self.userIsAuthor) {
        [self findConversation];
    } else {
        [self findConversationWithTaker];
    }
}

- (IBAction)didTapEditButton:(id)sender {
    if (self.userIsAuthor) {
        [self performSegueWithIdentifier:postDetailsToEditPostSegue sender:nil];
    }
}

- (IBAction)didTapDeleteButton:(id)sender {
    if (self.userIsAuthor && self.post.postStatus == OPEN) {
        [Utils callConfirmationWithTitle:@"Are you sure you want to delete this post?" confirmationMessage:@"This cannot be undone." yesActionTitle:@"Delete" noActionTitle:@"Cancel" viewController:self];
    }
}

- (IBAction)didTapCancelButton:(id)sender {
    if (self.post.postStatus == IN_PROGRESS && (self.userIsAuthor || [self.user.objectId isEqualToString:self.post.taker.objectId])) {
        NSString *confirmationMessage;
        if (self.userIsAuthor) {
            confirmationMessage = [NSString stringWithFormat:@"It is currently in progress with %@ for $%@.", self.post.taker.username, self.post.price];
        } else {
            confirmationMessage = [NSString stringWithFormat:@"It is currently in progress for %@.", self.post.price];
        }
        [Utils callConfirmationWithTitle:@"Are you sure you want to cancel this job?" confirmationMessage:confirmationMessage yesActionTitle:@"Cancel job" noActionTitle:@"No, go back" viewController:self];
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

- (void)findConversationWithTaker {
    // create query to access "author" key within a conversation's post
    PFQuery *postsQuery = [PFQuery queryWithClassName:@"Post"];
    [postsQuery whereKey:@"author" equalTo:self.user];
    
    // create query for conversations with current user as seeker, post author as author, post as post
    PFQuery *conversationsQuery=[PFQuery queryWithClassName:@"Conversation"];
    [conversationsQuery includeKey:@"post"];
    [conversationsQuery whereKey:@"post" matchesQuery:postsQuery];
    [conversationsQuery whereKey:@"post" equalTo:self.post];
    
    [conversationsQuery includeKey: @"seeker"];
    [conversationsQuery whereKey:@"seeker" equalTo:self.post.taker];
    
    [conversationsQuery includeKey: @"messages"];
    
    [conversationsQuery getFirstObjectInBackgroundWithBlock:^(NSObject *conversation, NSError*error){
        if (conversation) {
            self.conversation = (Conversation *)conversation;
            [self performSegueWithIdentifier:postDetailsToMessageSegue sender:nil];
        } else {
            [Utils callAlertWithTitle:@"Error Fetching Conversation" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
        }
    }];
}

- (void)deletePost {
    [self.post deletePostAndConversationsWithCompletion:^(BOOL didDeletePost, NSError *error) {
        if (didDeletePost) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate reloadData];
        } else {
            [Utils callAlertWithTitle:@"Error Deleting Post" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
        }
    }];
}

- (void)cancelJob {
    [self.post cancelJobWithCompletion:^(BOOL didCancelJob, NSError *error) {
        if (didCancelJob) {
            [self reloadDetails];
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
        if ([self.user.objectId isEqualToString:self.post.author.objectId] && self.post.taker) {
            conversationDetailController.otherUser = self.post.taker;
        } else {
            conversationDetailController.otherUser = self.post.author;
        }
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

- (void)formatColors{
    NSMutableArray *colors = [NSMutableArray array];
    [colors addObject:[Colors secondaryGreyLighterColor]];
    [colors addObject:[Colors secondaryGreyLightColor]];
    self.view.backgroundColor=[UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.view.frame andColors:colors];
}

@end
